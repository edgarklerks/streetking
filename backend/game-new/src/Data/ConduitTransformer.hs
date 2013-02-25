{-# LANGUAGE ViewPatterns, DoRec #-}
module Data.ConduitTransformer (
        conduitToEnumeratorSource,
        enumeratorToConduitSource
    ) where 

{-- 
- Package for transforming conduits to enumerators and back.
- Needed for cross compability between http-conduit and snap 
---}


import qualified Data.Conduit as C
import qualified Data.Conduit.List as C
import qualified Data.Enumerator as E 
import Control.Applicative
import Control.Monad 
import Control.Monad.Fix 
import Control.Monad.Trans 
import qualified Data.Sequence as S 
import qualified Data.Foldable as F 

import Control.Concurrent 
import Control.Concurrent.STM 
import System.IO
import System.IO.Unsafe



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



{-- 
-   Some simple tests of utilities above
-   There is error handling missing. Pipes can hang forever... 
-   This is kinda bad. DISREGARD THAT, I SUCK COCKS.  
-
- --}

testCtoE :: Show a => E.Enumerator a IO () -> IO ()
testCtoE n = do 
        x <- enumeratorToConduitSource n 
        x C.$$ C.mapM_ print 

testEtoC :: Show a => C.Source IO a -> IO ()
testEtoC n = do 
        x <- (conduitToEnumeratorSource n)
        E.run_ $ x E.$$ E.printChunks True  


newtype ThreadList a = ThreadList {
        unThreadList :: [(ThreadId, MVar a)]
    }



forkMany :: [IO a] -> IO (ThreadList a)
forkMany xs = ThreadList <$> (forM xs $ \x -> do 
                    m <- newEmptyMVar 
                    id <- forkIO $ do 
                            a <- x 
                            putMVar m a
                    return (id, m)

            )

joinMany :: ThreadList a -> IO [a]
joinMany (ThreadList xs) = forM xs $ \(_,m) -> readMVar m 


joinManyPar :: ThreadList a -> IO [a]
joinManyPar (ThreadList xs) = cataM xs $ \a -> (threadDelay 1000 *> (tryTakeMVar . snd) a)

(%>) :: Applicative m => m t -> (a -> m b) -> (a -> m b)
(%>) m s a = m *> s a 

-- cataM :: Monad m => [a] -> (a -> m (Maybe b)) -> m [b]
cataM (S.fromList -> xs) f = cataM' xs 
        where cataM' (S.viewl -> S.EmptyL) = return []
              cataM' (S.viewl -> (x S.:< xs)) = do 
                                                c <- f x 
                                                case c of 
                                                    Nothing -> cataM' (xs S.|> x)
                                                    Just b -> do 
                                                        rest <- cataM' xs
                                                        return (b : rest)

                                                    
 

testForkMany = do 
           ps <- forkMany $ (\x -> return $ (fix $ \f x -> if x < 2 then x else f (x `div` 2)) x) `fmap` [1..1000]
           joinManyPar ps 

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
                      

{-- Strangely useless data structure, but possible --}

-- Ignore it 
data DCL a = NodeD a (MVar (DCL a)) (MVar (DCL a))


single :: a -> IO (DCL a) 
single a = do
        rec 
            p <- newMVar (NodeD a p p)
        readMVar p 


two :: a -> a -> IO (DCL a) 
two a b = do 
    rec 
        p <- newMVar (NodeD a q q)
        q <- newMVar (NodeD b p p)
    readMVar p 

three :: a -> a -> a -> IO (DCL a)
three a b c = do 
    rec 
        p <- newMVar (NodeD a r q)
        q <- newMVar (NodeD b p r)
        r <- newMVar (NodeD c q p)
    readMVar p 

fromList :: Show a => [a] -> IO (DCL a)
fromList (x:xs) = do 
       rec 
           f <- newMVar (NodeD x l undefined)
           print "First node created"
           l <- foldM step f xs 
           (NodeD u v _) <- takeMVar l 
       putMVar l (NodeD u v f)
       readMVar f 
    where step z x = do 
                s <- newMVar (NodeD x z undefined)
                print $ "Node : " ++ (show x)
                (NodeD t p _) <- takeMVar z 
                putMVar z (NodeD t p s)
                return s 
        
nextNode :: DCL a -> IO (DCL a)
nextNode (NodeD _ _ p) = readMVar p 

prevNode :: DCL a -> IO (DCL a)
prevNode (NodeD _ p _) = readMVar p 



toListF :: Int -> DCL a -> IO [a] 
toListF 0 _ = return []
toListF n (NodeD a p q) = do 
                    s <- readMVar q
                    rest <- toListF (n - 1) s
                    return (a : rest)
toListB :: Int -> DCL a -> IO [a] 
toListB 0 _ = return []
toListB n (NodeD a p q) = do 
                    s <- readMVar p 
                    rest <- toListB (n - 1) s
                    return (a : rest)



