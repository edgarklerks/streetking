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
import           Data.MemTimeState
import           MemServerAsyncTest
import           ProtoExtended  
import           Snap.Core 
import           Snap.Snaplet
import           System.Random 
import           System.ZMQ3 as Z  
import qualified Data.Binary as B 
import qualified Data.ByteString as B
import qualified Data.ByteString.Lazy as L 
import qualified Control.Monad.CatchIO as CIO 
import           GHC.Exception

data DHTConfig = DHC {
        _query :: MVar (),
        _ctx :: Context,
        _addr :: String, 
        _pull :: Socket Pull,
        _req :: Socket Req,
        _pc :: (RequestConfig, IncomingConfig, UpdateConfig) 
    }

newtype NodeTest a = NodeTest {
            unNodeTest :: StateT DHTConfig IO a
    } deriving (Functor, Applicative, Monad, MonadIO, MonadState DHTConfig, Alternative, MonadPlus)

runNodeTest :: DHTConfig -> NodeTest a -> IO a 
runNodeTest dhc m = evalStateT (unNodeTest m) dhc 


data NodeTestParams = NTP {
            nt_pull :: String,
            nt_req :: String, 
            nt_dump :: String
    }


setupTests = do 
    let servers = [
                  NTP "tcp://127.0.0.1:7122" "tcp://127.0.0.1:8712" "test_server_1_dump"
                , NTP "tcp://127.0.0.1:7123" "tcp://127.0.0.1:8713" "test_server_2_dump"
                , NTP "tcp://127.0.0.1:7124" "tcp://127.0.0.1:8714" "test_server_3_dump"
                ]
    forM_ servers $ forkIO . createNodeTest 

   

createNodeTest :: NodeTestParams -> IO ()
createNodeTest ntp = do 
       l <- liftIO $ newMemState (60 * 1000 * 1000 * 30) (6000 * 1000) (nt_dump ntp)
       qc <- liftIO $ newTQueueIO 
       liftIO $ forkIO $ queryManager (nt_dump ntp) l qc 
       s <- liftIO $ startNode $ RP (nt_req ntp) (nt_pull ntp) qc False 
       return ()


sendQuery :: (MonadState DHTConfig m, MonadIO m) => Proto -> m Proto 
sendQuery r = do
                 s <- gets _query 
                 a <- gets _addr
                 p <- gets _pull
                 rq <- gets _req 
                 pc <- gets _pc
                 liftIO $ withMVar s $ \_ -> do  
                    res <- queryNode (pc_memstate $ get_pc_config $ pc) p rq a r 
                    return res 

makeLenses ''DHTConfig

initDHTConfig :: FilePath -> SnapletInit b DHTConfig
initDHTConfig fp = makeSnaplet "DistributedHashNodeSnaplet" "distributed hashnode" Nothing $ do 
        xs <- liftIO $ readConfig fp  
        -- Read config file 
        let (Just (StringC ctr)) = lookupConfig "DHT" xs >>= lookupVar "ctrl"
        let (Just (StringC upd)) = lookupConfig "DHT" xs >>= lookupVar "data"
        let (Just (StringC addr)) = lookupConfig "DHT" xs >>= lookupVar "local-addr" 


        let (Just (StringC svn)) = lookupConfig "DHT" xs >>= lookupVar "dump"

        -- create memstate 
        
        l <- either (\(SomeException c) -> error .("shit fuck"++) . show $ c ) id <$> ( liftIO $ CIO.try $ newMemState (60 * 1000 * 1000 * 30) (6000 * 1000) svn)
        printInfo "Created memstate"
        -- create query chan 
        qc <- liftIO $ newTQueueIO  
        liftIO $ forkIO $ queryManager svn l qc  
        -- start node  
        s <- liftIO $ startNode $  
                                RP upd ctr qc True  
        printInfo "started nodes" 
        -- setup local link 
        p <- liftIO $ newMVar () 
        
        ctx <- liftIO $ Z.context  
        pu <- liftIO $ Z.socket ctx Pull
        liftIO $ Z.bind pu addr  
        
        req <- liftIO $ Z.socket ctx Req 
        liftIO $ Z.connect req ctr
        -- set unload handler 
        onUnload $ do 
                print "Dumping state"
                void $ runQuery (pc_memstate $ get_pc_config s) DumpState  

        return $ DHC p ctx addr pu req s


-- addBinary :: Binary a => a -> IO ()
insertBinary :: (MonadIO m, MonadState DHTConfig m, B.Binary a) => B.ByteString -> a -> m Proto
insertBinary k s = sendQuery (insert k (fromLazy s))

lookupBinary :: (MonadIO m, MonadState DHTConfig m, B.Binary a) => B.ByteString -> m (Maybe a)
lookupBinary k = do 
            x <- sendQuery (ProtoExtended.query 2 k)
            case getResult x of 
                (Just (NotFound)) -> return $ Nothing 
                (Just (KeyVal k v)) -> return $ Just $ decodeL v 
                (Just (Value k)) -> return $ Just $ decodeL k 
            


decodeL = B.decode . L.pack . B.unpack 
fromLazy = B.pack . L.unpack . B.encode 

toStrings :: [Config] -> [String]
toStrings xs = toString <$> xs
toString (StringC p) = p 
