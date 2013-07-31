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

data ApplicationException

Constructors

+-------------------------+-----+
| UserErrorE ByteString   |     |
+-------------------------+-----+

Instances

+--------------------------------------------------------------------------------+-----+
| Show `ApplicationException <Application.html#t:ApplicationException>`__        |     |
+--------------------------------------------------------------------------------+-----+
| Typeable `ApplicationException <Application.html#t:ApplicationException>`__    |     |
+--------------------------------------------------------------------------------+-----+
| Exception `ApplicationException <Application.html#t:ApplicationException>`__   |     |
+--------------------------------------------------------------------------------+-----+

data App

Constructors

App

 

Fields

\_sess :: Snaplet SessionManager
     
\_auth :: Snaplet (AuthManager `App <Application.html#t:App>`__)
     
\_sql :: Snaplet
`SqlTransactionConfig <SqlTransactionSnaplet.html#t:SqlTransactionConfig>`__
     

sql :: Lens' `App <Application.html#t:App>`__ (Snaplet
`SqlTransactionConfig <SqlTransactionSnaplet.html#t:SqlTransactionConfig>`__)

sess :: Lens' `App <Application.html#t:App>`__ (Snaplet SessionManager)

auth :: Lens' `App <Application.html#t:App>`__ (Snaplet (AuthManager
`App <Application.html#t:App>`__))

type AppHandler = Handler `App <Application.html#t:App>`__
`App <Application.html#t:App>`__

type Application = `AppHandler <Application.html#t:AppHandler>`__

toAeson :: `InRule <Data-InRules.html#t:InRule>`__ -> ByteString

writeAeson :: `ToInRule <Data-InRules.html#t:ToInRule>`__ a => a ->
`Application <Application.html#t:Application>`__ ()

writeError :: `ToInRule <Data-InRules.html#t:ToInRule>`__ a => a ->
`Application <Application.html#t:Application>`__ ()

writeResult :: `ToInRule <Data-InRules.html#t:ToInRule>`__ a => a ->
`Application <Application.html#t:Application>`__ ()

writeResult' :: ToJSON a => a ->
`Application <Application.html#t:Application>`__ ()

writeMapable :: `Mapable <Model-General.html#t:Mapable>`__ a => a ->
`Application <Application.html#t:Application>`__ ()

writeMapables :: `Mapable <Model-General.html#t:Mapable>`__ a => [a] ->
`Application <Application.html#t:Application>`__ ()

getUserId :: `Application <Application.html#t:Application>`__ Integer

getOParam :: ByteString ->
`Application <Application.html#t:Application>`__ ByteString

type SqlMap = HashMap String
`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__

getJson :: `Application <Application.html#t:Application>`__
`SqlMap <Application.html#t:SqlMap>`__

getJsons :: `Application <Application.html#t:Application>`__
[`SqlMap <Application.html#t:SqlMap>`__\ ]

getPagesWithDTDOrdered :: [String] ->
`DTD <Data-DatabaseTemplate.html#t:DTD>`__ ->
`Application <Application.html#t:Application>`__ (((Integer, Integer),
`Constraints <Data-Database.html#t:Constraints>`__),
`Orders <Data-Database.html#t:Orders>`__)

getPagesWithDTD :: `DTD <Data-DatabaseTemplate.html#t:DTD>`__ ->
`Application <Application.html#t:Application>`__ ((Integer, Integer),
`Constraints <Data-Database.html#t:Constraints>`__)

writeError' :: ToJSON a => a ->
`Application <Application.html#t:Application>`__ ()

writeAeson' :: ToJSON a => a ->
`Application <Application.html#t:Application>`__ ()

internalError :: String ->
`Application <Application.html#t:Application>`__ a

runCompose :: (Applicative (m b
`SqlTransactionConfig <SqlTransactionSnaplet.html#t:SqlTransactionConfig>`__),
MonadState
`SqlTransactionConfig <SqlTransactionSnaplet.html#t:SqlTransactionConfig>`__
(m b
`SqlTransactionConfig <SqlTransactionSnaplet.html#t:SqlTransactionConfig>`__),
MonadSnaplet m, MonadCatchIO (m b
`SqlTransactionConfig <SqlTransactionSnaplet.html#t:SqlTransactionConfig>`__))
=> `ComposeMonad <Data-ComposeModel.html#t:ComposeMonad>`__ a
`Connection <Data-SqlTransaction.html#t:Connection>`__ a -> m b
`App <Application.html#t:App>`__ (HashMap String
`InRule <Data-InRules.html#t:InRule>`__)

runDb :: (Applicative (m b
`SqlTransactionConfig <SqlTransactionSnaplet.html#t:SqlTransactionConfig>`__),
MonadState
`SqlTransactionConfig <SqlTransactionSnaplet.html#t:SqlTransactionConfig>`__
(m b
`SqlTransactionConfig <SqlTransactionSnaplet.html#t:SqlTransactionConfig>`__),
MonadSnaplet m, MonadCatchIO (m b
`SqlTransactionConfig <SqlTransactionSnaplet.html#t:SqlTransactionConfig>`__))
=> `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ a -> m b
`App <Application.html#t:App>`__ a

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
