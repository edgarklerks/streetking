{-# LANGUAGE TemplateHaskell #-}
module Model.Functions where 

import Model.DBFunctions 
import Data.SqlTransaction
import Database.HDBC (toSql, fromSql)
import Data.Database
import Data.HashMap.Strict

import qualified Model.Task as TK

$(mkFunctions [
    ("account_update_energy", [''Integer], ''Bool, Scalar),
    ("personnel_train", [''Integer, ''String, ''String], ''Bool, Scalar),
    ("personnel_start_task", [''Integer, ''String, ''Integer], ''Bool, Scalar),
    ("personnel_cancel_task", [''Integer], ''Bool, Scalar),
    ("garage_actions_account", [''Integer], ''Bool, Scalar),
    ("garage_car_ready", [''Integer, ''Integer], ''String, Row),
    ("garage_active_car_ready", [''Integer], ''String, Row),
    ("garage_set_active_car", [''Integer, ''Integer], ''Bool, Scalar),
    ("garage_unset_active_car", [''Integer, ''Integer], ''Bool, Scalar),
    ("claim_tasks", [''Integer, ''Integer, ''Integer], ''TK.Task, Row)
    ])
