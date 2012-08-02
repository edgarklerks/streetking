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
import qualified Data.ByteString.Char8 as C
import qualified Data.ByteString.Lazy as B

import qualified Data.HashMap.Strict as HM
import           Control.Applicative
import qualified Data.Map as M
import           Model.TH
import           Prelude hiding (id)


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

$(genMapableRecord "ActionSetTopTime" [
        ("a_toptime_account_id", ''Integer),
        ("a_toptime_track_id", ''Integer),
        ("a_toptime_time", ''Double)
    ])



instance Default C.ByteString where def = C.empty

$(genAll "Task" "task" [             
                    ("id", ''Id),
                    ("type", ''String),
                    ("time", ''Integer),
                    ("data", ''C.ByteString),
                    ("deleted", ''Bool)
   ])

