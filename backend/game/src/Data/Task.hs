{-# LANGUAGE OverloadedStrings, RankNTypes, DisambiguateRecordFields, FlexibleContexts, TemplateHaskell  #-}

module Data.Task where

import           Control.Applicative
import           Control.Monad
import           Data.Maybe
import           Data.SqlTransaction
import           Data.Database
import           Database.HDBC 
import qualified Data.ByteString.Char8 as C
import qualified Data.ByteString.Lazy.Char8 as LBC
import           Data.Default
import qualified Data.Aeson as AS
import           Data.InRules
import           Model.TH
import           Data.Time.Clock.POSIX
import           Control.Monad.Trans
import           Model.General 

import qualified Model.TrackTime as TTM
import qualified Model.Task as TK
import qualified Model.TaskTrigger as TKT
import qualified Model.TaskExtended as TKE

{-
-- TODO: generic data type for task data
-- wrapped record? Aeson / InRule HashMap? 
-}

$(genMapableRecord "DataModifyMoney" [
        ("dmm_account_id", ''Integer),
        ("dmm_amount", ''Integer)
    ])

$(genMapableRecord "DataModifyExperience" [
        ("dme_account_id", ''Integer),
        ("dme_amount", ''Integer)
    ])

$(genMapableRecord "DataTransferMoney" [
        ("dtm_target_account_id", ''Integer),
        ("dtm_source_account_id", ''Integer),
        ("dtm_amount", ''Integer)
    ])

$(genMapableRecord "DataTransferCar" [
        ("dtc_target_account_id", ''Integer),
        ("dtc_source_account_id", ''Integer), 
        ("dtc_car_instance_id", ''Integer)
    ])

$(genMapableRecord "DataGivePart" [
        ("dgp_account_id", ''Integer),
        ("dgp_part_model_id", ''Integer)
    ])

$(genMapableRecord "DataTrackTime" [
        ("dtt_account_id", ''Integer),
        ("dtt_track_id", ''Integer),
        ("dtt_time", ''Double)
    ])

-- helper function, copied from Site.hs. This should really be put in a tools file somewhere.
aget :: Database Connection a => Constraints -> SqlTransaction Connection () -> SqlTransaction Connection a
aget cs f = do
    ss <- search cs [] 1 0
    unless (not $ null ss) f
    return $ head ss


{-
 - Tasks: pre-set low-cost actions to be fired if specified subject is called for after a specified time
 -}

setTask :: Integer -> String -> C.ByteString -> SqlTransaction Connection Integer 
setTask t tpe d = do
        save $ (def :: TK.Task) { TK.type = tpe, TK.time = t, TK.data = d, TK.deleted = False  }

setTaskTrigger :: String -> Integer -> Integer -> SqlTransaction Connection Integer 
setTaskTrigger tpe sid tid = do
        save $ (def :: TKT.TaskTrigger) { TKT.task_id = tid, TKT.type = tpe, TKT.subject_id = sid }

unsetTask :: Integer -> SqlTransaction Connection ()
unsetTask tid = do
        x <- aget ["id" |== toSql tid] (failTask "unset: task not found") :: SqlTransaction Connection TK.Task
        save $ x { TK.deleted = True }
        return ()

cleanupTasks :: SqlTransaction Connection ()
cleanupTasks = do 
        t <- liftIO $ floor <$> getPOSIXTime
        transaction sqlExecute $ Delete (table "task") ["time" |<= SqlInteger (t + 24*60*60), "deleted" |== SqlBool True]
        return ()

-- TODO: allow concurrent access: claim tasks for retrieval
-- 0. generate unique claim key 
-- 1. update selected tasks: set key in claim field
-- 2. select tasks with claim key
-- 3. proceed as normal
-- -> multiple concurrent searches cannot return the same task

searchCurrentTasks :: Constraints -> SqlTransaction Connection [TKE.TaskExtended]
searchCurrentTasks xs = do
        cleanupTasks
        t <- liftIO $ floor <$> getPOSIXTime
        search (("time" |<= SqlInteger t) : xs) [] 10000 0 

runTasksAll :: String -> SqlTransaction Connection ()
runTasksAll tp = do
        ss <- searchCurrentTasks ["subject_type" |== toSql tp]
        forM ss processTask
        return ()    

runTasks :: String -> Integer -> SqlTransaction Connection ()
runTasks tp sid = do
        ss <- searchCurrentTasks ["subject_type" |== toSql tp, "subject_id" |== toSql sid]
        forM ss processTask
        return ()    

processTask :: TKE.TaskExtended -> SqlTransaction Connection ()
processTask s = do

        unsetTask $ fromJust $ TKE.id s 
        
        case TKE.type s of

                "modify_money" -> undefined

                "modify_experience" ->undefined 

                "transfer_money" -> undefined 

                "transfer_car" -> undefined 

                "give_part" -> undefined 

                "set_top_time" -> do

                        let d :: DataTrackTime = fromJust $ AS.decode $ LBC.pack $ C.unpack $ TKE.data s
                        save $ (def :: TTM.TrackTime) { TTM.account_id = dtt_account_id d, TTM.track_id = dtt_track_id d, TTM.time = dtt_time d  }
                        return ()

                foo -> failTask $ "unknown task type: " ++ foo

-- failing tasks should not break transactions
-- TODO: store error report or sth
failTask :: String -> SqlTransaction Connection ()
failTask e = return ()


-- TODO: pack . unpack: InRule support for lazy bytestrings
setTrackTime :: Integer -> Integer -> Integer -> Double -> SqlTransaction Connection Integer
setTrackTime t trk uid tme = do
        tid <- setTask t "track_time" $ C.pack $ LBC.unpack $ AS.encode $ (def :: DataTrackTime) { dtt_track_id = trk, dtt_account_id = uid, dtt_time = tme }
        setTaskTrigger "track" trk tid
        setTaskTrigger "user" uid tid
        return tid

setModifyMoney :: Integer -> Integer -> Integer -> SqlTransaction Connection Integer
setModifyMoney t uid amt = do
        tid <- setTask t "modify_money" $ C.pack $ LBC.unpack $ AS.encode $ (def :: DataModifyMoney) { dmm_account_id = uid, dmm_amount = amt }
        setTaskTrigger "user" uid tid
        return tid
 
