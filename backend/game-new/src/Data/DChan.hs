{-# LANGUAGE GADTs, RankNTypes #-}
-- | Distributed data channel. 
-- | Slaves do some work and push the results to the master.
-- | In this case, slaves handle the login and the master (proxy) needs
-- | the authentication information for filtering traffic.  
-- | N slaves can push data to 1 master 
-- | Depredicated by nodesnaplet, which is a p2p network.
module Data.DChan (
        setupMaster,
        setupSlave,
        writeMaster, 
        Slave,
        Master
    ) where 

import Control.Applicative
import Control.Monad
import qualified Data.HashMap.Strict as H
import Data.Word
import qualified System.ZMQ as Z
import qualified Data.Binary as B 
import qualified Data.ByteString as BS
import qualified Data.ByteString.Char8 as BC
import qualified Data.ByteString.Lazy as BL
import Control.Concurrent
import Control.Concurrent.STM
import Debug.Trace
import Control.DeepSeq
import Debug.Trace

data ClientWords where 
    Server :: String ->  ClientWords 
    Disconnect :: String -> ClientWords
    Got :: ![BS.ByteString] -> ClientWords
        deriving Show

data ServerWords where 
    Ok :: ServerWords
    Error :: String -> ServerWords 
    Nop :: ServerWords 
    Get :: String -> Word16 -> ServerWords 
        deriving Show

type SlaveList = TMVar (H.HashMap String (Z.Socket Z.Req))
type ChanQueue = TVar (H.HashMap String (TChan BS.ByteString))

type Master = CTX Z.Rep MasterNode 
type Slave = CTX Z.Req SlaveNode 

data CTX s a = CTX {
        ctx :: Z.Context,
        sol :: Z.Socket s,
        node :: a
    }

newtype MasterNode = MN {
        slaves :: SlaveList  
    }

data SlaveNode = SN {
        master :: Z.Socket Z.Rep,
        addr :: String,
        queue :: ChanQueue
    }

newMaster :: String -> IO Master
newMaster cnc  = do 
        ctx <- Z.init 1 
        sol <- Z.socket ctx Z.Rep
        Z.bind sol cnc
        tr <- newTMVarIO H.empty
        let m = MN { slaves = tr }
        return $ CTX { ctx = ctx, sol = sol, node = m }

newSlave :: String -> String  -> IO Slave
newSlave cnc addr  = do 
        ctx <- Z.init 1
        sol <- Z.socket ctx Z.Req
        Z.connect sol cnc
        ctrl <- Z.socket ctx Z.Rep 
        Z.bind ctrl addr
        q <- newTVarIO H.empty 
        let m = SN { master = ctrl, addr = addr, queue = q }
        return $ CTX { ctx = ctx, sol = sol, node = m }

setupSlave :: String -> String -> IO Slave 
setupSlave cnc addr  = newSlave cnc addr >>= \x -> slaveManager x *> pure x

setupMaster :: String -> String -> (BS.ByteString -> IO ()) -> IO Master
setupMaster m ch f = newMaster m >>= \x -> solicitor x *> slaveOwner x ch f *> pure x

writeMaster :: Slave -> String -> BS.ByteString -> IO ()
writeMaster s c bs = atomically $ do 
        ch <- readTVar (queue $ node s) 
        case H.lookup c ch of 
                Just tc -> do 
                    writeTChan tc bs 
                Nothing -> do 
                    tc <- newTChan 
                    writeTVar (queue $ node s) (H.insert c tc ch)
                    writeTChan tc bs 

getSlaves :: Master -> IO [Z.Socket Z.Req]  
getSlaves = fmap (fmap snd . H.toList ) . atomically .  readTMVar . slaves . node 

readSlaves :: Master -> String -> IO [BS.ByteString]
readSlaves m ch = do 
            xs <- getSlaves m
            let step = \z i -> do 
                sendBinary i (Get ch 10)
                c <- receiveBinary i
                case c of 
                    (Got xs) -> return (xs ++ z)
            foldM step [] xs


solicit :: Slave -> IO ServerWords
solicit (CTX _ s n)  = sendBinary s (Server myaddr) *> receiveBinary s 
    where 
          myaddr = addr n

hasSlave :: SlaveList -> String -> IO Bool 
hasSlave m p = do 
    xs <- atomically $ readTMVar m
    case H.lookup p xs of 
        Nothing -> return False 
        Just s -> return True 
    

solicitor :: Master -> IO ThreadId
solicitor (CTX ctx sol n) = forkIO . forever $ do 
        s <-  receiveBinary sol :: IO  ClientWords 
        case s of 
            (Server xs) -> do 
                b <- hasSlave (slaves n) xs
                case b of 
                    False -> do 
                        print $ "Welcome " ++ xs 
                        s <- Z.socket ctx Z.Req
                        Z.connect s xs
                        atomically $ do 
                            sl <- takeTMVar (slaves n)
                            putTMVar (slaves n) (H.insert xs s sl)
                        sendBinary sol Ok 
                    True -> do 
                        print $ "Alive " ++ xs 
                        s <- Z.socket ctx Z.Req 
                        Z.connect s xs 
                        atomically $ do 
                            sl <- takeTMVar (slaves n) 
                            putTMVar (slaves n) (H.insert xs s sl) 
                        sendBinary sol Ok 

slaveOwner :: Master -> String -> (BS.ByteString -> IO ()) -> IO ThreadId
slaveOwner m c f = forkIO $ forever $ do 
                    xs <- readSlaves m c 
                    forM_ xs f 
                    threadDelay 100

slaveManager :: Slave -> IO ThreadId 
slaveManager m@(CTX ctx sol n) = do 
    solicit m 
    forkIO $ forever $ do 
        rm <-  receiveBinary (master n) :: IO ServerWords
        case rm of 
            Get ch nr -> do 
                    qe <- atomically $ readTVar (queue n)
                    case H.lookup ch qe of
                        Nothing -> sendBinary (master n) (Got [])
                        Just tc -> do 
                            xs <- atomically $ forM [1..nr] $ \i -> do 
                                    b <- isEmptyTChan tc
                                    case b of 
                                        False -> do 
                                            x <- readTChan tc 
                                            return [x]
                                        True -> return []
                            sendBinary (master n) (Got (concat xs))
                            

                    


{-- internal API --}

sendBinary :: (NFData b, B.Binary b, Z.SType a) => Z.Socket a -> b -> IO () 
sendBinary s t = t `deepseq` Z.send' s (B.encode t) [] 

receiveBinary :: (NFData b, B.Binary b, Z.SType a) =>  Z.Socket a -> IO b
receiveBinary s = do x <- (B.decode . toLazy) <$> Z.receive s []
                     return (force x)

toLazy x = BL.fromChunks [x] 


instance B.Binary ClientWords where 
    put (Server xs) =  B.put (0 :: Word8) *>
                    B.put xs 
    put (Got xs) = B.put (1 :: Word8) *> 
                   B.put xs
    put (Disconnect xs) = B.put (2 :: Word8) *>
                            B.put xs 
    get = do 
        x <- B.get :: B.Get Word8
        case x of 
            0 -> Server <$> B.get  
            1 -> Got <$> B.get
            2 -> Disconnect <$> B.get 
        

instance B.Binary ServerWords where 
    put (Ok) = B.put (0 :: Word8)
    put (Get ch n) = B.put (1 :: Word8) *>
                     B.put ch *> B.put n
    put (Nop) = B.put (2 :: Word8)
    put (Error xs) = B.put (3 :: Word8) *>
                     B.put xs 
    get = do 
        x <- B.get :: B.Get Word8
        case x of 
            0 -> pure Ok
            1 -> Get <$> B.get <*> B.get 
            2 -> pure Nop
            3 -> Error <$> B.get

instance NFData ClientWords where 
    rnf (Server xs) =  xs `deepseq` ()
    rnf (Got xs) = xs `deepseq` ()
    rnf (Disconnect xs) = xs `deepseq` ()

instance NFData BC.ByteString where 
    rnf xs = BC.map force xs `seq` ()

instance NFData BL.ByteString where 
    rnf xs = BL.map force xs `seq` ()

instance NFData ServerWords where 
    rnf (Ok) = ()
    rnf (Get ch n) = ch `deepseq` n `deepseq` ()
    rnf (Nop) = ()
    rnf (Error xs) = xs `deepseq` () 
{-- Test --}


-- | Example to setup the master
main = do 
    setupMaster "tcp://*:7391" "ctrl" (\x -> force x `deepseq` return ()) 
    forM_ [1..10] $ \i -> slaveSpawn (9431 + i)
    threadDelay 10000


   
-- | Example to setup the slaves 
slaveSpawn i = do 
    x <- setupSlave "tcp://127.0.0.1:7391" ("tcp://127.0.0.1:" ++ show i)
    forever $ do 
        threadDelay 100 
        writeMaster x "ctrl" (BC.pack $ show i)
