{-# LANGUAGE OverloadedStrings, RankNTypes, DisambiguateRecordFields, FlexibleContexts, TemplateHaskell  #-}

module Data.Task where

import           Control.Applicative
import           Control.Monad
import           Data.Maybe
import           Data.SqlTransaction
import           Data.Database
import           Database.HDBC 
import qualified Data.ByteString.Char8 as C
import qualified Data.ByteString.Lazy as LB
import qualified Data.ByteString.Lazy.Char8 as LBC
import           Data.Default
import qualified Data.Aeson as AS
import           Data.Attoparsec.Number
import qualified Data.InRules as IR
import           Model.TH
import           Data.Time.Clock.POSIX
import           Control.Monad.Trans
import           Model.General 
import           Data.HashMap.Strict as HM

import qualified Model.Task as TK
import qualified Model.TaskTrigger as TKT
import qualified Model.TaskExtended as TKE

import qualified Model.TrackTime as TTM
import qualified Model.Account as A
import qualified Model.Garage as G
import qualified Model.CarInstance as CI


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

trackTime :: Integer -> Integer -> Integer -> Double -> SqlTransaction Connection Integer
trackTime t trk uid tme  = do

        -- create the task: set action type, timestamp, and additional data fields (mixed types allowed)
        tid <- task TrackTime t $ ("track_id", trk) .> ("account_id", uid) .> ("time", tme) .> new

        -- create triggers for task execution: set trigger type, subject id, and task id
        -- a task can have more than one trigger, but will fire only once
        trigger Track trk tid
        trigger User uid tid

        -- return task id for great justice
        return tid

giveMoney :: Integer -> Integer -> Integer -> SqlTransaction Connection Integer
giveMoney t uid amt  = do
        tid <- task GiveMoney t $ ("account_id", uid) .> ("amount", amt) .> new
        trigger User uid tid
        return tid

giveRespect :: Integer -> Integer -> Integer -> SqlTransaction Connection Integer
giveRespect t uid amt  = do
        tid <- task GiveRespect t $ ("account_id", uid) .> ("amount", amt) .> new
        trigger User uid tid
        return tid

giveCar :: Integer -> Integer -> Integer -> SqlTransaction Connection Integer
giveCar t uid cid  = do
        tid <- task GiveCar t $ ("account_id", uid) .> ("car_model_id", cid) .> new
        trigger User uid tid
        return tid

givePart :: Integer -> Integer -> Integer -> SqlTransaction Connection Integer
givePart t uid pid  = do
        tid <- task GivePart t $ ("account_id", uid) .> ("part_model_id", pid) .> new
        trigger User uid tid
        return tid

transferMoney :: Integer -> Integer -> Integer -> Integer -> SqlTransaction Connection Integer
transferMoney t suid tuid amt  = do
        tid <- task TransferMoney t $ ("source_account_id", suid) .> ("target_account_id", tuid) .> ("amount", amt) .> new
        trigger User suid tid
        trigger User tuid tid
        return tid

transferCar :: Integer -> Integer -> Integer -> Integer -> SqlTransaction Connection Integer
transferCar t suid tuid cid  = do
        tid <- task TransferCar t $ ("source_account_id", suid) .> ("target_account_id", tuid) .> ("car_instance_id", cid) .> new
        trigger User suid tid
        trigger User tuid tid
        trigger Car cid tid
        return tid

{-
 - Process tasks
 -}

-- process an action
process :: Data -> SqlTransaction Connection ()
process d = do

         case "action" .< d :: Maybe Action of

                Just TrackTime -> do
                        save $ (def :: TTM.TrackTime) {
                                TTM.account_id = "account_id" .<< d,
                                TTM.track_id = "track_id" .<< d,
                                TTM.time = "time" .<< d
                            }
                        return ()

                Just GiveMoney -> do
                        ma <- load $ "account_id" .<< d :: SqlTransaction Connection (Maybe A.Account)
                        case ma of
                            Nothing -> fali "process: give money: user not found"
                            Just a -> do
                                save $ a { A.money = (A.money a) + ("amount" .<< d) }
                                return ()

                Just GiveRespect ->do
                        ma <- load $ "account_id" .<< d :: SqlTransaction Connection (Maybe A.Account)
                        case ma of
                            Nothing -> fali "process: give respect: user not found"
                            Just a -> do
                                save $ a { A.respect = (A.respect a) + ("amount" .<< d) }
                                return ()

                Just GivePart -> undefined 

                Just GiveCar -> undefined 

                Just TransferMoney -> do
                        msa <- load $ "source_account_id" .<< d :: SqlTransaction Connection (Maybe A.Account)
                        mta <- load $ "target_account_id" .<< d :: SqlTransaction Connection (Maybe A.Account)
                        case (msa, mta) of
                            (Just sa, Just ta) -> do
                                save $ sa { A.money = (A.money sa) - ("amount" .<< d) }
                                save $ ta { A.money = (A.money ta) + ("amount" .<< d) }
                                return ()
                            _ -> fali "process: transfer money: unable to retrieve required records"

                Just TransferCar -> do 
                        msa <- load $ "source_account_id" .<< d :: SqlTransaction Connection (Maybe A.Account)
                        mta <- load $ "target_account_id" .<< d :: SqlTransaction Connection (Maybe A.Account)
                        mci <- load $ "car_instance_id" .<< d :: SqlTransaction Connection (Maybe CI.CarInstance)
                        case (msa, mta, mci) of
                            (Just sa, Just ta, Just ci) -> do
--                                Just sg <- load (fromJust $ A.id sa) :: SqlTransaction Connection (Maybe G.Garage)
                                Just tg <- load (fromJust $ A.id ta) :: SqlTransaction Connection (Maybe G.Garage)
                                save $ ci { CI.garage_id = G.id tg }
                                return ()
--                                case (CI.garage_id ci) == (fromJust $ G.id sg :: Integer) of
--                                    False -> fali "process: transfer car: car not in source garage"
--                                    True -> do
--                                        save $ ci { CI.garage_id = tg }
--                                        return ()
                            _ -> fali "process: transfer car: unable to retrieve required records"


                Just e -> fali $ "process: unknown action: " ++ (show $ fromEnum e)
                Nothing -> fali "process: no action"


{-
 - Fire tasks 
 -}

-- fire all task triggers of a trigger type 
runAll :: Trigger -> SqlTransaction Connection ()
runAll tp = runWith ["type" |== (toSql $ toInteger $ fromEnum tp)]

-- fire task trigger by trigger type and subject ID
run :: Trigger -> Integer -> SqlTransaction Connection ()
run tp sid = runWith ["type" |== (toSql $ toInteger $ fromEnum tp), "target_id" |== toSql sid]

-- fire tasks by a selection of triggers
runWith :: Constraints -> SqlTransaction Connection ()
runWith cs = do 
        ss <- claim cs
        forM ss process
        return ()    


{-
 - Database interaction 
 -}

-- make a new task with time and data
task :: Action -> Integer -> Data -> SqlTransaction Connection Integer 
task a t d = save $ (def :: TK.Task) { TK.time = t, TK.data = (pack $ set ("action", a) d), TK.deleted = False }

-- make a new task trigger with subject type, subject ID and task ID
trigger :: Trigger -> Integer -> Integer -> SqlTransaction Connection Integer 
trigger tpe sid tid = save $ (def :: TKT.TaskTrigger) { TKT.task_id = tid, TKT.type = (toInteger $ fromEnum tpe), TKT.target_id = sid }

-- TODO: ensure concurrent processes do not claim the same tasks
-- -> 1. mark: update records with unique key
-- -> 2. fetch: select marked records
-- Note: select on TKE.TaskExtended, but update on TK.Task. may require explicit sql.

-- claim current tasks by selection constraints, and fetch them
claim :: Constraints -> SqlTransaction Connection [Data]
claim cs = do

        -- get time
        t <- liftIO $ floor <$> getPOSIXTime

        -- cleanup deleted tasks (triggers are deleted cascading)
        transaction sqlExecute $ Delete (table "task") ["time" |<= SqlInteger (t - 24*60*60), "deleted" |== SqlBool True]

        -- fetch tasks
        ss :: [TKE.TaskExtended] <- search (("time" |<= SqlInteger t) : cs) [] 10000 0

        -- mark tasks deleted and get data
        forM ss $ \s -> do
            update "task" ["id" |== (toSql $ TKE.task_id s)] [] [("deleted", SqlBool True)]
            case unpack $ TKE.data s of
                Nothing -> fali "claim: could not decode task data" >> return new  -- TODO: fix type mismatch
                Just d -> return d

-- failing tasks should never break transactions, as the triggers are injected into other, potentially critical operations
-- TODO: store error report in db or sth

-- fail a task
fali :: String -> SqlTransaction Connection () 
fali e = return ()


{-
 - Data
 -}

type Key = LB.ByteString
type Data = HM.HashMap Key AS.Value
type Pack = C.ByteString -- TODO: InRule support for ByteString.Lazy to allow Pack to be of this type

instance AS.ToJSON Action where toJSON a = AS.toJSON $ fromEnum a
instance AS.FromJSON Action where parseJSON (AS.Number (I n)) = return $ toEnum $ fromInteger n

-- pack data
pack :: forall a. AS.ToJSON a => a -> Pack 
pack = C.pack . LBC.unpack . AS.encode

-- unpack data
unpack :: forall a. AS.FromJSON a => Pack -> Maybe a
unpack = AS.decode . LBC.pack . C.unpack

-- force unpack data
unpack' :: forall a. AS.FromJSON a => Pack -> a
unpack' = fromJust . AS.decode . LBC.pack . C.unpack

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

-- force get data field
get' :: forall a. AS.FromJSON a => Key -> Data -> a
get' k d = fromJust $ get k d

(.<<) :: forall a. AS.FromJSON a => Key -> Data -> a
(.<<) = get'
infixr 4 .<<

-- get data field with default
getd :: forall a. AS.FromJSON a => a -> Key -> Data -> a 
getd f k d = maybe f fromJust $ get k d


