{-# LANGUAGE GADTs, ViewPatterns, OverloadedStrings, FlexibleInstances, MultiParamTypeClasses, RankNTypes, ImpredicativeTypes, ScopedTypeVariables #-}
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
import Data.Serialize 
import Data.List 
import Data.Monoid
import Control.Monad.Error 
import Control.Concurrent.STM 
import qualified Data.Set as S 
import Data.Time.Clock.POSIX 

pullSockSpec :: Int -> ServerSpec 
pullSockSpec p = ServerSpec {
            address = IP "" p,
            reverseAddress = ReverseNumeric,
            threading = Threaded,
            closeConnection = True, 
            recvSize = 4096
    }

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
runTranscoder s g f m = (floor <$> getPOSIXTime) >>= \tm -> unTranscoder m tm g f s  

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
getCurrentTime = Transcoder $ \tm f g s -> getPOSIXTime >>= \x -> return (s, Right $ floor x)

getStartTime :: Transcoder s e b Int 
getStartTime = Transcoder $ \tm f g s -> return (s, Right tm)

getDeltaTime :: Transcoder s e b Int 
getDeltaTime = (-) <$> getStartTime <*> getCurrentTime 

wait :: Transcoder s e b ()
wait = Transcoder $ \tm f g s -> threadDelay 10000 *> return (s, Right ())

controlMessage :: Stream a -> StreamTranscoder a ()
controlMessage xs = Transcoder $ \tm f g s -> g xs *> return (s, Right ()) 

putError :: StreamError -> StreamTranscoder a a
putError e = Transcoder $ \tm f g s -> return (s, Left e)

getMessage :: StreamTranscoder a (Maybe (Stream a))
getMessage = Transcoder $ \tm g p s -> g >>= \x -> return (s, Right x) 

runStream :: (Hashable b, Serialize b) => Int -> StreamTranscoder b b
runStream nt = do 
            str <- getMessage  
            case str of 
                Nothing -> wait *> do 
                            ts <- getDeltaTime 
                            if ts > nt then S.get >>= checkCase nt . reassemble 
                                       else runStream nt 
                Just str -> do 
                    addStream str 
                    b <- streamMonotone 
                    case b of 
                        True -> S.get >>= checkCase nt  . reassemble 
                        False -> do 
                            ts <- getDeltaTime 
                            if ts > nt then S.get >>= checkCase nt . reassemble 
                                       else runStream nt 

checkCase :: (Hashable b, Serialize b) => Int -> (Either StreamError b) -> StreamTranscoder b b 
checkCase n  (Left bs) = case bs of 
                                Missing xs -> controlMessage (Retry xs) *> runStream (n + n) 
                                a -> controlMessage Close *> putError TimeoutError -- return (Left  TimeoutError) 
checkCase n  (Right as) = controlMessage Ok *> return as

testStream :: IO ()
testStream = do 
    dta <- newTQueueIO 
    ctrl <- newTQueueIO 
    printInt =<< runStreamTranscoder (atomically . tryReadTQueue $ dta) (atomically . writeTQueue ctrl) (runStream 10)
    return ()


printInt :: ([Stream Int], Either StreamError Int)  -> IO ()
printInt = print 

findCycle :: Ord a => a -> (a -> a) -> [a]
findCycle a f = reverse $ findCycle' S.empty [a] f 
    where findCycle' n t@(a:_) f = let b = f a 
                                   in if b `S.member` n 
                                               then (b:(takeWhile (/=b) t) ++ [b]) 
                                               else b `seq` findCycle' (S.insert b n) (b:t) f 


