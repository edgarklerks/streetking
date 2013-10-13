{-# LANGUAGE OverloadedStrings, DeriveDataTypeable, ImplicitParams,NoMonomorphismRestriction, TupleSections #-}

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
import           NodeSnapletTest
import           ProxyExtendableSnapletConduit 
import           RoleSnaplet 
import           SqlTransactionSnaplet (initSqlTransactionSnaplet)
import qualified SqlTransactionSnaplet as S 
import           RandomSnaplet 
import           Data.Typeable
import qualified Control.Monad.CatchIO as CIO 
import qualified Data.ByteString.Char8 as B 
import qualified Data.ByteString.Char8 as C 
import           Control.Applicative 
import qualified Data.Aeson as A
import           Control.Monad 
import           Control.Comonad (extract) 
import qualified Data.Role 
import           Control.Monad.State
import           Data.Database hiding (sql, Delete)
import           Data.SqlTransaction
import           Model.General
import           Data.Monoid 
import           Database.HDBC.SqlValue
import qualified Model.Application as A
import           Control.Arrow (second)
import           Debug.Trace 
import           Data.List (tails, intercalate) 
import           Control.Exception.Base
import           LogSnaplet hiding (logCycle)
import qualified LogSnaplet as LSS 
import           Snap.Snaplet ()
------------------------------------------------------------------------------
import           Application

data ApplicationException = UserErrorE C.ByteString
    deriving (Typeable, Show)

instance CIO.Exception ApplicationException

logCycle x y = with logcycle $ LSS.logCycle x y    

enroute (n,x) = (B.pack n,) $ do 
--         modifyRequest (setHeader "Content-Type" "application/x-www-form-urlencoded")
        g <- rqMethod <$> getRequest 
        case g of 
            OPTIONS -> allowAll 
            otherwise -> allowAll *> logCycle "proxy_resources" n *> let b = CIO.catch x (\(UserErrorE e) -> writeBS $ "{\"error\":\"" <> (e) <> "\"}") in CIO.catch b (\(SomeException e) -> writeBS $ "{\"error\":\"" <> (B.pack $ show e) <> "\"}")



------------------------------------------------------------------------------
-- | The application's routes.
routes :: [(ByteString, Handler App App ())]
routes = let ?proxyTransform = id in fmap enroute $ [ 
           ("/Application/identify", identify)
         , ("/User/logout", return ())
         , ("/test", writeBS "Hello world")
         , ("/Role/application", roleApp)
         , ("/Role/user", roleUser)
         , ("/crossdomain.xml", crossDomain)
         , ("/", transparent)
         ]

-- cross domain shizzle for unity
crossDomain :: Application()
crossDomain = do
    modifyResponse (addHeader "Content-Type" "text/xml")
    writeBS $ B.pack $ ("<?xml version=\"1.0\"?><cross-domain-policy><allow-access-from domain=\"*\"/></cross-domain-policy>" :: String)


------------------------------------------------------------------------------
-- | The application initializer.
app :: SnapletInit App App
app = makeSnaplet "app" "An snaplet example application." Nothing $ do
    p <- nestSnaplet "" sql $ initSqlTransactionSnaplet "resources/server.ini"  
    ls <- nestSnaplet "" logcycle $ initLogSnaplet "resources/server.ini"
    prx <- nestSnaplet "" proxy $ initProxy  "resources/server.ini"
    dht <- nestSnaplet "" node $ initDHTConfig "resources/server.ini"  

    rnd <- nestSnaplet "" rnd $ initRandomSnaplet l64  
    ps <- nestSnaplet "" roles $ initRoleSnaplet rnd dht ls 

    addRoutes routes

    return $ App prx dht p rnd ps ls  


split :: Eq a => a -> [a] -> [[a]]
split c xs = foldr step [] xs
    where step x z@(y:ys) | x == c = [] : z 
                          | otherwise = ((x:y):ys)
          step x [] = [[x]]

checkAny method b = worker (tails $ split '/' b)
    where worker (uri:xs) = do 
                    s <- with roles $ may (intercalate "/" uri) method 
                    if s then return True else worker xs 
          worker [] = return False   

internalError = terminateConnection . UserErrorE . C.pack  

checkPerm req = (checkAny method uri) >>= \x -> unless x (internalError "You are not allowed to access the resource")
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

getServerId  = foldr step [] 
    where step (Server (Just x)) z = ("srvid", Just $ B.pack $ show x) : z
          step _ z = z


transparent = do
        logCycle "proxy_resources" "transparent" 
        withRequest $ \req ->  checkPerm req *> do 
                                                  ns <- with roles $ getRoles "user_token"
                                                  ps <- with roles $ getRoles "application_token"
                                                  ss <- with roles $ getRoles "server_token" 
                                                  with proxy (runProxy $ (getUserId ns) ++ (getDeveloperId ps) ++ (getServerId ss))

($>) a f = f a

identify = do 
        b <- getOpParam "token"
        u <- runDb $ (search ["token" |== toSql b] [] 1 0 :: SqlTransaction Connection [A.Application])
        withTop roles $ 
            case u of 
                [] -> internalError "need token"
                [u] -> do
                    addRole "application_token" (Developer $ A.id u)  >> return ()

runDb x = with sql $ S.runDb internalError  x


getOpParam s = do 
        x <- getParam s
        case x of 
            Nothing -> internalError ("parameter " ++ B.unpack s ++ " not in querystring") 
            Just a -> return a
            
allowAll = allowCredentials *> allowOrigin *> allowMethods *> allowHeaders
        
-- -Access-Control-Allow-Origin: * 

allowOrigin :: Application ()
allowOrigin = do 
            g <- getRequest
            modifyResponse (addHeader "Content-Type" "text/plain")
            modifyResponse (\x -> 
               case getHeader "Origin" g of 
                    Nothing ->  addHeader "Access-Control-Allow-Origin" "*" x
                    Just n ->   addHeader "Access-Control-Allow-Origin" n x
                )
-- Access-Control-Allow-Credentials: true  

allowCredentials :: Application () 
allowCredentials = modifyResponse (addHeader "Access-Control-Allow-Credentials" "true")

allowMethods :: Application ()
allowMethods = modifyResponse (addHeader "Access-Control-Allow-Methods" "POST, GET, OPTIONS, PUT")

allowHeaders :: Application ()
allowHeaders = modifyResponse (addHeader "Access-Control-Allow-Headers" "origin, content-type, accept, cookie");


roleApp :: Application()
roleApp = with roles $ (not.null) <$>  getRoles "application_token" >>= writeLBS .  ("{\"result\":" <>) . (<> "}") . A.encode 

roleUser :: Application()
roleUser = with roles $ do 
        xs <- getRoles "user_token"
        case xs of 
            [] -> writeLBS "{\"result\":0}" 
            [User (Just x)] -> writeLBS "{\"result\":1}" 
            [User (Nothing)] -> writeLBS "{\"result\":0}" 


