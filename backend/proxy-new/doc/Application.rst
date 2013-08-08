===========
Application
===========

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

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

\_proxy :: Snaplet
`ProxySnaplet <ProxyExtendableSnapletConduit.html#t:ProxySnaplet>`__
     
\_node :: Snaplet `DHTConfig <NodeSnapletTest.html#t:DHTConfig>`__
     
\_sql :: Snaplet
`SqlTransactionConfig <SqlTransactionSnaplet.html#t:SqlTransactionConfig>`__
     
\_rnd :: Snaplet `RandomConfig <RandomSnaplet.html#t:RandomConfig>`__
     
\_roles :: Snaplet `RoleSnaplet <RoleSnaplet.html#t:RoleSnaplet>`__
     
\_logcycle :: Snaplet `Cycle <Data-ExternalLog.html#t:Cycle>`__
     

sql :: Lens' `App <Application.html#t:App>`__ (Snaplet
`SqlTransactionConfig <SqlTransactionSnaplet.html#t:SqlTransactionConfig>`__)

roles :: Lens' `App <Application.html#t:App>`__ (Snaplet
`RoleSnaplet <RoleSnaplet.html#t:RoleSnaplet>`__)

rnd :: Lens' `App <Application.html#t:App>`__ (Snaplet
`RandomConfig <RandomSnaplet.html#t:RandomConfig>`__)

proxy :: Lens' `App <Application.html#t:App>`__ (Snaplet
`ProxySnaplet <ProxyExtendableSnapletConduit.html#t:ProxySnaplet>`__)

node :: Lens' `App <Application.html#t:App>`__ (Snaplet
`DHTConfig <NodeSnapletTest.html#t:DHTConfig>`__)

logcycle :: Lens' `App <Application.html#t:App>`__ (Snaplet
`Cycle <Data-ExternalLog.html#t:Cycle>`__)

type AppHandler = Handler `App <Application.html#t:App>`__
`App <Application.html#t:App>`__

type Application = `AppHandler <Application.html#t:AppHandler>`__

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
