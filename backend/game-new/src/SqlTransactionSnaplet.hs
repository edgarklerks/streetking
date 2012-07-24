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
import Data.Lens.Common
import Data.Lens.Template 
import Config.ConfigFileParser
import Control.Monad.State
import qualified Data.Text as T
import qualified Data.ConnectionPool as DCP 
import qualified Control.Monad.CatchIO as CIO
import qualified Database.HDBC.PostgreSQL as DB 
import Data.SqlTransaction


data SqlTransactionConfig = STC {
        _dsn :: String,
        _pool :: DCP.ConnectionPool,
        _dbcons :: Integer
    } 

$(makeLenses [''SqlTransactionConfig])

class HasSqlTransaction b where 
    sqlLens :: Lens (Snaplet b) (Snaplet SqlTransactionConfig) 

getDatabase :: (MonadIO m, MonadState SqlTransactionConfig m) => m DCP.ConnectionContext
getDatabase = gets _pool >>= liftIO . DCP.getConnection 

returnDatabase :: (MonadIO m, MonadState SqlTransactionConfig m) => DCP.ConnectionContext -> m ()  
returnDatabase x = gets _pool >>= \c -> liftIO (DCP.returnConnection c x) 

-- runDb :: SqlTransaction Connection a ->
runDb e xs = withConnection $ \c -> do 
    frp <- runSqlTransaction xs e c 
    frp `seq` return frp

withConnection :: (MonadState SqlTransactionConfig m, CIO.MonadCatchIO m) => (DB.Connection -> m a)  -> m a   
withConnection f = CIO.bracket getDatabase returnDatabase (f . DCP.unwrapContext)

-- initSqlTransactionSnaplet :: (MonadState ConfigSnaplet m, MonadIO m) => m SqlTransactionConfig  
initSqlTransactionSnaplet fp = makeSnaplet "SqlTransaction manager" "sql manager" Nothing $ do 
        xs <- liftIO $ readConfig fp 
        let (Just ( StringC pdsn )) = lookupConfig "database" xs >>= lookupVar "dsn"
        let (Just (IntegerC pdbcons)) = lookupConfig "database" xs >>= lookupVar "dbcons"
        db <- liftIO $ DCP.initConnectionPool (fromInteger $ pdbcons) (DB.connectPostgreSQL pdsn)
        return $ STC pdsn db pdbcons 


