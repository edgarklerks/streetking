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

import qualified Data.HashMap.Strict as HM
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

$(genMapableRecord "ActionModifyMoney" [
        ("a_money_account_id", ''Integer),
        ("a_money_amount", ''Integer)
    ])

$(genMapableRecord "ActionModifyExperience" [
        ("a_exp_account_id", ''Integer),
        ("a_exp_amount", ''Integer)
    ])

$(genMapableRecord "ActionTransferMoney" [
        ("a_tmon_target_account_id", ''Integer),
        ("a_tmon_source_account_id", ''Integer),
        ("a_tmon_amount", ''Integer)
    ])

$(genMapableRecord "ActionTransferCar" [
        ("a_tcar_target_account_id", ''Integer),
        ("a_tcar_source_account_id", ''Integer), -- not strictly necessary
        ("a_tcar_instance_id", ''Integer)
    ])

$(genMapableRecord "ActionGivePart" [
        ("a_part_account_id", ''Integer),
        ("a_part_model_id", ''Integer)
    ])



$(genAll "Task" "task" [             
                    ("id", ''Id),
                    ("type", ''String),
                    ("subject_id", ''Integer),
                    ("time", ''Integer),
                    ("data", ''String),
                    ("deleted", ''Bool)
   ])

