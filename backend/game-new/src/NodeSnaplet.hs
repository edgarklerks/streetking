{-# LANGUAGE TemplateHaskell, OverloadedStrings, FlexibleContexts #-}
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




toStrings :: [Config] -> [String]
toStrings xs = toString <$> xs
toString (StringC p) = p 
