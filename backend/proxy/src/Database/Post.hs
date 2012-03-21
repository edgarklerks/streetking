module Post where


import Control.Concurrent
import Control.Monad
import Control.Monad.State
import Control.Monad.Identity
import Control.Monad.Trans
import Data.Maybe
import Control.Monad.Maybe
import Data.Generics
import Data.Word
import Data.Int
import Control.Monad.Error

import qualified Data.Text as T

import Data.List

--
import Data.JSON2
import Network
import Data.Bits

import qualified Data.ByteString.Char8 as S
import qualified Data.ByteString.Lazy.Char8 as L
import qualified Data.IntSet as I

import Data.Object
import Data.Object.Yaml

import Data.InRules
import Data.Conversion


import Data.Time.Calendar
import Data.Time.Clock
import Data.Time.LocalTime


import Database.HDBC.SqlValue

import Data.Digest.TigerHash
import Data.Digest.TigerHash.ByteString

--import Database.HDBC
import Data.SqlTransaction

import Database.HDBC.PostgreSQL -- Database.HaskellDB.HDBC.PostgreSQL

import System.Random

--import JSONRPC.Server
--import Database.HDBC.PostgreSQL
  
 
 
main ::  IO ()
main = do
    putStrLn "Hallo."
  
 
tiger ::  [Char] -> String
tiger str =  b32TigerHash. tigerHash $ (L.pack str)

cnpst ::  IO Connection
cnpst = connectPostgreSQL "host=graf3.graffity.me port=5432 dbname=deosx user=graffiti password=wetwetwet"

connectDb ::  IO Connection
connectDb = cnpst

rightVal ::  Either [Char] t -> t
rightVal (Right a) = a
rightVal (Left b)  = error ( "no right value because: " ++ b )
--

testDevIns ::  IO ()
testDevIns = do
    c <- cnpst 

    disconnect c



numberAppsDeveloperString ::  [Char]
numberAppsDeveloperString = "select count(*) from application where developer_id  = ? ;"

insertAppDevMinString ::  [Char]
insertAppDevMinString = "insert into application (date_created,date_updated, developer_id,name ) values ( now(), now(), ?, ?);" 

newAppDev :: Integer ->  String -> [SqlValue]
newAppDev userid appname = conv2SqlArray( InArray ([ (toInRule userid), (toInRule appname) ]) ) 

makeNewAppName :: Integer -> String -> SqlTransaction Connection Integer 
makeNewAppName userid name = run insertAppDevMinString (newAppDev userid name )


makeNewApp ::  Integer -> SqlTransaction Connection Integer 
makeNewApp userid = do      
                         nmbApps <- quickQuery' numberAppsDeveloperString [(conv2Sql $ toInRule userid )]
                         let nmb = (fromSql (head $ head nmbApps)::Integer)
                         makeNewAppName userid ("NewApplication"++show(nmb+1) )

 
emailFromIdDevString ::  [Char]
emailFromIdDevString = "select email from developer where id  = ? ;"

insertTokenDevMinString ::  [Char]
insertTokenDevMinString = "insert into tokens (date_created,date_updated, token,user_type, user_id) values ( now(), now(), ?, 'developer', ?);" 


tokenExistDevString ::  [Char]
tokenExistDevString = "select count(*) > 0 from tokens where token  = ? ;"


insertTokenAppIdDevString ::  [Char]
insertTokenAppIdDevString = "insert into tokens (date_created,date_updated, token,user_type, user_id,application_id )"
                            ++" values ( now(), now(), ?, 'developer', ?,?);" 



tokenDev :: String -> Integer -> [SqlValue]
tokenDev token userid =  conv2SqlArray( InArray ([ (toInRule token), (toInRule userid)]) ) 

tokenAppDev :: String -> Integer -> Integer -> [SqlValue]
tokenAppDev token userid appid = conv2SqlArray( InArray ([ (toInRule token), (toInRule userid), (toInRule appid) ]) ) 



idDevIdApp2newToken ::  Integer -> Integer -> SqlTransaction Connection String
idDevIdApp2newToken  id appid =  do                         
                         email <- quickQuery' emailFromIdDevString [(conv2Sql $ toInRule id )]
                         rchar <- liftIO $ randomRIO ('a','z')
                         let arstr = rchar:[]
                         let eml =  fromSql $ head $ head email
                         let token = tiger ( eml ++ arstr ++ (show id) ++ (show appid) )
                         tokenrenew <- quickQuery' tokenExistDevString [(conv2Sql $ toInRule token )]  
                         when ( fromSql (head $ head tokenrenew ) ) $ rollback "token exists already"
                         run insertTokenAppIdDevString (tokenAppDev token id appid )
                         return token


appIdFromDevIdAppNameString ::  [Char]
appIdFromDevIdAppNameString = "select id from application where developer_id=? and name=?;"


newTokenForApp :: Integer -> String -> SqlTransaction Connection String
newTokenForApp devid appname = do
                              appidSql <- quickQuery' appIdFromDevIdAppNameString (newAppDev devid appname )
                              if ( (length appidSql) > 0 ) then do
                                let appid =  ( fromSql (head $ head appidSql )::Integer )
                                idDevIdApp2newToken devid appid
                              else rollback "no application for developer with that name"

newAppWithToken :: Integer -> String -> SqlTransaction Connection String
newAppWithToken devid appname = makeNewAppName  devid appname >>
                                newTokenForApp  devid appname 
                          


