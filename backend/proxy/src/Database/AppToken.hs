module Database.AppToken where 

import Data.SqlTransaction 


loginApp :: IConnection c => String -> SqlTransaction c Integer 
loginApp pw = do 
    x <- sqlGetOne "select id from application where token = ?" [toSql pw]
    case fromSql x of 
        Nothing -> rollback "no such application"
        Just id -> return id 

