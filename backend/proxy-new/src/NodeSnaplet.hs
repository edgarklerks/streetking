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
import System.Random 
import Proto 
data DHTConfig = DHC {
        _query :: MVar (Proto -> IO Proto)
    }

class HasDHT b where 
    dhtLens :: Lens (Snaplet b) (Snaplet DHTConfig) 


sendQuery :: (MonadState DHTConfig m, MonadIO m) => Proto -> m Proto 
sendQuery r = do 
        p <- gets _query 
        liftIO $ withMVar p $ \x -> do 
            x r

$(makeLenses [''DHTConfig])

initDHTConfig fp = makeSnaplet "DistributedHashNodeSnaplet" "distributed hashnode" Nothing $ do 
        xs <- liftIO $ readConfig fp  
        let (Just (StringC ctr)) = lookupConfig "DHT" xs >>= lookupVar "ctrl"
        let (Just (StringC upd)) = lookupConfig "DHT" xs >>= lookupVar "data"
        let (Just (StringC lcl)) = lookupConfig "DHT" xs >>= lookupVar "local"


        let (Just (StringC svn)) = lookupConfig "DHT" xs >>= lookupVar "dump"
        
        s <- liftIO $ startNode ctr upd svn 
        let cl = queryNode s lcl ctr
        p <- liftIO $ newMVar cl 
        return $ DHC p


-- addBinary :: Binary a => a -> IO ()
insertBinary k s = sendQuery (insert k (fromLazy s))

lookupBinary k = do 
            x <- sendQuery (Proto.query 2 k)
            case getResult x of 
                (Just (NotFound)) -> return $ Nothing 
                (Just (KeyVal k v)) -> return $ Just $ decodeL v 
                (Just (Value k)) -> return $ Just $ decodeL k 
            


decodeL = B.decode . L.pack . B.unpack 
fromLazy = B.pack . L.unpack . B.encode 

toStrings :: [Config] -> [String]
toStrings xs = toString <$> xs
toString (StringC p) = p 
