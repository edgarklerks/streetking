=====================
SqlTransactionSnaplet
=====================

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

SqlTransactionSnaplet

Documentation
=============

data SqlTransactionConfig

Constructors

STC

 

Fields

\_dsn :: String
     
\_pool :: `ConnectionPool <Data-ConnectionPool.html#t:ConnectionPool>`__
     
\_dbcons :: Integer
     

dsn :: Lens'
`SqlTransactionConfig <SqlTransactionSnaplet.html#t:SqlTransactionConfig>`__
String

pool :: Lens'
`SqlTransactionConfig <SqlTransactionSnaplet.html#t:SqlTransactionConfig>`__
`ConnectionPool <Data-ConnectionPool.html#t:ConnectionPool>`__

dbcons :: Lens'
`SqlTransactionConfig <SqlTransactionSnaplet.html#t:SqlTransactionConfig>`__
Integer

returnDatabase :: (MonadIO m, MonadState
`SqlTransactionConfig <SqlTransactionSnaplet.html#t:SqlTransactionConfig>`__
m) =>
`ConnectionContext <Data-ConnectionPool.html#t:ConnectionContext>`__ ->
m ()

getDatabase :: (MonadIO m, MonadState
`SqlTransactionConfig <SqlTransactionSnaplet.html#t:SqlTransactionConfig>`__
m) => m
`ConnectionContext <Data-ConnectionPool.html#t:ConnectionContext>`__

withConnection :: (MonadState
`SqlTransactionConfig <SqlTransactionSnaplet.html#t:SqlTransactionConfig>`__
m, MonadCatchIO m) =>
(`Connection <Data-SqlTransaction.html#t:Connection>`__ -> m a) -> m a

runDb :: (Applicative m, MonadCatchIO m, MonadState
`SqlTransactionConfig <SqlTransactionSnaplet.html#t:SqlTransactionConfig>`__
m) => (String -> m a) ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ a -> m a

initSqlTransactionSnaplet :: FilePath -> SnapletInit b
`SqlTransactionConfig <SqlTransactionSnaplet.html#t:SqlTransactionConfig>`__

class HasSqlTransaction b where

Methods

sqlLens :: SnapletLens (Snaplet b) (Snaplet
`SqlTransactionConfig <SqlTransactionSnaplet.html#t:SqlTransactionConfig>`__)

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
