=========
Data.Role
=========

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Data.Role

Synopsis

-  type `RolePair <#t:RolePair>`__ k =
   (`TimedMap <Data-TimedMap.html#t:TimedMap>`__ k
   [`Role <Data-Role.html#t:Role>`__\ ],
   `RoleSetMap <Data-Role.html#t:RoleSetMap>`__)
-  data `RoleSetFile <#t:RoleSetFile>`__

   -  = `Roles <#v:Roles>`__ [String]
      [`RoleSetFile <Data-Role.html#t:RoleSetFile>`__\ ]
   -  \| `Resource <#v:Resource>`__ String [String]

-  data `RestRight <#t:RestRight>`__

   -  = `Put <#v:Put>`__
   -  \| `Get <#v:Get>`__
   -  \| `Post <#v:Post>`__
   -  \| `Delete <#v:Delete>`__

-  newtype `RoleSetMap <#t:RoleSetMap>`__ = `RSM <#v:RSM>`__ {

   -  `unRSM <#v:unRSM>`__ :: TVar
      `RoleSet <Data-Role.html#t:RoleSet>`__

   }
-  type `Resource <#t:Resource>`__ = String
-  type `Id <#t:Id>`__ = Integer
-  data `Role <#t:Role>`__

   -  = `Developer <#v:Developer>`__ (Maybe
      `Id <Data-Role.html#t:Id>`__)
   -  \| `User <#v:User>`__ (Maybe `Id <Data-Role.html#t:Id>`__)
   -  \| `Server <#v:Server>`__ (Maybe `Id <Data-Role.html#t:Id>`__)
   -  \| `All <#v:All>`__

-  data `OpaqueRole <#t:OpaqueRole>`__

   -  = `ODeveloper <#v:ODeveloper>`__
   -  \| `OUser <#v:OUser>`__
   -  \| `OServer <#v:OServer>`__
   -  \| `OAll <#v:OAll>`__

-  `viewOpaque <#v:viewOpaque>`__ :: `Role <Data-Role.html#t:Role>`__ ->
   `OpaqueRole <Data-Role.html#t:OpaqueRole>`__
-  newtype `RoleSet <#t:RoleSet>`__ = `RS <#v:RS>`__ {

   -  `unRS <#v:unRS>`__ :: Map `Resource <Data-Role.html#t:Resource>`__
      (Map `Role <Data-Role.html#t:Role>`__
      [`RestRight <Data-Role.html#t:RestRight>`__\ ])

   }
-  `initRP <#v:initRP>`__ :: MonadIO m => FilePath -> m
   (`RolePair <Data-Role.html#t:RolePair>`__ ByteString)
-  `fileStore <#v:fileStore>`__ :: FilePath ->
   `TimedMapStore <Data-TimedMap.html#t:TimedMapStore>`__ ByteString
   [`Role <Data-Role.html#t:Role>`__\ ]
-  `fileRestore <#v:fileRestore>`__ :: FilePath ->
   `TimedMapRestore <Data-TimedMap.html#t:TimedMapRestore>`__ ByteString
   [`Role <Data-Role.html#t:Role>`__\ ]
-  `voidStore <#v:voidStore>`__ :: Ord k =>
   `TimedMapStore <Data-TimedMap.html#t:TimedMapStore>`__ k a
-  `voidRestore <#v:voidRestore>`__ :: Ord k =>
   `TimedMapRestore <Data-TimedMap.html#t:TimedMapRestore>`__ k a
-  `getRoles <#v:getRoles>`__ :: MonadIO m =>
   `RolePair <Data-Role.html#t:RolePair>`__ ByteString -> ByteString ->
   m [`Role <Data-Role.html#t:Role>`__\ ]
-  `updateTimeRole <#v:updateTimeRole>`__ :: MonadIO m =>
   `RolePair <Data-Role.html#t:RolePair>`__ ByteString -> ByteString ->
   m ()
-  `may <#v:may>`__ :: MonadIO m =>
   `RolePair <Data-Role.html#t:RolePair>`__ ByteString ->
   `Resource <Data-Role.html#t:Resource>`__ ->
   `Role <Data-Role.html#t:Role>`__ ->
   `RestRight <Data-Role.html#t:RestRight>`__ -> m Bool
-  `addRole <#v:addRole>`__ :: MonadIO m =>
   `RolePair <Data-Role.html#t:RolePair>`__ ByteString -> ByteString ->
   `Role <Data-Role.html#t:Role>`__ -> m ()
-  `dropRoles <#v:dropRoles>`__ :: MonadIO m =>
   `RolePair <Data-Role.html#t:RolePair>`__ ByteString -> ByteString ->
   m ()
-  `runCleanup <#v:runCleanup>`__ ::
   `RolePair <Data-Role.html#t:RolePair>`__ ByteString -> Int64 -> IO ()
-  `initCleanup <#v:initCleanup>`__ ::
   `RolePair <Data-Role.html#t:RolePair>`__ ByteString -> Int64 -> IO
   ThreadId
