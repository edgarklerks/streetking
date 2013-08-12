===================
Data.ConnectionPool
===================

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Data.ConnectionPool

Documentation
=============

c :: IO `Connection <Data-SqlTransaction.html#t:Connection>`__

happyTest :: IO ()

type Pointer = Int

newtype ConnectionContext

Constructors

ConnectionContext

 

Fields

unConnectionContext :: (Int,
`Connection <Data-SqlTransaction.html#t:Connection>`__)
     

data ConnectionBucket

Constructors

+--------------------------------------------------------------------+-----+
| Empty `Connection <Data-SqlTransaction.html#t:Connection>`__ Int   |     |
+--------------------------------------------------------------------+-----+
| Filled `Connection <Data-SqlTransaction.html#t:Connection>`__      |     |
+--------------------------------------------------------------------+-----+

Instances

+---------------------------------------------------------------------------+-----+
| Show `ConnectionBucket <Data-ConnectionPool.html#t:ConnectionBucket>`__   |     |
+---------------------------------------------------------------------------+-----+

newtype ConnectionPool

Constructors

ConnectionPool

 

Fields

unConnectionPool :: (TQueue
`Pointer <Data-ConnectionPool.html#t:Pointer>`__, TArray Int
`ConnectionBucket <Data-ConnectionPool.html#t:ConnectionBucket>`__)
     

initConnectionPool :: Int -> IO
`Connection <Data-SqlTransaction.html#t:Connection>`__ -> IO
`ConnectionPool <Data-ConnectionPool.html#t:ConnectionPool>`__

emptyConnectionBucket ::
`ConnectionPool <Data-ConnectionPool.html#t:ConnectionPool>`__ -> Int ->
Int -> STM ()

fillConnectionBucket ::
`ConnectionPool <Data-ConnectionPool.html#t:ConnectionPool>`__ -> Int ->
STM ()

reviveConnection ::
`ConnectionPool <Data-ConnectionPool.html#t:ConnectionPool>`__ ->
`ConnectionContext <Data-ConnectionPool.html#t:ConnectionContext>`__ ->
IO `ConnectionContext <Data-ConnectionPool.html#t:ConnectionContext>`__

putConnection ::
`ConnectionPool <Data-ConnectionPool.html#t:ConnectionPool>`__ -> Int ->
`Connection <Data-SqlTransaction.html#t:Connection>`__ -> STM ()

getConnection ::
`ConnectionPool <Data-ConnectionPool.html#t:ConnectionPool>`__ -> IO
`ConnectionContext <Data-ConnectionPool.html#t:ConnectionContext>`__

returnConnection ::
`ConnectionPool <Data-ConnectionPool.html#t:ConnectionPool>`__ ->
`ConnectionContext <Data-ConnectionPool.html#t:ConnectionContext>`__ ->
IO ()

unwrapContext ::
`ConnectionContext <Data-ConnectionPool.html#t:ConnectionContext>`__ ->
`Connection <Data-SqlTransaction.html#t:Connection>`__

unsafeGetConnection ::
`ConnectionPool <Data-ConnectionPool.html#t:ConnectionPool>`__ -> Int ->
STM `ConnectionContext <Data-ConnectionPool.html#t:ConnectionContext>`__

initConnectionReclaimer ::
`ConnectionPool <Data-ConnectionPool.html#t:ConnectionPool>`__ -> Int ->
IO ThreadId

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
