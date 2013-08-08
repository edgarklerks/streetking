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

Synopsis

-  data `ApplicationException <#t:ApplicationException>`__ =
   `UserErrorE <#v:UserErrorE>`__ ByteString
-  data `App <#t:App>`__ = `App <#v:App>`__ {

   -  `\_db <#v:_db>`__ :: Snaplet
      `SqlTransactionConfig <SqlTransactionSnaplet.html#t:SqlTransactionConfig>`__
   -  `\_config <#v:_config>`__ :: Snaplet
      `ConfigSnaplet <ConfigSnaplet.html#t:ConfigSnaplet>`__
   -  `\_rnd <#v:_rnd>`__ :: Snaplet
      `RandomConfig <RandomSnaplet.html#t:RandomConfig>`__
   -  `\_nde <#v:_nde>`__ :: Snaplet
      `DHTConfig <NodeSnapletTest.html#t:DHTConfig>`__
   -  `\_notf <#v:_notf>`__ :: Snaplet
      `NotificationConfig <NotificationSnaplet.html#t:NotificationConfig>`__
   -  `\_slock <#v:_slock>`__ :: Snaplet
      `Lock <LockSnaplet.html#t:Lock>`__
   -  `\_logcycle <#v:_logcycle>`__ :: Snaplet
      `Cycle <Data-ExternalLog.html#t:Cycle>`__

   }
-  `slock <#v:slock>`__ :: Lens' `App <Application.html#t:App>`__
   (Snaplet `Lock <LockSnaplet.html#t:Lock>`__)
-  `rnd <#v:rnd>`__ :: Lens' `App <Application.html#t:App>`__ (Snaplet
   `RandomConfig <RandomSnaplet.html#t:RandomConfig>`__)
-  `notf <#v:notf>`__ :: Lens' `App <Application.html#t:App>`__ (Snaplet
   `NotificationConfig <NotificationSnaplet.html#t:NotificationConfig>`__)
-  `nde <#v:nde>`__ :: Lens' `App <Application.html#t:App>`__ (Snaplet
   `DHTConfig <NodeSnapletTest.html#t:DHTConfig>`__)
-  `logcycle <#v:logcycle>`__ :: Lens' `App <Application.html#t:App>`__
   (Snaplet `Cycle <Data-ExternalLog.html#t:Cycle>`__)
-  `db <#v:db>`__ :: Lens' `App <Application.html#t:App>`__ (Snaplet
   `SqlTransactionConfig <SqlTransactionSnaplet.html#t:SqlTransactionConfig>`__)
-  `config <#v:config>`__ :: Lens' `App <Application.html#t:App>`__
   (Snaplet `ConfigSnaplet <ConfigSnaplet.html#t:ConfigSnaplet>`__)
-  `getUniqueKey <#v:getUniqueKey>`__ ::
   `Application <Application.html#t:Application>`__ ByteString
-  `runDb <#v:runDb>`__ ::
   `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
   `Connection <Data-SqlTransaction.html#t:Connection>`__ b -> Handler
   `App <Application.html#t:App>`__ `App <Application.html#t:App>`__ b
-  `sendLetter <#v:sendLetter>`__ :: (MonadState
   `NotificationConfig <NotificationSnaplet.html#t:NotificationConfig>`__
   (m b
   `NotificationConfig <NotificationSnaplet.html#t:NotificationConfig>`__),
   MonadState
   `SqlTransactionConfig <SqlTransactionSnaplet.html#t:SqlTransactionConfig>`__
   (m b
   `SqlTransactionConfig <SqlTransactionSnaplet.html#t:SqlTransactionConfig>`__),
   MonadSnaplet m, MonadSnap (m b
   `SqlTransactionConfig <SqlTransactionSnaplet.html#t:SqlTransactionConfig>`__))
   => `UserId <Data-Notifications.html#t:UserId>`__ ->
   `Letter <Data-Notifications.html#t:Letter>`__ -> m b
   `App <Application.html#t:App>`__
   `Letter <Data-Notifications.html#t:Letter>`__
-  `setRead <#v:setRead>`__ :: (MonadState
   `NotificationConfig <NotificationSnaplet.html#t:NotificationConfig>`__
   (m b
   `NotificationConfig <NotificationSnaplet.html#t:NotificationConfig>`__),
   MonadState
   `SqlTransactionConfig <SqlTransactionSnaplet.html#t:SqlTransactionConfig>`__
   (m b
   `SqlTransactionConfig <SqlTransactionSnaplet.html#t:SqlTransactionConfig>`__),
   MonadSnaplet m, MonadSnap (m b
   `SqlTransactionConfig <SqlTransactionSnaplet.html#t:SqlTransactionConfig>`__))
   => `UserId <Data-Notifications.html#t:UserId>`__ -> Integer -> m b
   `App <Application.html#t:App>`__ ()
