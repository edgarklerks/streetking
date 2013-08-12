===================
Data.ConnectionPool
===================

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Data.ConnectionPool

Description

Connection pool used for sharing database connections between threads

Synopsis

-  `c <#v:c>`__ :: IO
   `Connection <Data-SqlTransaction.html#t:Connection>`__
-  `happyTest <#v:happyTest>`__ :: IO ()
-  type `Pointer <#t:Pointer>`__ = Int
-  newtype `ConnectionContext <#t:ConnectionContext>`__ =
   `ConnectionContext <#v:ConnectionContext>`__ {

   -  `unConnectionContext <#v:unConnectionContext>`__ :: (Int,
      `Connection <Data-SqlTransaction.html#t:Connection>`__)

   }
-  data `ConnectionBucket <#t:ConnectionBucket>`__

   -  = `Empty <#v:Empty>`__
      `Connection <Data-SqlTransaction.html#t:Connection>`__ Int
   -  \| `Filled <#v:Filled>`__
      `Connection <Data-SqlTransaction.html#t:Connection>`__

-  newtype `ConnectionPool <#t:ConnectionPool>`__ =
   `ConnectionPool <#v:ConnectionPool>`__ {

   -  `unConnectionPool <#v:unConnectionPool>`__ :: (TQueue
      `Pointer <Data-ConnectionPool.html#t:Pointer>`__, TArray Int
      `ConnectionBucket <Data-ConnectionPool.html#t:ConnectionBucket>`__)

   }
-  `initConnectionPool <#v:initConnectionPool>`__ :: Int -> IO
   `Connection <Data-SqlTransaction.html#t:Connection>`__ -> IO
   `ConnectionPool <Data-ConnectionPool.html#t:ConnectionPool>`__
-  `emptyConnectionBucket <#v:emptyConnectionBucket>`__ ::
   `ConnectionPool <Data-ConnectionPool.html#t:ConnectionPool>`__ -> Int
   -> Int -> STM ()
-  `fillConnectionBucket <#v:fillConnectionBucket>`__ ::
   `ConnectionPool <Data-ConnectionPool.html#t:ConnectionPool>`__ -> Int
   -> STM ()
-  `reviveConnection <#v:reviveConnection>`__ ::
   `ConnectionPool <Data-ConnectionPool.html#t:ConnectionPool>`__ ->
   `ConnectionContext <Data-ConnectionPool.html#t:ConnectionContext>`__
   -> IO
   `ConnectionContext <Data-ConnectionPool.html#t:ConnectionContext>`__
-  `putConnection <#v:putConnection>`__ ::
   `ConnectionPool <Data-ConnectionPool.html#t:ConnectionPool>`__ -> Int
   -> `Connection <Data-SqlTransaction.html#t:Connection>`__ -> STM ()
-  `getConnection <#v:getConnection>`__ ::
   `ConnectionPool <Data-ConnectionPool.html#t:ConnectionPool>`__ -> IO
   `ConnectionContext <Data-ConnectionPool.html#t:ConnectionContext>`__
-  `returnConnection <#v:returnConnection>`__ ::
   `ConnectionPool <Data-ConnectionPool.html#t:ConnectionPool>`__ ->
   `ConnectionContext <Data-ConnectionPool.html#t:ConnectionContext>`__
   -> IO ()
-  `unwrapContext <#v:unwrapContext>`__ ::
   `ConnectionContext <Data-ConnectionPool.html#t:ConnectionContext>`__
   -> `Connection <Data-SqlTransaction.html#t:Connection>`__
-  `unsafeGetConnection <#v:unsafeGetConnection>`__ ::
   `ConnectionPool <Data-ConnectionPool.html#t:ConnectionPool>`__ -> Int
   -> STM
   `ConnectionContext <Data-ConnectionPool.html#t:ConnectionContext>`__
-  `initConnectionReclaimer <#v:initConnectionReclaimer>`__ ::
   `ConnectionPool <Data-ConnectionPool.html#t:ConnectionPool>`__ -> Int
   -> IO ThreadId

Documentation
=============

c :: IO `Connection <Data-SqlTransaction.html#t:Connection>`__

happyTest :: IO ()

type Pointer = Int

newtype ConnectionContext

A connection context is a numbered connection

Constructors

ConnectionContext

 

Fields

unConnectionContext :: (Int,
`Connection <Data-SqlTransaction.html#t:Connection>`__)
     

data ConnectionBucket

A connection bucket can be empty or full If it is empty, it remembers
it's connection number

Constructors

+--------------------------------------------------------------------+-----+
| Empty `Connection <Data-SqlTransaction.html#t:Connection>`__ Int   |     |
+--------------------------------------------------------------------+-----+
| Filled `Connection <Data-SqlTransaction.html#t:Connection>`__      |     |
+--------------------------------------------------------------------+-----+

Instances

Show `ConnectionBucket <Data-ConnectionPool.html#t:ConnectionBucket>`__

Show instance for debugging

newtype ConnectionPool

The pool is a ring of unused connections and an array of buckets

Constructors

ConnectionPool

 

Fields

unConnectionPool :: (TQueue
`Pointer <Data-ConnectionPool.html#t:Pointer>`__, TArray Int
`ConnectionBucket <Data-ConnectionPool.html#t:ConnectionBucket>`__)
     

initConnectionPool :: Int -> IO
`Connection <Data-SqlTransaction.html#t:Connection>`__ -> IO
`ConnectionPool <Data-ConnectionPool.html#t:ConnectionPool>`__

Startup n connections

emptyConnectionBucket ::
`ConnectionPool <Data-ConnectionPool.html#t:ConnectionPool>`__ -> Int ->
Int -> STM ()

Empty a connection bucket

fillConnectionBucket ::
`ConnectionPool <Data-ConnectionPool.html#t:ConnectionPool>`__ -> Int ->
STM ()

fill a connection bucket

reviveConnection ::
`ConnectionPool <Data-ConnectionPool.html#t:ConnectionPool>`__ ->
`ConnectionContext <Data-ConnectionPool.html#t:ConnectionContext>`__ ->
IO `ConnectionContext <Data-ConnectionPool.html#t:ConnectionContext>`__

revive a connection (if it is dead)

putConnection ::
`ConnectionPool <Data-ConnectionPool.html#t:ConnectionPool>`__ -> Int ->
`Connection <Data-SqlTransaction.html#t:Connection>`__ -> STM ()

Put a connection back into the pool

getConnection ::
`ConnectionPool <Data-ConnectionPool.html#t:ConnectionPool>`__ -> IO
`ConnectionContext <Data-ConnectionPool.html#t:ConnectionContext>`__

Get a connection from the pool

returnConnection ::
`ConnectionPool <Data-ConnectionPool.html#t:ConnectionPool>`__ ->
`ConnectionContext <Data-ConnectionPool.html#t:ConnectionContext>`__ ->
IO ()

Return a connection to the pool

unwrapContext ::
`ConnectionContext <Data-ConnectionPool.html#t:ConnectionContext>`__ ->
`Connection <Data-SqlTransaction.html#t:Connection>`__

Unwrap a connection

unsafeGetConnection ::
`ConnectionPool <Data-ConnectionPool.html#t:ConnectionPool>`__ -> Int ->
STM `ConnectionContext <Data-ConnectionPool.html#t:ConnectionContext>`__

Unsafely get a connection from the pool

initConnectionReclaimer ::
`ConnectionPool <Data-ConnectionPool.html#t:ConnectionPool>`__ -> Int ->
IO ThreadId

This should reclaim a connection after n seconds, but is not yet
implemented

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
