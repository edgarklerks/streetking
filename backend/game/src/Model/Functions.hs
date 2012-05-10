{-# LANGUAGE TemplateHaskell #-}
module Model.Functions where 

import Model.DBFunctions 
import Data.SqlTransaction
import Database.HDBC (toSql, fromSql)
import Data.Database
import Data.HashMap.Strict

$(mkFunctions [
    ("account_update_energy", [''Integer], ''Bool, Scalar),
    ("personnel_train", [''Integer, ''String, ''String], ''Bool, Scalar),
    ("personnel_start_task", [''Integer, ''String, ''Integer], ''Bool, Scalar)
    ])