-  `initStore <#v:initStore>`__ ::
   `RolePair <Data-Role.html#t:RolePair>`__ ByteString ->
   `TimedMapStore <Data-TimedMap.html#t:TimedMapStore>`__ ByteString
   [`Role <Data-Role.html#t:Role>`__\ ] -> IO ThreadId
-  `runRestore <#v:runRestore>`__ ::
   `RolePair <Data-Role.html#t:RolePair>`__ ByteString ->
   `TimedMapRestore <Data-TimedMap.html#t:TimedMapRestore>`__ ByteString
   [`Role <Data-Role.html#t:Role>`__\ ] -> IO ()
-  `dumpAll <#v:dumpAll>`__ :: MonadIO m =>
   `RolePair <Data-Role.html#t:RolePair>`__ ByteString -> m String
-  `may' <#v:may-39->`__ :: `RoleSet <Data-Role.html#t:RoleSet>`__ ->
   `Resource <Data-Role.html#t:Resource>`__ ->
   `Role <Data-Role.html#t:Role>`__ ->
   `RestRight <Data-Role.html#t:RestRight>`__ -> Bool
-  `roleSet <#v:roleSet>`__ :: Parser
   `RoleSetFile <Data-Role.html#t:RoleSetFile>`__
-  `roleResources <#v:roleResources>`__ :: Parser [(String, [String])]
-  `roleHeader <#v:roleHeader>`__ :: Parser [String]
-  `resourceRule <#v:resourceRule>`__ :: Parser (String, [String])
-  `hsep <#v:hsep>`__ :: Parser Char
-  `defs <#v:defs>`__ :: Parser String
-  `vsepB <#v:vsepB>`__ :: Parser Char
-  `vsepH0 <#v:vsepH0>`__ :: Parser String
-  `vsepH <#v:vsepH>`__ :: Parser String
-  `roles <#v:roles>`__ :: Parser String
-  `identifier <#v:identifier>`__ :: Parser Char
-  `zipRoleSet <#v:zipRoleSet>`__ ::
   `RoleSetFile <Data-Role.html#t:RoleSetFile>`__ ->
   `RoleSet <Data-Role.html#t:RoleSet>`__
-  `readRole <#v:readRole>`__ :: String ->
   `Role <Data-Role.html#t:Role>`__

Documentation
=============

type RolePair k = (`TimedMap <Data-TimedMap.html#t:TimedMap>`__ k
[`Role <Data-Role.html#t:Role>`__\ ],
`RoleSetMap <Data-Role.html#t:RoleSetMap>`__)

data RoleSetFile

Constructors

+---------------------------------------------------------------------+-----+
| Roles [String] [`RoleSetFile <Data-Role.html#t:RoleSetFile>`__\ ]   |     |
+---------------------------------------------------------------------+-----+
| Resource String [String]                                            |     |
+---------------------------------------------------------------------+-----+

Instances

+-------------------------------------------------------+-----+
| Show `RoleSetFile <Data-Role.html#t:RoleSetFile>`__   |     |
+-------------------------------------------------------+-----+

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

+---------------------------------------------------+-----+
| Eq `RestRight <Data-Role.html#t:RestRight>`__     |     |
+---------------------------------------------------+-----+
| Show `RestRight <Data-Role.html#t:RestRight>`__   |     |
+---------------------------------------------------+-----+

newtype RoleSetMap

Constructors

RSM

 

Fields

unRSM :: TVar `RoleSet <Data-Role.html#t:RoleSet>`__
     

type Resource = String

type Id = Integer

data Role

Constructors

+--------------------------------------------------+-----+
| Developer (Maybe `Id <Data-Role.html#t:Id>`__)   |     |
+--------------------------------------------------+-----+
| User (Maybe `Id <Data-Role.html#t:Id>`__)        |     |
+--------------------------------------------------+-----+
| Server (Maybe `Id <Data-Role.html#t:Id>`__)      |     |
+--------------------------------------------------+-----+
| All                                              |     |
+--------------------------------------------------+-----+

Instances

+-------------------------------------------+-----+
| Eq `Role <Data-Role.html#t:Role>`__       |     |
+-------------------------------------------+-----+
| Ord `Role <Data-Role.html#t:Role>`__      |     |
+-------------------------------------------+-----+
| Read `Role <Data-Role.html#t:Role>`__     |     |
+-------------------------------------------+-----+
| Show `Role <Data-Role.html#t:Role>`__     |     |
+-------------------------------------------+-----+
| Binary `Role <Data-Role.html#t:Role>`__   |     |
+-------------------------------------------+-----+

data OpaqueRole

Constructors

+--------------+-----+
| ODeveloper   |     |
+--------------+-----+
| OUser        |     |
+--------------+-----+
| OServer      |     |
+--------------+-----+
| OAll         |     |
+--------------+-----+

Instances

