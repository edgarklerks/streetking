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

\_proxy :: Snaplet [ProxySnaplet](ProxyExtendableSnapletConduit.html#t:ProxySnaplet)
:    
\_node :: Snaplet [DHTConfig](NodeSnapletTest.html#t:DHTConfig)
:    
\_sql :: Snaplet [SqlTransactionConfig](SqlTransactionSnaplet.html#t:SqlTransactionConfig)
:    
\_rnd :: Snaplet [RandomConfig](RandomSnaplet.html#t:RandomConfig)
:    
\_roles :: Snaplet [RoleSnaplet](RoleSnaplet.html#t:RoleSnaplet)
:    
\_logcycle :: Snaplet [Cycle](Data-ExternalLog.html#t:Cycle)
:    

sql :: Lens' [App](Application.html#t:App) (Snaplet
[SqlTransactionConfig](SqlTransactionSnaplet.html#t:SqlTransactionConfig))

roles :: Lens' [App](Application.html#t:App) (Snaplet
[RoleSnaplet](RoleSnaplet.html#t:RoleSnaplet))

rnd :: Lens' [App](Application.html#t:App) (Snaplet
[RandomConfig](RandomSnaplet.html#t:RandomConfig))

proxy :: Lens' [App](Application.html#t:App) (Snaplet
[ProxySnaplet](ProxyExtendableSnapletConduit.html#t:ProxySnaplet))

node :: Lens' [App](Application.html#t:App) (Snaplet
[DHTConfig](NodeSnapletTest.html#t:DHTConfig))

logcycle :: Lens' [App](Application.html#t:App) (Snaplet
[Cycle](Data-ExternalLog.html#t:Cycle))

type AppHandler = Handler [App](Application.html#t:App)
[App](Application.html#t:App)

type Application = [AppHandler](Application.html#t:AppHandler)

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
