{-# LANGUAGE GADTs, ViewPatterns, OverloadedStrings, FlexibleInstances, MultiParamTypeClasses, RankNTypes, ImpredicativeTypes, ScopedTypeVariables, LiberalTypeSynonyms, FlexibleContexts, NoMonomorphismRestriction #-}
module Data.Socket where 


import Control.Monad 
import Control.Applicative
import Control.Monad.Cont 
import Control.Monad.State as S  
import Network.Fancy 
import Control.Concurrent 
import qualified Data.ByteString as B
import qualified Data.ByteString.Char8 as BC
import Data.Hashable 
import Data.Serialize as R 
import Data.List 
import Data.Monoid
import Control.Monad.Error 
import Control.Concurrent.STM 
import qualified Data.Set as S 
import Data.Time.Clock.POSIX 
import Data.Word
import Test.QuickCheck 
import qualified Data.HashMap.Strict as HS

pullSockSpec :: Int -> ServerSpec 
pullSockSpec p = ServerSpec {
            address = IP "" p,
            reverseAddress = ReverseNumeric,
            threading = Threaded,
            closeConnection = True, 
            recvSize = 4096
    }
-- generalized abstract data types 
--

type StreamQueue a = TQueue (Stream a)
type IndexedStreamQueue a = TQueue (Int, Stream a)

data Stream a where 
        -- | Data messages 
        Start :: Int -> Stream a
        Packet :: Int -> B.ByteString -> Stream a
        End :: Int -> Stream a
        -- | Control messages 
        Retry :: [Int] -> Stream a 
        Ok :: Stream a 
        Resend :: Stream a 
        Close :: Stream a 
    deriving (Show, Eq, Ord)

instance Serialize (Stream a) where 
        put (Start a) = R.put (0x01 :: Word8) *> R.put a
        put (Packet a b) = R.put (0x02 :: Word8) *> R.put a *> R.put b
        put (End a) = R.put (0x03 :: Word8) *> R.put a
        put (Retry xs) = R.put (0x04 :: Word8) *> R.put xs
        put (Ok) = R.put (0x05 :: Word8)
        put (Resend) = R.put (0x06 :: Word8)
        put (Close) = R.put (0x07 :: Word8)
        get = do 
            b <- R.get :: Get Word8
            case b of 
                0x01 -> Start <$> R.get 
                0x02 -> Packet <$> R.get <*> R.get 
                0x03 -> End <$> R.get 
                0x04 -> Retry <$> R.get 
                0x05 -> pure Ok
                0x06 -> pure Resend
                0x07 -> pure Close 
        



data StreamError = Missing [Int]
                 | HashBroken 
                 | CannotDecode 
                 | StreamError String 
                 | NoHash 
                 | InvalidStream 
                 | TimeoutError 
        deriving (Show, Eq)

instance Error StreamError where 
        noMsg = CannotDecode 
        strMsg = StreamError 


disassemble :: (Hashable a, Serialize a) => Int -> a -> [Stream a]
disassemble n a = Start (hash a) : toStream 0 (encode a)
        where toStream x (B.null -> True) = [End x]
              toStream x bs = Packet x (B.take n bs) : toStream (x + 1) (B.drop n bs)


reassemble :: (Hashable a, Serialize a) => [Stream a] -> Either StreamError a
reassemble (sort -> xs) = do 
                      unless (monotone xs) $ throwError (getMissing xs)
                      assemble xs  


assemble :: (Hashable a, Serialize a) => [Stream a] -> Either StreamError a 
assemble = (uncurry  convert) . foldr (flip step) (B.empty, 0)
    where convert :: (Hashable a, Serialize a) => B.ByteString -> Int -> Either StreamError a 
          convert xs n = do a <- mapError (decode xs) 
                            unless (hash a == n) $ throwError (HashBroken)
                            return a 
          step (bs, _) (Start n) = (bs, n)
          step (bs,n) (Packet _ pp) = (pp <> bs, n)
          step z (End n) = z 


mapError :: Either String a -> Either StreamError a
mapError (Left e) = (Left (StreamError e))
mapError (Right a) = Right a


getMissing :: [Stream a] -> StreamError 
getMissing (Start _ : n) = getMissing' n []
        where getMissing' (Packet n _:xs) z = getMissing' xs (n : z) 
              getMissing' (End s:[]) z = Missing ([0..s] \\ z)
              getMissing' _ _ = InvalidStream  
getMissing _ = NoHash 


monotone :: [Stream a] -> Bool 
monotone (Start n:xs) = monotone' Nothing xs 
        where monotone' Nothing (Packet 0 _:xs) = monotone' (Just 0) xs 
              monotone' (Just n) (Packet p _:xs) | n == pred p = monotone' (Just p) xs
                                               | otherwise = False 
              monotone' (Just c) (End p:[]) | c == pred p = True 
                                            | otherwise = False 
              monotone' _ _ = False 
monotone _ = False  


newtype Transcoder s e b a = Transcoder {
                    unTranscoder ::  Int -> (IO (Maybe (Stream b))) -> (Stream b -> IO ()) -> s -> IO (s, Either e a)
    }

runTranscoder :: (Hashable a, Serialize a) => s -> (IO (Maybe (Stream a))) -> (Stream a -> IO ()) -> Transcoder s e a a -> IO (s, Either e a)
runTranscoder s g f m = (floor <$> getPOSIXTime) >>= \tm -> unTranscoder m (1000 * tm) g f s  

instance Functor (Transcoder s e b) where 
        fmap f m = Transcoder $ \tm g p s -> 
                                 do (s', a') <- unTranscoder m tm g p s
                                    case a' of 
                                        Left e -> return (s', Left e)
                                        Right a -> return (s', Right (f a))


instance Applicative (Transcoder s e b) where 
        pure a = Transcoder $ \tm g p s -> return (s, Right a)
        (<*>) fs xs = Transcoder $ \tm g p s -> do 
                                    (s',f) <- (unTranscoder fs) tm g p s 
                                    (s'',x) <- (unTranscoder xs) tm g p s'
                                    case (f, x) of 
                                        (Right f, Right x) -> return (s'', Right (f x))
                                        (Left e, _) -> return (s'', Left e)
                                        (_, Left e) -> return (s'', Left e)

instance Monad (Transcoder s e b) where 
        return = pure 
        (>>=) m f = Transcoder $ \tm g p s -> do 
                                (s', a) <- (unTranscoder m) tm g p s
                                case a of 
                                    Left e -> return (s', Left e)
                                    Right a -> do 
                                        (s'', b) <- unTranscoder (f a) tm g p s' 
                                        return (s'', b)


instance MonadState s (Transcoder s e b) where 
        get = Transcoder $ \tm f g  s -> return (s,Right s)
        put a = Transcoder $ \tm f g s -> return (a, Right ())


type StreamTranscoder b a = Transcoder [Stream b] StreamError b a


-- runStreamTranscoder :: (Hashable b, Serialize b) => (Stream b -> IO ()) -> StreamTranscoder b b -> IO ([Stream b],b) 
runStreamTranscoder g f (m :: StreamTranscoder b a) = runTranscoder [] g f m 

liftSTM :: STM a -> Transcoder s e b a 
liftSTM m = Transcoder $ \tm f g s -> atomically m >>= \b ->  return (s, Right b)

streamMonotone :: StreamTranscoder b Bool 
streamMonotone = Transcoder $ \tm f g s -> return (s, Right $ monotone s)

addStream :: Stream b -> StreamTranscoder b () 
addStream b = modify (insert b)   
                
getCurrentTime :: Transcoder s e b Int 
getCurrentTime = Transcoder $ \tm f g s -> getPOSIXTime >>= \x -> return (s, Right $ floor (1000 * x))

getStartTime :: Transcoder s e b Int 
getStartTime = Transcoder $ \tm f g s -> return (s, Right tm)

getDeltaTime :: Transcoder s e b Int 
getDeltaTime = (-) <$> getCurrentTime <*> getStartTime 

wait :: Transcoder s e b ()
wait = Transcoder $ \tm f g s -> threadDelay 10000 *> return (s, Right ())

controlMessage :: Stream a -> StreamTranscoder a ()
controlMessage xs = Transcoder $ \tm f g s -> g xs *> return (s, Right ()) 

putError :: StreamError -> StreamTranscoder a a
putError e = Transcoder $ \tm f g s -> return (s, Left e)

getMessage :: StreamTranscoder a (Maybe (Stream a))
getMessage = Transcoder $ \tm g p s -> g >>= \x -> return (s, Right x) 

printInfo :: Show a => a -> Transcoder s e b () 
printInfo xs = return () --  Transcoder $ \tm g p s -> print xs >> return (s, Right ())


{-- stream receiver --}

runStream :: (Hashable b, Serialize b) => Int -> StreamTranscoder b b
runStream nt = do 
            str <- getMessage  
            case str of 
                Nothing -> do 
                        ts <- getDeltaTime 
                        printInfo ts
                        printInfo "nothing?"
                        if ts > nt then S.get >>= checkCase nt . reassemble 
                                   else runStream nt 
                Just str -> do 
                    addStream str 
                    b <- streamMonotone 
                    printInfo str 
                    case b of 
                        True -> S.get >>= checkCase nt  . reassemble 
                        False -> do 
                            ts <- getDeltaTime 
                            if ts > nt then S.get >>= checkCase nt . reassemble 
                                       else runStream nt 

checkCase :: (Hashable b, Serialize b) => Int -> (Either StreamError b) -> StreamTranscoder b b 
checkCase n  (Left bs) = case bs of 
                                Missing xs -> printInfo xs *> controlMessage (Retry xs) *> runStream (n + n) 
                                NoHash -> controlMessage (Resend) *> runStream (n + n) -- error "no hash found"
                                a -> printInfo a *> controlMessage Close *> putError TimeoutError -- return (Left  TimeoutError) 
checkCase n  (Right as) = controlMessage Ok *> return as

testStream :: [(String, MockStream String)] -> IO ()
testStream fs = forM_ fs $ \(s, f) -> do 
    dta <- newTQueueIO 
    ctrl <- newTQueueIO 
    print $ "running " ++ s ++ " test"
    forkIO $ f (s :: String) dta ctrl 
    print =<< runStreamTranscoder (atomically . tryReadTQueue $ dta) (atomically . writeTQueue ctrl) (runStream 500)


runTests = testStream [
                      ("perfect", mockStreamPerfect),
                      ("missing", mockStreamMissing),
                      ("broken", mockStreamBroken)
                    ]

type MockStream a = (Show a, Serialize a, Hashable a) => a -> (TQueue (Stream a)) -> (TQueue (Stream a)) -> IO ()

mockStreamPerfect :: MockStream a -- (Show a, Serialize a, Hashable a) => a -> (TQueue (Stream a)) -> (TQueue (Stream a)) -> IO  () 
mockStreamPerfect n inp outp = forM_ (disassemble 4 n) $ atomically . \x -> writeTQueue inp x 

mockStreamMissing :: MockStream a -- (Show a, Serialize a, Hashable a) => a -> (TQueue (Stream a)) -> (TQueue (Stream a)) -> IO ()
mockStreamMissing m inp outp = let ps = disassemble 4 m
                                   (missing, wilsend) = (breakEvens ps) 
                               in do 
                                     forM_ missing $ atomically . writeTQueue inp
                                     p <- atomically $ readTQueue outp 
                                     case p of
                                        Retry xs -> print "please retry" *> (forM_ xs $ \x -> (atomically $ writeTQueue inp (select x ps)))
                                        Resend -> print "restart" *> mockStreamMissing m inp outp -- - error "shouldn't happen"
                                        Ok -> return ()
                                        Close -> error "want to close"

mockStreamBroken :: MockStream a
mockStreamBroken n inp outp = let ps = disassemble 4 n 
                                  (missing, wilsend) = breakEvens ps 
                              in do
                                forM_ wilsend $ atomically . writeTQueue inp 
                                p <- atomically $ readTQueue outp 
                                case p of 
                                    Retry xs -> print "please retry" *> (forM_ xs $ \x -> (atomically $ writeTQueue inp (select x ps)))
                                    Resend -> print "restart" *> mockStreamMissing n inp outp 
                                    Ok -> return ()
                                    Close -> error "want to close"

select :: Int -> [Stream a] -> Stream a
select n w@(Packet t _ : xs) | n == t = head w 
                             | otherwise = select n xs 
select n (x:xs) = select n xs 
select n [] = error "cannot happen?"

                                     

whileM :: Monad m => m Bool -> m ()
whileM m = do 
        b <- m 
        when b $ whileM m 

                                                                        
                                   

breakEvens :: [Stream a] -> ([Stream a], [Stream a])
breakEvens xs =  be ([],[]) xs 
    where  be (ps,ts) (t@(Packet n g):xs) | even n = be (ps, t:ts) xs
           be (ps, ts) (t : xs) = be (t:ps, ts) xs
           be (ps, ts) [] = (ps, ts)


printInt :: ([Stream Int], Either StreamError Int)  -> IO ()
printInt = print 

findCycle :: Ord a => a -> (a -> a) -> [a]
findCycle a f = reverse $ findCycle' S.empty [a] f 
    where findCycle' n t@(a:_) f = let b = f a 
                                   in if b `S.member` n 
                                               then (b:(takeWhile (/=b) t) ++ [b]) 
                                               else b `seq` findCycle' (S.insert b n) (b:t) f 



-- createSocketListener 

data SeqPacket a = SeqPacket {
            unSeqPacket :: (Int, Stream a)
    } deriving (Show)

instance Serialize (SeqPacket a) where 
    put (SeqPacket (a,b)) = R.put a *> R.put b 
    get = SeqPacket <$> ((,) <$> R.get <*> R.get)

toBS :: (Hashable a, Serialize a) => SeqPacket a -> B.ByteString 
toBS (SeqPacket (d,s)) = encode (d,s)

fromBS :: (Hashable a, Serialize a) => B.ByteString -> Either String (SeqPacket a)
fromBS b =  decode b



receivePackets :: (Hashable a, Serialize a) => Address -> (SeqPacket a -> Address -> IO (Maybe (SeqPacket a))) -> IO [ThreadId]
receivePackets addr f  = let spec = serverSpec {
                    address = addr
            } in dgramServer spec $ \(fromBS -> x) a -> do 
                                case x of 
                                    Left e -> return mempty
                                    Right x -> do 
                                        b <- f x a
                                        case b of 
                                            Just a -> return (pure $ toBS a)
                                            Nothing -> return [] 



maxChunkSize = 1024 * 1024

sendPacket :: (Hashable a, Serialize a) => Address -> SeqPacket a -> IO (Either String (SeqPacket a))
sendPacket addr seq =  withDgram addr $  (\x -> send x (toBS $ seq) *> (fromBS <$> recv x maxChunkSize))
      

testShit = do 
     bxd <- newTQueueIO 
     forkIO $ boxedManager bxd 


     dta <- newTQueueIO :: IO (StreamQueue Int)
     ctrl <- newTQueueIO :: IO (StreamQueue Int) 
     receivePackets (IP "127.0.0.1" 8123) $ \(p :: SeqPacket Int) a -> case p of 
                                                                                    (SeqPacket (s, n)) -> do 
                                                                                                             atomically $ writeTQueue dta n 
                                                                                                             return (Just $ SeqPacket (s, Ok)) 
     forkIO $ forM_ [1..100 :: Int] $ \p -> do
                let xs = disassemble 1 p 
                ns <- forM xs $ \l -> sendPacket (IP "127.0.0.1" 8123) ((SeqPacket (p, l))) 
                printBoxedQ bxd "packets" ns 
                printBoxedQ bxd "transcoder" =<< runStreamTranscoder (atomically $ tryReadTQueue dta) (atomically . writeTQueue ctrl) (runStream 2000)




multiShit = do
        bxd <- newTQueueIO 
        forkIO $ boxedManager bxd 


        xs <- newTVarIO (HS.empty)


        receivePackets (IP "127.0.0.1" 8712) $ \(p :: SeqPacket String) a -> case p of 
                                                                            (SeqPacket (s, n)) -> do 
                                                                                        printBoxedQ bxd "seqpacket" s
                                                                                        bs <- atomically $ do 
                                                                                                p <- readTVar xs 
                                                                                                case HS.lookup s p of 
                                                                                                        Nothing ->  do 
                                                                                                            dta <- newTQueue :: STM (StreamQueue String)
                                                                                                            ctrl <- newTQueue :: STM (StreamQueue String)
                                                                                                            writeTVar xs $ HS.insert s (dta,ctrl) p  
                                                                                                            return (Left (dta, ctrl))
                                                                                                        Just a -> return (Right a)
                                                                                        case bs of 
                                                                                          Left (dta,ctrl) -> forkIO (printBoxedQ bxd "transcoder" =<< runStreamTranscoder (atomically $ tryReadTQueue dta) (atomically . writeTQueue ctrl) (runStream 5000)) *> atomically (writeTQueue dta n) *> return (Just $ SeqPacket (s, Ok))
                                                                                                    
                                                                                          Right (dta,ctrl) -> atomically (writeTQueue dta n) *> return (Just $ SeqPacket (s, Ok))

                                                                                        
        forM_ (show <$> [1..10 :: Int]) $ \l -> forkIO $ do 

                                                           let xs = disassemble 4 l 
                                                           forM_ xs $ \x -> sendPacket (IP "127.0.0.1" 8712) (SeqPacket (read l, x))

                                                                                                            


data Boxed = forall a. Show a => Box a

testF :: (Hashable a, Serialize a) => StreamQueue a -> SeqPacket a -> Address -> IO (SeqPacket a)
testF sq addr = undefined  

printBoxedQ :: Show a => TQueue (Boxed, String) -> String -> a -> IO ()
printBoxedQ tq lbl a = atomically $ writeTQueue tq (Box a, lbl)

printBoxed' :: String -> Boxed -> IO ()
printBoxed' lbl (Box a) = let n = length lbl `div` 2 
                              b = putStrLn (replicate (20 - n) '=' ++ lbl ++ replicate (20 - n) '=' ++ replicate 1 '\n')
                          in b *> print a *> putStr "\n" *> b


boxedManager :: TQueue (Boxed,String) -> IO ()
boxedManager c = forever $ do 
                    (a,p) <- atomically $ readTQueue c
                    printBoxed' p a

