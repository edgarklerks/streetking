module Model.Ansi where 

import Data.SqlTransaction
import Database.HDBC.SqlValue
import Database.HDBC.PostgreSQL 
import Model.General 
import Control.Applicative 


isNullable :: String -> String -> SqlTransaction Connection Bool 
isNullable table field = do 
                    s <- fromSql <$> sqlGetOne "select is_nullable from information_schema.columns where table_name = ? and column_name = ?" [toSql table, toSql field]
                    return (s == "YES")


