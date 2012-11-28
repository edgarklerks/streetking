{-# LANGUAGE OverloadedStrings, FlexibleContexts #-}
module LockSnaplet (
        initLock,
        withLockBlock,
        withLockNonBlock,
        Lock,
        getLock,
        HasLock(..)
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

withLockNonBlock :: (MonadIO m, Applicative m, Hashable a) => Lock -> String -> a -> m () -> m ()
withLockNonBlock l n a m = do 
            b <- setLockBlock l n a 
            if b 
                then m <* removeLock l n a 
                else return ()

withLockBlock :: (MonadIO m, Applicative m, Hashable a) => Lock -> String -> a -> m b -> m b 
withLockBlock l n a m = do 
            b <- setLockBlock l n a 
            if b 
                then m <* removeLock l n a 
                else liftIO (threadDelay 1000) *> withLockBlock l n a m 

getLock :: MonadState Lock m => m Lock 
getLock = do 
        get 
            
mkKey m a = hashWithSalt (hash m) a 


class HasLock b where 
    lockLens :: Lens (Snaplet b) (Snaplet Lock)

initLock :: SnapletInit b Lock 
initLock = makeSnaplet "Lock" "lock snaplet" Nothing $ do 

        return $ Lock undefined 
