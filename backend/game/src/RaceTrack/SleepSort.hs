{-# LANGUAGE ViewPatterns, RankNTypes #-}
module SleepSort where 

import Control.Applicative
import Control.Concurrent.STM
import Control.Concurrent
import Control.Monad.Cont
import Control.Monad
import Control.Monad.Trans
import Debug.Trace
import System.IO.Unsafe
import Control.Monad
import Control.Monad.CC
import Control.Monad.State 
import Debug.Trace 


data Data a = Stop Int | Data a
    deriving (Show)


toSeconds :: Enum a => Data a -> Int 
toSeconds (Data a) = fromEnum a * 2000
toSeconds (Stop i) = i * 2000

pack x = Data x

sort :: (Enum a) => [a] -> [a]
sort os@(fmap pack -> xs) = unsafePerformIO $ do 
        ch <- newTChanIO
        let ms = maximum (fromEnum <$> os) + 1 
        forM_ (xs ++ [Stop ms]) $ \i -> forkIO $ threadDelay (toSeconds i) *> atomically (writeTChan ch i)
        collect ch
  
liftSTM :: STM a -> ContT r STM a 
liftSTM a = ContT (a>>=)

collect :: TChan (Data a) -> IO [a]
collect ch = atomically . (`runContT` return) $ callCC $ \k -> do 
                p <- liftSTM . newTVar $ [] 
                forever $ do 
                    c <- liftSTM . readTChan $ ch
                    case c of 
                        Stop _ -> do 
                            xs <- liftSTM . readTVar $ p
                            k xs 
                            return undefined  
                        Data b -> liftSTM (modifyTVar p (b:)) *> return undefined  




type StateC r s = CCT r (State s) 

runStateC :: (forall r. StateC r s a) -> s -> (a, s)
runStateC m = runState (runCCT m)


test :: StateC r Int Int 
test = reset $ \s -> do 

    reset $ \p -> (7*) <$> (shift p $ \n -> do 
            (*3) <$> (shift s $ \k -> k (n (k (n (k (return 1)))))))



