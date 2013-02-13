{-# LANGUAGE GADTs, ViewPatterns, ScopedTypeVariables, TypeSynonymInstances, FlexibleInstances, TemplateHaskell, QuasiQuotes, NoMonomorphismRestriction, RankNTypes #-}
module Data.MemTimeState (
            MemState,
            Query(..),
            Result(..),
            QueryChan,
            runQuery,
            newMemState,
            queryManager 

 ) where 


import           Data.Monoid 
import qualified Data.HashMap.Strict as H 
import           Control.Monad.STM 
import           Control.Monad hiding (forM_) 
import           Control.Monad.Trans 
import           Control.Applicative 
import           Control.Concurrent 
import           Control.Concurrent.STM 
import qualified Data.Serialize as S  
import           Data.Word 
import qualified Data.ByteString as B 
import           System.Directory
import           System.Random 
-- extractTill :: Ord q => q -> Prio q a -> ([a],Prio q a)
-- insert :: Ord q => q -> a -> Prio q a -> Prio q a  
import qualified Data.PriorityQueue as Q 
import           Lens.Family
import           Lens.Family.Unchecked
import           Data.Time.Clock.POSIX
import           Data.Foldable 
import           Debug.Trace 
import           Prelude hiding (foldr, foldl)
import           Data.ExternalLog 





type Key = B.ByteString 
type Value = B.ByteString 
type Time = Word64 
type Pointer = Word64 
-- | This map holds the pointer to the current values 
--
type Map = H.HashMap Key Pointer

type MemMap = H.HashMap Pointer (B.ByteString, TVar Time)
type Snapshot = H.HashMap B.ByteString B.ByteString 
type TimeMap = Q.Prio Time Pointer  

-- | The Map is a mapping from a bytestring key to the internal used key.
-- | MemMap contains the binary data, indexed by the internal key 
-- | TimeMap contains the internal keys index by time 

data MemState = MS {
              -- mapkey : Key -> Word64 
              _mapkey :: TVar Map,
              _timemap :: TVar TimeMap,
              _memmap :: TVar MemMap,
              _seed :: TVar StdGen,
              _changes :: TVar Int,
              _sweep :: Time,-- sweep every n seconds  
              _ttl :: Time,
              _filelock :: TMVar (),
              _cycle_logger :: Cycle 

    }
logCycle :: MemState -> String -> String -> IO ()
logCycle ms n m = reportCycle (_cycle_logger ms) n m 

logCycleSTM :: MemState -> String -> String -> STM ()
logCycleSTM ms n m = reportCycleSTM (_cycle_logger ms) n m 


unlockFile  :: MemState -> IO ()
unlockFile ms = atomically $ putTMVar (_filelock ms) ()

lockFile :: MemState -> IO ()
lockFile ms = atomically $ takeTMVar (_filelock ms)

-- | Blocking lock action 
withLock :: MemState -> IO a -> IO a 
withLock ms a = do s <- atomically $ takeTMVar (_filelock ms)
                   x <- a
                   atomically $ putTMVar (_filelock ms) s
                   return x 


-- | Non blocking lock action 
ifUnlock :: MemState -> IO a -> IO ()
ifUnlock ms a = do s <- atomically $ tryTakeTMVar (_filelock ms) 
                   case s of 
                        Nothing -> return ()
                        Just l -> a >> atomically (putTMVar (_filelock ms) l)

mkTLens f = mkLens out inp 
    where out a = readTVar (f a) 
          inp a b = writeTVar (f a) b >> return a 

-- (~.) :
(~.) :: forall b. (forall f. Functor f => RefFamily f MemState (STM MemState) (STM b) b) -> (b -> b) -> MemState -> STM MemState 
(~.) s f ms = do 
            r <- ms ^. s 
            s <~ (f r) $ ms 

rnd :: (Functor f, Random b) => RefFamily f MemState (STM MemState) (STM b) b      
rnd = mkLens inp out -- . seed 
    where out a b = return a 
          inp a = do 
                s <- a ^. seed  
                let (b,g) = random s 
                seed <~ g $ a
                return $ b 

-- modal logic 
-- data Void 
-- logic            Haskell
-- not a            a -> Void 
-- a ==> b          a -> b 
-- []               Monad m => m a 
-- <>               Comonad w => w a 
-- a or b           Either a b 
-- a and b          (a,b)
--
--
-- w a -> a, b -> b m 


insertKeyValue :: MemState -> Time -> Key -> B.ByteString -> STM ()
insertKeyValue ms ct k v  = do 
                a <- insertKey ms k 
                case a of 
                    kn -> do 
                            v' <- newTVar ct
                            memmap ~. H.insert kn (v,v')  $ ms  
                            timemap ~. Q.insert ct kn  $ ms   
                            return ()

cleanKey :: MemState -> Pointer -> STM MemState
cleanKey ms old = do 
            memmap ~. H.delete old $ ms 

deleteKey :: MemState -> Key -> STM () 
deleteKey ms k = do 
            p <- getPointer ms k 
            case p of 
                Just a -> void $ cleanKey ms a
                Nothing -> return ()

updatePointer :: MemState -> Time -> Pointer -> STM () 
updatePointer ms ct p = do 
                timemap ~. Q.insert ct p $ ms 
                return () 

-- | Retrieve the internal key and updates the time record 
getPointer :: MemState -> Key -> STM (Maybe Pointer)
getPointer ms k = do 
            mk <- ms  ^. mapkey
            case H.lookup k mk of
                Nothing -> return Nothing 
                Just a -> do 
                    return (Just a)
                     



mapkey = mkTLens _mapkey 
timemap = mkTLens _timemap 
memmap = mkTLens _memmap 
seed = mkTLens _seed 
changes = mkTLens _changes 
sweep = mkLens out inp 
    where out a = (_sweep a) 
          inp a b = return a 

newMemState :: Cycle -> Time -> Time -> FilePath -> IO MemState 
newMemState ls ttl sw fp = do 
            g <- newStdGen
            b <- doesFileExist fp 
            if b then mkstate g fp 
                 else mknewstate g 
        where mkstate g fp = do 
                        nm <- B.readFile fp 
                        let b = S.decode nm :: Either String Snapshot 
                        case b of 
                            Left s -> error s 
                            Right s -> rebuildState ls s ttl sw 
              mknewstate g = atomically $ do 
                        mk <- newTVar mempty  
                        tm <- newTVar mempty  
                        mm <- newTVar mempty 
                        chg <- newTVar 0 
                        g' <- newTVar g 
                        s <- newTMVar ()
                        return $ MS mk tm mm g' chg sw ttl s ls 

-- H.HashMap B.ByteString B.ByteString (=Snapshot)

-- H.HashMap B.ByteString B.ByteString -> H.HashMap Key Pointer (=Map)
buildPointerMap :: Snapshot -> IO Map 
buildPointerMap sn = foldrM step mempty (H.keys sn)  
        where step x z = do 
                    p <- randomIO 
                    return $ H.insert x p z 

-- Time -> (Map, Snapshot) -> H.HashMap Pointer (B.ByteString, TVar Time )(=MemMap)

buildMemMap :: Time -> Map -> Snapshot -> IO MemMap 
buildMemMap ct mm sp = foldrM step mempty (H.keys sp)
            where step k z = do 
                        case H.lookup k sp of 
                                Just v -> case H.lookup k mm of 
                                                    Just p -> do 
                                                            ts <- newTVarIO ct 
                                                            return $ H.insert p (v,ts) z 
                                                    Nothing -> return z
                                Nothing -> return z
        
-- Time -> Map -> Q.Prio Time Pointer (=TimeMap)

buildTimeMap :: Time -> MemMap -> IO TimeMap 
buildTimeMap ct mm = return $ Q.fromList $ (repeat ct) `zip` (H.keys mm) 



rebuildState :: Cycle -> Snapshot -> Time -> Time -> IO MemState 
rebuildState ls snp ttl sw = do 
                    ct <- getMicroSeconds 
                    mk <- buildPointerMap snp   
                    mm <- buildMemMap (ct + ttl) mk snp  
                    tm <- buildTimeMap (ct + ttl) mm  
                    mk' <- newTVarIO mk 
                    mm' <- newTVarIO mm 
                    tm' <- newTVarIO tm
                    seed' <- newStdGen 
                    seed <- newTVarIO seed' 
                    chg <- newTVarIO 0 
                    p <- newTMVarIO () 
                    return $ MS mk' tm' mm' seed chg sw ttl p ls 

compressState :: MemState -> STM Snapshot 
compressState ms = let tmk = _mapkey ms 
                       ttm = _memmap ms 
                   in do 
                    mk <- readTVar tmk
                    tm <- readTVar ttm 
                    return $ foldr (step tm mk) mempty (H.keys mk)
        where step mm mk k z = case H.lookup k mk of 
                                    Just p -> case H.lookup p mm of 
                                                    Just (fst -> v) -> H.insert k v z 
                                                    Nothing -> z 
                                    Nothing -> z 

                                



                    


runQuery :: QueryChan -> Query -> IO Result 
runQuery s x = do 
            un <- newEmptyTMVarIO 
            atomically $ writeTQueue s (x,un)
            atomically $ takeTMVar un 


getSeed :: MemState -> STM StdGen 
getSeed x =  do 
            tx <-  x ^. seed
            let (g1,g2) = split tx 
            seed <~ g1 $ x
            return g2


data Keys = New Word64 | Update Word64 Word64 

insertKey :: MemState -> Key -> STM Pointer
insertKey t  k = do 
                    (ki :: Word64) <- t ^. rnd  
                    mk <- t ^. mapkey 
                    case H.lookup k mk of 
                            Nothing -> do 
                                    mapkey <~ (H.insert k ki mk) $ t 
                                    return $ ki 
                            Just kold -> do 
                                    return $ kold
            

getMicroSeconds :: IO Word64 
getMicroSeconds = do
            s <- getPOSIXTime
            return $ floor $ s*1000 *1000 

getCT :: MemState -> Pointer -> STM (Maybe Time)
getCT ms p = do 
                mmap <- ms ^. memmap 
                case H.lookup p mmap of 
                        Just (a, tv) -> Just <$> readTVar tv
                        Nothing -> return Nothing 

getValue :: MemState -> Time -> Key -> STM (Maybe Value)
getValue ms ct k = do 
            p <- getPointer ms k 
            logCycleSTM ms "memstate" "getValue" 
            case p of 
                Nothing -> return Nothing 
                Just p -> do 
                    mmap <- ms ^. memmap 
                    case H.lookup p mmap of 
                            Just (a,tv) -> do 
                                        modifyTVar tv (const ct) 
                                        timemap ~. Q.insert ct p $ ms 
                                        return (Just a) 
                            Nothing -> return Nothing  

data Query where 
        Insert    :: Key -> Value -> Query 
        Delete    :: Key -> Query 
        Query     :: Key -> Query  
        DumpState :: Query  
            deriving Show

type Unique a = TMVar a
type QueryChan = TQueue (Query, Unique Result)

data Result where 
        Value :: B.ByteString -> Result 
        NotFound :: Result 
        Empty :: Result 
        Except :: String -> Result 
        KeyVal :: B.ByteString -> B.ByteString -> Result 
    deriving (Eq,Show)

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



queryManager :: FilePath -> MemState -> QueryChan -> IO ()
queryManager fp ms qc = forkIO (sweeper ms) >> (forever $ do 
                            logCycle ms "memstate" "queryManager" 
                            atomically $ changes ~. (+1) $ ms   
                            i <- atomically $ ms ^. changes 
                            when (i `mod` 10000 == 0) $ void $ forkIO $ 
                                            ifUnlock ms $ do 
                                                storeSnapShot fp ms 

                            ct <- getMicroSeconds 
                            (q,u) <- atomically $ readTQueue qc 
                            case q of 
                                Insert x y -> atomically $ do 
                                            s <- insertKeyValue ms (ct + _ttl ms) x y 
                                            putTMVar u Empty 
                                Delete x -> atomically $ do 
                                                deleteKey ms x  
                                                putTMVar u Empty 
                                Query a -> atomically $ do 
                                                v <- getValue ms (ct + _ttl ms) a  
                                                case v of 
                                                    Just a -> putTMVar u (Value a)
                                                    Nothing -> putTMVar u NotFound 

                                DumpState -> storeSnapShot fp ms >> (atomically $ putTMVar u Empty)) 


instance S.Serialize Snapshot where 
            put = S.put . H.toList
            get = H.fromList <$> S.get

sweeper :: MemState -> IO () 
sweeper ms = forever $ do 
        logCycle ms "memstate" "sweeper" 
        threadDelay (fromIntegral $ _sweep ms) 
        ct <- getMicroSeconds 
        atomically $ do 
            xs <- ms ^. timemap 
            case Q.extractTillWithKey ct xs of 
                (xs,pr) -> do 
                        forM_ xs $ \(q,i) -> do 
                                    s <- getCT ms i  
                                    case s of 
                                        Nothing -> return ()
                                        Just s -> when (q == s) $ void $ cleanKey ms i 

                        void $ timemap <~ pr $ ms 

                     

storeSnapShot :: FilePath -> MemState -> IO ()
storeSnapShot fp ms = do 
                         xs <- atomically $ compressState ms 
                         B.writeFile fp $ S.encode xs  
