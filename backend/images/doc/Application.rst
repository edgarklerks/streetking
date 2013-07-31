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

\_heist :: Snaplet (Heist `App <Application.html#t:App>`__)
     
\_config :: Snaplet
`ConfigSnaplet <ConfigSnaplet.html#t:ConfigSnaplet>`__
     
\_sql :: Snaplet
`SqlTransactionConfig <SqlTransactionSnaplet.html#t:SqlTransactionConfig>`__
     
\_img :: Snaplet `ImageConfig <ImageSnapLet.html#t:ImageConfig>`__
     

sql :: Lens' `App <Application.html#t:App>`__ (Snaplet
`SqlTransactionConfig <SqlTransactionSnaplet.html#t:SqlTransactionConfig>`__)

img :: Lens' `App <Application.html#t:App>`__ (Snaplet
`ImageConfig <ImageSnapLet.html#t:ImageConfig>`__)

heist :: Lens' `App <Application.html#t:App>`__ (Snaplet (Heist
`App <Application.html#t:App>`__))

config :: Lens' `App <Application.html#t:App>`__ (Snaplet
`ConfigSnaplet <ConfigSnaplet.html#t:ConfigSnaplet>`__)

runDb :: (Applicative (m b
`SqlTransactionConfig <SqlTransactionSnaplet.html#t:SqlTransactionConfig>`__),
MonadState
`SqlTransactionConfig <SqlTransactionSnaplet.html#t:SqlTransactionConfig>`__
(m b
`SqlTransactionConfig <SqlTransactionSnaplet.html#t:SqlTransactionConfig>`__),
MonadCatchIO (m b
`SqlTransactionConfig <SqlTransactionSnaplet.html#t:SqlTransactionConfig>`__),
MonadSnaplet m) =>
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ a -> m b
`App <Application.html#t:App>`__ a

type AppHandler = Handler `App <Application.html#t:App>`__
`App <Application.html#t:App>`__

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
