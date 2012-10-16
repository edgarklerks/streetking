{-# LANGUAGE RankNTypes, GADTs, StandaloneDeriving, NoMonoLocalBinds, NoMonomorphismRestriction, GeneralizedNewtypeDeriving,OverloadedStrings, ScopedTypeVariables, DeriveGeneric, TypeSynonymInstances, FlexibleInstances, ImpredicativeTypes #-}
module Data.MemState (
            MemState,
            Query(..),
            Result(..),
            QueryChan,
            runQuery,
            newMemState,
            queryManager
            
                     
        ) where  

import qualified Data.HashMap.Strict as H 
import           Control.Monad.STM
import           Control.Monad
import           Control.Monad.Trans
import           Control.Applicative
import qualified Data.ByteString as B 
import qualified Data.ByteString.Char8 as C
import           Control.Concurrent.STM
import           System.Directory
import qualified Data.Serialize as S  
import qualified Data.ByteString as B 
import           Control.Concurrent
import           Debug.Trace 
import           Control.Monad.CatchIO
import           Data.Word


data MemState = MS {
            unMS :: TVar MemMap,
            lock :: MVar (),
            changes :: TVar Int 
        } 

type MemMap = H.HashMap B.ByteString (TVar B.ByteString)
type Snapshot = H.HashMap B.ByteString B.ByteString


instance S.Serialize Snapshot where 
            put = S.put . H.toList
            get = H.fromList <$> S.get

newQueryChan :: IO QueryChan 
newQueryChan = newTChanIO

addCounter :: MemState -> STM ()
addCounter = flip modifyTVar (+1) . changes 

resetCounter :: MemState -> STM ()
resetCounter = flip writeTVar 0 . changes

readCounter :: MemState -> STM Int 
readCounter = readTVar . changes

lockState :: MemState -> IO ()
lockState  = void . takeMVar . lock   

unlockState :: MemState -> IO ()
unlockState = void . flip putMVar () . lock 

storeSnapShot :: FilePath -> MemState ->  IO ()
storeSnapShot fp m = withLock m $ do
                        s <- atomically $ readTVar (unMS m) >>= \s -> snapshot s
                        B.writeFile fp (S.encode s)

withLock m f = finally (lockState m >> f) (unlockState m)

loadSnapShot :: FilePath -> IO MemState 
loadSnapShot fp = do 
                    p <- S.decode <$> B.readFile fp 
                    l <- newMVar ()
                    case p of 
                        Left s -> error s
                        Right a -> atomically $ do 
                                        s <- loadsnapshot a
                                        p <- newTVar s
                                        t <- newTVar 0
                                        return (MS p l t)

snapshot :: MemMap -> STM Snapshot
snapshot m = foldM step (H.empty)  (H.keys m) 
                where step x i = do  
                            case H.lookup i m of 
                                Nothing -> return x
                                Just a -> do 
                                        p <- readTVar a 
                                        return $ H.insert i p x 

loadsnapshot :: Snapshot -> STM MemMap 
loadsnapshot m = foldM step (H.empty) (H.keys m)
                where step x i = do 
                            case H.lookup i m of 
                                    Nothing -> return x
                                    Just a -> do 
                                        p <- newTVar a 
                                        return $ H.insert i p x


newMemState :: t -> t -> FilePath -> IO MemState 
newMemState _ _ fp = do 
           b <- doesFileExist fp  
           if b then mkstate fp 
                else mknewstate  
    where mkstate fp = do 
                    nm <- B.readFile fp 
                    let b = S.decode nm :: Either String Snapshot
                    t <- newMVar ()
                    case b of
                        Left s -> error s
                        Right s -> do p <- atomically $ loadsnapshot s
                                      l <- newTVarIO p 
                                      n <- newTVarIO 0 
                                      return (MS l t n)
          mknewstate = do 
                   t <- newMVar ()
                   p <- newTVarIO (H.empty)
                   l <- newTVarIO 0 
                   return (MS p t l)

data Query where 
        Insert :: B.ByteString -> B.ByteString -> Query 
        Delete :: B.ByteString -> Query 
        Query :: B.ByteString -> Query  
        DumpState :: Query  
            deriving Show


instance S.Serialize Query where 
        put (Insert b x) = S.put (0 :: Word8) *> S.put b *> S.put x
        put (Delete b) = S.put (1 :: Word8) *> S.put b 
        put (Query b) = S.put (2 :: Word8) *> S.put b
        get = do 
            b <- S.get :: S.Get Word8
            case b of 
                0 -> Insert <$> S.get <*> S.get
                1 -> Delete <$> S.get
                2 -> Query <$> S.get 

data Result where 
        Value :: B.ByteString -> Result 
        NotFound :: Result 
        Empty :: Result 
        Except :: String -> Result 
        KeyVal :: B.ByteString -> B.ByteString -> Result 
    deriving Show

instance S.Serialize Result where 
        put (Value b) = S.put (0 :: Word8) *> S.put b
        put (NotFound) = S.put (1 :: Word8) 
        put Empty = S.put (2 :: Word8)
        put (Except b) = S.put (3 :: Word8) *> S.put b
        put (KeyVal b a) = S.put (4 :: Word8) *> S.put b *> S.put a
        get = do 
            b <- S.get :: S.Get Word8 
            case b of 
                0 -> Value <$> S.get 
                1 -> pure NotFound 
                2 -> pure Empty 
                3 -> Except <$> S.get 
                4 -> KeyVal <$> S.get <*> S.get

data Op = I | D | Q

type Unique a = TMVar a
type QueryChan = TChan (Query, Unique Result)

test :: IO a
test = do 
    m <- newMemState "asd"
    n <- newTChanIO 
    forkIO $ queryManager "asd" m n
   
    forkIO $  iclient n 1 1000
    forkIO $ iclient n 1001 2000
    forkIO $ forM_ [1 .. 2000] $ \i -> do 
                    p <- runQuery n $ Query (C.pack $ show i)
                    print p
    forever $ threadDelay 10000


iclient :: (Enum a, Show a) => QueryChan -> a -> a -> IO ()
iclient n p q = forM_ [p..q] $ \i -> runQuery n $ Insert (C.pack $ show i) (C.pack $ show i)

    

queryManager :: FilePath -> MemState -> QueryChan  -> IO ()
queryManager fp m c = let ms = unMS m 
                   in forever $ do 
                        i <- atomically $ readCounter m
                        when (i > 1000) $ void $ forkIO $ do 
                                    atomically $ resetCounter m 
                                    storeSnapShot fp m 
                        (q,u) <- atomically $ readTChan c
                        case q of 
                            Insert x y -> atomically $ do 
                                                addCounter m 
                                                p <- readTVar ms 
                                                a <- newTVar y
                                                writeTVar ms $ H.insert x a p 
                                                putTMVar u Empty 
                            Delete x -> atomically $ do 
                                                addCounter m 
                                                p <- readTVar ms 
                                                writeTVar ms $ H.delete x p
                                                putTMVar u Empty 
                            Query a -> atomically $ do 
                                                p <- readTVar ms 
                                                case H.lookup a p of 
                                                        Nothing -> putTMVar u NotFound
                                                        Just a -> readTVar a >>= \x -> putTMVar u (Value x)
                            DumpState -> storeSnapShot fp m >> (atomically $ putTMVar u Empty)



runQuery :: QueryChan   -> Query ->  IO Result 
runQuery s x = do 
            un <- newEmptyTMVarIO 
            atomically $ writeTChan s (x, un) 
            atomically $ takeTMVar un 

