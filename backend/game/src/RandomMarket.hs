module Main where 

import qualified  Model.MarketItem as MI 
import qualified  Model.Account as A
import qualified  Model.PartInstance as P
import            Model.General
import            Data.SqlTransaction
import            Data.Database
import            Database.HDBC.Types
import            Database.HDBC.PostgreSQL
import            Control.Monad
import            Control.Applicative


runDb :: SqlTransaction Connection a -> IO a
runDb f = do 
    d <- dbconn
    runSqlTransaction f error d <* disconnect d


loadUsers :: SqlTransaction Connection [A.Account] 
loadUsers = search [] [] 100 00


loadParts :: A.Account -> SqlTransaction Connection [P.PartInstance]
loadParts = search [] [] 100 00

saveMarketItem = do 
    xs <- loadUsers 
    sequence $ xs >>= loadParts  


