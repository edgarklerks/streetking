{-# LANGUAGE TemplateHaskell, OverloadedStrings, FlexibleContexts, NoMonomorphismRestriction #-}
module NodeSnaplet where 

import Config.ConfigFileParser 
import MemServerAsync
import Proto 
import Data.Lens.Common 
import Data.Lens.Template
import Snap.Core 
import Snap.Snaplet
import Control.Monad.Trans
import Control.Monad 
import Control.Applicative
import Control.Concurrent
import Control.Monad.State
import qualified Data.Binary as B 
import qualified Data.ByteString as B
import qualified Data.ByteString.Lazy as L 
import Data.MemState 
data DHTConfig = DHC {
        _query :: Proto -> IO Proto  
    }

class HasDHT b where 
    dhtLens :: Lens (Snaplet b) (Snaplet DHTConfig) 


sendQuery :: (MonadState DHTConfig m, MonadIO m) => Proto -> m Proto 
sendQuery r = do 
        p <- gets _query 
        liftIO $ p r

$(makeLenses [''DHTConfig])

initDHTConfig fp = makeSnaplet "DistributedHashNodeSnaplet" "distributed hashnode" Nothing $ do 
        xs <- liftIO $ readConfig fp  
        let (Just (StringC ctr)) = lookupConfig "DHT" xs >>= lookupVar "ctrl"
        let (Just (StringC upd)) = lookupConfig "DHT" xs >>= lookupVar "data"
        let (Just (ArrayC ns)) = lookupConfig "DHT" xs >>= lookupVar "nodes"
        let cl = client ctr "tcp://127.0.0.1:91281"

        let (Just (StringC svn)) = lookupConfig "DHT" xs >>= lookupVar "dump"
        
        liftIO $ forkIO $ startNode ctr upd svn 

        return $ DHC cl 


-- addBinary :: Binary a => a -> IO ()
insertBinary k s = with dhtLens $ do 
            p <- gets _query  
            liftIO $ p (insert k (fromLazy s))

lookupBinary k = with dhtLens $ do 
            p <- gets _query 
            (Result d) <- liftIO $ p (Proto.query 0 k)
            case d of 
                (NotFound) -> return $ Nothing 
                (KeyVal k v) -> return $ Just $ decodeL v 
                (Value k) -> return $ Just $ decodeL k 
            


decodeL = B.decode . L.pack . B.unpack 
fromLazy = B.pack . L.unpack . B.encode 

toStrings :: [Config] -> [String]
toStrings xs = toString <$> xs
toString (StringC p) = p 
