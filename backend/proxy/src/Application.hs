{-# LANGUAGE OverloadedStrings,TypeOperators, TypeSynonymInstances, MultiParamTypeClasses, ScopedTypeVariables,ViewPatterns, DeriveDataTypeable #-}
{-

This module defines our application's monad and any application-specific
information it requires.

-}

module Application
  ( Application
  , applicationInitializer
  , may
  , addRole 
  , withRoleState
  , R.dumpAll 
  , R.Role(..)
  , R.RestRight(..)
  , R.Resource
  , R.Method(..)
  , dropRoles
  , getRoles
  , getServer
  , withConnection
  , getOpParam 
  , R.Id(..),
  ApplicationException(..)
  ) where
import           Data.Typeable
import           Data.DChan
import           Data.Binary
import           Snap.Extension
import           Snap.Types
import           Control.Concurrent.STM
import           Control.Monad.Reader
import           Data.ByteString.Char8 (unpack, pack) 
import           Data.List (break)
import           Data.Word
import qualified System.Entropy as E 
import qualified Data.Map as M
import qualified Data.Digest.TigerHash as H
import qualified Data.Digest.TigerHash.ByteString as H
import           Text.Printf
import qualified Data.ByteString.Lazy as BL
import qualified Data.ByteString as B
import qualified Data.ByteString.Char8 as C
import           Data.Maybe 
import qualified Data.Role as R
import           System.Entropy 
import           Control.Concurrent
import           Data.ServerPool
import           Control.Comonad
import qualified Data.SqlTransaction as ST
import           Config.ConfigFileParser
import           Database.HDBC.PostgreSQL
import qualified Database.HDBC as DB
import           Data.Int
import           Data.Convertible
import           Control.Applicative
import qualified Data.ConnectionPool as DCP
import qualified Control.Monad.CatchIO as CIO

------------------------------------------------------------------------------
-- | 'Application' is our application's monad. It uses 'SnapExtend' from
-- 'Snap.Extension' to provide us with an extended 'MonadSnap' making use of
-- the Heist and Timer Snap extensions.
type Application  = SnapExtend ApplicationState

type ServerPool = Pool (B.ByteString, Int)

------------------------------------------------------------------------------
-- | 'ApplicationState' is a record which contains the state needed by the Snap
-- extensions we're using.  We're using Heist so we can easily render Heist
-- templates, and Timer simply to illustrate the config loading differences
-- between development and production modes.
data ApplicationState = ApplicationState {
      rolePair :: R.RolePair B.ByteString 
    , ch :: CryptHandle 
    , thrs :: [ThreadId]
    , pool :: TVar (ServerPool) 
    , dsn :: DCP.ConnectionPool
    }
data ApplicationException = UserErrorE C.ByteString 
    deriving (Typeable, Show)

instance CIO.Exception ApplicationException

getOpParam :: B.ByteString -> Application (B.ByteString)
getOpParam x = do 
        xs <- getParam x
        case xs of 
            Just s -> return s
            Nothing -> do 
                modifyResponse (setResponseCode 400) 
                CIO.throw $ UserErrorE $ "Wrong parameters given, need " `C.append` x



withConnection :: (Connection -> Application a) -> Application a
withConnection f = CIO.catch (CIO.bracket getDatabase returnDatabase (f . DCP.unwrapContext)) $ \(UserErrorE e) -> do 
    modifyResponse (setResponseCode 400) 
--    writeBS e
    writeBS $ "{\"error\":\"" `C.append` e `C.append` "\"}" 
    r <- getResponse
    finishWith r 




getDatabase :: Application DCP.ConnectionContext
getDatabase = asks dsn >>= liftIO . DCP.getConnection 

returnDatabase :: DCP.ConnectionContext -> Application ()
returnDatabase x = asks dsn >>= \c -> liftIO (DCP.returnConnection c x)


getDsn :: Sections -> Maybe String 
getDsn xs = do 
    db <- lookupConfig "database" xs
    (StringC u) <- lookupVar "user" db
    (StringC p) <- lookupVar "password" db
    (StringC nm) <- lookupVar "dbname" db 
    (StringC server) <- lookupVar "host" db
    (StringC port) <- lookupVar "port" db
    return $ "host=" ++ server ++ " port=" ++ port ++ " dbname=" ++ nm ++ " user=" ++ u ++ " password=" ++ p


loadConfig :: Initializer (String, String, Integer, String) 
loadConfig = do 
     xs <- liftIO $ readConfig "resources/server.cfg"
     let (IntegerC n) = fromJust $ lookupConfig "monitor" xs >>= lookupVar "port"
     let (StringC pool) = fromJust $ lookupConfig "server" xs >>= lookupVar "pool"
     let (StringC np) = fromJust $ lookupConfig "server" xs >>= lookupVar "dchan"
     let dsn = fromJust $ getDsn xs
     return (pool, dsn, n, np)

           
-- | Check if current client can access Resource with RestRight
may :: R.Resource -> R.RestRight -> Application Bool 
may rs rr = do 
            ct <- getCookie "user_token"
            at <- getCookie "application_token"
            ct' <- getParam "user_token"
            at' <- getParam "application_token"
            xs <- asks rolePair 
            let ls = fmap cookieValue $ maybesToList [at,ct]
            let ls' = maybesToList [at',ct']
            ts <- foldM (getRoles xs) [R.All] (ls ++ ls')
            b <- foldM (getPerms xs rr rs) False ts
            return b
    where getRoles xs zs x = do 
                    z <- R.getRoles xs x 
                    return (z ++ zs)
          getPerms xs rr rs zs x = do 
                        b <- R.may xs rs x rr 
                        return (b || zs)

getRoles :: String -> Application [R.Role]
getRoles s = do 
    xs <- asks rolePair 
    ct <- fmap cookieValue <$> getCookie (C.pack s)
    ct' <- getParam (C.pack s)
    case (ct' <|> ct) of 
        Nothing -> return []
        Just x -> R.getRoles xs x

-- | Drops all the roles from the cookie 
dropRoles :: String -> Application ()
dropRoles s = do 
    xs <- asks rolePair 
    ct <- fmap cookieValue <$> getCookie (C.pack s)
    ct' <- getParam (C.pack s)
    case (ct' <|> ct) of
        Nothing -> return () 
        Just x -> R.dropRoles xs x >> return ()

-- | Adds a role under the give cookieName, if the cookie doesn't exist, a new cookie gets created and some fresh entropy consumed
addRole :: String -> R.Role -> Application ()
addRole s r = do 
        xs <- asks rolePair 
        ch <- asks ch 
        ts <- liftIO $ hGetEntropy ch 64 
        let h = C.pack . H.b32TigerHash . H.tigerHash $ ts
        R.addRole xs h r
        let ck = Cookie (C.pack s) h Nothing Nothing (Just "/")
        modifyResponse . addCookie $ ck
        modifyRequest (\r -> r { rqCookies = ck : rqCookies r})
        writeBS $ "{\"result\":\"" `C.append` h `C.append` "\"}"
        

importTokens :: R.RolePair B.ByteString -> B.ByteString -> IO ()
importTokens rp xs = let (x,y) = decode (BL.pack $ B.unpack $ xs) :: (C.ByteString, R.Role) in  R.addRole rp x y 

-- | Helper functions. Concat all results from a list of Maybes [Just 1, Just 3, Nothing, Just 2] -> [1, 3, 2]
maybesToList :: [Maybe a] -> [a] 
maybesToList [] = []
maybesToList (Just x:xs) = x : maybesToList xs 
maybesToList (_:xs) = maybesToList xs 

-- | Retrieves the RoleState from the ApplicationState 
getRoleState :: Application (R.RolePair B.ByteString)
getRoleState = asks rolePair 

-- | Retrieve a server from the ServerPool
getServer :: Application (B.ByteString, Int)
getServer = do 
        t <- asks pool 
        liftIO $ atomically $ do
                x <- readTVar t 
                writeTVar t (next x)
                return (extract x)

-- | Run a monadic action with an RoleState 
withRoleState :: (R.RolePair B.ByteString -> Application a) -> Application a 
withRoleState f = f =<< asks rolePair
------------------------------------------------------------------------------


------------------------------------------------------------------------------
-- | The 'Initializer' for ApplicationState. For more on 'Initializer's, see
-- the documentation from the snap package. Briefly, this is used to
-- generate the 'ApplicationState' needed for our application and will
-- automatically generate reload\/cleanup actions for us which we don't need
-- to worry about.


serverInit :: Initializer (TVar ServerPool) 
serverInit = do 
    (pl, dsn,_, _) <- loadConfig
    let (ip, (':':port)) = break (==':') pl
    spl <- liftIO $ newTVarIO (mkPool [(C.pack $ ip,read port)])
    return spl


applicationInitializer :: Initializer ApplicationState
applicationInitializer = do
    -- Loading config 
    (pl, dsn,p, dc) <- loadConfig
    rso <- R.initRP  "resources/roleSet.cfg"
    -- connect to database 
    -- restoring rolestate 
    liftIO $ R.runRestore rso (R.fileRestore "resources/dump")
    -- initializing server 
    spl <- serverInit
    -- bringing up the cleanup and store thread
    tc <- liftIO $ R.initCleanup rso (60 * 60 * 24 * 7 * 4)
    ts <- liftIO $ R.initStore rso (R.fileStore "resources/dump")
    -- open the entropy handle 
    ch <- liftIO $ openHandle 
    db <- liftIO $ DCP.initConnectionPool 10 (connectPostgreSQL dsn)
    liftIO $ setupMaster dc "token" (importTokens rso)
    --  and there we go
    return $ ApplicationState rso ch [tc,ts] spl db 

