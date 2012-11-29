{-# LANGUAGE OverloadedStrings, FlexibleContexts #-}
module LockSnaplet (
        initLock,
        withLockBlock,
        withLockNonBlock,
        Lock,
        getLock,
        HasLock(..),
        printLocks
    ) where 


import Control.Monad
import Control.Applicative
import Control.Monad.Trans
import Snap.Snaplet
import Data.Lens.Common
import Data.Lens.Template
import Data.Text 
import Control.Concurrent
import Control.Concurrent.STM 
import qualified Data.Set as S
import Data.Monoid 
import Data.Hashable  
import Control.Monad.State

type Namespace = String 

newtype Lock = Lock {
        unLock :: TVar (S.Set Int) 
    }



setLock l m a = do 
    let s = unLock l
    liftIO $ atomically $ do 
            x <- readTVar s
            writeTVar s (S.insert (mkKey m a) x) 

removeLock l m a = do 
        let s = unLock l
        liftIO $ atomically $ do 
                x <- readTVar s 
                writeTVar s (S.delete (mkKey m a) x)

setLockBlock l m a = do 
            let s = unLock l
            liftIO $ atomically $ do 
                tv <- readTVar s
                if (mkKey m a `S.member` tv)
                    then return False 
                    else writeTVar s (S.insert (mkKey m a) tv) *> return True 

withLockNonBlock :: (MonadIO m, Applicative m, Show a) => Lock -> Namespace -> a -> m () -> m ()
withLockNonBlock l n a m = do 
            b <- setLockBlock l n a 
            if b 
                then do
                    m  
                    removeLock l n a 
                    return ()
                else return ()

withLockBlock :: (MonadIO m, Applicative m, Show a) => Lock -> Namespace -> a -> m b -> m b 
withLockBlock l n a m = do 
            b <- setLockBlock l n a 
            liftIO $ printLocks l 
            if b 
                then do 
                        liftIO $ print "run first"
                        s <- m 
                        liftIO $ print "removed lock"
                        s `seq` removeLock l n a -- run second  
                        return s
                else liftIO (threadDelay 1000) *> withLockBlock l n a m 

getLock :: MonadState Lock m => m Lock 
getLock = do 
        get 

printLocks :: Lock -> IO ()
printLocks l = print =<< readTVarIO (unLock l)

mkKey :: (Show a, Show b) => a -> b -> Int 
mkKey m a = hashWithSalt (hash $ show m) (show a) 


class HasLock b where 
    lockLens :: Lens (Snaplet b) (Snaplet Lock)

initLock :: SnapletInit b Lock 
initLock = makeSnaplet "Lock" "lock snaplet" Nothing $ do 
        s <- liftIO $ newTVarIO mempty
        return $ Lock s 


testb = mkKey "personnel" 1 
testc = mkKey "personnel" 1 
