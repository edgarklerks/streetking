{-# LANGUAGE OverloadedStrings #-}

{-|

This is where all the routes and handlers are defined for your site. The
'site' function combines everything together and is exported by this module.

-}

module Site
  ( site
  ) where

import           Control.Applicative
import           Control.Monad
import           Control.Monad.Trans
import           Data.Maybe
import qualified Data.ByteString.Char8 as B
import qualified Data.ByteString.Lazy.Char8 as BL
import           Database.Media 
import qualified Data.Text.Encoding as T
import           Snap.Extension.Heist
import           Snap.Extension.Timer
--import           Snap.Extension.Decoder
import           Snap.Util.FileServe
import           Snap.Types
import qualified Snap.Iteratee as SI
import qualified Data.Map as M
import           Text.Templating.Heist
import qualified Text.XmlHtml as X
import           Application
import qualified Data.Enumerator as E 
import qualified Data.Enumerator.List as EL
import qualified Network.Socket.Enumerator as ES
import qualified Network.Socket.ByteString as NB
import qualified Network.Socket as NS 
import           Foreign.C.Types (CInt)
import           Data.Monoid
import           Control.Arrow 
import qualified Network.HTTP.Enumerator as HE
import           Control.Monad.Identity
import           Control.Monad.Cont
import           Data.SqlTransaction
import           Database.AppToken
import           Database.Login --Register
import           Database.Register
import           Database.Task
import           Blaze.ByteString.Builder
import qualified Network.HTTP.Types as T
import qualified Control.Monad.CatchIO as CIO
import qualified Data.Aeson as A



-- | Passes requests to another server if constraints are met  
proxy :: Application ()
proxy = transparent <|> wall  

-- | Reverse application, gives an object oriented feel to record types
($>):: a -> (a -> b) -> b
($>) o a = a o 


-- snap to http-enumerator 
-- type Enumerator a m b = Step a m b -> Iteratee a m b 
-- type Iteratee a m b =  m (Step a m b)
-- type Step = Continue (Stream a -> Iteratee a m b)
--           | Yield b (Stream a)
--           | Error SomeException 
--

runHttp :: HE.Request t -> HE.Manager -> Application (Int, T.ResponseHeaders, B.ByteString)   
runHttp he m = do 
    bdy <- getRequestBody
    x <- E.run $ runHttp' he step m bdy 
    case x of 
        Left e -> internalError (show e)
        Right x -> return x
    where 
        runHttp' he f m bdy = HE.http (he {HE.requestBody = HE.RequestBodyLBS bdy }) (\s p -> f (T.statusCode s) p) m
        step s p =  E.continue $ iter s p B.empty
        iter s p z E.EOF = do 
                    E.yield (s, p, z) E.EOF
        iter s p z (E.Chunks xs) = E.continue (iter s p (z `B.append` (B.concat xs))) 
-- Step a m b -> Iteratee a m b 
goHttp :: Enumerator Builder IO a 
goHttp s = E.returnI s

-- | Actions, which will send the request to an backend server 
sendAbroad :: Request -> Application () 
sendAbroad req =
            let  accept = fromMaybe "application/json" $ getHeader "Accept" req
                 method = req $> rqMethod
                 uri = req $> rqURI
                 resource = req $> rqContextPath 
                 subresource = req $> rqPathInfo 
                 params = req $> rqParams 
                 request = HE.def {HE.method = B.pack . show $ method, HE.path = (resource `B.append` subresource)}  
            in do 
               (host, port) <- getServer  
               userid <- getRoles "user_token"
               devid <- getRoles "application_token"
               let prs = fmap (second (Just . head)) $ (M.toList params ++ (getUserId userid) ++ (getDeveloperId devid))
               m <- liftIO $  HE.newManager 
               (s,hp,bs) <- runHttp (request {HE.host = host, HE.port = port, HE.queryString = prs}) m   
               writeBS bs 
               liftIO $ HE.closeManager m
               modifyResponse (setResponseCode s)
               modifyResponse (findHeaderLocation hp)

findHeaderLocation ps r = case lookup "Location" ps of 
    Just x -> addHeader "Location" x r
    Nothing -> r

getUserId :: [Role] -> [(B.ByteString, [B.ByteString])]
getUserId = foldr step []
        where step (User (Just x)) z = ("userid",[B.pack $ show x]) : z
              step _ z = z

getDeveloperId :: [Role] -> [(B.ByteString, [B.ByteString])] 
getDeveloperId  = foldr step [] 
    where step (Developer (Just x)) z = ("devid", [B.pack $ show x]) : z
          step _ z = z

getDevId :: Application Integer 
getDevId = do 
        x <- getParam "devid" 
        case x of 
            Just y -> return (read $ B.unpack y)
            Nothing -> internalError "No devid"

-- | Be transparent
transparent :: Application ()
transparent = withRequest $ \req -> checkPerm req *> sendAbroad req

-- | Or run into the wall
wall :: Application ()
wall = modifyResponse (setResponseCode 403) *> writeBS "{\"error\":\"You don't have permission to access this resource\"}" *> (finishWith =<< getResponse)

internalError :: String -> Application a 
internalError x = modifyResponse (setResponseCode 500) *> (CIO.throw $ UserErrorE (B.pack x))

-- | Check permissions against cookie. Everybody has the all roll 
checkPerm :: Request -> Application ()
checkPerm req = may uri method >>= guard  
        where uri = stripSl $ tail $ B.unpack $ (req $> rqContextPath) `B.append`  (req $> rqPathInfo)
              method = frm $ req $> rqMethod 
              frm :: Method -> RestRight 
              frm POST = Post 
              frm GET = Get 
              frm DELETE = Delete 
              frm PUT = Put 
              frm _ = error "Fali"
              stripSl ['/'] = []
              stripSl [] = []
              stripSl (x:xs) = x : stripSl xs

-- | Identify the user and sets a cookie with a developer Role if the token is correct
-- 6 ^ 6 ^ 6 children is my eternal goal. 
-- For this I need a bank, 
-- 36 generations of 6,
-- be remembered 648 years,
-- and live 18 years without a soul. 
checkPerm' :: Application ()
checkPerm' = withRequest checkPerm  <|> wall

identify :: Application ()
identify = withConnection $ \c -> do 
    b <- getOpParam "token"
    u <- runSqlTransaction ( tokenDevId (B.unpack b)) internalError c  
    addRole "application_token" (Developer (Just . fromInteger $ u)) 

-- | Debug function to dump the current RoleState 
inspect :: Application ()
inspect = do 
        writeBS "Inspect" -- *> (writeBS . B.pack =<< withRoleState dumpAll)
        withRoleState $ \x -> do 
            y <- dumpAll x
            writeBS $ B.pack y
            z <- getRoles "user_token"
            x <- getRoles "application_token"
            writeBS $ B.pack $ show (z,x)

login :: Application ()
login = checkPerm' *> withConnection login''
        where login'' db = do 
                e <- B.unpack <$> getOpParam "email"
                p <- B.unpack <$> getOpParam "password"
                u <- runSqlTransaction (loginUserMinClearText e p) internalError db
                addRole "user_token" (User (Just . fromInteger $ u))

logout :: Application ()
logout = checkPerm'  *> dropRoles "user_token"

                

mediaGet :: Application () 
mediaGet = checkPerm' *> withConnection f 
    where f db = do 
            mid <- B.unpack <$> getOpParam "id"
            let xid = read mid :: Int
            (s,p) <- runSqlTransaction (mediaRoute xid) internalError db
            withRequest $ \r -> do 
                m <- liftIO $ HE.newManager
                (s,hp,bs) <- runHttp (mediaRequest r s p) m
                liftIO $ HE.closeManager m 
                writeBS bs
                modifyResponse (setResponseCode s)

mediaRequest :: Request -> String -> String -> HE.Request Application 
mediaRequest  req host port = let 
                 method = req $> rqMethod
                 uri = req $> rqURI
                 resource = req $> rqContextPath 
                 subresource = req $> rqPathInfo 
                 params = req $> rqParams 
                 reqParams = fmap (second (Just . head)) $ M.toList params 
                 request = HE.def {HE.method = B.pack . show $ method, HE.path = (resource `B.append` subresource), HE.port = (read port), HE.host = (B.pack host), HE.queryString = reqParams }  
            in request  

 
-- test Roles
roleApp :: Application()
roleApp = (not.null) <$>  getRoles "application_token" >>= writeLBS .  ("{\"result\":" `BL.append`) . (`BL.append` "}") . A.encode 

roleUser :: Application()
roleUser = (not.null) <$>  getRoles "user_token" >>= writeLBS .  ("{\"result\":" `BL.append` ) . (`BL.append` "}") . A.encode



-- return a new task
{-- 
makeNewTask :: Application ()
makeNewTask = do 
        writeBS "newTask " -- *> (writeBS . B.pack =<< withRoleState dumpAll)
        withRoleState $ \x -> do 
            db <- getDatabase
            x <- getRoles "application_token"
            appid <- getDevId
            u <- runSqlTransaction (newTaskAppid appid) internalError db 
            writeBS $ B.pack $ show (u)
--}
{-- --}

{--
index :: Application ()
index = do 
    r <- getRequest 
    heistLocal (bindSplices $ indexSplices r ) $ render "index"
  where
    indexSplices r =
        [ ("start-time",   startTimeSplice)
        , ("current-time", currentTimeSplice)
        , ("html", paths (rqPathInfo r))
        ]
paths xs = return [X.TextNode $ T.decodeASCII $ xs]

------------------------------------------------------------------------------
-- | Renders the echo page.
echo :: Application ()
echo = do
    message <- decodedParam "stuff"
    heistLocal (bindString "message" (T.decodeUtf8 message)) $ render "echo"
  where
    decodedParam p = fromMaybe "" <$> getParam p
--}
------------------------------------------------------------------------------
-- | The main entry point handler.
site :: Application ()
site = CIO.catch (route [ 
    ("/Application/identify", identify),
    ("/Application/inspect", inspect),
    ("/User/login", login),
    ("/User/logout", logout),
    ("/Role/application", roleApp),
    ("/Role/user", roleUser),
    ("/Media/get", mediaGet),
    ("/", proxy) ] ) $ \(UserErrorE e) -> 
        writeBS $ "{\"error\":\"" `B.append` e `B.append` "\"}" 

        

