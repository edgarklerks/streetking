=================
Data.ComposeModel
=================

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Data.ComposeModel

Documentation
=============

action :: `ToInRule <Data-InRules.html#t:ToInRule>`__ a => String ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c a ->
`ComposeMonad <Data-ComposeModel.html#t:ComposeMonad>`__ r c a

label :: `ToInRule <Data-InRules.html#t:ToInRule>`__ a => String -> a ->
`ComposeMonad <Data-ComposeModel.html#t:ComposeMonad>`__ r c ()

runComposeMonad :: (Applicative m, MonadIO m,
`IConnection <Data-SqlTransaction.html#t:IConnection>`__ conn) =>
`Lock <LockSnaplet.html#t:Lock>`__ ->
`ComposeMonad <Data-ComposeModel.html#t:ComposeMonad>`__ a conn a ->
(String -> m (HashMap String `InRule <Data-InRules.html#t:InRule>`__))
-> conn -> m (HashMap String `InRule <Data-InRules.html#t:InRule>`__)

data ComposeMonad r c a

Instances

+-----------------------------------------------------------------------------------------+-----+
| MonadReader c (`ComposeMonad <Data-ComposeModel.html#t:ComposeMonad>`__ r c)            |     |
+-----------------------------------------------------------------------------------------+-----+
| MonadError String (`ComposeMonad <Data-ComposeModel.html#t:ComposeMonad>`__ r c)        |     |
+-----------------------------------------------------------------------------------------+-----+
| MonadWriter ComposeMap (`ComposeMonad <Data-ComposeModel.html#t:ComposeMonad>`__ r c)   |     |
+-----------------------------------------------------------------------------------------+-----+
| Monad (`ComposeMonad <Data-ComposeModel.html#t:ComposeMonad>`__ r c)                    |     |
+-----------------------------------------------------------------------------------------+-----+
| Functor (`ComposeMonad <Data-ComposeModel.html#t:ComposeMonad>`__ r c)                  |     |
+-----------------------------------------------------------------------------------------+-----+
| MonadPlus (`ComposeMonad <Data-ComposeModel.html#t:ComposeMonad>`__ r c)                |     |
+-----------------------------------------------------------------------------------------+-----+
| Applicative (`ComposeMonad <Data-ComposeModel.html#t:ComposeMonad>`__ r c)              |     |
+-----------------------------------------------------------------------------------------+-----+
| Alternative (`ComposeMonad <Data-ComposeModel.html#t:ComposeMonad>`__ r c)              |     |
+-----------------------------------------------------------------------------------------+-----+
| MonadIO (`ComposeMonad <Data-ComposeModel.html#t:ComposeMonad>`__ r c)                  |     |
+-----------------------------------------------------------------------------------------+-----+
| MonadCont (`ComposeMonad <Data-ComposeModel.html#t:ComposeMonad>`__ r c)                |     |
+-----------------------------------------------------------------------------------------+-----+
| Monoid (`ComposeMonad <Data-ComposeModel.html#t:ComposeMonad>`__ r c ())                |     |
+-----------------------------------------------------------------------------------------+-----+

deep :: String ->
`ComposeMonad <Data-ComposeModel.html#t:ComposeMonad>`__ a
`Connection <Data-SqlTransaction.html#t:Connection>`__ a ->
`ComposeMonad <Data-ComposeModel.html#t:ComposeMonad>`__ r
`Connection <Data-SqlTransaction.html#t:Connection>`__ ()

abort :: r -> `ComposeMonad <Data-ComposeModel.html#t:ComposeMonad>`__ r
c a

liftDb :: `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
c a -> `ComposeMonad <Data-ComposeModel.html#t:ComposeMonad>`__ r c a

getComposeUser ::
`ComposeMonad <Data-ComposeModel.html#t:ComposeMonad>`__ r c
`Lock <LockSnaplet.html#t:Lock>`__

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
