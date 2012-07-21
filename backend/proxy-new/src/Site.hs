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
        ("/identify", identify),
         ("/", transparent)

         ]


------------------------------------------------------------------------------
-- | The application initializer.
app :: SnapletInit App App
app = makeSnaplet "app" "An snaplet example application." Nothing $ do
    p <- nestSnaplet "sql" sql $ initSqlTransactionSnaplet "resources/server.ini"  
    prx <- nestSnaplet "proxy" proxy $ initProxy "resources/server.ini"
    dht <- nestSnaplet "node" node $ initDHTConfig "resources/server.ini"
    rnd <- nestSnaplet "rnd" rnd $ initRandomSnaplet l64  
    ps <- nestSnaplet "rls" roles $ initRoleSnaplet 
    addRoutes routes

    return $ App prx dht p rnd ps 

data UserException = UE String 
        deriving Typeable 

instance Show (UserException) where 
        show (UE s) = s

instance CIO.Exception UserException 

internalError = terminateConnection . UE 

checkPerm :: (?proxyTransform :: B.ByteString -> B.ByteString) =>  Request -> Handler App App () 
checkPerm req = with roles $ may uri method >>= guard 
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

transparent :: (?proxyTransform :: B.ByteString -> B.ByteString) => Handler App App ()  
transparent = withRequest $ \req -> checkPerm req *> with proxy runProxy 

($>) a f = f a

identify = do 
        b <- getOpParam "token"
        u <- runDb $ search ["application_token" |== toSql b] [] 1 0
        case u of 
            [] -> internalError "need token"
            [u] -> with roles $ addRole "application_token" (Developer $ A.id u) 

runDb x = with' S.sqlLens $ S.runDb internalError  x


getOpParam s = do 
        x <- getParam s
        case x of 
            Nothing -> internalError ("parameter " ++ B.unpack s ++ " not in querystring") 
            Just a -> return a
            

