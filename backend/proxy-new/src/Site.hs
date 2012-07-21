{-# LANGUAGE OverloadedStrings, DeriveDataTypeable, ImplicitParams,NoMonomorphismRestriction #-}

------------------------------------------------------------------------------
-- | This module is where all the routes and handlers are defined for your
-- site. The 'app' function is the initializer that combines everything
-- together and is exported by this module.
module Site
  ( app
  ) where

------------------------------------------------------------------------------
import           Control.Applicative
import           Data.ByteString (ByteString)
import           Data.Maybe
import qualified Data.Text as T
import           Snap.Core
import           Snap.Snaplet
import           Snap.Util.FileServe
import           NodeSnaplet
import           ProxySnaplet 
import           RoleSnaplet 
import           SqlTransactionSnaplet (initSqlTransactionSnaplet)
import qualified SqlTransactionSnaplet as S 
import           RandomSnaplet 
import           Data.Typeable
import qualified Control.Monad.CatchIO as CIO 
import qualified Data.ByteString.Char8 as B 
import qualified Data.ByteString.Char8 as C 
import Control.Applicative 
import Control.Monad 
import qualified Data.Role 
import Control.Monad.State
import Data.Database hiding (sql, Delete)
import Data.SqlTransaction
import Model.General
import Database.HDBC.SqlValue
import qualified Model.Application as A
------------------------------------------------------------------------------
import           Application




------------------------------------------------------------------------------
-- | The application's routes.
routes :: [(ByteString, Handler App App ())]
routes = let ?proxyTransform = id in [ 
          ("/identify", identify)
         , ("/test", writeBS "Hello world")
        , ("/", transparent)
         ]


------------------------------------------------------------------------------
-- | The application initializer.
app :: SnapletInit App App
app = makeSnaplet "app" "An snaplet example application." Nothing $ do
    p <- nestSnaplet "" sql $ initSqlTransactionSnaplet "resources/server.ini"  
    prx <- nestSnaplet "" proxy $ initProxy "resources/server.ini"
    dht <- nestSnaplet "" node $ initDHTConfig "resources/server.ini"

    rnd <- nestSnaplet "" rnd $ initRandomSnaplet l64  
    ps <- nestSnaplet "" roles $ initRoleSnaplet rnd dht 
    addRoutes routes

    return $ App prx dht p rnd ps 

data UserException = UE String 
        deriving Typeable 

instance Show (UserException) where 
        show (UE s) = s

instance CIO.Exception UserException 

internalError = terminateConnection . UE 

checkPerm req = do
            liftIO $ print uri 
            liftIO $ print method 
            (with roles $ may uri method) >>= guard 
    where uri = stripSL $ B.unpack $ ?proxyTransform $ B.tail  (req $> rqContextPath) `B.append` (req $> rqPathInfo) 
          method = frm $ req $> rqMethod 
          frm :: Method -> RestRight 
          frm POST = Post 
          frm GET = Get 
          frm DELETE = Delete 
          frm PUT = Put 
          frm _ = error "not allowed method"
          stripSL ['/'] = []
          stripSL [] = []
          stripSL (x:xs) = x : stripSL xs 

getUserId = foldr step []
        where step (User (Just x)) z = ("userid",Just $ B.pack $ show x) : z
              step _ z = z

getDeveloperId  = foldr step [] 
    where step (Developer (Just x)) z = ("devid", Just $ B.pack $ show x) : z
          step _ z = z


transparent = do
        withRequest $ \req -> checkPerm req *> do 
                                                  ns <- with roles $ getRoles "user_token"
                                                  ps <- with roles $ getRoles "application_token"
                                                  with proxy (runProxy $ (getUserId ns) ++ (getDeveloperId ps))

($>) a f = f a

identify = do 
        b <- getOpParam "token"
        liftIO $ print b
        u <- runDb $ (search ["token" |== toSql b] [] 1 0 :: SqlTransaction Connection [A.Application])
        withTop roles $ 
            case u of 
                [] -> internalError "need token"
                [u] -> addRole "application_token" (Developer $ A.id u)  >> return ()

runDb x = with sql $ S.runDb internalError  x


getOpParam s = do 
        x <- getParam s
        case x of 
            Nothing -> internalError ("parameter " ++ B.unpack s ++ " not in querystring") 
            Just a -> return a
            

