{-# LANGUAGE TemplateHaskell #-}
module Model.Test where 

import Model.DBFunctions 
import Data.SqlTransaction
import Database.HDBC (toSql, fromSql)
import Data.Database
import Data.HashMap.Strict

$(mkFunctions [
    ("account_update_energy", [''Integer], undefined, Row)
    ])
