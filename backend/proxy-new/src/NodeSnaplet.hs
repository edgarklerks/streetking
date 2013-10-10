{-# LANGUAGE TemplateHaskell, OverloadedStrings, FlexibleContexts, NoMonomorphismRestriction #-}
module NodeSnaplet where 

import           Config.ConfigFileParser 
import           Control.Applicative
import           Control.Concurrent
import           Control.Monad 
import           Control.Monad.State
import           Control.Monad.Trans
import           Control.Lens hiding (Context)
import           Snap.Core 
import           Snap.Snaplet
import           System.Random 
import qualified Data.Binary as B 
import qualified Data.ByteString as B
import qualified Data.ByteString.Lazy as L 
import           Data.Redis

data DHTConfig = DHC {
               _redisTree :: Tree String B.ByteString
    }



makeLenses ''DHTConfig

initDHTConfig :: FilePath -> SnapletInit b DHTConfig
initDHTConfig fp = makeSnaplet "DistributedHashNodeSnaplet" "distributed hashnode" Nothing $ do 
        xs <- liftIO $ readConfig fp  
        t <- loadTree "localhost" 6379
        return $ DHTConfig t 


-- addBinary :: Binary a => a -> IO ()
insertBinary :: (MonadIO m, MonadState DHTConfig m, B.Binary a) => B.ByteString -> a -> m () 
insertBinary k s = do 
                      t <- gets _redisTree 
                      liftIO $ onRedis t (insert  k (fromLazy s))

lookupBinary :: (MonadIO m, MonadState DHTConfig m, B.Binary a) => B.ByteString -> m (Maybe a)
lookupBinary k = do 
            t <- gets _redisTree 
            s <- liftIO $ onRedis t (find t k)
            case s of 
                Nothing -> return $ Nothing 
                Just b -> return decodeL b 

decodeL = B.decode . L.pack . B.unpack 
fromLazy = B.pack . L.unpack . B.encode 

toStrings :: [Config] -> [String]
toStrings xs = toString <$> xs
toString (StringC p) = p 
