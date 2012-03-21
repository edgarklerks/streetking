{-# LANGUAGE EmptyDataDecls #-}
module Database.Upload where 
import qualified Data.ByteString as B
import Database.HDBC
import Database.HDBC.PostgreSQL
import Useful
import Useful.IO
import Control.Monad
import Config.ConfigFileParser
{--
main :: IO ( )
main = do x <- readFile "data.txt"
          print x 
          let user_id = 4
          print user_id
          connection <- connectPostgreSQL "hostaddr = 192.168.1.66 port = 5432 dbname = deos user = postgres password = wetwetwet"
          begin connection
          statement <- prepare connection "select ST_X(g.location), ST_Y(g.location), g.id from graffiti g"
          succeed <- execute statement []
          valuesSQL <- fetchAllRows statement
          y <- readFile "config.conf"
          case (parse fileParser "config.conf" y) of
             Left err  -> print err
             Right xs  -> print xs 
          statement <- prepare connection "insert into Media_task values  (" ++ user_id ++ "," ++ path ++ "," ++ serverName ++ ", ST_GeomFromText('POINT(@groupLocation)'))""
--          foreach (concat valuesSQL) (print . fromSql) 
          -- do foreach [1..3] print
          
          print $ (fmap.fmap) (\i -> fromSql i :: String) valuesSQL
data Mock 
data Unix 

data FileType = Image 
              | Video
              | Audio 

mock :: Mock
mock = undefined 

unix :: Unix 
unix = undefined 

class GetMagic a where 
    getMagic :: a -> FilePath -> FileType
          
instance GetMagic Mock where 
    getMagic _ f = Image 
 
instance GetMagic Unix where 
    getMagic _ f = undefined -- todo unix code 
   --}
