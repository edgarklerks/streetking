{-# LANGUAGE TypeSynonymInstances, FlexibleInstances, MultiParamTypeClasses #-}
{-

This module defines our application's monad and any application-specific
information it requires.

-}

module Application
  ( Application
  , applicationInitializer
  ) where

import           Snap.Extension
import           Snap.Extension.Heist.Impl
import           Snap.Extension.Timer.Impl
import           Snap.Types 
import           Config.ConfigFileParser
import qualified Database.HDBC as DB
import qualified Database.HDBC.PostgreSQL as DB 
import           Data.Binary as Bin
import qualified Data.ByteString.Char8 as B
import qualified Control.Monad.CatchIO as CIO
import qualified Data.ConnectionPool as DCP 
import qualified Data.ByteString.Lazy.Char8 as L
import qualified Model.Account as A 
import qualified Model.General (Database(..), Mapable(..))
import           Data.TimedMap
import           Data.DChan 
import           Control.Concurrent
import           Control.Monad.Trans
import           Control.Monad.Reader
import           Data.Maybe
import qualified Data.Role as R 


------------------------------------------------------------------------------
-- | 'Application' is our application's monad. It uses 'SnapExtend' from
-- 'Snap.Extension' to provide us with an extended 'MonadSnap' making use of
-- the Heist and Timer Snap extensions.
type Application = SnapExtend ApplicationState


------------------------------------------------------------------------------
-- | 'ApplicationState' is a record which contains the state needed by the Snap
-- extensions we're using.  We're using Heist so we can easily render Heist
-- templates, and Timer simply to illustrate the config loading differences
-- between development and production modes.
data ApplicationState = ApplicationState
    { templateState :: HeistState Application
    , timerState    :: TimerState
    , dsn :: DCP.ConnectionPool
    , slaveChan :: Slave  
    }


------------------------------------------------------------------------------
instance HasHeistState Application ApplicationState where
    getHeistState     = templateState
    setHeistState s a = a { templateState = s }


------------------------------------------------------------------------------
instance HasTimerState ApplicationState where
    getTimerState     = timerState
    setTimerState s a = a { timerState = s }


------------------------------------------------------------------------------
-- | The 'Initializer' for ApplicationState. For more on 'Initializer's, see
-- the documentation from the snap package. Briefly, this is used to
-- generate the 'ApplicationState' needed for our application and will
-- automatically generate reload\/cleanup actions for us which we don't need
-- to worry about.

addRole :: R.Id -> B.ByteString -> Application ()
addRole r p = do 
        s <- asks slaveChan 
        liftIO $ writeMaster s "token" $ B.pack . L.unpack $ Bin.encode ((R.User (Just r)), p)

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
    heist <- heistInitializer "resources/templates" id
    timer <- timerInitializer
    (dsn, nr, dc, dctrl) <- loadConfig
    db <- liftIO $ DCP.initConnectionPool (fromInteger nr) (DB.connectPostgreSQL dsn)
    s <- liftIO $ setupSlave dc dctrl
    return $ ApplicationState heist timer db s
