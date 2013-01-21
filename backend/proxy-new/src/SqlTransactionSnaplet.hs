{-# LANGUAGE TemplateHaskell, NoMonomorphismRestriction, FlexibleContexts, FlexibleInstances, OverloadedStrings #-}
module SqlTransactionSnaplet (
    SqlTransactionConfig(..),
    dsn,
    pool,
    dbcons,
    returnDatabase,
    getDatabase,
    withConnection,
    runDb,
    initSqlTransactionSnaplet,
    HasSqlTransaction(..)
) where 

import Control.Monad
import Control.Applicative
import Snap.Snaplet
import Snap.Core 
import Control.Lens
import Config.ConfigFileParser
import Control.Monad.State
import qualified Data.Text as T
import qualified Data.ConnectionPool as DCP 
import qualified Control.Monad.CatchIO as CIO
import qualified Database.HDBC.PostgreSQL as DB 
import qualified Database.HDBC as DB 
import Data.SqlTransaction


data SqlTransactionConfig = STC {
        _dsn :: String,
        _pool :: DCP.ConnectionPool,
        _dbcons :: Integer
    } 

makeLenses ''SqlTransactionConfig

class HasSqlTransaction b where 
    sqlLens :: SnapletLens (Snaplet b) (Snaplet SqlTransactionConfig) 

getDatabase :: (MonadIO m, MonadState SqlTransactionConfig m) => m DCP.ConnectionContext
getDatabase = gets _pool >>= liftIO . DCP.getConnection 

returnDatabase :: (MonadIO m, MonadState SqlTransactionConfig m) => DCP.ConnectionContext -> m ()  
returnDatabase x = gets _pool >>= \c -> liftIO (DCP.returnConnection c x) 

-- runDb :: SqlTransaction Connection a ->
runDb :: (Applicative m, CIO.MonadCatchIO m, MonadState SqlTransactionConfig m) => (String -> m a) -> SqlTransaction Connection a -> m a
runDb e xs = withConnection $ \c -> do 
    liftIO $ DB.begin c 
    frp <- runSqlTransaction xs e c 
    liftIO $ DB.commit c 
    frp `seq` return frp

withConnection :: (MonadState SqlTransactionConfig m, CIO.MonadCatchIO m) => (DB.Connection -> m a)  -> m a   
withConnection f = CIO.bracket getDatabase returnDatabase (f . DCP.unwrapContext)

-- initSqlTransactionSnaplet :: (MonadState ConfigSnaplet m, MonadIO m) => m SqlTransactionConfig  
initSqlTransactionSnaplet :: FilePath -> SnapletInit b SqlTransactionConfig
initSqlTransactionSnaplet fp = makeSnaplet "SqlTransaction manager" "sql manager" Nothing $ do 
        xs <- liftIO $ readConfig fp 
        let (Just ( StringC pdsn )) = lookupConfig "database" xs >>= lookupVar "dsn"
        let (Just (IntegerC pdbcons)) = lookupConfig "database" xs >>= lookupVar "dbcons"
        db <- liftIO $ DCP.initConnectionPool (fromInteger $ pdbcons) (DB.connectPostgreSQL' pdsn)
        return $ STC pdsn db pdbcons 


