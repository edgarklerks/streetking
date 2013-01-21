{-# LANGUAGE ViewPatterns #-}
module SleepSort where 

import Control.Applicative
import Control.Concurrent.STM
import Control.Concurrent
import Control.Monad.Cont
import Control.Monad
import Control.Monad.Trans
import Debug.Trace
import System.IO.Unsafe


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




                    
