{-# GHC_OPTIONS -fno-cse -fno-full-laziness #-}
module Data.Lock (
        withLockBlock,
        withLockNonBlock,
        Namespace,
        printLocks 
    ) where 


import System.IO.Unsafe 
import qualified Data.Set as S 
import Data.Monoid 
import Control.Concurrent
import Control.Concurrent.STM
import Control.Monad 
import Control.Monad.Trans 
import Control.Applicative

type Namespace = String 

{-# NOINLINE unsafeLock #-}
unsafeLock :: TVar (S.Set String)
unsafeLock = m `seq` unsafePerformIO $ newTVarIO m
        where m = mempty 


setLock :: Show a => Namespace -> a ->  IO ()
setLock s a = atomically $ do 
                tv <- readTVar unsafeLock 
                writeTVar unsafeLock (S.insert (show (s,a)) tv)

removeLock :: Show a => Namespace -> a -> IO ()
removeLock s a = atomically $ do 
                    tv <- readTVar unsafeLock 
                    writeTVar unsafeLock (S.delete (show (s,a)) tv)

isLocked :: Show a => Namespace -> a -> IO Bool 
isLocked nm a = atomically $ do 
                    tv <- readTVar unsafeLock 
                    return $ (show (nm, a)) `S.member` tv

setLockBlock :: Show a => Namespace -> a -> IO Bool
setLockBlock s a = atomically $ do 
                        tv <- readTVar unsafeLock 
                        if (show (s,a)) `S.member` tv
                                then return False 
                                else writeTVar unsafeLock (S.insert (show (s,a)) tv) *> return True 



withLockBlock :: (Applicative m, MonadIO m, Show a) => Namespace -> a -> m b -> m b
withLockBlock s a m = do 
                b <- liftIO $ setLockBlock s a 
                if b 
                    then m <* liftIO (removeLock s a)
                    else liftIO (threadDelay 1000) *> withLockBlock s a m 

withLockNonBlock :: (Applicative m, MonadIO m, Show a) => Namespace -> a -> m () -> m ()
withLockNonBlock s a m = do 
                xs <- liftIO $ readTVarIO unsafeLock 
                b <- liftIO $ setLockBlock s a 
                xs <- liftIO $ readTVarIO unsafeLock 
                if b 
                    then m <* liftIO (removeLock s a) 
                    else return () 


printLocks :: IO ()
printLocks = do 
        xs <- readTVarIO unsafeLock 
        print xs 

testLock = do 
    t <- newEmptyMVar 
    forM_ [1..100] $ \i -> do 
        forkIO (threadDelay (i * 5000) *> worker i t)

    putMVar t () 


worker n s = withLockNonBlock "lalala" 1 $ do
        readMVar s 
        threadDelay 10000 
        print $ "hello" ++ show n 
