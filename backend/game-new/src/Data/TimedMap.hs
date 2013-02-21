module Data.TimedMap where


import                  Control.Concurrent.STM
import                  Control.Concurrent.STM.TVar
import                  Control.Monad
import                  Control.Applicative
import qualified        Data.Map as M
import                  Prelude hiding (lookup) 
import                  Data.Time.Clock.POSIX
import                  Data.Int
import qualified        Data.Foldable as F
import                  Data.Maybe

newtype TimedMap k a = TimedMap  {
                   unTimeMap :: TVar (TMap k a) 
                }
type TimedMapRestore k a = IO [(Int64, k, a)]
type TimedMapStore k a = [(Int64, k,  a)] -> IO ()

newtype TMap k a = TMap {
        unTMap :: (M.Map k Int64, M.Map k a)
    } deriving Show

-- | creates a new timed map 
newTimedMap :: Ord k => IO (TimedMap k a) 
newTimedMap = do 
            xs <- newTVarIO $ TMap (M.fromList [], M.fromList [])
            return $ TimedMap xs
-- | Helper function, gets a time stamp as a 64 bits  integer
getTimeStamp :: IO Int64
getTimeStamp = floor <$> getPOSIXTime

-- | Some helper functions to work with the now 
withNow0 :: (a -> Int64 -> IO b) -> a -> IO b 
withNow0 f xs = getTimeStamp >>= \x -> f xs x 

withNow1 :: (a -> Int64 -> b -> IO c) -> a -> b -> IO c
withNow1 f xs a =  getTimeStamp >>= \x -> f xs x a

withNow2 :: (a -> Int64 -> b -> c -> IO d) -> a -> b -> c -> IO d
withNow2 f xs a b =  getTimeStamp >>= \x -> f xs x a b  

withNow3 :: (a -> Int64 -> b -> c -> d -> IO e) -> a -> b -> c -> d -> IO e
withNow3 f xs a b c =  getTimeStamp >>= \x -> f xs x a b c
            
-- | Lookup a value from a TimedMap
lookup :: Ord k => TimedMap k a -> k -> STM (Maybe a)
lookup xs y = do     
                    x <- readTVar (unTimeMap xs)
                    return (tlookup x y)
-- | Lookup a time from a TimedMap
lookupTime :: Ord k => TimedMap k a -> k -> STM (Maybe Int64)
lookupTime xs y = do     
                    x <- readTVar (unTimeMap xs)
                    return (tlookupTime x y)
              

-- | Lookup a time and other value from a TimedMap
lookupBoth' :: Ord k => TimedMap k a -> k -> STM (Maybe (Int64, a))
lookupBoth' xs y = do     
                    x <- readTVar (unTimeMap xs)
                    return (tupleMaybe (tlookupBoth x y))
			  
tupleMaybe :: (Maybe Int64, Maybe b) -> Maybe (Int64,b)
tupleMaybe (Just x, Just y) = Just (x,y)
tupleMaybe (Nothing , Just y) = Nothing  
tupleMaybe (Just x, Nothing ) = Nothing  
tupleMaybe (Nothing, Nothing ) =Nothing  
			  
-- | Lookup a time and other value from a TimedMap
lookupBoth :: Ord k => TimedMap k a -> k -> STM (Maybe Int64 , Maybe a )
lookupBoth xs y = do     
                    x <- readTVar (unTimeMap xs)
                    return (tlookupBoth x y)

-- | Insert a value in a TimedMap 
insert :: Ord k => TimedMap k a -> Int64 -> k -> a -> STM ()
insert xs e x a = do 
                    xs' <- readTVar (unTimeMap xs)
                    writeTVar (unTimeMap xs) (tinsert xs' e x a)

-- | Cleanup old variables from a TimedMap, the expiration time is given  
cleanup :: Ord k => TimedMap k a -> Int64 -> STM ()
cleanup xs e = do 
                    xs' <- readTVar (unTimeMap xs)
                    writeTVar (unTimeMap xs) (tcleanup xs' e) 

-- | Update the time from a key 
updateTime :: Ord k => TimedMap k a -> Int64 -> k -> STM ()
updateTime xs e k = do 
                xs' <- readTVar (unTimeMap xs)
                writeTVar (unTimeMap xs) (tupdateTime xs' e k)

-- | Delete a key from a TimedMap
delete :: Ord k => TimedMap k a -> k -> STM ()
delete xs k =  do 
                xs' <- readTVar (unTimeMap xs)
                writeTVar (unTimeMap xs) (tdelete xs' k) 

tlookup :: Ord k => TMap k a -> k -> Maybe a 
tlookup m k = M.lookup k . snd . unTMap  $ m

tlookupTime :: Ord k => TMap k a -> k -> Maybe Int64 
tlookupTime m k = M.lookup k . fst . unTMap  $ m


tlookupBoth :: Ord k => TMap k a -> k -> (Maybe Int64 , Maybe a )
tlookupBoth m k = (lp, mp)
    where unmap = unTMap m 
          mp = M.lookup k (snd unmap)
          lp = M.lookup k (fst unmap)

tinsert :: Ord k => TMap k a -> Int64 -> k -> a -> TMap k a
tinsert m e k v = TMap (lp, mp)
        where unmap = unTMap m 
              mp = M.insert k v (snd unmap) 
              lp = M.insert k e (fst unmap)

tupdateTime :: Ord k => TMap k a -> Int64 -> k -> TMap k a
tupdateTime m e k = TMap (lp, mp)
            where mp = (snd unmap)
                  lp = M.insert k e (fst unmap)
                  unmap = unTMap m 

tcleanup :: Ord k => TMap k a -> Int64 -> TMap k a 
tcleanup xs e = TMap (nm, mp) 
    where (nm, rm) = tremove e (fst unmap) 
          mp = foldr (\x z -> M.delete x z) (snd unmap) rm
          unmap = unTMap xs

tremove :: Ord a => Int64 -> M.Map a Int64 -> (M.Map a Int64, [a])    
tremove e = M.foldrWithKey step (M.empty, [])
        where step k a (b,xs) | e <= a  = (M.insert k a b, xs)
                              | otherwise = (b, k:xs)

tdelete :: Ord k => TMap k a -> k -> TMap k a 
tdelete xs k = TMap (nw, rm)
        where unmap = unTMap xs
              nw = fst unmap 
              rm = M.delete k (snd unmap)

storeTimedMap :: Ord k => TimedMapStore k a -> TimedMap k a -> IO ()
storeTimedMap f tm = do t <- readTVarIO (unTimeMap tm)
                        storeTMap f t 

-- | This is not an atomically safe action! Restores the map with the given handler.
-- An insert to the map will be overwritten 
restoreTimedMap :: Ord k => TimedMap k a -> TimedMapRestore k a -> IO () 
restoreTimedMap k f =   atomically . writeTVar (unTimeMap k)  =<< restoreTMap f

-- | 
storeTMap :: Ord k => TimedMapStore k a -> TMap k a -> IO ()
storeTMap f tm = f [ (e,k,fromJust $ M.lookup k ys ) | (k,e) <- M.toList xs,  M.member k ys]
    where (xs, ys) = unTMap tm

restoreTMap :: Ord k => TimedMapRestore k a -> IO (TMap k a) 
restoreTMap f = (\xs -> TMap $ foldr step (M.empty, M.empty) xs) <$> f
        where step (e,k,a) (ek,ka) = (M.insert k e ek, M.insert k a ka)



