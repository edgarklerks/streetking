{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TemplateHaskell, OverloadedStrings #-}
module Model.Task where 

import           Data.SqlTransaction
import           Database.HDBC
import           Data.Convertible
import           Model.General
import           Data.Database 
import           Control.Monad
import qualified Data.Aeson as AS
import Data.InRules

import           Control.Applicative
import qualified Data.Map as M
import           Model.TH
import           Prelude hiding (id)



-- task types: account, car, track, ...
-- taskdata format stores actions and variables necessary for task
-- task fires when data is retrieved that can be affected by this type of task --> type should be array, or many-to-many?
-- * set top time (track)
-- * reward user after mission / race (account)
-- * ...

-- user reward
-- * money
-- * experience
-- * item
--   -> part
--   -> car instance (ie. from other player)
--   -> car model (ie. new car instance)

{-
data TaskAction = TATopTime {
        ta_toptime_account_id :: Integer,
        ta_toptime_track_id :: Integer,
        ta_toptime_time :: Double
    } | TAModifyMoney {
        ta_money_account_id  :: Integer,
        ta_money_amount :: Integer
    } | TAModifyExperience {
        ta_experience_account_id :: Integer,
        ta_experience_amount :: Integer
    } | TAGivePart | TATransferCar 
            deriving (Show, Eq)

type TaskActions = [TaskAction]
-}

$(genMapableRecord "ActionTopTime" [
        ("a_toptime_account_id", ''Integer),
        ("a_toptime_track_id", ''Integer),
        ("a_toptime_time", ''Double)
    ])

$(genMapableRecord "ActionModifyMoney" [
        ("a_money_account_id", ''Integer),
        ("a_money_amount", ''Integer)
    ])

$(genMapableRecord "ActionModifyExperience" [
        ("a_exp_account_id", ''Integer),
        ("a_exp_amount", ''Integer)
    ])

{-
$(genMapableRecord "ActionModifyExperience" [
    ])
-}

data WrappedAction =
      WrapTT ActionTopTime
    | WrapMM ActionModifyMoney
    | WrapME ActionModifyExperience
        deriving (Eq, Show)
 
type WrappedActions = [WrappedAction]

$(genAll "Task" "task" [             
                    ("id", ''Id),
                    ("type_id", ''Integer),
                    ("subject_id", ''Integer),
                    ("time", ''Integer),
                    ("data", ''String),
                    ("deleted", ''Bool)
   ])