-  `setArchive <#v:setArchive>`__ :: (MonadState
   `NotificationConfig <NotificationSnaplet.html#t:NotificationConfig>`__
   (m b
   `NotificationConfig <NotificationSnaplet.html#t:NotificationConfig>`__),
   MonadState
   `SqlTransactionConfig <SqlTransactionSnaplet.html#t:SqlTransactionConfig>`__
   (m b
   `SqlTransactionConfig <SqlTransactionSnaplet.html#t:SqlTransactionConfig>`__),
   MonadSnaplet m, MonadSnap (m b
   `SqlTransactionConfig <SqlTransactionSnaplet.html#t:SqlTransactionConfig>`__))
   => `UserId <Data-Notifications.html#t:UserId>`__ -> Integer -> m b
   `App <Application.html#t:App>`__ ()
-  `checkMailBox <#v:checkMailBox>`__ :: (MonadState
   `NotificationConfig <NotificationSnaplet.html#t:NotificationConfig>`__
   (m b
   `NotificationConfig <NotificationSnaplet.html#t:NotificationConfig>`__),
   MonadState
   `SqlTransactionConfig <SqlTransactionSnaplet.html#t:SqlTransactionConfig>`__
   (m b
   `SqlTransactionConfig <SqlTransactionSnaplet.html#t:SqlTransactionConfig>`__),
   MonadSnaplet m, MonadSnap (m b
   `SqlTransactionConfig <SqlTransactionSnaplet.html#t:SqlTransactionConfig>`__))
   => `UserId <Data-Notifications.html#t:UserId>`__ -> m b
   `App <Application.html#t:App>`__
   `Letters <Data-Notifications.html#t:Letters>`__
-  type `AppHandler <#t:AppHandler>`__ = Handler
   `App <Application.html#t:App>`__ `App <Application.html#t:App>`__
-  type `Application <#t:Application>`__ =
   `AppHandler <Application.html#t:AppHandler>`__
-  `toAeson <#v:toAeson>`__ :: `InRule <Data-InRules.html#t:InRule>`__
   -> ByteString
-  `writeAeson <#v:writeAeson>`__ ::
   `ToInRule <Data-InRules.html#t:ToInRule>`__ a => a ->
   `Application <Application.html#t:Application>`__ ()
-  `writeError <#v:writeError>`__ ::
   `ToInRule <Data-InRules.html#t:ToInRule>`__ a => a ->
   `Application <Application.html#t:Application>`__ ()
-  `writeResult <#v:writeResult>`__ ::
   `ToInRule <Data-InRules.html#t:ToInRule>`__ a => a ->
   `Application <Application.html#t:Application>`__ ()
-  `writeResult' <#v:writeResult-39->`__ :: ToJSON a => a ->
   `Application <Application.html#t:Application>`__ ()
-  `writeMapable <#v:writeMapable>`__ ::
   `Mapable <Model-General.html#t:Mapable>`__ a => a ->
   `Application <Application.html#t:Application>`__ ()
-  `writeMapables <#v:writeMapables>`__ ::
   `Mapable <Model-General.html#t:Mapable>`__ a => [a] ->
   `Application <Application.html#t:Application>`__ ()
-  `getUserId <#v:getUserId>`__ ::
   `Application <Application.html#t:Application>`__ Integer
-  `getOParam <#v:getOParam>`__ :: ByteString ->
   `Application <Application.html#t:Application>`__ ByteString
-  type `SqlMap <#t:SqlMap>`__ = HashMap String
   `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__
-  `getJson <#v:getJson>`__ ::
   `Application <Application.html#t:Application>`__
   `SqlMap <Application.html#t:SqlMap>`__
-  `getJsons <#v:getJsons>`__ ::
   `Application <Application.html#t:Application>`__
   [`SqlMap <Application.html#t:SqlMap>`__\ ]
-  `getPagesWithDTDOrdered <#v:getPagesWithDTDOrdered>`__ :: [String] ->
   `DTD <Data-DatabaseTemplate.html#t:DTD>`__ ->
   `Application <Application.html#t:Application>`__ (((Integer,
   Integer), `Constraints <Data-Database.html#t:Constraints>`__),
   `Orders <Data-Database.html#t:Orders>`__)
