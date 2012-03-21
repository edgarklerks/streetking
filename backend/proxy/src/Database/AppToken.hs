module Database.AppToken where

-- This is a file to test & develop new functions that 
-- connect to the Database. If you want or need a function from here. Please refractor
--
{--
fmap g . fmap h = fmap ( g. h)
fmap id = id 
fmap g . (fmap h . fmap i) = (fmap g . fmap h) . fmap i
--}
import Control.Concurrent
import Control.Applicative 
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
import Network
import Data.Bits

import qualified Data.ByteString.Char8 as S
import qualified Data.ByteString.Lazy.Char8 as L
import qualified Data.IntSet as I

import Data.Object
import Data.Object.Yaml

import Data.InRules
import Data.Conversion

import Data.Security 

import Data.Time.Calendar
import Data.Time.Clock
import Data.Time.LocalTime


import Database.HDBC.SqlValue
 
--import Database.HDBC
import Data.SqlTransaction

import Database.HDBC.PostgreSQL -- Database.HaskellDB.HDBC.PostgreSQL

import System.Random

--import JSONRPC.Server
--import Database.HDBC.PostgreSQL
    
 
 
emailFromIdDevString ::  String
emailFromIdDevString = "select email from developer where id  = ? ;"

insertTokenDevMinString ::  String
insertTokenDevMinString = "insert into tokens (date_created,date_updated, token,user_type, user_id) "
                        ++"values ( unix_timestamp(), unix_timestamp(), ?, 'developer', ?);" 


tokenExistDevString ::  String
tokenExistDevString = "select count(*) > 0 from tokens where token  = ? ;"


insertTokenAppIdDevString ::  String
insertTokenAppIdDevString = "insert into tokens (date_created,date_updated, token,user_type, user_id,application_id )"
                            ++" values ( unix_timestamp(), unix_timestamp(), ?, 'developer', ?,?);" 



tokenDev :: String -> Integer -> [SqlValue]
tokenDev token userid =  [toSql token, toSql userid]
-- conv2SqlArray( InArray ([ (toInRule token), (toInRule userid)]) ) 

tokenAppDev :: String -> Integer -> Integer -> [SqlValue]
tokenAppDev token userid appid = [toSql token, toSql userid, toSql appid]
-- conv2SqlArray( InArray ([ (toInRule token), (toInRule userid), (toInRule appid) ]) ) 

tokenDevIdString :: String 
tokenDevIdString = "select application_id from tokens where token  = ? limit 1;"


tokenDevId :: String -> SqlTransaction Connection Integer
tokenDevId x = do 
       id@(~((x:xs):ys)) <- quickQuery' tokenDevIdString [(toSql x)] 
       when (null id) (rollback "This developer does not exist")
       return $ fromSql x 

idDevIdApp2newToken ::  Integer -> Integer -> SqlTransaction Connection String
idDevIdApp2newToken  id appid =  do                         
                         email <- quickQuery' emailFromIdDevString [toSql id]
                         rchar <- liftIO $ randomRIO ('a','z')
                         let eml =  fromSql $ head $ head email
                         let token = tiger $ eml ++ (rchar:(show id)) ++ (show appid) 
                         tokenrenew <- quickQuery' tokenExistDevString [toSql token]
                         when ( fromSql (head $ head tokenrenew ) ) $ rollback "token exists already"
                         run insertTokenAppIdDevString (tokenAppDev token id appid )
                         return token


appIdFromDevIdAppNameString ::  String
appIdFromDevIdAppNameString = "select id from application where developer_id=? and name=?;"

devIdAppName :: Integer ->  String -> [SqlValue]
devIdAppName userid appname = [toSql userid, toSql appname]
-- conv2SqlArray( InArray ([ (toInRule userid), (toInRule appname) ]) ) 


newTokenForApp :: Integer -> String -> SqlTransaction Connection String
newTokenForApp devid appname = do
                              appidSql <- quickQuery' appIdFromDevIdAppNameString (devIdAppName devid appname )                            
                              when (null appidSql) (rollback "no application for developer with that name")
                              let appid = fromSql $ head $ head appidSql 
                              idDevIdApp2newToken devid appid

selectLatestTokenDevIdString :: String 
selectLatestTokenDevIdString = "select token from tokens where application_id = ? order by date_created desc limit 1;"

getLatesTokenOfApp :: Integer -> String -> SqlTransaction Connection String
getLatesTokenOfApp devid appname = do
               appidSql <- quickQuery' appIdFromDevIdAppNameString (devIdAppName devid appname )                            
               when (null appidSql) (rollback "no application for developer with that name")
               let appid = fromSql $ head $ head appidSql 
               sla <- getLatesTokenOfAppId devid appid
               return sla

               
getLatesTokenOfAppId :: Integer -> Integer -> SqlTransaction Connection String
getLatesTokenOfAppId devid appid  = do
               appTokenSql <- quickQuery' selectLatestTokenDevIdString ( [toSql appid] )      
               if (null appTokenSql ) then do                      
                    idDevIdApp2newToken devid appid
               else return (fromSql $ head $ head appTokenSql)       
                

selectAppsDevNameString ::  String
selectAppsDevNameString = "select id, name from application where developer_id = ? and name ilike ?;" 



devGetAppNameLike :: Integer ->  String -> SqlTransaction Connection InRule
devGetAppNameLike devid name  = do  
        devAppsSql <- quickQuery selectAppDevMinString [  toSql devid ,toSql $ stringLike name]
        return (convFromSqlAA devAppsSql)


selectAppDevMinString ::  String
selectAppDevMinString = "select id from application where developer_id = ? and name = ?;" 

devGetAppName :: Integer ->  String -> SqlTransaction Connection Integer
devGetAppName devid name  = do  
        devAppsSql <- quickQuery selectAppDevMinString [  toSql devid ,toSql name]
        return (fromSql (head $ head devAppsSql)::Integer)


selectAppsDevMinString ::  String
selectAppsDevMinString = "select name from application where developer_id = ? ;" 


 
devGetApps :: Integer ->  SqlTransaction Connection InRule
devGetApps devid    = do  
        devAppsSql <- quickQuery selectAppsDevMinString [  toSql devid  ]
        return (convFromSqlAA devAppsSql )



selectDevFromAppIdString ::  String
selectDevFromAppIdString = "select developer_id from application where id = ? ;" 

devGetIdFromAppId :: Integer ->  SqlTransaction Connection Integer
devGetIdFromAppId appid    = do  
        devAppsSql <- quickQuery selectDevFromAppIdString [  toSql appid  ]
        return (fromSql $ head $ head devAppsSql )

