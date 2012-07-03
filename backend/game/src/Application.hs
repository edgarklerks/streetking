{-# LANGUAGE TypeSynonymInstances, FlexibleInstances, MultiParamTypeClasses, DeriveDataTypeable, OverloadedStrings, FlexibleContexts #-}
{-

This module defines our application's monad and any application-specific
information it requires.

-}

module Application
  ( Application
  , applicationInitializer
  , getUniqueKey
  , runDb 
  , addRole 
  , ApplicationException(..)
  , getJson 
  , getJsons
  , getId 
  , getUserId 
  , getPages 
  , getPagesWithDTD
  , getPagesWithDTDOrdered
  , searchWithDTDOrdered
  , SqlMap 
  , writeResult 
  , writeError 
  , writeMapable
  , writeMapables
  , internalError
  , getOParam
  ) where

import           Snap.Extension
import           Snap.Types 
import           Config.ConfigFileParser
import qualified Database.HDBC as DB
import qualified Database.HDBC.PostgreSQL as DB 
import           Data.Binary as Bin
import qualified Data.ByteString.Char8 as B
import qualified Control.Monad.CatchIO as CIO
import           Control.Applicative
import           Data.Typeable
import qualified Data.ConnectionPool as DCP 
import qualified Data.ByteString.Lazy.Char8 as L
import           Data.TimedMap
import           Data.DChan 
import           Control.Concurrent
import           Control.Monad.Trans
import           Control.Monad.Reader
import           Data.Maybe
import qualified Data.Role as R 
import           Data.SqlTransaction
import qualified Data.HashMap.Strict as S
import           Data.InRules
import           Data.Conversion
import           Data.Aeson 
import           Data.Attoparsec.Lazy
import           Database.HDBC.PostgreSQL hiding (internalError)
import           Data.Database hiding (Value) 
import           Data.DatabaseTemplate 
import           Data.Convertible 
import           System.Entropy
import qualified Data.Digest.TigerHash as H
import qualified Data.Digest.TigerHash.ByteString as H
import           Data.Monoid
import           Debug.Trace
import           Model.General (Mapable(..), Default(..), Database(..))
import           Data.SortOrder 
------------------------------------------------------------------------------
-- | 'Application' is our application's monad. It uses 'SnapExtend' from
-- 'Snap.Extension' to provide us with an extended 'MonadSnap' making use of
-- the Heist and Timer Snap extensions.
type Application = SnapExtend ApplicationState

getUniqueKey :: Application B.ByteString
getUniqueKey = do 
    p <- asks ch
    ts <- liftIO $ hGetEntropy p 64
    return (B.pack . H.b32TigerHash . H.tigerHash $ ts)


data ApplicationException = UserErrorE B.ByteString 
    deriving (Typeable, Show)

instance CIO.Exception ApplicationException

apiError :: B.ByteString -> Application ()
apiError xs = CIO.throw (UserErrorE xs)

toAeson :: InRule -> L.ByteString  
toAeson = (Data.Aeson.encode :: Value -> L.ByteString) . fromInRule

writeAeson :: ToInRule a => a -> Application ()
writeAeson = writeLBS . toAeson . toInRule

writeError :: ToInRule a => a -> Application ()
writeError x = writeAeson $ S.fromList [("error" :: String, x)]

writeResult :: ToInRule a => a -> Application ()
writeResult x = writeAeson $ S.fromList [("result" :: String, x)]

writeMapable :: Mapable a => a -> Application ()
writeMapable = writeResult . toHashMap 

writeMapables :: Mapable a => [a] -> Application ()
writeMapables = writeResult . fmap toHashMap 

-- | Retrieve the userid or halt computation with error 
getUserId :: Application Integer 
getUserId =  do 
        x <- getParam "userid"
        case x of 
                Just y -> return (read $ B.unpack y)
                Nothing -> internalError "No userid"


------------------------------------------------------------------------------
-- | 'ApplicationState' is a record which contains the state needed by the Snap
-- extensions we're using.  We're using Heist so we can easily render Heist
-- templates, and Timer simply to illustrate the config loading differences
-- between development and production modes.
data ApplicationState = ApplicationState
    { 
        dsn :: DCP.ConnectionPool
      , slaveChan :: Slave  
      ,  ch :: CryptHandle 
    }

type SqlMap = S.HashMap String SqlValue 
getJson :: Application  SqlMap 
getJson = do 
    t <- parse json <$> getRequestBody 
    case t of 
        (Done _ v)  -> return (fromInRule $ toInRule v)
        otherwise -> return S.empty --- internalError "No json provided" 

getJsons :: Application [SqlMap]
getJsons = do 
    t <- parse json <$> getRequestBody 
    case t of 
        (Done _ v)  -> return (fromInRule $ toInRule v)
        otherwise -> return [] --- internalError "No json provided" 

getId :: Application Integer 
getId = do 
    xs <- getJson
    let b = S.lookup "id" xs 
    case b of 
        Nothing -> internalError "No id provided"
        Just i -> return (DB.fromSql i)

getOParam :: B.ByteString -> Application B.ByteString
getOParam x = do 
    p <- getParam x
    case p of 
        Nothing -> internalError $ "param: " `mappend` (B.unpack x) `mappend`  "must provided"
        Just a -> return a

getPages :: Application (Integer,Integer)
getPages = do 
    xs <- getJson
    let b = S.lookupDefault (DB.SqlInteger 100) "limit" xs
    let o = S.lookupDefault (DB.SqlInteger 0) "offset" xs 
    return (DB.fromSql b, DB.fromSql o)

getPagesWithDTDOrdered :: [String] -> DTD -> Application (((Integer, Integer), Constraints), Orders)
getPagesWithDTDOrdered vs d = do 
                xs <- getJson
                let b = S.lookupDefault (DB.SqlInteger 100) "limit" xs
                let o = S.lookupDefault (DB.SqlInteger 0) "offset" xs 
                let od = S.lookupDefault "" "sql" xs
                let cst = dtd d $ convert xs 
                let od' = getSortOrder (convert od) >>= \od -> sortOrder od vs 
                case od' of 
                    Left e -> internalError e
                    Right x -> do 
                        return (((DB.fromSql b, DB.fromSql o), cst), x)


searchWithDTDOrdered :: (Mapable a, Database Connection a) =>  [String] -> DTD -> Application [a] 
searchWithDTDOrdered vs d = do 
            (((l,o), xs), od) <- getPagesWithDTDOrdered vs d 
            runDb $ search xs od l o
                

getPagesWithDTD :: DTD -> Application ((Integer, Integer), Constraints)
getPagesWithDTD d = do 
        xs <- getJson 
        let b = S.lookupDefault (DB.SqlInteger 100) "limit" xs
        let o = S.lookupDefault (DB.SqlInteger 0) "offset" xs 
        return ((DB.fromSql b, DB.fromSql o),(dtd d $ convert xs ))

------------------------------------------------------------------------------
-- | The 'Initializer' for ApplicationState. For more on 'Initializer's, see
-- the documentation from the snap package. Briefly, this is used to
-- generate the 'ApplicationState' needed for our application and will
-- automatically generate reload\/cleanup actions for us which we don't need
-- to worry about.
internalError :: String -> Application a 
internalError x = modifyResponse (setResponseCode 500) *> (CIO.throw $ UserErrorE (B.pack x))


getDatabase :: Application DCP.ConnectionContext
getDatabase = asks dsn >>= liftIO . DCP.getConnection 

returnDatabase :: DCP.ConnectionContext -> Application ()
returnDatabase x = asks dsn >>= \c -> liftIO (DCP.returnConnection c x)


runDb :: SqlTransaction Connection a -> Application a
runDb xs =  withConnection $ \c -> do 
    frp <- runSqlTransaction xs internalError c
    frp `seq`return frp

withConnection :: (DB.Connection -> Application a) -> Application a
withConnection f = CIO.bracket getDatabase returnDatabase (f . DCP.unwrapContext)


addRole :: R.Id -> B.ByteString -> Application ()
addRole r p = do 
        s <- asks slaveChan 
        liftIO $ writeMaster s "token" $ B.pack . L.unpack $ Bin.encode ((p, R.User (Just r)))

getDsn :: Sections -> Maybe String 
getDsn xs = do 
    db <- lookupConfig "database" xs
    (StringC u) <- lookupVar "user" db
    (StringC p) <- lookupVar "password" db
    (StringC nm) <- lookupVar "dbname" db 
    (StringC server) <- lookupVar "host" db
    (StringC port) <- lookupVar "port" db
    return $ "host=" ++ server ++ " port=" ++ port ++ " dbname=" ++ nm ++ " user=" ++ u ++ " password=" ++ p

getDbPool :: Sections -> Maybe Integer
getDbPool xs = do 
        db <- lookupConfig "database" xs
        (IntegerC a) <- lookupVar "dbcons" db
        return a



-- loadConfig :: MonadIO m => m (String, String, String, Integer, Integer, String, String, String)
loadConfig = do 
     xs <- liftIO $ readConfig "resources/server.cfg"
     let (StringC dc) = fromJust $ lookupConfig "server" xs >>= lookupVar "dchan"
     let (StringC dctrl) = fromJust $ lookupConfig "server" xs >>= lookupVar "dchan-ctrl"
     let dsn = fromJust $ getDsn xs
     let gn = fromJust $ getDbPool xs
     return  (dsn,  gn, dc, dctrl)


applicationInitializer :: Initializer ApplicationState
applicationInitializer = do
    (dsn, nr, dc, dctrl) <- loadConfig
    db <- liftIO $ DCP.initConnectionPool (fromInteger nr) (DB.connectPostgreSQL dsn)
    liftIO $ print "started connection pool"
    s <- liftIO $ setupSlave dc dctrl
    liftIO $ print "connected to bla"
    ch <- liftIO $ openHandle
    return $ ApplicationState db s ch
