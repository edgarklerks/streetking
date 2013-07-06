-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Data.TimedMap

Synopsis

-   newtype [TimedMap](#t:TimedMap) k a = [TimedMap](#v:TimedMap) {
    -   [unTimeMap](#v:unTimeMap) :: TVar ([TMap](Data-TimedMap.html#t:TMap) k a)

    }
-   type [TimedMapRestore](#t:TimedMapRestore) k a = IO [(Int64, k, a)]
-   type [TimedMapStore](#t:TimedMapStore) k a = [(Int64, k, a)] -\> IO ()
-   newtype [TMap](#t:TMap) k a = [TMap](#v:TMap) {
    -   [unTMap](#v:unTMap) :: (Map k Int64, Map k a)

    }
-   [newTimedMap](#v:newTimedMap) :: Ord k =\> IO ([TimedMap](Data-TimedMap.html#t:TimedMap) k a)
-   [getTimeStamp](#v:getTimeStamp) :: IO Int64
-   [withNow0](#v:withNow0) :: (a -\> Int64 -\> IO b) -\> a -\> IO b
-   [withNow1](#v:withNow1) :: (a -\> Int64 -\> b -\> IO c) -\> a -\> b -\> IO c
-   [withNow2](#v:withNow2) :: (a -\> Int64 -\> b -\> c -\> IO d) -\> a -\> b -\> c -\> IO d
-   [withNow3](#v:withNow3) :: (a -\> Int64 -\> b -\> c -\> d -\> IO e) -\> a -\> b -\> c -\> d -\> IO e
-   [lookup](#v:lookup) :: Ord k =\> [TimedMap](Data-TimedMap.html#t:TimedMap) k a -\> k -\> STM (Maybe a)
-   [lookupTime](#v:lookupTime) :: Ord k =\> [TimedMap](Data-TimedMap.html#t:TimedMap) k a -\> k -\> STM (Maybe Int64)
-   [lookupBoth'](#v:lookupBoth-39-) :: Ord k =\> [TimedMap](Data-TimedMap.html#t:TimedMap) k a -\> k -\> STM (Maybe (Int64, a))
-   [tupleMaybe](#v:tupleMaybe) :: (Maybe Int64, Maybe b) -\> Maybe (Int64, b)
-   [lookupBoth](#v:lookupBoth) :: Ord k =\> [TimedMap](Data-TimedMap.html#t:TimedMap) k a -\> k -\> STM (Maybe Int64, Maybe a)
-   [insert](#v:insert) :: Ord k =\> [TimedMap](Data-TimedMap.html#t:TimedMap) k a -\> Int64 -\> k -\> a -\> STM ()
-   [cleanup](#v:cleanup) :: Ord k =\> [TimedMap](Data-TimedMap.html#t:TimedMap) k a -\> Int64 -\> STM ()
-   [updateTime](#v:updateTime) :: Ord k =\> [TimedMap](Data-TimedMap.html#t:TimedMap) k a -\> Int64 -\> k -\> STM ()
-   [delete](#v:delete) :: Ord k =\> [TimedMap](Data-TimedMap.html#t:TimedMap) k a -\> k -\> STM ()
-   [tlookup](#v:tlookup) :: Ord k =\> [TMap](Data-TimedMap.html#t:TMap) k a -\> k -\> Maybe a
-   [tlookupTime](#v:tlookupTime) :: Ord k =\> [TMap](Data-TimedMap.html#t:TMap) k a -\> k -\> Maybe Int64
-   [tlookupBoth](#v:tlookupBoth) :: Ord k =\> [TMap](Data-TimedMap.html#t:TMap) k a -\> k -\> (Maybe Int64, Maybe a)
-   [tinsert](#v:tinsert) :: Ord k =\> [TMap](Data-TimedMap.html#t:TMap) k a -\> Int64 -\> k -\> a -\> [TMap](Data-TimedMap.html#t:TMap) k a
-   [tupdateTime](#v:tupdateTime) :: Ord k =\> [TMap](Data-TimedMap.html#t:TMap) k a -\> Int64 -\> k -\> [TMap](Data-TimedMap.html#t:TMap) k a
-   [tcleanup](#v:tcleanup) :: Ord k =\> [TMap](Data-TimedMap.html#t:TMap) k a -\> Int64 -\> [TMap](Data-TimedMap.html#t:TMap) k a
-   [tremove](#v:tremove) :: Ord a =\> Int64 -\> Map a Int64 -\> (Map a Int64, [a])
-   [tdelete](#v:tdelete) :: Ord k =\> [TMap](Data-TimedMap.html#t:TMap) k a -\> k -\> [TMap](Data-TimedMap.html#t:TMap) k a
-   [storeTimedMap](#v:storeTimedMap) :: Ord k =\> [TimedMapStore](Data-TimedMap.html#t:TimedMapStore) k a -\> [TimedMap](Data-TimedMap.html#t:TimedMap) k a -\> IO ()
-   [restoreTimedMap](#v:restoreTimedMap) :: Ord k =\> [TimedMap](Data-TimedMap.html#t:TimedMap) k a -\> [TimedMapRestore](Data-TimedMap.html#t:TimedMapRestore) k a -\> IO ()
-   [storeTMap](#v:storeTMap) :: Ord k =\> [TimedMapStore](Data-TimedMap.html#t:TimedMapStore) k a -\> [TMap](Data-TimedMap.html#t:TMap) k a -\> IO ()
-   [restoreTMap](#v:restoreTMap) :: Ord k =\> [TimedMapRestore](Data-TimedMap.html#t:TimedMapRestore) k a -\> IO ([TMap](Data-TimedMap.html#t:TMap) k a)

Documentation
=============

newtype TimedMap k a

Constructors

TimedMap

 

Fields

unTimeMap :: TVar ([TMap](Data-TimedMap.html#t:TMap) k a)  
 

type TimedMapRestore k a = IO [(Int64, k, a)]

type TimedMapStore k a = [(Int64, k, a)] -\> IO ()

newtype TMap k a

Constructors

TMap

 

Fields

unTMap :: (Map k Int64, Map k a)  
 

Instances

||
|(Show k, Show a) =\> Show ([TMap](Data-TimedMap.html#t:TMap) k a)| |

newTimedMap :: Ord k =\> IO ([TimedMap](Data-TimedMap.html#t:TimedMap) k a)

creates a new timed map

getTimeStamp :: IO Int64

Helper function, gets a time stamp as a 64 bits integer

withNow0 :: (a -\> Int64 -\> IO b) -\> a -\> IO b

Some helper functions to work with the now

withNow1 :: (a -\> Int64 -\> b -\> IO c) -\> a -\> b -\> IO c

withNow2 :: (a -\> Int64 -\> b -\> c -\> IO d) -\> a -\> b -\> c -\> IO d

withNow3 :: (a -\> Int64 -\> b -\> c -\> d -\> IO e) -\> a -\> b -\> c -\> d -\> IO e

lookup :: Ord k =\> [TimedMap](Data-TimedMap.html#t:TimedMap) k a -\> k -\> STM (Maybe a)

Lookup a value from a TimedMap

lookupTime :: Ord k =\> [TimedMap](Data-TimedMap.html#t:TimedMap) k a -\> k -\> STM (Maybe Int64)

Lookup a time from a TimedMap

lookupBoth' :: Ord k =\> [TimedMap](Data-TimedMap.html#t:TimedMap) k a -\> k -\> STM (Maybe (Int64, a))

Lookup a time and other value from a TimedMap

tupleMaybe :: (Maybe Int64, Maybe b) -\> Maybe (Int64, b)

lookupBoth :: Ord k =\> [TimedMap](Data-TimedMap.html#t:TimedMap) k a -\> k -\> STM (Maybe Int64, Maybe a)

Lookup a time and other value from a TimedMap

insert :: Ord k =\> [TimedMap](Data-TimedMap.html#t:TimedMap) k a -\> Int64 -\> k -\> a -\> STM ()

Insert a value in a TimedMap

cleanup :: Ord k =\> [TimedMap](Data-TimedMap.html#t:TimedMap) k a -\> Int64 -\> STM ()

Cleanup old variables from a TimedMap, the expiration time is given

updateTime :: Ord k =\> [TimedMap](Data-TimedMap.html#t:TimedMap) k a -\> Int64 -\> k -\> STM ()

Update the time from a key

delete :: Ord k =\> [TimedMap](Data-TimedMap.html#t:TimedMap) k a -\> k -\> STM ()

Delete a key from a TimedMap

tlookup :: Ord k =\> [TMap](Data-TimedMap.html#t:TMap) k a -\> k -\> Maybe a

tlookupTime :: Ord k =\> [TMap](Data-TimedMap.html#t:TMap) k a -\> k -\> Maybe Int64

tlookupBoth :: Ord k =\> [TMap](Data-TimedMap.html#t:TMap) k a -\> k -\> (Maybe Int64, Maybe a)

tinsert :: Ord k =\> [TMap](Data-TimedMap.html#t:TMap) k a -\> Int64 -\> k -\> a -\> [TMap](Data-TimedMap.html#t:TMap) k a

tupdateTime :: Ord k =\> [TMap](Data-TimedMap.html#t:TMap) k a -\> Int64 -\> k -\> [TMap](Data-TimedMap.html#t:TMap) k a

tcleanup :: Ord k =\> [TMap](Data-TimedMap.html#t:TMap) k a -\> Int64 -\> [TMap](Data-TimedMap.html#t:TMap) k a

tremove :: Ord a =\> Int64 -\> Map a Int64 -\> (Map a Int64, [a])

tdelete :: Ord k =\> [TMap](Data-TimedMap.html#t:TMap) k a -\> k -\> [TMap](Data-TimedMap.html#t:TMap) k a

storeTimedMap :: Ord k =\> [TimedMapStore](Data-TimedMap.html#t:TimedMapStore) k a -\> [TimedMap](Data-TimedMap.html#t:TimedMap) k a -\> IO ()

restoreTimedMap :: Ord k =\> [TimedMap](Data-TimedMap.html#t:TimedMap) k a -\> [TimedMapRestore](Data-TimedMap.html#t:TimedMapRestore) k a -\> IO ()

This is not an atomically safe action! Restores the map with the given handler. An insert to the map will be overwritten

storeTMap :: Ord k =\> [TimedMapStore](Data-TimedMap.html#t:TimedMapStore) k a -\> [TMap](Data-TimedMap.html#t:TMap) k a -\> IO ()

restoreTMap :: Ord k =\> [TimedMapRestore](Data-TimedMap.html#t:TimedMapRestore) k a -\> IO ([TMap](Data-TimedMap.html#t:TMap) k a)

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