-  `getPagesWithDTDOrderedAndParams <#v:getPagesWithDTDOrderedAndParams>`__
   :: `SqlMap <Application.html#t:SqlMap>`__ -> [String] ->
   `DTD <Data-DatabaseTemplate.html#t:DTD>`__ ->
   `Application <Application.html#t:Application>`__ (((Integer,
   Integer), `Constraints <Data-Database.html#t:Constraints>`__),
   `Orders <Data-Database.html#t:Orders>`__)
-  `getPagesWithDTD <#v:getPagesWithDTD>`__ ::
   `DTD <Data-DatabaseTemplate.html#t:DTD>`__ ->
   `Application <Application.html#t:Application>`__ ((Integer, Integer),
   `Constraints <Data-Database.html#t:Constraints>`__)
-  `addRole <#v:addRole>`__ :: (MonadIO (m b
   `DHTConfig <NodeSnapletTest.html#t:DHTConfig>`__), MonadState
   `DHTConfig <NodeSnapletTest.html#t:DHTConfig>`__ (m b
   `DHTConfig <NodeSnapletTest.html#t:DHTConfig>`__), MonadSnaplet m) =>
   `Id <Data-Role.html#t:Id>`__ -> ByteString -> m b
   `App <Application.html#t:App>`__
   `Proto <ProtoExtended.html#t:Proto>`__
-  `writeError' <#v:writeError-39->`__ :: ToJSON a => a ->
   `Application <Application.html#t:Application>`__ ()
-  `writeAeson' <#v:writeAeson-39->`__ :: ToJSON a => a ->
   `Application <Application.html#t:Application>`__ ()
-  `internalError <#v:internalError>`__ :: String ->
   `Application <Application.html#t:Application>`__ a
-  `runCompose <#v:runCompose>`__ ::
   `ComposeMonad <Data-ComposeModel.html#t:ComposeMonad>`__ a
   `Connection <Data-SqlTransaction.html#t:Connection>`__ a -> Handler
   `App <Application.html#t:App>`__ `App <Application.html#t:App>`__
   (HashMap String `InRule <Data-InRules.html#t:InRule>`__)
-  `withLockBlock <#v:withLockBlock>`__ :: Show a => Namespace -> a ->
   Handler `App <Application.html#t:App>`__
   `Lock <LockSnaplet.html#t:Lock>`__ b -> Handler
   `App <Application.html#t:App>`__ `App <Application.html#t:App>`__ b
-  `withLockNonBlock <#v:withLockNonBlock>`__ :: Show a => Namespace ->
   a -> Handler `App <Application.html#t:App>`__
   `Lock <LockSnaplet.html#t:Lock>`__ () -> Handler
   `App <Application.html#t:App>`__ `App <Application.html#t:App>`__ ()
-  `getLock <#v:getLock>`__ ::
   `Application <Application.html#t:Application>`__
   `Lock <LockSnaplet.html#t:Lock>`__

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

\_db :: Snaplet
`SqlTransactionConfig <SqlTransactionSnaplet.html#t:SqlTransactionConfig>`__
     
\_config :: Snaplet
`ConfigSnaplet <ConfigSnaplet.html#t:ConfigSnaplet>`__
     
\_rnd :: Snaplet `RandomConfig <RandomSnaplet.html#t:RandomConfig>`__
     
\_nde :: Snaplet `DHTConfig <NodeSnapletTest.html#t:DHTConfig>`__
     
\_notf :: Snaplet
`NotificationConfig <NotificationSnaplet.html#t:NotificationConfig>`__
     
\_slock :: Snaplet `Lock <LockSnaplet.html#t:Lock>`__
     
\_logcycle :: Snaplet `Cycle <Data-ExternalLog.html#t:Cycle>`__
     

slock :: Lens' `App <Application.html#t:App>`__ (Snaplet
`Lock <LockSnaplet.html#t:Lock>`__)

rnd :: Lens' `App <Application.html#t:App>`__ (Snaplet
`RandomConfig <RandomSnaplet.html#t:RandomConfig>`__)

notf :: Lens' `App <Application.html#t:App>`__ (Snaplet
`NotificationConfig <NotificationSnaplet.html#t:NotificationConfig>`__)

nde :: Lens' `App <Application.html#t:App>`__ (Snaplet
`DHTConfig <NodeSnapletTest.html#t:DHTConfig>`__)

