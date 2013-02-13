{-# LANGUAGE TemplateHaskell, ScopedTypeVariables #-}
module Model.Functions where 

import Model.DBFunctions 
import Data.SqlTransaction
import Database.HDBC (toSql, fromSql)
import Data.Database
import Data.HashMap.Strict

import qualified Model.Task as TK
import qualified Model.PartType as PT 
import qualified Model.CarInstanceParts as CIP

$(mkFunctions [
        ("account_update_energy", [''Integer], ''Bool, Scalar),
        ("personnel_train", [''Integer, ''String, ''String], ''Bool, Scalar),
        ("personnel_start_task", [''Integer, ''String, ''Integer], ''Bool, Scalar),
        ("personnel_cancel_task", [''Integer], ''Bool, Scalar),
        ("garage_actions_account", [''Integer], ''Bool, Scalar),
        ("car_get_worn_parts", [''Integer], ''CIP.CarInstanceParts, Row),
        ("car_get_missing_parts", [''Integer], ''PT.PartType, Row),
        ("garage_set_active_car", [''Integer, ''Integer], ''Bool, Scalar),
        ("garage_unset_active_car", [''Integer, ''Integer], ''Bool, Scalar),
        ("claim_tasks", [''Integer, ''Integer, ''Integer], ''TK.Task, Row),
        ("tasks_in_progress", [''Integer, ''Integer, ''Integer], ''Bool, Scalar),
        ("unix_timestamp", [], ''Integer, Scalar),
        ("unix_millitime", [], ''Integer, Scalar)
    ])
