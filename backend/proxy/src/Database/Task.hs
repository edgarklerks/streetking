{-# LANGUAGE ViewPatterns #-}
module Database.Task where


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
import Database.HDBC.SqlValue

import Data.SqlTransaction 
import Database.HDBC.PostgreSQL -- Database.HaskellDB.HDBC.PostgreSQL

import System.Random   

import Database.AppToken
{-- 
 -task has appid 
    task token
 -
 - taskNew return token
 -      make new task 
 - taskDone return true or false 
 - --}



randomString :: Integer -> IO String
randomString x 
   | x <= 0 = do y <- randomRIO ('a','z')
                 return ([y])
   | otherwise = do y <- randomRIO ('a','z')
                    ys <-  randomString (x - 1) 
                    return (  [y] ++ ys )                       


                       
saltBurn ::  [Char] -> IO String
saltBurn str = do 
                  saltStr <- randomString 42
                  let ground =  tiger( str ++ saltStr )
                  return ground
 
insertTaskMinString :: String
insertTaskMinString = "insert into social_tasks (date_created,date_updated,task_token, app_id  )"
                           ++" values(unix_timestamp(), unix_timestamp(), ?, ? ) returning id;" 

newTaskAppid ::  Integer -> SqlTransaction Connection String
newTaskAppid appid = do 
     devid <- devGetIdFromAppId appid
     tasktoken <- newTask devid appid
     return tasktoken

newTask :: Integer -> Integer -> SqlTransaction Connection String
newTask devid appid@(toSql -> sappid ) = do 
    tokenApp <- getLatesTokenOfAppId devid appid
    tasktoken <- liftIO (saltBurn tokenApp)
    acExist <- quickQuery' insertTaskMinString [toSql tasktoken ,sappid ]
    when (null acExist) (rollback "Inserting new Task Failed.")
    return tasktoken
    
getTokenTaskString:: String
getTokenTaskString = "select task_token from social_tasks where id = ? ;" 

getTaskToken ::  Integer -> SqlTransaction Connection String
getTaskToken taskid@(toSql -> staskid ) = do
    acExist <- quickQuery' getTokenTaskString [staskid ]
    when (null acExist) (rollback "getTaskToken Failed.")
    return (fromSql $ head $ head acExist)

getIdTaskString:: String
getIdTaskString = "select id from social_tasks where task_token = ? ;" 

getTaskId ::  String -> SqlTransaction Connection Integer
getTaskId tasktoken@(toSql -> stasktoken   ) = do
    acExist <- quickQuery' getIdTaskString [stasktoken ]
    when (null acExist) (rollback "getTaskId Failed.")
    return (fromSql $ head $ head acExist)


updateTaskFinishedString :: String
updateTaskFinishedString = "update social_tasks set date_updated = unix_timestamp() , finished = True where "
                           ++" id = ? ;" 

finishTask ::  Integer -> SqlTransaction Connection Integer
finishTask taskid@(toSql -> staskid ) = do
    acExist <- run updateTaskFinishedString [staskid ]
    --when (null acExist) (rollback "finishTask Failed.")
    return ( acExist)


finishTaskToken ::  String -> SqlTransaction Connection Integer
finishTaskToken  tasktoken = do
     tid <- getTaskId tasktoken
     finishTask tid

--  "select token from tokens where application_id = ? order by date_created desc limit 1;"
getTaskDoneString:: String
getTaskDoneString = "select finished from social_tasks where task_token = ?  order by date_created desc limit 1 ;" 

isTaskFinished ::  String -> SqlTransaction Connection Bool
isTaskFinished  tasktoken@(toSql -> stasktoken   ) = do
    acExist <- quickQuery' getTaskDoneString [stasktoken ]
    when (null acExist) (rollback "isTaskFinished Failed.")
    return (fromSql $ head $ head acExist)


getTaskDoneIdString:: String
getTaskDoneIdString = "select finished from social_tasks where id = ? ;" 

isTaskFinishedId ::  Integer -> SqlTransaction Connection Bool
isTaskFinishedId taskid@(toSql -> staskid ) = do
    acExist <- quickQuery' getTaskDoneIdString [staskid ]
    when (null acExist) (rollback "isTaskFinished Failed.")
    return (fromSql $ head $ head acExist)




getTaskDoneAppIdString:: String
getTaskDoneAppIdString = "select app_id from social_tasks where id = ? and finished = true;" 

getTaskFinishedAppId ::  Integer -> SqlTransaction Connection Integer
getTaskFinishedAppId taskid@(toSql -> staskid ) = do
    acExist <- quickQuery' getTaskDoneAppIdString [staskid ]
    when (null acExist) (rollback "task has not finished or does not exist.")
    return (fromSql $ head $ head acExist)

getTaskFinishedAppIdToken tasktoken@(toSql -> stasktoken   ) = do
    tid <- getTaskId tasktoken
    appid <- getTaskFinishedAppId tid
    return appid



getTaskSocialString:: String
getTaskSocialString = "select app_id, task_network, network_token, network_token_secret from social_tasks "
                    ++"where task_token = ? and finished = true order by date_created desc limit 1;" 

getTaskSocial tasktoken@(toSql -> stasktoken   ) = do
    acExist <- quickQuery' getTaskSocialString [stasktoken ]
    when (null acExist) (rollback "task or token does not exist or is not finished.")
    return (head acExist)



