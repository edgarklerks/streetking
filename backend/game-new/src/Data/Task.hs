{-# LANGUAGE OverloadedStrings, FlexibleContexts, TemplateHaskell, ScopedTypeVariables, ViewPatterns, TypeSynonymInstances, FlexibleInstances #-}

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
import           Data.Default
import qualified Data.Aeson as AS
import           Data.Attoparsec.Number
import           Data.Time.Clock.POSIX
import           Model.General 
import           Data.DataPack
import           Data.Account as DA

import qualified Model.Transaction as TR 
import           Model.Transaction (transactionMoney)
import qualified Model.Escrow as Escrow

import qualified Model.Functions as Fun
import qualified Model.Task as TK
import qualified Model.TaskTrigger as TKT
import qualified Model.TrackTime as TTM
import qualified Model.Account as A
import qualified Model.Garage as G
import qualified Model.CarInstance as CI
import qualified Model.Part as PM
import qualified Model.PartInstance as PI
import           Data.Chain

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
    | EscrowCancel
    | EscrowRelease
       deriving (Eq, Enum)








instance AS.ToJSON Action where toJSON a = AS.toJSON $ fromEnum a
instance AS.FromJSON Action where 
    parseJSON (AS.Number (I n)) = return $ toEnum $ fromInteger n
    parseJSON _ = fail "parseJSON: improper type for Action"

data Trigger =
      Track
    | User
    | Car
    | Part 
    | Cron 
        deriving (Eq, Enum)


{-
 - Set tasks 
 -}

-- make a new task with time and data
task :: (AS.ToJSON a) => a -> Integer -> Data -> SqlTransaction Connection Integer 
task a t d = save $ (def :: TK.Task) { TK.time = t, TK.data = ("action", a) .> d, TK.deleted = False }

-- make a new task trigger with subject type, subject ID and task ID
trigger :: Trigger -> Integer -> Integer -> SqlTransaction Connection Integer 
trigger tpe sid tid = save $ (def :: TKT.TaskTrigger) { TKT.task_id = tid, TKT.type = (toInteger $ fromEnum tpe), TKT.target_id = sid }

-- create a new track time entry for a user, possibly updating track top time as well
trackTime :: Integer -> Integer -> Integer -> Double -> SqlTransaction Connection () 
trackTime t trk uid tme  = do

        -- create the task: set action type, timestamp, and additional data fields (mixed types allowed)
        tid <- task TrackTime t $ mkData $ do
            set "track_id" trk
            set "account_id"  uid
            set "time" tme

        -- create triggers for task execution: set trigger type, subject id, and task id
        -- a task can have more than one trigger, but will fire only once
        trigger Track trk tid
        trigger User uid tid

        -- return unit for great justice
        return () 

-- add or remove money from user account
giveMoney :: Integer -> Integer -> Integer -> String -> Integer -> SqlTransaction Connection ()
giveMoney t uid amt tn tv = do
        tid <- task GiveMoney t $ mkData $ do
            set "transaction_type_name" tn
            set "transaction_type_id" tv
            set "account_id" uid
            set "amount" amt
        trigger User uid tid
        return () 

-- add or remove respect from user account
giveRespect :: Integer -> Integer -> Integer -> SqlTransaction Connection ()
giveRespect t uid amt  = do
        tid <- task GiveRespect t $ mkData $ do
            set "account_id"  uid
            set "amount" amt
        trigger User uid tid
        return ()

-- create a new car instance and assign it to user garage
giveCar :: Integer -> Integer -> Integer -> SqlTransaction Connection ()
giveCar t uid cid  = do
        tid <- task GiveCar t $ mkData $ do
            set "account_id" uid
            set "car_model_id" cid
        trigger User uid tid
        return ()

-- create a new part instance and assign it to user garage
givePart :: Integer -> Integer -> Integer -> SqlTransaction Connection ()
givePart t uid pid  = do
        tid <- task GivePart t $ mkData $ do
            set "account_id" uid
            set "part_model_id" pid
        trigger User uid tid
        return ()

-- remove money from one account and add it to another
transferMoney :: Integer -> Integer -> Integer -> Integer -> String -> Integer -> SqlTransaction Connection ()
transferMoney t suid tuid amt tn tv = do
        tid <- task TransferMoney t $ mkData $ do
            set "transaction_type_name" tn
            set "transaction_type_id" tv
            set "source_account_id" suid
            set "target_account_id" tuid
            set "amount" amt
        trigger User suid tid
        trigger User tuid tid
        return ()

-- remove a car from one user's garage and add it to another's
transferCar :: Integer -> Integer -> Integer -> Integer -> SqlTransaction Connection ()
transferCar t suid tuid cid  = do
        tid <- task TransferCar t $ mkData $ do
            set "source_account_id" suid
            set "target_account_id" tuid
            set "car_instance_id" cid
        trigger User suid tid
        trigger User tuid tid
        trigger Car cid tid
        return ()

-- cancel escrow account: return money to depositor 
escrowCancel :: Integer -> Integer -> SqlTransaction Connection ()
escrowCancel t eid = do
        me <- load eid
        uid <- case me of
            Nothing -> rollback $ "Task: escrowCancel: escrow account not found for id " ++ (show eid)
            Just e -> return $ Escrow.account_id e
        tid <- task EscrowCancel t $ mkData $ set "escrow_id" eid
        trigger User uid tid
        return ()

-- release escrow account: transfer money to target account 
escrowRelease :: Integer -> Integer -> Integer -> SqlTransaction Connection ()
escrowRelease t eid uid = do
        tid <- task EscrowRelease t $ mkData $ do 
            set "escrow_id" eid
            set "account_id" uid
        trigger User uid tid
        return ()


{-
 - Trigger tasks 
 -}

-- fire all task triggers of a trigger type 
runAll :: Trigger -> SqlTransaction Connection ()
runAll tp = Data.Task.run tp 0

-- fire task trigger by trigger type and subject ID
run :: Trigger -> Integer -> SqlTransaction Connection ()
run tp sid = void $ (flip catchError) (runFail tp sid) $ do

        t <- liftIO $ floor <$> (1000 *) <$> getPOSIXTime
        
        cleanup $ t - 24 * 3600

        ss <- claim t tp sid 
        forM_ ss $ \s -> do
            f <- catchError (process s) (processFail s) 
            when f $ remove s 
            release s 

        wait t tp sid
        
-- mark a selection of tasks as claimed, and return them 
claim :: Integer -> Trigger -> Integer -> SqlTransaction Connection [TK.Task] --[(Integer, Data)]
claim t tp sid = Data.List.map (flip updateHashMap (def :: TK.Task)) <$> Fun.claim_tasks t (toInteger $ fromEnum tp) sid

-- unmark a task as claimed
release :: TK.Task -> SqlTransaction Connection ()
release s = void $ update "task" ["id" |== (toSql $ TK.id s)] [] [("claim", SqlInteger 0)]

-- mark a task as deleted
remove :: TK.Task -> SqlTransaction Connection ()
remove s = void $ update "task" ["id" |== (toSql $ TK.id s)] [] [("deleted", SqlBool True)]

-- physically remove tasks marked as deleted that are older than t 
cleanup :: Integer -> SqlTransaction Connection ()
cleanup t = void $ transaction sqlExecute $ Delete (table "task") ["time" |<= SqlInteger t, "deleted" |== SqlBool True]

-- wait until there are no running tasks
wait :: Integer -> Trigger -> Integer -> SqlTransaction Connection () 
wait t tp sid = w 0 $ Fun.tasks_in_progress t (toInteger $ fromEnum tp) sid
    where
        w n test = void $ do
            when (n>5) $ throwError "Task wait: timeout"
            b <- test
            when b $ do
                liftIO $ threadDelay $ 1000 * 50
                w (n+1) test
initTask = registerTask pred executeTask 
        where pred d = case "action" .< (TK.data d) of 
                            Just (x :: Action) -> True 
                            _ -> False 

executeTask t = let d = TK.data t in 
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
                        DA.addRespect ("account_id" .<< d) ("amount" .<< d)
                        return True
--                        ma <- load $ "account_id" .<< d :: SqlTransaction Connection (Maybe A.Account)
--                        case ma of
--                            Nothing -> throwError "process: give respect: user not found"
--                            Just a -> do
--                                save $ a { A.respect = (A.respect a) + ("amount" .<< d) }
--                                return True

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

                Just EscrowCancel -> do
                        Escrow.cancel $ "escrow_id" .<< d
                        return True
 
                Just EscrowRelease -> do
                        Escrow.release ("escrow_id" .<< d) ("account_id" .<< d)
                        return True

                Just e -> throwError $ "process: unknown action: " ++ (show $ fromEnum e)


process :: TK.Task -> SqlTransaction Connection Bool 
process = runTask -- executeTask (undefined :: Zero) 
{-
 - Error handling
 -
 - TODO: store error report in database, mark task as invalid and continue
 -}

-- fail processing a task
processFail :: TK.Task -> String -> SqlTransaction Connection Bool 
processFail s e = return True 

-- fail during task run
runFail :: Trigger -> Integer -> String -> SqlTransaction Connection ()
runFail tp sid e =  return ()



