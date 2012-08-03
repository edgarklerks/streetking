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
import           Data.InRules
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


{-
 - Types
 -}

data Action =
      TrackTime
    | ModifyMoney
    | ModifyExperience
    | TransferMoney
    | TransferCar
    | GivePart
        deriving (Eq, Enum)

data Trigger =
      Car
    | User
    | Track
        deriving (Eq, Enum)


{-
 - Set tasks 
 -}

trackTime :: Integer -> Integer -> Integer -> Double -> SqlTransaction Connection Integer
trackTime t trk uid tme  = do
        tid <- task TrackTime t $ set "track_id" trk $
                                  set "account_id" uid $
                                  set "time" tme $ new
        trigger Track trk tid
        trigger User uid tid
        return tid

modifyMoney :: Integer -> Integer -> Integer -> SqlTransaction Connection Integer
modifyMoney t uid amt  = do
        tid <- task ModifyMoney t $ set "account_id" uid $
                                    set "amount" amt $ new
        trigger User uid tid
        return tid


{-
 - Process tasks
 -}

-- process an action
process :: Data -> SqlTransaction Connection ()
process d = do

         case get "action" d :: Maybe Action of

                Just ModifyMoney -> do
                        ma <- load $ get' "account_id" d :: SqlTransaction Connection (Maybe A.Account)
                        case ma of
                            Nothing -> fali "process: modify money: user not found"
                            Just a -> do
                                save $ a { A.money = (A.money a) + (get' "amount" d) }
                                return ()

                Just ModifyExperience ->undefined 

                Just TransferMoney -> undefined 

                Just TransferCar -> undefined 

                Just GivePart -> undefined 

                Just TrackTime -> do
                        save $ (def :: TTM.TrackTime) {
                                TTM.account_id = get' "account_id" d,
                                TTM.track_id = get' "track_id" d,
                                TTM.time = get' "time" d
                            }
                        return ()

                Just e -> fali $ "process: unknown action: " ++ (show $ fromEnum e)
                Nothing -> fali "process: no action"


{-
 - Fire tasks 
 -}

-- fire all task triggers of a trigger type 
runAll :: Trigger -> SqlTransaction Connection ()
runAll tp = runWith ["subject_type" |== (toSql $ toInteger $ fromEnum tp)]

-- fire task trigger by trigger type and subject ID
run :: Trigger -> Integer -> SqlTransaction Connection ()
run tp sid = runWith ["subject_type" |== (toSql $ toInteger $ fromEnum tp), "subject_id" |== toSql sid]

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
task a t d = save $ (def :: TK.Task) { TK.time = t, TK.data = (pack $ set "action" a d), TK.deleted = False }

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
--                Nothing -> fali "claim: cannot decode task data" -- TODO: fix type mismatch
                Just d -> return d

-- failing tasks should not break transactions
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
set :: forall a. AS.ToJSON a => Key -> a -> Data -> Data
set k v d = HM.insert k (AS.toJSON v) d

-- get data field of specified type
get :: forall a. AS.FromJSON a => Key -> Data -> Maybe a
get k d = case fmap AS.fromJSON $ HM.lookup k d of
        Just (AS.Success v) -> Just v
        _ -> Nothing

-- force get data field
get' :: forall a. AS.FromJSON a => Key -> Data -> a
get' k d = fromJust $ get k d

-- get data field with default
getd :: forall a. AS.FromJSON a => a -> Key -> Data -> a 
getd f k d = maybe f fromJust $ get k d


