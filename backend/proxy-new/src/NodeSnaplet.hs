{-# LANGUAGE TemplateHaskell, OverloadedStrings, FlexibleContexts, NoMonomorphismRestriction #-}
module NodeSnaplet where 

import           Config.ConfigFileParser 
import           Control.Applicative
import           Control.Concurrent
import           Control.Monad 
import           Control.Monad.State
import           Control.Monad.Trans
import           Control.Lens hiding (Context)
import           Data.MemTimeState
import           MemServerAsync
import           Proto 
import           Snap.Core 
import           Snap.Snaplet
import           System.Random 
import           System.ZMQ3 as Z  
import qualified Data.Binary as B 
import qualified Data.ByteString as B
import qualified Data.ByteString.Lazy as L 

data DHTConfig = DHC {
        _query :: MVar (),
        _ctx :: Context,
        _addr :: NodeAddr, 
        _pull :: Socket Pull,
        _req :: Socket Req,
        _pc :: ProtoConfig 
    }



sendQuery :: (MonadState DHTConfig m, MonadIO m) => Proto -> m Proto 
sendQuery r = do
                 s <- gets _query 
                 a <- gets _addr
                 p <- gets _pull
                 rq <- gets _req 
                 pc <- gets _pc
                 liftIO $ withMVar s $ \_ -> do  
                    res <- queryNode pc p rq a r 
                    return res 

makeLenses ''DHTConfig

initDHTConfig :: FilePath -> SnapletInit b DHTConfig
initDHTConfig fp = makeSnaplet "DistributedHashNodeSnaplet" "distributed hashnode" Nothing $ do 
        xs <- liftIO $ readConfig fp  
        let (Just (StringC ctr)) = lookupConfig "DHT" xs >>= lookupVar "ctrl"
        let (Just (StringC upd)) = lookupConfig "DHT" xs >>= lookupVar "data"
        let (Just (StringC addr)) = lookupConfig "DHT" xs >>= lookupVar "local-addr" 


        let (Just (StringC svn)) = lookupConfig "DHT" xs >>= lookupVar "dump"
        
        s <- liftIO $ startNode ctr upd svn 
        p <- liftIO $ newMVar () 
        
        ctx <- liftIO $ Z.init 1  
        pu <- liftIO $ Z.socket ctx Pull
        liftIO $ Z.bind pu addr  
        
        req <- liftIO $ Z.socket ctx Req 
        liftIO $ Z.connect req ctr

        onUnload $ do 
                print "Dumping state"
                void $ runQuery (memstate s) DumpState  

        return $ DHC p ctx addr pu req s


-- addBinary :: Binary a => a -> IO ()
insertBinary :: (MonadIO m, MonadState DHTConfig m, B.Binary a) => B.ByteString -> a -> m Proto
insertBinary k s = sendQuery (insert k (fromLazy s))

lookupBinary :: (MonadIO m, MonadState DHTConfig m, B.Binary a) => B.ByteString -> m (Maybe a)
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
