% SqlTransactionSnaplet
% 
% 

-   [Contents](index.html)
-   [Index](doc-index.html)

 

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
:    
\_pool :: [ConnectionPool](Data-ConnectionPool.html#t:ConnectionPool)
:    
\_dbcons :: Integer
:    

dsn :: Lens'
[SqlTransactionConfig](SqlTransactionSnaplet.html#t:SqlTransactionConfig)
String

pool :: Lens'
[SqlTransactionConfig](SqlTransactionSnaplet.html#t:SqlTransactionConfig)
[ConnectionPool](Data-ConnectionPool.html#t:ConnectionPool)

dbcons :: Lens'
[SqlTransactionConfig](SqlTransactionSnaplet.html#t:SqlTransactionConfig)
Integer

returnDatabase :: (MonadIO m, MonadState
[SqlTransactionConfig](SqlTransactionSnaplet.html#t:SqlTransactionConfig)
m) =\> [ConnectionContext](Data-ConnectionPool.html#t:ConnectionContext)
-\> m ()

getDatabase :: (MonadIO m, MonadState
[SqlTransactionConfig](SqlTransactionSnaplet.html#t:SqlTransactionConfig)
m) =\> m
[ConnectionContext](Data-ConnectionPool.html#t:ConnectionContext)

withConnection :: (MonadState
[SqlTransactionConfig](SqlTransactionSnaplet.html#t:SqlTransactionConfig)
m, MonadCatchIO m) =\>
([Connection](Data-SqlTransaction.html#t:Connection) -\> m a) -\> m a

runDb :: (Applicative m, MonadCatchIO m, MonadState
[SqlTransactionConfig](SqlTransactionSnaplet.html#t:SqlTransactionConfig)
m) =\> [Lock](LockSnaplet.html#t:Lock) -\> (String -\> m a) -\>
[SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction)
[Connection](Data-SqlTransaction.html#t:Connection) a -\> m a

initSqlTransactionSnaplet :: FilePath -\> SnapletInit b
[SqlTransactionConfig](SqlTransactionSnaplet.html#t:SqlTransactionConfig)

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
