module Database.Media where 

import Data.SqlTransaction

mediaRoute :: IConnection c => Int -> SqlTransaction c (String, String)
mediaRoute x = do 
    p <- sqlGetOne "select servername from media_task where id=?" [toSql x] 
    let (x, z) = break (==':') $ fromSql p
    return (x, tail z)
