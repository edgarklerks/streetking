{-# LANGUAGE TemplateHaskell, OverloadedStrings, FlexibleContexts, NoMonomorphismRestriction, GeneralizedNewtypeDeriving #-}
module NodeSnapletTest where 

import           Config.ConfigFileParser 
import           Control.Applicative
import           Control.Concurrent
import           Control.Monad 
import           Control.Monad.State
import           Control.Concurrent.STM  
import           Control.Monad.Trans
import           Control.Lens hiding (Context)
import           Snap.Core 
import           Snap.Snaplet
import           System.Random 
import qualified Data.Binary as B 
import qualified Data.ByteString as B
import qualified Data.ByteString.Lazy as L 
import qualified Control.Monad.CatchIO as CIO 
import           GHC.Exception
import qualified Data.Redis as R 

data DHTConfig v = DHC {
               _redis :: R.Tree L.ByteString L.ByteString 
    }

newtype NodeTest v a = NodeTest {
            unNodeTest :: StateT (DHTConfig v) IO a
    } deriving (Functor, Applicative, Monad, MonadIO, MonadState (DHTConfig v), Alternative, MonadPlus)

runNodeTest :: DHTConfig v -> NodeTest v a -> IO a 
runNodeTest dhc m = evalStateT (unNodeTest m) dhc 



insert :: (MonadState (DHTConfig v) m, B.Binary v,MonadIO m) => L.ByteString -> v -> m ()
insert k v = do 
    r <- gets _redis
    liftIO $ R.insert r k (B.encode v) 

find :: (MonadState (DHTConfig v) m, B.Binary v, MonadIO m) => L.ByteString -> m (Maybe v) 
find k = do 
    r <- gets _redis 
    x <- liftIO $ R.find r k 
    case x of 
        Nothing -> return Nothing 
        Just a -> return $ Just (B.decode a)



makeLenses ''DHTConfig

initDHTConfig :: FilePath -> SnapletInit b (DHTConfig v)
initDHTConfig fp = makeSnaplet "DistributedHashNodeSnaplet" "distributed hashnode" Nothing $ do 
        xs <- liftIO $ readConfig fp  
        let (Just (StringC port)) = lookupConfig "DHT" xs >>= lookupVar "port"
        let (Just (StringC host)) = lookupConfig "DHT" xs >>= lookupVar "host"

        r <- liftIO $ R.loadTree ("root" :: L.ByteString) ("node" :: L.ByteString) host (read port)
        return $ DHC r 
