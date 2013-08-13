===========
RoleSnaplet
===========

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

RoleSnaplet

Synopsis

-  `may <#v:may>`__ :: (MonadState
   `DHTConfig <NodeSnapletTest.html#t:DHTConfig>`__ (m b
   `DHTConfig <NodeSnapletTest.html#t:DHTConfig>`__), MonadState
   `RoleSnaplet <RoleSnaplet.html#t:RoleSnaplet>`__ (m b
   `RoleSnaplet <RoleSnaplet.html#t:RoleSnaplet>`__), MonadState
   `Cycle <Data-ExternalLog.html#t:Cycle>`__ (m b
   `Cycle <Data-ExternalLog.html#t:Cycle>`__), MonadIO (m b
   `DHTConfig <NodeSnapletTest.html#t:DHTConfig>`__), MonadIO (m b
   `Cycle <Data-ExternalLog.html#t:Cycle>`__), MonadSnaplet m, MonadSnap
   (m b `RoleSnaplet <RoleSnaplet.html#t:RoleSnaplet>`__)) =>
   `Resource <RoleSnaplet.html#t:Resource>`__ ->
   `RestRight <RoleSnaplet.html#t:RestRight>`__ -> m b
   `RoleSnaplet <RoleSnaplet.html#t:RoleSnaplet>`__ Bool
-  `addRole <#v:addRole>`__ :: (MonadState
   `DHTConfig <NodeSnapletTest.html#t:DHTConfig>`__ (m b
   `DHTConfig <NodeSnapletTest.html#t:DHTConfig>`__), MonadState
   `Cycle <Data-ExternalLog.html#t:Cycle>`__ (m b
   `Cycle <Data-ExternalLog.html#t:Cycle>`__), MonadState
   `RandomConfig <RandomSnaplet.html#t:RandomConfig>`__ (m b
   `RandomConfig <RandomSnaplet.html#t:RandomConfig>`__), MonadState
   `RoleSnaplet <RoleSnaplet.html#t:RoleSnaplet>`__ (m b
   `RoleSnaplet <RoleSnaplet.html#t:RoleSnaplet>`__), MonadIO (m b
   `DHTConfig <NodeSnapletTest.html#t:DHTConfig>`__), MonadIO (m b
   `Cycle <Data-ExternalLog.html#t:Cycle>`__), MonadIO (m b
   `RandomConfig <RandomSnaplet.html#t:RandomConfig>`__), Binary a,
   MonadSnaplet m, MonadSnap (m b
   `RoleSnaplet <RoleSnaplet.html#t:RoleSnaplet>`__)) => ByteString -> a
   -> m b `RoleSnaplet <RoleSnaplet.html#t:RoleSnaplet>`__ ()
-  `withRoleState <#v:withRoleState>`__ :: MonadState
   `RoleSnaplet <RoleSnaplet.html#t:RoleSnaplet>`__ m =>
   (`RolePair <Data-Role.html#t:RolePair>`__ ByteString -> m a) -> m a
-  `dumpAll <#v:dumpAll>`__ :: MonadIO m =>
   `RolePair <Data-Role.html#t:RolePair>`__ ByteString -> m String
-  data `Role <#t:Role>`__

   -  = `Developer <#v:Developer>`__ (Maybe
      `Id <RoleSnaplet.html#t:Id>`__)
   -  \| `User <#v:User>`__ (Maybe `Id <RoleSnaplet.html#t:Id>`__)
   -  \| `Server <#v:Server>`__ (Maybe `Id <RoleSnaplet.html#t:Id>`__)
   -  \| `All <#v:All>`__

-  data `RestRight <#t:RestRight>`__

   -  = `Put <#v:Put>`__
   -  \| `Get <#v:Get>`__
   -  \| `Post <#v:Post>`__
   -  \| `Delete <#v:Delete>`__

-  type `Resource <#t:Resource>`__ = String
-  `dropRoles <#v:dropRoles>`__ :: (MonadState
   `RoleSnaplet <RoleSnaplet.html#t:RoleSnaplet>`__ m, MonadSnap m) =>
   ByteString -> m ()
