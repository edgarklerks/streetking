{-# LANGUAGE OverloadedStrings, FlexibleContexts, TemplateHaskell, ScopedTypeVariables, ViewPatterns, TypeSynonymInstances, FlexibleInstances #-}
{-- 
- Changelog
- Edgar - default time from database 
- Edgar - added emitEvent 
-
--}
module Data.Task (

        Data.Task.init,
        registerHandler,
        Data.Task.run,
        runAll,
        executeTask,

        task,
        trigger,

        Action(..),
        Trigger(..),
        
        trackTime,
        emitEvent,
        giveMoney,
        transferMoney,
        giveCar,
        transferCar,
        givePart,
        giveRespect,
        escrowCancel,
        escrowRelease
        
    ) where

import Prelude hiding (log)
import           Control.Applicative
import           Control.Concurrent
import           Control.Monad
import           Control.Monad.Error
import           Data.Account as DA
import           Data.Attoparsec.Number
-- import           Data.Chain
import           Data.DataPack
import           Data.Database
import           Data.Default
import           Data.Event 
import           Data.List
import           Data.Maybe
import           Data.SqlTransaction
import           Data.Time.Clock.POSIX
import           Database.HDBC (toSql, fromSql) 
import qualified Database.HDBC as DB
import           Model.Functions
import           Model.General 
import           Model.Transaction (transactionMoney)
import qualified Data.Aeson as AS
import qualified Model.Account as A
import qualified Model.CarInstance as CI
import qualified Model.Escrow as Escrow
import qualified Model.EventStream as ES 
import qualified Model.Functions as Fun
import qualified Model.Garage as G
import qualified Model.Part as PM
import qualified Model.PartInstance as PI
import qualified Model.Task as TK
import qualified Model.TaskTrigger as TKT
import qualified Model.TrackTime as TTM
import qualified Model.Transaction as TR 
import qualified Model.TaskLog as TL

import Data.String
import Data.Typeable 
import Data.Aeson.TH 

import System.IO.Unsafe 
import Data.IORef 
import qualified Data.HashMap.Strict as S 
import Control.Monad.Trans 
import Control.Concurrent.STM 
import Debug.Trace 


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
    | EmitEvent 
       deriving (Eq, Enum)

instance Show Action where
    show TrackTime = "TrackTime"
    show GiveRespect = "GiveRespect"
    show GiveMoney = "GiveMoney"
    show GiveCar = "GiveCar"
    show GivePart = "GivePart"
    show TransferMoney = "TransferMoney"
    show TransferCar = "TransferCar"
    show EscrowCancel = "EscrowCancel"
    show EscrowRelease = "EscrowRelease"
    show EmitEvent = "EmitEvent"
    show a = "Action " ++ (show $ fromEnum a)

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
    | Test
        deriving (Eq, Enum)

instance Show Trigger where
    show Track = "Track"
    show User = "User"
    show Car = "Car"
    show Part = "Part"
    show Cron = "Cron"
    show Test = "Test"
    show a = "Trigger " ++ (show $ fromEnum a)

instance AS.ToJSON Trigger where toJSON a = AS.toJSON $ fromEnum a
instance AS.FromJSON Trigger where 
    parseJSON (AS.Number (I n)) = return $ toEnum $ fromInteger n
    parseJSON _ = fail "parseJSON: improper type for Trigger"


fali :: SqlTransaction Connection ()
fali = void $ sqlGetOne "select fali from account;" []

follow :: SqlTransaction Connection SqlValue
follow = sqlGetOne "select 42;" []

foo :: SqlError -> SqlTransaction Connection ()
foo e = do
        liftIO $ print $ "caught error: " ++ (show e)
        return ()

test :: SqlTransaction Connection ()
test = void $ do
        catchError fali foo
        c <- Data.SqlTransaction.get 
--        liftIO $ DB.rollback c
--        liftIO $ DB.commit c
        r <- follow
        liftIO $ print $ "follow-up result: " ++ (show r)


{-
 - Failure
 -}

-- fail processing a task
processFail :: TK.Task -> SqlError -> SqlTransaction Connection () 
processFail s e = do
        log "error" s $ mkData $ do
                set "phase" ("processing" :: String)
                set "error" $ show e
        reject s

-- fail during task triggering
runFail :: Trigger -> Integer -> SqlError -> SqlTransaction Connection ()
runFail tp sid e =  do
        log "error" def $ mkData $ do
                set "phase" ("triggering" :: String)
                set "trigger" $ show tp
                set "subject_id" sid
                set "error" (show e)

{-
 - Logging
 -}

log :: String -> TK.Task -> Data -> SqlTransaction Connection ()
log s k d = void $ forkSqlTransaction $ void $ do
        t <- unix_millitime
        save $ (def :: TL.TaskLog) { TL.time = t, TL.entry = d, TL.activity = s, TL.task_id = TK.id k }

{-
 - Handler chaining
 -}

-- hold task handlers in the idiosyncratically named variable "lolwut"
{-# NOINLINE lolwut #-}
lolwut :: TVar [(TK.Task -> Bool, TK.Task -> SqlTransaction Connection Bool)]
lolwut = unsafePerformIO $ newTVarIO []  

-- register a new task handler
registerHandler :: (TK.Task -> Bool) -> (TK.Task -> SqlTransaction Connection Bool) -> IO ()
registerHandler f x = atomically $ modifyTVar lolwut (\xs -> ((f,x) : xs))


{-
 - Set tasks 
 -}

-- make a new task with time and data
task :: (AS.ToJSON a) => a -> Integer -> Data -> SqlTransaction Connection Integer 
task a t d = save $ (def :: TK.Task) { TK.time = t, TK.data = ("action", a) .> d, TK.state = "waiting" }

-- make a new task trigger with subject type, subject ID and task ID
trigger :: Trigger -> Integer -> Integer -> SqlTransaction Connection Integer 
trigger tpe sid tid = save $ (def :: TKT.TaskTrigger) { TKT.task_id = tid, TKT.type = (toInteger $ fromEnum tpe), TKT.target_id = sid }


{-
 - Trigger tasks 
 -}

-- fire all task triggers of a trigger type 
runAll :: Trigger -> SqlTransaction Connection ()
runAll tp = Data.Task.run tp 0

-- fire task trigger by trigger type and subject ID
run :: Trigger -> Integer -> SqlTransaction Connection ()
run tp sid = void $ (flip catchError) (runFail tp sid) $ do

        t <- unix_millitime
        
        cleanup t 

        ss <- claim t tp sid 
        forM_ ss $ \s -> do
            (flip catchError) (processFail s) $ do
                    h <- process s
                    case h of
                            True -> resolve s
                            False -> reject s
        wait t tp sid

-- attempt to process a task
process :: TK.Task -> SqlTransaction Connection Bool 
process t = do 
        log "process" t emptyData
        fs <- liftIO $ readTVarIO lolwut 
        let stepM [] = rollback $ "no handler for task action: " ++ (show $ ("action" .< (TK.data t) :: Maybe Action) ) -- "last shit not found"
            stepM ((pred,f):fs) | pred t = f t 
                                | otherwise = stepM fs 
        stepM fs 
        
-- mark a selection of tasks as claimed, and return them 
claim :: Integer -> Trigger -> Integer -> SqlTransaction Connection [TK.Task] 
claim t tp sid = do
        xs <- Data.List.map (flip updateHashMap (def :: TK.Task)) <$> Fun.claim_tasks t (toInteger $ fromEnum tp) sid
        return xs

-- mark a task as completed
resolve :: TK.Task -> SqlTransaction Connection ()
resolve s = do
        log "resolve" s emptyData
        update "task" ["id" |== (toSql $ TK.id s)] [] [("claim", SqlInteger 0), ("state", SqlString "done")]
        
-- mark a task as failed
reject :: TK.Task -> SqlTransaction Connection ()
reject s = do
        log "reject" s emptyData
        update "task" ["id" |== (toSql $ TK.id s)] [] [("claim", SqlInteger 0), ("state", SqlString "error")]
        
-- release a task to be fired again later
release :: TK.Task -> SqlTransaction Connection ()
release s = do
        log "release" s emptyData
        void $ update "task" ["id" |== (toSql $ TK.id s)] [] [("claim", SqlInteger 0), ("state", SqlString "waiting")]
        
-- clean up
cleanup :: Integer -> SqlTransaction Connection ()
cleanup t = void $ do

        let old = t - 7 * 24 * 60 * 60 * 1000
        let timeout = t - 60 * 60 * 1000

        -- timeout unfinished claimed tasks
        ss <- search ["state" |== toSql ("claimed" :: String), "claimed" |<= SqlInteger timeout] [] 100 0
        forM ss $ \s -> do
                log "error" s $ mkData $ do
                        set "phase" ("cleanup" :: String)
                        set "error" ("timeout after " ++ (show $ t - (TK.claimed s)) ++ " milliseconds" :: String)
                reject s
                 
        -- delete old completed tasks
        transaction sqlExecute $ Delete (table "task") ["time" |<= SqlInteger old, "state" |== SqlString "done"]

-- wait until there are no running tasks for the current trigger request
wait :: Integer -> Trigger -> Integer -> SqlTransaction Connection () 
wait t tp sid = w 0 $ Fun.tasks_in_progress t (toInteger $ fromEnum tp) sid
    where
        w n test = void $ do
            when (n>5) $ rollback "Task wait: timeout"
            b <- test
            when b $ do
                liftIO $ threadDelay $ 1000 * 50
                w (n+1) test

init = registerHandler pred executeTask 
        where pred d = case "action" .< (TK.data d) of 
                            Just (x :: Action) -> True 
                            _ -> False 


{-
 - Payloads
 -}

executeTask :: TK.Task -> SqlTransaction Connection Bool 
executeTask t = let d = TK.data t in do
            
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
--                            Nothing -> rollback "process: give respect: user not found"
--                            Just a -> do
--                                save $ a { A.respect = (A.respect a) + ("amount" .<< d) }
--                                return True

                Just GivePart -> do
                        mp <- load $ "part_model_id" .<< d :: SqlTransaction Connection (Maybe PM.Part)
                        when (isNothing mp) $ rollback $ "process: give part: part model not found"
                        g <- head <$> search ["account_id" |== (SqlInteger $ "account_id" .<< d )]  []  1 0 :: SqlTransaction Connection G.Garage
                        save (def {
                                PI.garage_id = G.id g, 
                                PI.part_id = "part_model_id" .<< d,
                                PI.account_id = "account_id" .<< d
                            } :: PI.PartInstance) 
                        return True

                Just GiveCar -> rollback "process: not implemented: GiveCar"
                Just EmitEvent -> do 
                        let ev = "event" .<< d
                        let uid = "account_id" .<< d
                        ES.emitEvent uid ev 
                        return True 


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
                            _ -> rollback "process: transfer car: unable to retrieve required records"

                Just EscrowCancel -> do
                        Escrow.cancel $ "escrow_id" .<< d
                        return True
 
                Just EscrowRelease -> do
                        Escrow.release ("escrow_id" .<< d) ("account_id" .<< d)
                        return True

                Just e -> rollback $ "process: unknown action: " ++ (show $ fromEnum e)


{-
 - "Factories"
 -}

-- create a new track time entry for a user, possibly updating track top time as well
trackTime :: Integer -> Integer -> Integer -> Double -> SqlTransaction Connection () 
trackTime t trk uid tme = void $ do
        
        -- create the task: set action type, timestamp, and additional data fields (mixed types allowed)
        tid <- task TrackTime t $ mkData $ do
            set "track_id" trk
            set "account_id"  uid
            set "time" tme
        
        -- create triggers for task execution: set trigger type, subject id, and task id
        -- a task can have more than one trigger, but will fire only once
        trigger Track trk tid
        trigger User uid tid

emitEvent :: Integer -> Event -> Integer -> SqlTransaction Connection ()
emitEvent uid ev tm = void $ do 
        tid <- task EmitEvent tm $ mkData $ do 
                    set "event" ev
                    set "account_id" uid 
                    set "time" tm 
        trigger User uid tid 
--        liftIO $ print (uid,ev,tm) 


-- add or remove money from user account
giveMoney :: Integer -> Integer -> Integer -> String -> Integer -> SqlTransaction Connection ()
giveMoney t uid amt tn tv = void $ do
        tid <- task GiveMoney t $ mkData $ do
            set "transaction_type_name" tn
            set "transaction_type_id" tv
            set "account_id" uid
            set "amount" amt
        trigger User uid tid


-- add or remove respect from user account
giveRespect :: Integer -> Integer -> Integer -> SqlTransaction Connection ()
giveRespect t uid amt = void $ do
        tid <- task GiveRespect t $ mkData $ do
            set "account_id"  uid
            set "amount" amt
        trigger User uid tid

-- create a new car instance and assign it to user garage
giveCar :: Integer -> Integer -> Integer -> SqlTransaction Connection ()
giveCar t uid cid  = void $ do
        tid <- task GiveCar t $ mkData $ do
            set "account_id" uid
            set "car_model_id" cid
        trigger User uid tid

-- create a new part instance and assign it to user garage
givePart :: Integer -> Integer -> Integer -> SqlTransaction Connection ()
givePart t uid pid  = void $ do
        tid <- task GivePart t $ mkData $ do
            set "account_id" uid
            set "part_model_id" pid
        trigger User uid tid

-- remove money from one account and add it to another
transferMoney :: Integer -> Integer -> Integer -> Integer -> String -> Integer -> SqlTransaction Connection ()
transferMoney t suid tuid amt tn tv = void $ do
        tid <- task TransferMoney t $ mkData $ do
            set "transaction_type_name" tn
            set "transaction_type_id" tv
            set "source_account_id" suid
            set "target_account_id" tuid
            set "amount" amt
        trigger User suid tid
        trigger User tuid tid

-- remove a car from one user's garage and add it to another's
transferCar :: Integer -> Integer -> Integer -> Integer -> SqlTransaction Connection ()
transferCar t suid tuid cid  = void $ do
        tid <- task TransferCar t $ mkData $ do
            set "source_account_id" suid
            set "target_account_id" tuid
            set "car_instance_id" cid
        trigger User suid tid
        trigger User tuid tid
        trigger Car cid tid

-- cancel escrow account: return money to depositor 
escrowCancel :: Integer -> Integer -> SqlTransaction Connection ()
escrowCancel t eid = void $ do
        me <- load eid
        uid <- case me of
            Nothing -> rollback $ "Task: escrowCancel: escrow account not found for id " ++ (show eid)
            Just e -> return $ Escrow.account_id e
        tid <- task EscrowCancel t $ mkData $ set "escrow_id" eid
        trigger User uid tid

-- release escrow account: transfer money to target account 
escrowRelease :: Integer -> Integer -> Integer -> SqlTransaction Connection ()
escrowRelease t eid uid = void $ do
        tid <- task EscrowRelease t $ mkData $ do 
            set "escrow_id" eid
            set "account_id" uid
        trigger User uid tid


