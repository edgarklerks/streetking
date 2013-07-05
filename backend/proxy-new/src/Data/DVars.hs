{-# LANGUAGE MultiParamTypeClasses, FlexibleInstances,FunctionalDependencies, UndecidableInstances, OverlappingInstances #-} 
-- | Generalization of concurrent variables 
-- | Handles mvars, tvars, tqueue, tchan, chan, tmvars, IOvar  
module Data.DVars where 

import Control.Applicative
import Control.Monad
import Control.Monad.STM 
import Control.Concurrent
import Control.Concurrent.STM 
import Control.Monad.Trans 
import Control.Monad.State 
import Control.Monad.Reader 
import Data.IORef 


class RunDVar m t where 
    -- | Run a dvar in a monad 
    runDVar :: t a -> m a

class ReadDVar t f where 
    -- | Read a dvar (blocks when empty) 
    readDVar :: f a -> t a

class PutDVar t f where 
    -- | Put a dvar (blocks when full)
    putDVar :: f a -> a -> t () 

class WriteDVar t f where 
    -- | Write a dvar (doesn't block when full)
    writeDVar :: f a ->  a -> t ()

class SwapDVar t f where 
    -- | Swap a dvar (blocks when empty)
    swapDVar :: f a -> a -> t a 

class CreateDVar t f where  
    -- | Initiate a new dvar 
    newDVar :: a -> t (f a)
   
class EmptyDVar t f where 
    -- | Initiate a new empty dvar 
    newEmptyDVar :: t (f a)

class TryTakeDVar t f where 
    -- | Read a dvar, doesn't block when empty 
    tryTakeDVar :: f a -> t (Maybe a)



class TakeDVar t f where 
    -- | Read a dvar, makes it empty when succeed 
    takeDVar :: f a -> t a 
class ModifyDVar t f where 
    -- | Change a dvar, blocks when empty 
    modifyDVar :: f a -> (a -> a) -> t () 

-- | Reader like monad  
class (Monad m) => MonadGetter m s | m -> s where 
        getter :: (s -> a) -> m a
        getterM :: (s -> m a) -> m a
        getterM f = do 
            s <- getter f
            s

{-- Run instances --}

instance RunDVar STM STM where 
        runDVar = id 
instance MonadIO m => RunDVar m IO where 
        runDVar = liftIO 
instance MonadIO m => RunDVar m STM where 
        runDVar = liftIO . atomically 

{-- Read instances --}

{-- MVAR --}
instance MonadIO m => ReadDVar m MVar where 
        readDVar = runDVar . readMVar
{-- TVar --}
instance ReadDVar STM TVar where 
        readDVar = readTVar 
instance MonadIO m => ReadDVar m TVar where 
        readDVar = runDVar . readTVar  
{-- TMVar --}
instance ReadDVar STM TMVar where 
        readDVar = readTMVar 
instance MonadIO m => ReadDVar m TMVar where 
        readDVar = runDVar . readTMVar 

instance TryTakeDVar STM TMVar where 
        tryTakeDVar = tryTakeTMVar

instance MonadIO m => TryTakeDVar m MVar where 
        tryTakeDVar = runDVar . tryTakeMVar

{-- TChan --}
instance ReadDVar STM TChan where 
        readDVar = peekTChan
instance MonadIO m => ReadDVar m TChan where 
        readDVar = runDVar . peekTChan

{-- Write instances --}

instance (MonadIO m) => WriteDVar m MVar where 
        writeDVar m s = liftIO $ do 
                    x <- isEmptyMVar m
                    case x of 
                        True -> putMVar m s  
                        False -> void $ swapMVar m s  
instance (MonadIO m) => WriteDVar m TVar where 
        writeDVar m s = runDVar $ writeTVar m s 
instance WriteDVar STM TVar where 
        writeDVar m s = writeTVar m s  

instance WriteDVar STM TChan where 
        writeDVar m s = do 
                b <- isEmptyTChan m 
                case b of 
                    True -> writeTChan m s 
                    False -> readTChan m >> writeTChan m s 
instance (MonadIO m) => WriteDVar m TChan where 
        writeDVar m s = runDVar $ do 
                            b <- isEmptyTChan m
                            case b of 
                                True -> writeTChan m s 
                                False -> readTChan m >> writeTChan m s
instance WriteDVar STM TMVar where 
        writeDVar m s = do 
                b <- isEmptyTMVar m 
                case b of 
                    True -> putTMVar m s
                    False -> void $ swapTMVar m s 
instance (MonadIO m) => WriteDVar m TMVar where 
        writeDVar m s = runDVar $ do 
                b <- isEmptyTMVar m
                case b of 
                    True -> putTMVar m s
                    False -> void $ swapTMVar m s 

instance (MonadIO m) => WriteDVar m Chan where 
        writeDVar m s = runDVar $ do 
                b <- isEmptyChan m 
                case b of 
                    True -> writeChan m s 
                    False -> readChan m >> writeChan m s

instance (MonadIO m) => SwapDVar m MVar where 
                swapDVar m s = runDVar $ swapMVar m s  

instance SwapDVar STM TVar where 
                swapDVar m s = readTVar m <* writeTVar m s

instance (MonadIO m) => SwapDVar m TVar where 
                swapDVar m s = runDVar $ readTVar m <* writeTVar m s

instance SwapDVar STM TMVar where 
                swapDVar m s = swapTMVar m s
instance MonadIO m => SwapDVar m TMVar where 
                swapDVar m s = runDVar $ swapTMVar m s 
instance SwapDVar STM TChan where 
            swapDVar m s = readTChan m <* writeTChan m s
instance (MonadIO m) => SwapDVar m TChan where 
            swapDVar m s = runDVar $ readTChan m <* writeTChan m s
instance (MonadIO m) => SwapDVar m Chan where 
            swapDVar m s = runDVar $ readChan m <* writeChan m s


instance (MonadIO m) => PutDVar m MVar where 
            putDVar m s = runDVar $ putMVar m s

instance PutDVar STM TMVar where 
            putDVar m s = putTMVar m s
instance (MonadIO m) => PutDVar m TMVar where 
            putDVar m s = runDVar $ putTMVar m s 
instance PutDVar STM TChan where 
            putDVar m s = writeTChan m s
instance (MonadIO m) => PutDVar m TChan where 
            putDVar m s = runDVar $ writeTChan m s
instance (MonadIO m) => PutDVar m Chan where 
            putDVar m s = runDVar $ writeChan m s

instance (MonadIO m) => TakeDVar  m MVar where 
            takeDVar m = runDVar $ takeMVar m
instance TakeDVar STM TChan where 
            takeDVar m = readTChan m 
instance (MonadIO m) => TakeDVar m TChan where 
            takeDVar m = runDVar $ readTChan m 
instance (MonadIO m) => TakeDVar m Chan where 
            takeDVar = runDVar . readChan 
instance (MonadIO m) => TakeDVar m TMVar where 
            takeDVar = runDVar . takeTMVar
instance TakeDVar STM TMVar where 
            takeDVar = takeTMVar 

instance (MonadIO m) => CreateDVar m MVar where 
            newDVar a = runDVar $ newMVar a 
instance CreateDVar STM TVar where
            newDVar = newTVar
instance (MonadIO m) => CreateDVar m TVar where 
            newDVar = runDVar . newTVar 
instance CreateDVar STM TMVar where 
            newDVar = newTMVar 
instance (MonadIO m) => CreateDVar m TMVar where 
            newDVar = runDVar . newTMVar
            
instance (MonadIO m) => EmptyDVar m MVar where 
            newEmptyDVar = runDVar $ newEmptyMVar 
instance EmptyDVar STM TMVar where 
            newEmptyDVar = newEmptyTMVar
instance (MonadIO m) => EmptyDVar m TMVar where 
            newEmptyDVar = runDVar $ newEmptyTMVar
instance (MonadIO m) => EmptyDVar m Chan where 
            newEmptyDVar = runDVar $ newChan 
instance (MonadIO m) => EmptyDVar m TChan where 
            newEmptyDVar = runDVar $ newTChan 
instance EmptyDVar STM TChan where 
            newEmptyDVar = newTChan


instance (MonadIO m) => ModifyDVar m MVar where 
                modifyDVar m f = runDVar $ modifyMVar_ m (\x -> return (f x)) 
instance ModifyDVar STM TVar where 
                modifyDVar m f = modifyTVar m f
instance (MonadIO m) => ModifyDVar m TVar where 
                modifyDVar m f = runDVar $ modifyTVar m f

instance (MonadIO m) => ModifyDVar m TMVar where 
                modifyDVar m f = runDVar $ do 
                                    a <- takeTMVar m
                                    putTMVar m (f a)

instance ModifyDVar STM TMVar where 
                modifyDVar m f = do 
                            a <- takeTMVar m 
                            putTMVar m (f a)

instance (MonadIO m) => ReadDVar m IORef where 
                readDVar = runDVar . readIORef

instance (MonadIO m) => WriteDVar m IORef where 
                writeDVar m s = runDVar $ writeIORef m s

instance (MonadIO m) => CreateDVar m IORef where 
                newDVar = runDVar . newIORef

instance (MonadIO m) => ModifyDVar m IORef where 
                modifyDVar m f = runDVar $ atomicModifyIORef m (\x -> (f x,())) 


newtype IOVar a = IOVar {
                unIOVar :: IO (MVar a)
            }

instance (MonadIO m) => ReadDVar m IOVar where 
                readDVar m = runDVar $ do 
                                        mv <- unIOVar m 
                                        a <- readMVar mv
                                        return a

instance (MonadIO m) => WriteDVar m IOVar where 
                writeDVar m s = runDVar $ do 
                                        mv <- unIOVar m
                                        writeDVar mv s 
instance (MonadIO m) => CreateDVar m IOVar where 
            newDVar m = return $ IOVar (newMVar m)
instance (MonadIO m) => EmptyDVar m IOVar where 
            newEmptyDVar = return $ IOVar (newEmptyDVar)
instance (MonadIO m) => PutDVar m IOVar where 
            putDVar m s = runDVar $ do 
                                mv <- unIOVar m 
                                putDVar mv s
instance (MonadIO m) => TakeDVar m IOVar where 
            takeDVar m = runDVar $ do 
                                mv <- unIOVar m 
                                takeDVar mv 
instance (MonadIO m) => SwapDVar m IOVar where 
            swapDVar m s = runDVar $ do 
                                mv <- unIOVar m 
                                swapDVar m s

instance (MonadIO m) => ModifyDVar m IOVar where 
            modifyDVar m f = runDVar $ do 
                                mv <- unIOVar m 
                                modifyDVar mv f



instance Functor IOVar where 
        fmap f m = IOVar $ do 
                     mv <- unIOVar m
                     a <- readMVar mv 
                     newMVar (f a)

instance Applicative IOVar where 
        pure = return 
        (<*>) = ap 

instance Monad IOVar where 
        return = IOVar . newMVar 
        (>>=) m f = IOVar $ do 
                        mv <- unIOVar m
                        a <- readMVar mv 
                        unIOVar $ f a 
        (>>) m n = IOVar $ do 
                        _ <- unIOVar m
                        unIOVar n 

instance MonadIO IOVar where 
        liftIO m = IOVar $ do 
                        a <- m 
                        newMVar a

{-- TQUEUE --}


instance ReadDVar STM TQueue where 
        readDVar = peekTQueue
instance MonadIO m => ReadDVar m TQueue where 
        readDVar = runDVar . peekTQueue

instance (MonadIO m) => EmptyDVar m TQueue where 
            newEmptyDVar = runDVar $ newTQueue 
instance EmptyDVar STM TQueue where 
            newEmptyDVar = newTQueue

instance (MonadIO m) => SwapDVar m TQueue where 
            swapDVar m s = runDVar $ readTQueue m <* writeTQueue m s

instance SwapDVar STM TQueue where 
            swapDVar m s = readTQueue m <* writeTQueue m s

instance TakeDVar STM TQueue where 
            takeDVar m = readTQueue m 
instance (MonadIO m) => TakeDVar m TQueue where 
            takeDVar m = runDVar $ readTQueue m 


{-- Write instances --}

instance WriteDVar STM TQueue where 
        writeDVar m s = do 
                b <- isEmptyTQueue m 
                case b of 
                    True -> writeTQueue m s 
                    False -> readTQueue m >> writeTQueue m s 
instance (MonadIO m) => WriteDVar m TQueue where 
        writeDVar m s = runDVar $ do 
                            b <- isEmptyTQueue m
                            case b of 
                                True -> writeTQueue m s 
                                False -> readTQueue m >> writeTQueue m s
instance PutDVar STM TQueue where 
            putDVar m s = writeTQueue m s
instance (MonadIO m) => PutDVar m TQueue where 
            putDVar m s = runDVar $ writeTQueue m s

test :: Int -> IOVar Int
test x = do 
    p <- fmap (const 2) <$> liftIO $ print "hello world"
    liftIO (print "test")
    liftIO (print "woekoe")
    
    return (1 + p)
-- | Write a dvar (doesn't block) 
(=$) :: WriteDVar m f => f a -> a -> m ()
(=$) = writeDVar 

-- | Put a dvar (blocks)
(=|) :: PutDVar m f => f a -> a -> m ()
(=|) = putDVar 

-- | Change a dvar (blocks)
(=.) :: ModifyDVar m f => f a -> (a -> a) -> m ()
(=.) = modifyDVar 

infix 4 =|
infix 4 =.
infix 4 =$
