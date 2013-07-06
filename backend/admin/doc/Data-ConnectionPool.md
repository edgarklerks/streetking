-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Data.ConnectionPool

Documentation
=============

c :: IO [Connection](Data-SqlTransaction.html#t:Connection)

happyTest :: IO ()

type Pointer = Int

newtype ConnectionContext

Constructors

ConnectionContext

 

Fields

unConnectionContext :: (Int, [Connection](Data-SqlTransaction.html#t:Connection))  
 

data ConnectionBucket

Constructors

||
|Empty [Connection](Data-SqlTransaction.html#t:Connection) Int| |
|Filled [Connection](Data-SqlTransaction.html#t:Connection)| |

Instances

||
|Show [ConnectionBucket](Data-ConnectionPool.html#t:ConnectionBucket)| |

newtype ConnectionPool

Constructors

ConnectionPool

 

Fields

unConnectionPool :: (TQueue [Pointer](Data-ConnectionPool.html#t:Pointer), TArray Int [ConnectionBucket](Data-ConnectionPool.html#t:ConnectionBucket))  
 

initConnectionPool :: Int -\> IO [Connection](Data-SqlTransaction.html#t:Connection) -\> IO [ConnectionPool](Data-ConnectionPool.html#t:ConnectionPool)

emptyConnectionBucket :: [ConnectionPool](Data-ConnectionPool.html#t:ConnectionPool) -\> Int -\> Int -\> STM ()

fillConnectionBucket :: [ConnectionPool](Data-ConnectionPool.html#t:ConnectionPool) -\> Int -\> STM ()

reviveConnection :: [ConnectionPool](Data-ConnectionPool.html#t:ConnectionPool) -\> [ConnectionContext](Data-ConnectionPool.html#t:ConnectionContext) -\> IO [ConnectionContext](Data-ConnectionPool.html#t:ConnectionContext)

putConnection :: [ConnectionPool](Data-ConnectionPool.html#t:ConnectionPool) -\> Int -\> [Connection](Data-SqlTransaction.html#t:Connection) -\> STM ()

getConnection :: [ConnectionPool](Data-ConnectionPool.html#t:ConnectionPool) -\> IO [ConnectionContext](Data-ConnectionPool.html#t:ConnectionContext)

returnConnection :: [ConnectionPool](Data-ConnectionPool.html#t:ConnectionPool) -\> [ConnectionContext](Data-ConnectionPool.html#t:ConnectionContext) -\> IO ()

unwrapContext :: [ConnectionContext](Data-ConnectionPool.html#t:ConnectionContext) -\> [Connection](Data-SqlTransaction.html#t:Connection)

unsafeGetConnection :: [ConnectionPool](Data-ConnectionPool.html#t:ConnectionPool) -\> Int -\> STM [ConnectionContext](Data-ConnectionPool.html#t:ConnectionContext)

initConnectionReclaimer :: [ConnectionPool](Data-ConnectionPool.html#t:ConnectionPool) -\> Int -\> IO ThreadId

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
