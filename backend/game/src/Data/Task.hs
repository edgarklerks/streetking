{-# LANGUAGE OverloadedStrings, RankNTypes, DisambiguateRecordFields, FlexibleContexts, TemplateHaskell, ScopedTypeVariables, ViewPatterns  #-}

module Data.Task where

import           Control.Applicative
import           Control.Monad
import           Control.Monad.Error
import           Control.Concurrent
import           Data.List
import           Data.Maybe
import           Data.SqlTransaction
import           Data.Database
import           Database.HDBC (toSql) 
import qualified Data.ByteString.Char8 as C
import qualified Data.ByteString.Lazy as LB
import qualified Data.ByteString.Lazy.Char8 as LBC
import           Data.Default
import qualified Data.Aeson as AS
import           Data.Attoparsec.Number
import           Data.Time.Clock.POSIX
import           Control.Monad.Trans
import           Model.General 
import           Data.HashMap.Strict as HM
import qualified Model.Transaction as TR 
import           Model.Transaction (transactionMoney)

import qualified Model.Functions as Fun
import qualified Model.Task as TK
import qualified Model.TaskTrigger as TKT
import qualified Model.TaskExtended as TKE
import qualified Model.TrackTime as TTM
import qualified Model.Account as A
import qualified Model.Garage as G
import qualified Model.CarInstance as CI
import qualified Model.Part as PM
import qualified Model.PartInstance as PI

-- TODO: static tasks
-- -> have start time, updated time, end time; field "static" boolean
-- -> when fired, set updated time; only delete if past end time
-- -> non-static tasks equivalent to static tasks with end_time < start_time
-- static tasks can be used for:
-- -> personnel activity updates (repair, improvement, ...)
-- -> user energy recovery 

{-
 - Types
 -}

data Action =
      TrackTime
    | GiveRespect
    | GiveMoney
    | GiveCar
    | GivePart
    | TransferMoney
    | TransferCar
       deriving (Eq, Enum)

data Trigger =
      Track
    | User
    | Car
    | Part 
        deriving (Eq, Enum)


{-
 - Set tasks 
 -}

-- make a new task with time and data
task :: Action -> Integer -> Data -> SqlTransaction Connection Integer 
task a t d = save $ (def :: TK.Task) { TK.time = t, TK.data = (pack $ ("action", a) .> d), TK.deleted = False }

-- make a new task trigger with subject type, subject ID and task ID
trigger :: Trigger -> Integer -> Integer -> SqlTransaction Connection Integer 
trigger tpe sid tid = save $ (def :: TKT.TaskTrigger) { TKT.task_id = tid, TKT.type = (toInteger $ fromEnum tpe), TKT.target_id = sid }

-- create a new track time entry for a user, possibly updating track top time as well
trackTime :: Integer -> Integer -> Integer -> Double -> SqlTransaction Connection () 
trackTime t trk uid tme  = do

        -- create the task: set action type, timestamp, and additional data fields (mixed types allowed)
        tid <- task TrackTime t $ ("track_id", trk) .> ("account_id", uid) .> ("time", tme) .> new

        -- create triggers for task execution: set trigger type, subject id, and task id
        -- a task can have more than one trigger, but will fire only once
        trigger Track trk tid
        trigger User uid tid

        -- return unit for great justice
        return () 

-- add or remove money from user account
giveMoney :: Integer -> Integer -> Integer -> String -> Integer -> SqlTransaction Connection ()
giveMoney t uid amt tn tv = do
        tid <- task GiveMoney t $ ("transaction_type_name", tn) .> ("transaction_type_id", tv) .> ("account_id", uid) .> ("amount", amt) .> new
        trigger User uid tid
        return () 

-- add or remove respect from user account
giveRespect :: Integer -> Integer -> Integer -> SqlTransaction Connection ()
giveRespect t uid amt  = do
        tid <- task GiveRespect t $ ("account_id", uid) .> ("amount", amt) .> new
        trigger User uid tid
        return ()

-- create a new car instance and assign it to user garage
giveCar :: Integer -> Integer -> Integer -> SqlTransaction Connection ()
giveCar t uid cid  = do
        tid <- task GiveCar t $ ("account_id", uid) .> ("car_model_id", cid) .> new
        trigger User uid tid
        return ()

-- create a new part instance and assign it to user garage
givePart :: Integer -> Integer -> Integer -> SqlTransaction Connection ()
givePart t uid pid  = do
        tid <- task GivePart t $ ("account_id", uid) .> ("part_model_id", pid) .> new
        trigger User uid tid
        return ()

-- remove money from one account and add it to another
transferMoney :: Integer -> Integer -> Integer -> Integer -> String -> Integer -> SqlTransaction Connection ()
transferMoney t suid tuid amt tn tv = do
        tid <- task TransferMoney t $ ("transaction_type_name", tn) .> ("transaction_type_id", tv) .> ("source_account_id", suid) .> ("target_account_id", tuid) .> ("amount", amt) .> new
        trigger User suid tid
        trigger User tuid tid
        return ()

-- remove a car from one user's garage and add it to another's
transferCar :: Integer -> Integer -> Integer -> Integer -> SqlTransaction Connection ()
transferCar t suid tuid cid  = do
        tid <- task TransferCar t $ ("source_account_id", suid) .> ("target_account_id", tuid) .> ("car_instance_id", cid) .> new
        trigger User suid tid
        trigger User tuid tid
        trigger Car cid tid
        return ()


{-
 - Trigger tasks 
 -}

-- fire task trigger by trigger type and subject ID
run :: Trigger -> Integer -> SqlTransaction Connection ()
run tp sid = void $ (flip catchError) (runFail tp sid) $ do

        t <- liftIO $ floor <$> getPOSIXTime

        ss <- claim t tp sid 
        forM_ ss $ \(n, s) -> do
            f <- catchError (process s) (processFail n s) 
            when f $ remove n
            release n

        cleanup $ t - 24 * 3600
        wait t tp sid

-- fire all task triggers of a trigger type 
runAll :: Trigger -> SqlTransaction Connection ()
runAll tp = Data.Task.run tp 0

-- mark a selection of tasks as claimed, and return them 
claim :: Integer -> Trigger -> Integer -> SqlTransaction Connection [(Integer, Data)]
claim t tp sid = do

        -- fetch tasks and remove duplicates caused by multiple triggers on the same task
        ss <- Data.List.map (flip updateHashMap (def :: TK.Task)) <$> Fun.claim_tasks t (toInteger $ fromEnum tp) sid
        
        -- read tasks and return 
        forM ss $ \s -> do
            case unpack $ TK.data s of
                Nothing -> throwError "Task claim: could not decode task data" 
                Just d -> return (fromJust $ TK.id s, d)

-- unmark a task as claimed
release :: Integer -> SqlTransaction Connection ()
release n = void $ update "task" ["id" |== toSql n] [] [("claim", SqlInteger 0)]

-- mark a task as deleted
remove :: Integer -> SqlTransaction Connection ()
remove n = void $ update "task" ["id" |== toSql n] [] [("deleted", SqlBool True)]

-- physically remove tasks marked as deleted that are older than t 
cleanup :: Integer -> SqlTransaction Connection ()
cleanup t = void $ transaction sqlExecute $ Delete (table "task") ["time" |<= SqlInteger t, "deleted" |== SqlBool True]

-- wait until there are no running tasks
wait :: Integer -> Trigger -> Integer -> SqlTransaction Connection () 
wait = wait' 0 
    where
        wait' :: Integer -> Integer -> Trigger -> Integer -> SqlTransaction Connection () 
        wait' n t tp sid = void $ do
                b <- Fun.tasks_in_progress t (toInteger $ fromEnum tp) sid
                case n > 5 of
                    False -> do
                        when b $ do
                            liftIO $ threadDelay $ 1000 * 50
                            wait' (n+1) t tp sid
                    True -> throwError "Task wait: timeout"


{-
 - Process tasks
 -}

-- process task data. return true if task is to be deleted, false otherwise
process :: Data -> SqlTransaction Connection Bool 
process d = do

         case "action" .< d :: Maybe Action of

                Just TrackTime -> do
                        save $ (def :: TTM.TrackTime) {
                                TTM.account_id = "account_id" .<< d,
                                TTM.track_id = "track_id" .<< d,
                                TTM.time = "time" .<< d
                            }
                        return True 

                Just GiveMoney -> do
                        let sid = "account_id" .<< d
                        let tn = "transaction_type_name" .<< d
                        let tv = "transaction_type_id" .<< d 
                        let am = "amount" .<< d

                        transactionMoney sid (def { 
                                        TR.amount = am,
                                        TR.type = tn,
                                        TR.type_id = tv 
                                        })
                        return True 
   
                Just GiveRespect ->do
                        ma <- load $ "account_id" .<< d :: SqlTransaction Connection (Maybe A.Account)
                        case ma of
                            Nothing -> throwError "process: give respect: user not found"
                            Just a -> do
                                save $ a { A.respect = (A.respect a) + ("amount" .<< d) }
                                return True

                Just GivePart -> do
                        mp <- load $ "part_model_id" .<< d :: SqlTransaction Connection (Maybe PM.Part)
                        when (isNothing mp) $ throwError $ "process: give part: part model not found"
                        g <- head <$> search ["account_id" |== (SqlInteger $ "account_id" .<< d )]  []  1 0 :: SqlTransaction Connection G.Garage
                        save (def {
                                PI.garage_id = G.id g, 
                                PI.part_id = "part_model_id" .<< d,
                                PI.account_id = "account_id" .<< d
                            } :: PI.PartInstance) 
                        return True

                Just GiveCar -> throwError "process: not implemented: GiveCar"

                -- TODO: use money transaction 
                Just TransferMoney -> do
                        let sid = "source_account_id" .<< d 
                        let tid = "target_account_id" .<< d 
                        let tn = "transaction_type_name" .<< d
                        let tv = "transaction_type_id" .<< d 
                        let am = "amount" .<< d

                        transactionMoney sid (def { 
                                        TR.amount = - am,
                                        TR.type = tn,
                                        TR.type_id = tv 
                                        })
                        transactionMoney tid (def { 
                                        TR.amount = am,
                                        TR.type = tn,
                                        TR.type_id = tv 
                                        })
 
                        return True
                Just TransferCar -> do 
                        msa <- load $ "source_account_id" .<< d :: SqlTransaction Connection (Maybe A.Account)
                        mta <- load $ "target_account_id" .<< d :: SqlTransaction Connection (Maybe A.Account)
                        mci <- load $ "car_instance_id" .<< d :: SqlTransaction Connection (Maybe CI.CarInstance)
                        case (msa, mta, mci) of
                            (Just sa, Just ta, Just ci) -> do
--                                Just sg <- load (fromJust $ A.id sa) :: SqlTransaction Connection (Maybe G.Garage)
                                Just tg <- load (fromJust $ A.id ta) :: SqlTransaction Connection (Maybe G.Garage)
                                save $ ci { CI.garage_id = G.id tg }
                                return True 
--                                case (CI.garage_id ci) == (fromJust $ G.id sg :: Integer) of
--                                    False -> fali "process: transfer car: car not in source garage"
--                                    True -> do
--                                        save $ ci { CI.garage_id = tg }
--                                        return ()
                            _ -> throwError "process: transfer car: unable to retrieve required records"

                Just e -> throwError $ "process: unknown action: " ++ (show $ fromEnum e)
                Nothing -> throwError "process: no action"


{-
 - Error handling
 -
 - TODO: store error report in database, mark task as invalid and continue
 -}

-- fail processing a task
processFail :: Integer -> Data -> String -> SqlTransaction Connection Bool 
processFail n s e = return True 

-- fail during task run
runFail :: Trigger -> Integer -> String -> SqlTransaction Connection ()
runFail tp sid e = return ()


{-
 - Task data
 -}

type Key = LB.ByteString
type Data = HM.HashMap Key AS.Value
type Pack = C.ByteString -- TODO: InRule support for ByteString.Lazy to allow Pack to be of this type

instance AS.ToJSON Action where toJSON a = AS.toJSON $ fromEnum a
instance AS.FromJSON Action where 
    parseJSON (AS.Number (I n)) = return $ toEnum $ fromInteger n
    parseJSON _ = fail "parseJSON: improper type for Action"

-- pack data
pack :: forall a. AS.ToJSON a => a -> Pack 
pack = C.pack . LBC.unpack . AS.encode

-- unpack data
unpack :: forall a. AS.FromJSON a => Pack -> Maybe a
unpack = AS.decode . LBC.pack . C.unpack

-- force unpack data
funpack :: forall a. AS.FromJSON a => Pack -> a
funpack = fromJust . AS.decode . LBC.pack . C.unpack

-- empty data
new :: Data
new = HM.empty 

-- set data field
set :: forall a. AS.ToJSON a => (Key, a) -> Data -> Data
set (k, v) d = HM.insert k (AS.toJSON v) d

(.>) :: forall a. AS.ToJSON a => (Key, a) -> Data -> Data
(.>) = set
infixr 4 .>

-- get data field of specified type
get :: forall a. AS.FromJSON a => Key -> Data -> Maybe a
get k d = case fmap AS.fromJSON $ HM.lookup k d of
        Just (AS.Success v) -> Just v
        _ -> Nothing

(.<) :: forall a. AS.FromJSON a => Key -> Data -> Maybe a
(.<) = get
infixr 4 .<

-- get data field with default
getd :: forall a. AS.FromJSON a => a -> Key -> Data -> a 
getd f k d = maybe f fromJust $ get k d

-- force get data field
getf :: forall a. AS.FromJSON a => Key -> Data -> a
getf k d = getd (error $ "Data: force get: field not found") k d

getm :: (MonadError String m, AS.FromJSON a) => Key -> Data -> m a
getm k d = case get k d of 
            Just a -> return a 
            Nothing -> throwError $ strMsg $ "Data: force get: field not found: " ++ (LBC.unpack k)

(.<<) :: forall a. AS.FromJSON a => Key -> Data -> a
(.<<) = getf
infixr 4 .<<