logcycle :: Lens' `App <Application.html#t:App>`__ (Snaplet
`Cycle <Data-ExternalLog.html#t:Cycle>`__)

db :: Lens' `App <Application.html#t:App>`__ (Snaplet
`SqlTransactionConfig <SqlTransactionSnaplet.html#t:SqlTransactionConfig>`__)

config :: Lens' `App <Application.html#t:App>`__ (Snaplet
`ConfigSnaplet <ConfigSnaplet.html#t:ConfigSnaplet>`__)

getUniqueKey :: `Application <Application.html#t:Application>`__
ByteString

runDb :: `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ b -> Handler
`App <Application.html#t:App>`__ `App <Application.html#t:App>`__ b

sendLetter :: (MonadState
`NotificationConfig <NotificationSnaplet.html#t:NotificationConfig>`__
(m b
`NotificationConfig <NotificationSnaplet.html#t:NotificationConfig>`__),
MonadState
`SqlTransactionConfig <SqlTransactionSnaplet.html#t:SqlTransactionConfig>`__
(m b
`SqlTransactionConfig <SqlTransactionSnaplet.html#t:SqlTransactionConfig>`__),
MonadSnaplet m, MonadSnap (m b
`SqlTransactionConfig <SqlTransactionSnaplet.html#t:SqlTransactionConfig>`__))
=> `UserId <Data-Notifications.html#t:UserId>`__ ->
`Letter <Data-Notifications.html#t:Letter>`__ -> m b
`App <Application.html#t:App>`__
`Letter <Data-Notifications.html#t:Letter>`__

setRead :: (MonadState
`NotificationConfig <NotificationSnaplet.html#t:NotificationConfig>`__
(m b
`NotificationConfig <NotificationSnaplet.html#t:NotificationConfig>`__),
MonadState
`SqlTransactionConfig <SqlTransactionSnaplet.html#t:SqlTransactionConfig>`__
(m b
`SqlTransactionConfig <SqlTransactionSnaplet.html#t:SqlTransactionConfig>`__),
MonadSnaplet m, MonadSnap (m b
`SqlTransactionConfig <SqlTransactionSnaplet.html#t:SqlTransactionConfig>`__))
=> `UserId <Data-Notifications.html#t:UserId>`__ -> Integer -> m b
`App <Application.html#t:App>`__ ()

setArchive :: (MonadState
`NotificationConfig <NotificationSnaplet.html#t:NotificationConfig>`__
(m b
`NotificationConfig <NotificationSnaplet.html#t:NotificationConfig>`__),
MonadState
`SqlTransactionConfig <SqlTransactionSnaplet.html#t:SqlTransactionConfig>`__
(m b
`SqlTransactionConfig <SqlTransactionSnaplet.html#t:SqlTransactionConfig>`__),
MonadSnaplet m, MonadSnap (m b
`SqlTransactionConfig <SqlTransactionSnaplet.html#t:SqlTransactionConfig>`__))
=> `UserId <Data-Notifications.html#t:UserId>`__ -> Integer -> m b
`App <Application.html#t:App>`__ ()

checkMailBox :: (MonadState
`NotificationConfig <NotificationSnaplet.html#t:NotificationConfig>`__
(m b
`NotificationConfig <NotificationSnaplet.html#t:NotificationConfig>`__),
MonadState
`SqlTransactionConfig <SqlTransactionSnaplet.html#t:SqlTransactionConfig>`__
(m b
`SqlTransactionConfig <SqlTransactionSnaplet.html#t:SqlTransactionConfig>`__),
MonadSnaplet m, MonadSnap (m b
`SqlTransactionConfig <SqlTransactionSnaplet.html#t:SqlTransactionConfig>`__))
=> `UserId <Data-Notifications.html#t:UserId>`__ -> m b
`App <Application.html#t:App>`__
`Letters <Data-Notifications.html#t:Letters>`__

type AppHandler = Handler `App <Application.html#t:App>`__
`App <Application.html#t:App>`__

type Application = `AppHandler <Application.html#t:AppHandler>`__

toAeson :: `InRule <Data-InRules.html#t:InRule>`__ -> ByteString

writeAeson :: `ToInRule <Data-InRules.html#t:ToInRule>`__ a => a ->
`Application <Application.html#t:Application>`__ ()

Write Aeson to user

writeError :: `ToInRule <Data-InRules.html#t:ToInRule>`__ a => a ->
`Application <Application.html#t:Application>`__ ()

Write an error to the http client

