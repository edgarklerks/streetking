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
import           Data.Unique.Id

import qualified Model.TrackTime as TTM
import qualified Model.Task as TK
import qualified Model.TaskTrigger as TKT
import qualified Model.TaskExtended as TKE

{-
-- TODO: generic data type for task data
-- wrapped record? Aeson / InRule HashMap?
-- -> use simple record type with to/from aeson only
-- -> store as bytestring
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

type Package = C.ByteString


{-
 - Set tasks 
 -}

trackTime :: Integer -> Integer -> Integer -> Double -> SqlTransaction Connection Integer
trackTime t trk uid tme = do
        tid <- save $ task t "track_time" $ pack $ (def :: DataTrackTime) { dtt_track_id = trk, dtt_account_id = uid, dtt_time = tme }
        save $ trigger "track" trk tid
        save $ trigger "user" uid tid
        return tid

modifyMoney :: Integer -> Integer -> Integer -> SqlTransaction Connection Integer
modifyMoney t uid amt = do
        tid <- save $ task t "modify_money" $ pack $ (def :: DataModifyMoney) { dmm_account_id = uid, dmm_amount = amt }
        save $ trigger "user" uid tid
        return tid


{-
 - Fire tasks 
 -}

-- fire all task triggers of a trigger type 
runAll :: String -> SqlTransaction Connection ()
runAll tp = do
        ss <- claim ["subject_type" |== toSql tp]
        forM ss process
        return ()    

-- fire task trigger by trigger type and subject ID
run :: String -> Integer -> SqlTransaction Connection ()
run tp sid = do
        ss <- claim ["subject_type" |== toSql tp, "subject_id" |== toSql sid]
        forM ss process
        return ()    


{-
 - Internal
 -}

-- TODO: InRule support for ByteString.Lazy to allow storage as a record column type 

-- pack data
pack :: forall a. AS.ToJSON a => a -> Package 
pack = C.pack . LBC.unpack . AS.encode

-- unpack data
unpack :: forall a. AS.FromJSON a => Package -> Maybe a
unpack = AS.decode . LBC.pack . C.unpack

-- make a new task with time and data
task :: Integer -> String -> Package -> TK.Task
task t tpe d = (def :: TK.Task) { TK.type = tpe, TK.time = t, TK.data = d, TK.deleted = False, TK.claim = 0 }

-- make a new task trigger with subject type, subject ID and task ID
trigger :: String -> Integer -> Integer -> TKT.TaskTrigger 
trigger tpe sid tid = (def :: TKT.TaskTrigger) { TKT.task_id = tid, TKT.type = tpe, TKT.subject_id = sid }

-- mark a task as deleted
unset :: Integer -> SqlTransaction Connection ()
unset tid = do
        ss <- search ["id" |== toSql tid] [] 1 0
        when (null ss) $ fali $ "unset: task not found: " ++ (show tid)
        save $ (head ss) { TK.deleted = True }
        return ()

-- cleanup deleted tasks (triggers are deleted cascading)
cleanup :: SqlTransaction Connection ()
cleanup = do 
        t <- liftIO $ floor <$> getPOSIXTime
        transaction sqlExecute $ Delete (table "task") ["time" |<= SqlInteger (t - 24*60*60), "deleted" |== SqlBool True]
        return ()

-- TODO: allow concurrent access: claim tasks for retrieval
-- 0. generate unique claim key 
-- 1. update selected tasks: set key in claim field
-- 2. select tasks with claim key
-- 3. proceed as normal
-- -> multiple concurrent searches cannot return the same task

-- claim current tasks by selection constraints, and fetch them
claim :: Constraints -> SqlTransaction Connection [TKE.TaskExtended]
claim xs = do
        cleanup
        i <- liftIO $ fmap (hashedId . idFromSupply) $ initIdSupply 't' -- TODO: init not here, probably doesn't work 
        t <- liftIO $ floor <$> getPOSIXTime
        update "task" (("time" |<= SqlInteger t) : xs) [] [("claim", toSql i)]
        search ["claim" |== toSql i] [] 10000 0 

-- process a task
process :: TKE.TaskExtended -> SqlTransaction Connection ()
process s = do

        unset $ fromJust $ TKE.id s 
        
        case TKE.type s of

                "modify_money" -> undefined

                "modify_experience" ->undefined 

                "transfer_money" -> undefined 

                "transfer_car" -> undefined 

                "give_part" -> undefined 

                "track_time" -> do

                        let d :: DataTrackTime = fromJust $ unpack $ TKE.data s
                        save $ (def :: TTM.TrackTime) { TTM.account_id = dtt_account_id d, TTM.track_id = dtt_track_id d, TTM.time = dtt_time d  }
                        return ()

                e -> fali $ "unknown task type: " ++ e

-- failing tasks should not break transactions
-- TODO: store error report in db or sth

-- fail a task
fali :: String -> SqlTransaction Connection ()
fali e = return ()