-  `getRoles <#v:getRoles>`__ :: (MonadState
   `DHTConfig <NodeSnapletTest.html#t:DHTConfig>`__ (m b
   `DHTConfig <NodeSnapletTest.html#t:DHTConfig>`__), MonadState
   `Cycle <Data-ExternalLog.html#t:Cycle>`__ (m b
   `Cycle <Data-ExternalLog.html#t:Cycle>`__), MonadIO (m b
   `DHTConfig <NodeSnapletTest.html#t:DHTConfig>`__), MonadIO (m b
   `Cycle <Data-ExternalLog.html#t:Cycle>`__), MonadSnaplet m, MonadSnap
   (m b `RoleSnaplet <RoleSnaplet.html#t:RoleSnaplet>`__)) => ByteString
   -> m b `RoleSnaplet <RoleSnaplet.html#t:RoleSnaplet>`__
   [`Role <RoleSnaplet.html#t:Role>`__\ ]
-  type `Id <#t:Id>`__ = Integer
-  data `RoleSnaplet <#t:RoleSnaplet>`__ =
   `RoleSnaplet <#v:RoleSnaplet>`__ {

   -  `runRS <#v:runRS>`__ :: `RolePair <Data-Role.html#t:RolePair>`__
      ByteString
   -  `\_random <#v:_random>`__ :: Snaplet
      `RandomConfig <RandomSnaplet.html#t:RandomConfig>`__
   -  `\_dht <#v:_dht>`__ :: Snaplet
      `DHTConfig <NodeSnapletTest.html#t:DHTConfig>`__
   -  `\_log\_cycler <#v:_log_cycler>`__ :: Snaplet
      `Cycle <Data-ExternalLog.html#t:Cycle>`__

   }
-  class `HasRoleSnaplet <#t:HasRoleSnaplet>`__ b where

   -  `roleLens <#v:roleLens>`__ :: SnapletLens (Snaplet b) (Snaplet
      `RoleSnaplet <RoleSnaplet.html#t:RoleSnaplet>`__)

-  `initRoleSnaplet <#v:initRoleSnaplet>`__ :: Snaplet
   `RandomConfig <RandomSnaplet.html#t:RandomConfig>`__ -> Snaplet
   `DHTConfig <NodeSnapletTest.html#t:DHTConfig>`__ -> Snaplet
   `Cycle <Data-ExternalLog.html#t:Cycle>`__ -> SnapletInit b
   `RoleSnaplet <RoleSnaplet.html#t:RoleSnaplet>`__

Documentation
=============

may :: (MonadState `DHTConfig <NodeSnapletTest.html#t:DHTConfig>`__ (m b
`DHTConfig <NodeSnapletTest.html#t:DHTConfig>`__), MonadState
`RoleSnaplet <RoleSnaplet.html#t:RoleSnaplet>`__ (m b
`RoleSnaplet <RoleSnaplet.html#t:RoleSnaplet>`__), MonadState
`Cycle <Data-ExternalLog.html#t:Cycle>`__ (m b
`Cycle <Data-ExternalLog.html#t:Cycle>`__), MonadIO (m b
`DHTConfig <NodeSnapletTest.html#t:DHTConfig>`__), MonadIO (m b
`Cycle <Data-ExternalLog.html#t:Cycle>`__), MonadSnaplet m, MonadSnap (m
b `RoleSnaplet <RoleSnaplet.html#t:RoleSnaplet>`__)) =>
`Resource <RoleSnaplet.html#t:Resource>`__ ->
`RestRight <RoleSnaplet.html#t:RestRight>`__ -> m b
`RoleSnaplet <RoleSnaplet.html#t:RoleSnaplet>`__ Bool

addRole :: (MonadState `DHTConfig <NodeSnapletTest.html#t:DHTConfig>`__
(m b `DHTConfig <NodeSnapletTest.html#t:DHTConfig>`__), MonadState
`Cycle <Data-ExternalLog.html#t:Cycle>`__ (m b
`Cycle <Data-ExternalLog.html#t:Cycle>`__), MonadState
`RandomConfig <RandomSnaplet.html#t:RandomConfig>`__ (m b
`RandomConfig <RandomSnaplet.html#t:RandomConfig>`__), MonadState
`RoleSnaplet <RoleSnaplet.html#t:RoleSnaplet>`__ (m b
`RoleSnaplet <RoleSnaplet.html#t:RoleSnaplet>`__), MonadIO (m b
`DHTConfig <NodeSnapletTest.html#t:DHTConfig>`__), MonadIO (m b
`Cycle <Data-ExternalLog.html#t:Cycle>`__), MonadIO (m b
`RandomConfig <RandomSnaplet.html#t:RandomConfig>`__), Binary a,
MonadSnaplet m, MonadSnap (m b
`RoleSnaplet <RoleSnaplet.html#t:RoleSnaplet>`__)) => ByteString -> a ->
m b `RoleSnaplet <RoleSnaplet.html#t:RoleSnaplet>`__ ()

