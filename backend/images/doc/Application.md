% Application
% 
% 

-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Application

Description

This module defines our application's state type and an alias for its
handler monad.

Documentation
=============

data App

Constructors

App

 

Fields

\_heist :: Snaplet (Heist [App](Application.html#t:App))
:    
\_config :: Snaplet [ConfigSnaplet](ConfigSnaplet.html#t:ConfigSnaplet)
:    
\_sql :: Snaplet [SqlTransactionConfig](SqlTransactionSnaplet.html#t:SqlTransactionConfig)
:    
\_img :: Snaplet [ImageConfig](ImageSnapLet.html#t:ImageConfig)
:    

sql :: Lens' [App](Application.html#t:App) (Snaplet
[SqlTransactionConfig](SqlTransactionSnaplet.html#t:SqlTransactionConfig))

img :: Lens' [App](Application.html#t:App) (Snaplet
[ImageConfig](ImageSnapLet.html#t:ImageConfig))

heist :: Lens' [App](Application.html#t:App) (Snaplet (Heist
[App](Application.html#t:App)))

config :: Lens' [App](Application.html#t:App) (Snaplet
[ConfigSnaplet](ConfigSnaplet.html#t:ConfigSnaplet))

runDb :: (Applicative (m b
[SqlTransactionConfig](SqlTransactionSnaplet.html#t:SqlTransactionConfig)),
MonadState
[SqlTransactionConfig](SqlTransactionSnaplet.html#t:SqlTransactionConfig)
(m b
[SqlTransactionConfig](SqlTransactionSnaplet.html#t:SqlTransactionConfig)),
MonadCatchIO (m b
[SqlTransactionConfig](SqlTransactionSnaplet.html#t:SqlTransactionConfig)),
MonadSnaplet m) =\>
[SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction)
[Connection](Data-SqlTransaction.html#t:Connection) a -\> m b
[App](Application.html#t:App) a

type AppHandler = Handler [App](Application.html#t:App)
[App](Application.html#t:App)

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
