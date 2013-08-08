=================
Data.ComposeModel
=================

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Data.ComposeModel

Description

This module is a writer like monad, which builds a tree like map of
InRules values from SqlTransaction Actions This is handy for building
complex return objects

Synopsis

-  data `ComposeMonad <#t:ComposeMonad>`__ r c a
-  `abort <#v:abort>`__ :: r ->
   `ComposeMonad <Data-ComposeModel.html#t:ComposeMonad>`__ r c a
-  `action <#v:action>`__ ::
   (`IConnection <Data-SqlTransaction.html#t:IConnection>`__ c,
   `ToInRule <Data-InRules.html#t:ToInRule>`__ a) => String ->
   `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c a ->
   `ComposeMonad <Data-ComposeModel.html#t:ComposeMonad>`__ r c a
-  `deep <#v:deep>`__ :: String ->
   `ComposeMonad <Data-ComposeModel.html#t:ComposeMonad>`__ a
   `Connection <Data-SqlTransaction.html#t:Connection>`__ a ->
   `ComposeMonad <Data-ComposeModel.html#t:ComposeMonad>`__ r
   `Connection <Data-SqlTransaction.html#t:Connection>`__ ()
-  `getComposeUser <#v:getComposeUser>`__ ::
   `ComposeMonad <Data-ComposeModel.html#t:ComposeMonad>`__ r c
   `Lock <LockSnaplet.html#t:Lock>`__
-  `label <#v:label>`__ ::
   (`IConnection <Data-SqlTransaction.html#t:IConnection>`__ c,
   `ToInRule <Data-InRules.html#t:ToInRule>`__ a) => String -> a ->
   `ComposeMonad <Data-ComposeModel.html#t:ComposeMonad>`__ r c ()
-  `liftDb <#v:liftDb>`__ ::
   `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c a ->
   `ComposeMonad <Data-ComposeModel.html#t:ComposeMonad>`__ r c a
-  `runComposeMonad <#v:runComposeMonad>`__ :: (Applicative m,
   `IConnection <Data-SqlTransaction.html#t:IConnection>`__ conn,
   MonadIO m) => `Lock <LockSnaplet.html#t:Lock>`__ ->
   `ComposeMonad <Data-ComposeModel.html#t:ComposeMonad>`__ a conn a ->
   (String -> m (HashMap String
   `InRule <Data-InRules.html#t:InRule>`__)) -> conn -> m (HashMap
   String `InRule <Data-InRules.html#t:InRule>`__)

Documentation
=============

data ComposeMonad r c a

ComposeMonad, is a continutation monad to jump out of a composition A
Reader to store the connection And a writer to build up our map

Instances

+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| MonadReader c (`ComposeMonad <Data-ComposeModel.html#t:ComposeMonad>`__ r c)                                                                                                                 |     |
+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `IConnection <Data-SqlTransaction.html#t:IConnection>`__ c => MonadError `SqlError <Data-SqlTransaction.html#t:SqlError>`__ (`ComposeMonad <Data-ComposeModel.html#t:ComposeMonad>`__ r c)   |     |
+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `IConnection <Data-SqlTransaction.html#t:IConnection>`__ c => MonadWriter ComposeMap (`ComposeMonad <Data-ComposeModel.html#t:ComposeMonad>`__ r c)                                          |     |
+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Monad (`ComposeMonad <Data-ComposeModel.html#t:ComposeMonad>`__ r c)                                                                                                                         |     |
+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Functor (`ComposeMonad <Data-ComposeModel.html#t:ComposeMonad>`__ r c)                                                                                                                       |     |
+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `IConnection <Data-SqlTransaction.html#t:IConnection>`__ c => MonadPlus (`ComposeMonad <Data-ComposeModel.html#t:ComposeMonad>`__ r c)                                                       |     |
+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Applicative (`ComposeMonad <Data-ComposeModel.html#t:ComposeMonad>`__ r c)                                                                                                                   |     |
+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `IConnection <Data-SqlTransaction.html#t:IConnection>`__ c => Alternative (`ComposeMonad <Data-ComposeModel.html#t:ComposeMonad>`__ r c)                                                     |     |
+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| MonadIO (`ComposeMonad <Data-ComposeModel.html#t:ComposeMonad>`__ r c)                                                                                                                       |     |
+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| MonadCont (`ComposeMonad <Data-ComposeModel.html#t:ComposeMonad>`__ r c)                                                                                                                     |     |
+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `IConnection <Data-SqlTransaction.html#t:IConnection>`__ c => Monoid (`ComposeMonad <Data-ComposeModel.html#t:ComposeMonad>`__ r c ())                                                       |     |
+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+

abort :: r -> `ComposeMonad <Data-ComposeModel.html#t:ComposeMonad>`__ r
c a

action :: (`IConnection <Data-SqlTransaction.html#t:IConnection>`__ c,
`ToInRule <Data-InRules.html#t:ToInRule>`__ a) => String ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c a ->
`ComposeMonad <Data-ComposeModel.html#t:ComposeMonad>`__ r c a

Run an SqlTransaction action into the compose monad under a label

deep :: String ->
`ComposeMonad <Data-ComposeModel.html#t:ComposeMonad>`__ a
`Connection <Data-SqlTransaction.html#t:Connection>`__ a ->
`ComposeMonad <Data-ComposeModel.html#t:ComposeMonad>`__ r
`Connection <Data-SqlTransaction.html#t:Connection>`__ ()

run a compose map computation and store it under a label as leaf

getComposeUser ::
`ComposeMonad <Data-ComposeModel.html#t:ComposeMonad>`__ r c
`Lock <LockSnaplet.html#t:Lock>`__

Function to get the user state

label :: (`IConnection <Data-SqlTransaction.html#t:IConnection>`__ c,
`ToInRule <Data-InRules.html#t:ToInRule>`__ a) => String -> a ->
`ComposeMonad <Data-ComposeModel.html#t:ComposeMonad>`__ r c ()

Label the value

liftDb :: `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
c a -> `ComposeMonad <Data-ComposeModel.html#t:ComposeMonad>`__ r c a

Lift an SqlTransaction into the ComposeMonad

runComposeMonad :: (Applicative m,
`IConnection <Data-SqlTransaction.html#t:IConnection>`__ conn, MonadIO
m) => `Lock <LockSnaplet.html#t:Lock>`__ ->
`ComposeMonad <Data-ComposeModel.html#t:ComposeMonad>`__ a conn a ->
(String -> m (HashMap String `InRule <Data-InRules.html#t:InRule>`__))
-> conn -> m (HashMap String `InRule <Data-InRules.html#t:InRule>`__)

::

     runComposeMonad :: (Applicative m, MonadIO m) => ComposeMonad a Connection a -> (String -> m (H.HashMap String InRule)) -> Connection -> m (H.HashMap String InRule)

run Compose map safely

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