+-----------------------------------------------------+-----+
| Eq `OpaqueRole <Data-Role.html#t:OpaqueRole>`__     |     |
+-----------------------------------------------------+-----+
| Ord `OpaqueRole <Data-Role.html#t:OpaqueRole>`__    |     |
+-----------------------------------------------------+-----+
| Show `OpaqueRole <Data-Role.html#t:OpaqueRole>`__   |     |
+-----------------------------------------------------+-----+

viewOpaque :: `Role <Data-Role.html#t:Role>`__ ->
`OpaqueRole <Data-Role.html#t:OpaqueRole>`__

newtype RoleSet

Constructors

RS

 

Fields

unRS :: Map `Resource <Data-Role.html#t:Resource>`__ (Map
`Role <Data-Role.html#t:Role>`__
[`RestRight <Data-Role.html#t:RestRight>`__\ ])
     

Instances

+-----------------------------------------------+-----+
| Show `RoleSet <Data-Role.html#t:RoleSet>`__   |     |
+-----------------------------------------------+-----+

initRP :: MonadIO m => FilePath -> m
(`RolePair <Data-Role.html#t:RolePair>`__ ByteString)

fileStore :: FilePath ->
`TimedMapStore <Data-TimedMap.html#t:TimedMapStore>`__ ByteString
[`Role <Data-Role.html#t:Role>`__\ ]

File store handler

fileRestore :: FilePath ->
`TimedMapRestore <Data-TimedMap.html#t:TimedMapRestore>`__ ByteString
[`Role <Data-Role.html#t:Role>`__\ ]

File restore handler

voidStore :: Ord k =>
`TimedMapStore <Data-TimedMap.html#t:TimedMapStore>`__ k a

Empty Store handler

voidRestore :: Ord k =>
`TimedMapRestore <Data-TimedMap.html#t:TimedMapRestore>`__ k a

Empty Restore handler

getRoles :: MonadIO m => `RolePair <Data-Role.html#t:RolePair>`__
ByteString -> ByteString -> m [`Role <Data-Role.html#t:Role>`__\ ]

Retrieve all the roles from a RoleState from the given token.

updateTimeRole :: MonadIO m => `RolePair <Data-Role.html#t:RolePair>`__
ByteString -> ByteString -> m ()

may :: MonadIO m => `RolePair <Data-Role.html#t:RolePair>`__ ByteString
-> `Resource <Data-Role.html#t:Resource>`__ ->
`Role <Data-Role.html#t:Role>`__ ->
`RestRight <Data-Role.html#t:RestRight>`__ -> m Bool

Lookup from the RoleState if a user may access a resource as role with
restright

addRole :: MonadIO m => `RolePair <Data-Role.html#t:RolePair>`__
ByteString -> ByteString -> `Role <Data-Role.html#t:Role>`__ -> m ()

Adds a role to the RoleState under the given token.

dropRoles :: MonadIO m => `RolePair <Data-Role.html#t:RolePair>`__
ByteString -> ByteString -> m ()

Drop all the roles from token in the RoleState

runCleanup :: `RolePair <Data-Role.html#t:RolePair>`__ ByteString ->
Int64 -> IO ()

Cleanup all expired tokens

initCleanup :: `RolePair <Data-Role.html#t:RolePair>`__ ByteString ->
Int64 -> IO ThreadId

Start separated thread to cleanup all tokens wich are expired

initStore :: `RolePair <Data-Role.html#t:RolePair>`__ ByteString ->
`TimedMapStore <Data-TimedMap.html#t:TimedMapStore>`__ ByteString
[`Role <Data-Role.html#t:Role>`__\ ] -> IO ThreadId

Start the storing thread, which periodically stores the whole RoleState
with the given handler

runRestore :: `RolePair <Data-Role.html#t:RolePair>`__ ByteString ->
`TimedMapRestore <Data-TimedMap.html#t:TimedMapRestore>`__ ByteString
[`Role <Data-Role.html#t:Role>`__\ ] -> IO ()

Restore the roleState from the given handler

dumpAll :: MonadIO m => `RolePair <Data-Role.html#t:RolePair>`__
ByteString -> m String

Debug function to dump the internal state

may' :: `RoleSet <Data-Role.html#t:RoleSet>`__ ->
`Resource <Data-Role.html#t:Resource>`__ ->
`Role <Data-Role.html#t:Role>`__ ->
`RestRight <Data-Role.html#t:RestRight>`__ -> Bool

Pure function to lookup from a RoleSet if a Role can acces a resource
under the given rights

roleSet :: Parser `RoleSetFile <Data-Role.html#t:RoleSetFile>`__

roleResources :: Parser [(String, [String])]

roleHeader :: Parser [String]

resourceRule :: Parser (String, [String])

hsep :: Parser Char

defs :: Parser String

vsepB :: Parser Char

vsepH0 :: Parser String

vsepH :: Parser String

roles :: Parser String

identifier :: Parser Char

zipRoleSet :: `RoleSetFile <Data-Role.html#t:RoleSetFile>`__ ->
`RoleSet <Data-Role.html#t:RoleSet>`__

readRole :: String -> `Role <Data-Role.html#t:Role>`__

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