withRoleState :: MonadState
`RoleSnaplet <RoleSnaplet.html#t:RoleSnaplet>`__ m =>
(`RolePair <Data-Role.html#t:RolePair>`__ ByteString -> m a) -> m a

dumpAll :: MonadIO m => `RolePair <Data-Role.html#t:RolePair>`__
ByteString -> m String

Debug function to dump the internal state

data Role

Constructors

+----------------------------------------------------+-----+
| Developer (Maybe `Id <RoleSnaplet.html#t:Id>`__)   |     |
+----------------------------------------------------+-----+
| User (Maybe `Id <RoleSnaplet.html#t:Id>`__)        |     |
+----------------------------------------------------+-----+
| Server (Maybe `Id <RoleSnaplet.html#t:Id>`__)      |     |
+----------------------------------------------------+-----+
| All                                                |     |
+----------------------------------------------------+-----+

Instances

+---------------------------------------------+-----+
| Eq `Role <RoleSnaplet.html#t:Role>`__       |     |
+---------------------------------------------+-----+
| Ord `Role <RoleSnaplet.html#t:Role>`__      |     |
+---------------------------------------------+-----+
| Read `Role <RoleSnaplet.html#t:Role>`__     |     |
+---------------------------------------------+-----+
| Show `Role <RoleSnaplet.html#t:Role>`__     |     |
+---------------------------------------------+-----+
| Binary `Role <RoleSnaplet.html#t:Role>`__   |     |
+---------------------------------------------+-----+

data RestRight

Constructors

+----------+-----+
| Put      |     |
+----------+-----+
| Get      |     |
+----------+-----+
| Post     |     |
+----------+-----+
| Delete   |     |
+----------+-----+

Instances

+-----------------------------------------------------+-----+
| Eq `RestRight <RoleSnaplet.html#t:RestRight>`__     |     |
+-----------------------------------------------------+-----+
| Show `RestRight <RoleSnaplet.html#t:RestRight>`__   |     |
+-----------------------------------------------------+-----+

type Resource = String

dropRoles :: (MonadState
`RoleSnaplet <RoleSnaplet.html#t:RoleSnaplet>`__ m, MonadSnap m) =>
ByteString -> m ()

getRoles :: (MonadState `DHTConfig <NodeSnapletTest.html#t:DHTConfig>`__
(m b `DHTConfig <NodeSnapletTest.html#t:DHTConfig>`__), MonadState
`Cycle <Data-ExternalLog.html#t:Cycle>`__ (m b
`Cycle <Data-ExternalLog.html#t:Cycle>`__), MonadIO (m b
`DHTConfig <NodeSnapletTest.html#t:DHTConfig>`__), MonadIO (m b
`Cycle <Data-ExternalLog.html#t:Cycle>`__), MonadSnaplet m, MonadSnap (m
b `RoleSnaplet <RoleSnaplet.html#t:RoleSnaplet>`__)) => ByteString -> m
b `RoleSnaplet <RoleSnaplet.html#t:RoleSnaplet>`__
[`Role <RoleSnaplet.html#t:Role>`__\ ]

type Id = Integer

data RoleSnaplet

Constructors

RoleSnaplet

 

Fields

runRS :: `RolePair <Data-Role.html#t:RolePair>`__ ByteString
     
\_random :: Snaplet `RandomConfig <RandomSnaplet.html#t:RandomConfig>`__
     
\_dht :: Snaplet `DHTConfig <NodeSnapletTest.html#t:DHTConfig>`__
     
\_log\_cycler :: Snaplet `Cycle <Data-ExternalLog.html#t:Cycle>`__
     

class HasRoleSnaplet b where

Methods

roleLens :: SnapletLens (Snaplet b) (Snaplet
`RoleSnaplet <RoleSnaplet.html#t:RoleSnaplet>`__)

initRoleSnaplet :: Snaplet
`RandomConfig <RandomSnaplet.html#t:RandomConfig>`__ -> Snaplet
`DHTConfig <NodeSnapletTest.html#t:DHTConfig>`__ -> Snaplet
`Cycle <Data-ExternalLog.html#t:Cycle>`__ -> SnapletInit b
`RoleSnaplet <RoleSnaplet.html#t:RoleSnaplet>`__

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
