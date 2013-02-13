module Data.ConduitTransformer where 
{-- 
- Package for transforming conduits to enumerators and back.
- Needed for cross compability between http-conduit and snap 
---}
import qualified Data.Conduit as C
import qualified Data.Conduit.List as C
import qualified Data.Enumerator as E 
import Control.Monad 
import Control.Monad.Trans 

import Control.Concurrent 
import Control.Concurrent.STM 


readChannel :: MonadIO m => TQueue (Maybe [a]) -> m (Maybe [a])
readChannel = liftIO . atomically . readTQueue 

writeChannel :: MonadIO m => TQueue (Maybe [a]) -> Maybe [a] -> m ()
writeChannel n = liftIO . atomically . writeTQueue n  

-- Producer / Source 
tqueueEnumerator :: TQueue (Maybe [a]) -> E.Enumerator a IO b 
tqueueEnumerator n f = do 
            p <- readChannel n
            case p of 
                Nothing -> case f of 
                             E.Continue g -> g E.EOF 
                             a -> E.returnI a 
                Just a -> case f of 
                            E.Continue g -> do 
                                step <- lift . E.runIteratee . g . E.Chunks $ a 
                                tqueueEnumerator n step 
                            a -> E.returnI a 


-- Consumer / Sink 
tqueueIterator :: TQueue (Maybe [a]) -> E.Iteratee a IO ()
tqueueIterator f = E.continue go 
        where go (E.Chunks xs) = do 
                        writeChannel f (Just xs) 
                        E.continue go 
              go E.EOF = writeChannel f Nothing >> E.yield () E.EOF 



tqueueSource :: Show a => TQueue (Maybe [a]) -> C.Source IO a 
tqueueSource n = do 
            s <- readChannel n
            case s of 
                Nothing -> return () 
                Just xs -> mapM_ C.yield xs >> tqueueSource n 


tqueueSink :: TQueue (Maybe [a]) -> C.Sink a IO ()
tqueueSink n = do 
            xs <- C.head 
            case xs of 
                Nothing -> writeChannel n (Nothing)
                Just xs -> writeChannel n (Just [xs]) >> tqueueSink n 

-- push the source to a sink 
--
-- sink send to channel 
--
-- channel is read by an enumerator 
--
--      feed to an iterator  
--
--
conduitToEnumeratorSource :: C.Source IO a -> IO (E.Enumerator a IO ())
conduitToEnumeratorSource f = do 
                        x <- newTQueueIO 
                        forkIO $ f C.$$ tqueueSink x 
                        return (tqueueEnumerator x)

-- This is the dual operation 


-- feed the enumerator  
--              
--              to an iterator  
--
-- iterator send to channel 
--
-- channel is read by an source 
--
enumeratorToConduitSource :: Show a => E.Enumerator a IO () -> IO (C.Source IO a)
enumeratorToConduitSource f = do 
                        x <- newTQueueIO 
                        forkIO $ void $ E.run $ f E.$$ tqueueIterator x 
                        return (tqueueSource x) 


testCtoE :: Show a => E.Enumerator a IO () -> IO ()
testCtoE n = do 
        x <- enumeratorToConduitSource n 
        x C.$$ C.mapM_ print 

testEtoC :: Show a => C.Source IO a -> IO ()
testEtoC n = do 
        x <- (conduitToEnumeratorSource n)
        E.run_ $ x E.$$ E.printChunks True  


forkBoth m a  = do
            x <- newEmptyMVar 
            forkIO $ do 
                m
                putMVar x ()
            forkIO $ a
            takeMVar x 

testTqueueSink = do 
            x <- newTQueueIO 
            let m = do 
                s <- readChannel x
                case s of
                    Nothing -> return ()
                    Just xs -> print xs >> m 
            let a = do 
                C.sourceList [1..10] C.$$ tqueueSink x 
            forkBoth m a

testTqueueSource = do 
            x <- newTQueueIO 
            let m = do 
                forM_ [1..10] $ \l -> writeChannel x (Just [l])
            let a = do 
                n <- tqueueSource x C.$$  C.mapM_ (print . ("got value: " ++) . show)
                return ()
            forkBoth m a 
                

testTqueueEnumerator = do
        x <- newTQueueIO 
        let m = do 
            forM_ [1..10] $ \l -> writeChannel x (Just [l]) 
        let a = do 
            E.run_ $ tqueueEnumerator x E.$$ E.printChunks True 
        forkBoth m a 

testTqueueIterator = do 
        x <- newTQueueIO
        let m = do 
            p <- readChannel x
            case p of 
                Nothing -> return ()
                Just xs -> print xs >> m 
        let a = do
            E.run_ $ E.enumList 1 [1..10] E.$$ tqueueIterator x 
        forkBoth m a 
        