writeResult :: `ToInRule <Data-InRules.html#t:ToInRule>`__ a => a ->
`Application <Application.html#t:Application>`__ ()

Write a InRule to the http client

writeResult' :: ToJSON a => a ->
`Application <Application.html#t:Application>`__ ()

Write a JSON to the http client

writeMapable :: `Mapable <Model-General.html#t:Mapable>`__ a => a ->
`Application <Application.html#t:Application>`__ ()

Write a mapable to the client

writeMapables :: `Mapable <Model-General.html#t:Mapable>`__ a => [a] ->
`Application <Application.html#t:Application>`__ ()

Write multiple mapables as a json array

getUserId :: `Application <Application.html#t:Application>`__ Integer

get the user id from the proxy

getOParam :: ByteString ->
`Application <Application.html#t:Application>`__ ByteString

get a GET param faults when param doesn't exist

type SqlMap = HashMap String
`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__

getJson :: `Application <Application.html#t:Application>`__
`SqlMap <Application.html#t:SqlMap>`__

get json in the form of a ``SqlMap``

getJsons :: `Application <Application.html#t:Application>`__
[`SqlMap <Application.html#t:SqlMap>`__\ ]

Get multiple jsons as a ``SqlMap``

getPagesWithDTDOrdered

Arguments

:: [String]

Allowed order fields

-> `DTD <Data-DatabaseTemplate.html#t:DTD>`__

search expression

-> `Application <Application.html#t:Application>`__ (((Integer,
Integer), `Constraints <Data-Database.html#t:Constraints>`__),
`Orders <Data-Database.html#t:Orders>`__)

 

Generates a constraint and returns an (((limit, offset),
Constraints),Orders)

getPagesWithDTDOrderedAndParams

Arguments

:: `SqlMap <Application.html#t:SqlMap>`__

Default values

-> [String]

Allowed ordered fields

-> `DTD <Data-DatabaseTemplate.html#t:DTD>`__

search expression, see ``DatabaseTemplate``

-> `Application <Application.html#t:Application>`__ (((Integer,
Integer), `Constraints <Data-Database.html#t:Constraints>`__),
`Orders <Data-Database.html#t:Orders>`__)

 

Same as ``getPagsWithDTDOrdered``, only then provide default values

getPagesWithDTD :: `DTD <Data-DatabaseTemplate.html#t:DTD>`__ ->
`Application <Application.html#t:Application>`__ ((Integer, Integer),
`Constraints <Data-Database.html#t:Constraints>`__)

Generate a constraint and a limit and offset

addRole :: (MonadIO (m b
`DHTConfig <NodeSnapletTest.html#t:DHTConfig>`__), MonadState
`DHTConfig <NodeSnapletTest.html#t:DHTConfig>`__ (m b
`DHTConfig <NodeSnapletTest.html#t:DHTConfig>`__), MonadSnaplet m) =>
`Id <Data-Role.html#t:Id>`__ -> ByteString -> m b
`App <Application.html#t:App>`__ `Proto <ProtoExtended.html#t:Proto>`__

Add a role to a user id

writeError' :: ToJSON a => a ->
`Application <Application.html#t:Application>`__ ()

write an json error

writeAeson' :: ToJSON a => a ->
`Application <Application.html#t:Application>`__ ()

Write an error to the client

internalError :: String ->
`Application <Application.html#t:Application>`__ a

Throws an internal error code 500

runCompose :: `ComposeMonad <Data-ComposeModel.html#t:ComposeMonad>`__ a
`Connection <Data-SqlTransaction.html#t:Connection>`__ a -> Handler
`App <Application.html#t:App>`__ `App <Application.html#t:App>`__
(HashMap String `InRule <Data-InRules.html#t:InRule>`__)

Run a composemonad in the SqlTransaction monad

withLockBlock :: Show a => Namespace -> a -> Handler
`App <Application.html#t:App>`__ `Lock <LockSnaplet.html#t:Lock>`__ b ->
Handler `App <Application.html#t:App>`__
`App <Application.html#t:App>`__ b

Do an SqlTransaction action with a non blocking lock

withLockNonBlock :: Show a => Namespace -> a -> Handler
`App <Application.html#t:App>`__ `Lock <LockSnaplet.html#t:Lock>`__ ()
-> Handler `App <Application.html#t:App>`__
`App <Application.html#t:App>`__ ()

Do a SqlTransaction with a blocking lock

getLock :: `Application <Application.html#t:Application>`__
`Lock <LockSnaplet.html#t:Lock>`__

Retrieve the lock manager

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
