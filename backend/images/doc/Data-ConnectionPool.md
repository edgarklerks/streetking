-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Data.ConnectionPool

Description

Connection pool used for sharing database connections between threads

Synopsis

-   [c](#v:c) :: IO [Connection](Data-SqlTransaction.html#t:Connection)
-   [happyTest](#v:happyTest) :: IO ()
-   type [Pointer](#t:Pointer) = Int
-   newtype [ConnectionContext](#t:ConnectionContext) = [ConnectionContext](#v:ConnectionContext) {
    -   [unConnectionContext](#v:unConnectionContext) :: (Int, [Connection](Data-SqlTransaction.html#t:Connection))

    }
-   data [ConnectionBucket](#t:ConnectionBucket)
    -   = [Empty](#v:Empty) [Connection](Data-SqlTransaction.html#t:Connection) Int
    -   | [Filled](#v:Filled) [Connection](Data-SqlTransaction.html#t:Connection)

-   newtype [ConnectionPool](#t:ConnectionPool) = [ConnectionPool](#v:ConnectionPool) {
    -   [unConnectionPool](#v:unConnectionPool) :: (TQueue [Pointer](Data-ConnectionPool.html#t:Pointer), TArray Int [ConnectionBucket](Data-ConnectionPool.html#t:ConnectionBucket))

    }
-   [initConnectionPool](#v:initConnectionPool) :: Int -\> IO [Connection](Data-SqlTransaction.html#t:Connection) -\> IO [ConnectionPool](Data-ConnectionPool.html#t:ConnectionPool)
-   [emptyConnectionBucket](#v:emptyConnectionBucket) :: [ConnectionPool](Data-ConnectionPool.html#t:ConnectionPool) -\> Int -\> Int -\> STM ()
-   [fillConnectionBucket](#v:fillConnectionBucket) :: [ConnectionPool](Data-ConnectionPool.html#t:ConnectionPool) -\> Int -\> STM ()
-   [reviveConnection](#v:reviveConnection) :: [ConnectionPool](Data-ConnectionPool.html#t:ConnectionPool) -\> [ConnectionContext](Data-ConnectionPool.html#t:ConnectionContext) -\> IO [ConnectionContext](Data-ConnectionPool.html#t:ConnectionContext)
-   [putConnection](#v:putConnection) :: [ConnectionPool](Data-ConnectionPool.html#t:ConnectionPool) -\> Int -\> [Connection](Data-SqlTransaction.html#t:Connection) -\> STM ()
-   [getConnection](#v:getConnection) :: [ConnectionPool](Data-ConnectionPool.html#t:ConnectionPool) -\> IO [ConnectionContext](Data-ConnectionPool.html#t:ConnectionContext)
-   [returnConnection](#v:returnConnection) :: [ConnectionPool](Data-ConnectionPool.html#t:ConnectionPool) -\> [ConnectionContext](Data-ConnectionPool.html#t:ConnectionContext) -\> IO ()
-   [unwrapContext](#v:unwrapContext) :: [ConnectionContext](Data-ConnectionPool.html#t:ConnectionContext) -\> [Connection](Data-SqlTransaction.html#t:Connection)
-   [unsafeGetConnection](#v:unsafeGetConnection) :: [ConnectionPool](Data-ConnectionPool.html#t:ConnectionPool) -\> Int -\> STM [ConnectionContext](Data-ConnectionPool.html#t:ConnectionContext)
-   [initConnectionReclaimer](#v:initConnectionReclaimer) :: [ConnectionPool](Data-ConnectionPool.html#t:ConnectionPool) -\> Int -\> IO ThreadId

Documentation
=============

c :: IO [Connection](Data-SqlTransaction.html#t:Connection)

happyTest :: IO ()

type Pointer = Int

newtype ConnectionContext

A connection context is a numbered connection

Constructors

ConnectionContext

 

Fields

unConnectionContext :: (Int, [Connection](Data-SqlTransaction.html#t:Connection))  
 

data ConnectionBucket

A connection bucket can be empty or full If it is empty, it remembers it's connection number

Constructors

||
|Empty [Connection](Data-SqlTransaction.html#t:Connection) Int| |
|Filled [Connection](Data-SqlTransaction.html#t:Connection)| |

Instances

Show [ConnectionBucket](Data-ConnectionPool.html#t:ConnectionBucket)

Show instance for debugging

newtype ConnectionPool

The pool is a ring of unused connections and an array of buckets

Constructors

ConnectionPool

 

Fields

unConnectionPool :: (TQueue [Pointer](Data-ConnectionPool.html#t:Pointer), TArray Int [ConnectionBucket](Data-ConnectionPool.html#t:ConnectionBucket))  
 

initConnectionPool :: Int -\> IO [Connection](Data-SqlTransaction.html#t:Connection) -\> IO [ConnectionPool](Data-ConnectionPool.html#t:ConnectionPool)

Startup n connections

emptyConnectionBucket :: [ConnectionPool](Data-ConnectionPool.html#t:ConnectionPool) -\> Int -\> Int -\> STM ()

Empty a connection bucket

fillConnectionBucket :: [ConnectionPool](Data-ConnectionPool.html#t:ConnectionPool) -\> Int -\> STM ()

fill a connection bucket

reviveConnection :: [ConnectionPool](Data-ConnectionPool.html#t:ConnectionPool) -\> [ConnectionContext](Data-ConnectionPool.html#t:ConnectionContext) -\> IO [ConnectionContext](Data-ConnectionPool.html#t:ConnectionContext)

revive a connection (if it is dead)

putConnection :: [ConnectionPool](Data-ConnectionPool.html#t:ConnectionPool) -\> Int -\> [Connection](Data-SqlTransaction.html#t:Connection) -\> STM ()

Put a connection back into the pool

getConnection :: [ConnectionPool](Data-ConnectionPool.html#t:ConnectionPool) -\> IO [ConnectionContext](Data-ConnectionPool.html#t:ConnectionContext)

Get a connection from the pool

returnConnection :: [ConnectionPool](Data-ConnectionPool.html#t:ConnectionPool) -\> [ConnectionContext](Data-ConnectionPool.html#t:ConnectionContext) -\> IO ()

Return a connection to the pool

unwrapContext :: [ConnectionContext](Data-ConnectionPool.html#t:ConnectionContext) -\> [Connection](Data-SqlTransaction.html#t:Connection)

Unwrap a connection

unsafeGetConnection :: [ConnectionPool](Data-ConnectionPool.html#t:ConnectionPool) -\> Int -\> STM [ConnectionContext](Data-ConnectionPool.html#t:ConnectionContext)

Unsafely get a connection from the pool

initConnectionReclaimer :: [ConnectionPool](Data-ConnectionPool.html#t:ConnectionPool) -\> Int -\> IO ThreadId

This should reclaim a connection after n seconds, but is not yet implemented

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
