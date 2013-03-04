module Main where 


import Database.HDBC.PostgreSQL 
import Data.SqlTransaction
import Control.Applicative
import Control.Monad.Trans
import Model.General
import qualified Model.Race as R 
import qualified Model.AccountProfile as A 
import qualified Model.CarInGarage as C 
import Database.HDBC
import Data.Racing 
import Data.Maybe

conn :: IO Connection
conn = connectPostgreSQL "user=deosx password=#*rl& dbname=streetking_dev host=db.graffity.me" 


runDb :: SqlTransaction Connection a -> IO a
runDb m = do 
        c <- conn 
        runSqlTransaction m error c <* disconnect c

type SQ = SqlTransaction Connection 
test = do 
    (car,acc) <- par2 (fromJust <$> (load 226) :: SQ C.CarInGarage) (fromJust <$> (load 34) :: SQ A.AccountProfile)
    let rd = RaceData acc car def  
    liftIO $ print $ toSql car 
    save (def {R.track_id  = 1, R.type = 1, R.data = [rd] } :: R.Race)


test2 = do 
    x <- load 4  
    liftIO $ print (x :: Maybe R.Race)
