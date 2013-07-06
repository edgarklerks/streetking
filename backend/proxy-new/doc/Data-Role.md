% Data.Role
% 
% 

-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Data.Role

Synopsis

-   type [RolePair](#t:RolePair) k =
    ([TimedMap](Data-TimedMap.html#t:TimedMap) k
    [[Role](Data-Role.html#t:Role)],
    [RoleSetMap](Data-Role.html#t:RoleSetMap))
-   data [RoleSetFile](#t:RoleSetFile)
    -   = [Roles](#v:Roles) [String]
        [[RoleSetFile](Data-Role.html#t:RoleSetFile)]
    -   | [Resource](#v:Resource) String [String]

-   data [RestRight](#t:RestRight)
    -   = [Put](#v:Put)
    -   | [Get](#v:Get)
    -   | [Post](#v:Post)
    -   | [Delete](#v:Delete)

-   newtype [RoleSetMap](#t:RoleSetMap) = [RSM](#v:RSM) {
    -   [unRSM](#v:unRSM) :: TVar [RoleSet](Data-Role.html#t:RoleSet)

    }
-   type [Resource](#t:Resource) = String
-   type [Id](#t:Id) = Integer
-   data [Role](#t:Role)
    -   = [Developer](#v:Developer) (Maybe [Id](Data-Role.html#t:Id))
    -   | [User](#v:User) (Maybe [Id](Data-Role.html#t:Id))
    -   | [Server](#v:Server) (Maybe [Id](Data-Role.html#t:Id))
    -   | [All](#v:All)

-   data [OpaqueRole](#t:OpaqueRole)
    -   = [ODeveloper](#v:ODeveloper)
    -   | [OUser](#v:OUser)
    -   | [OServer](#v:OServer)
    -   | [OAll](#v:OAll)

-   [viewOpaque](#v:viewOpaque) :: [Role](Data-Role.html#t:Role) -\>
    [OpaqueRole](Data-Role.html#t:OpaqueRole)
-   newtype [RoleSet](#t:RoleSet) = [RS](#v:RS) {
    -   [unRS](#v:unRS) :: Map [Resource](Data-Role.html#t:Resource)
        (Map [Role](Data-Role.html#t:Role)
        [[RestRight](Data-Role.html#t:RestRight)])

    }
-   [initRP](#v:initRP) :: MonadIO m =\> FilePath -\> m
    ([RolePair](Data-Role.html#t:RolePair) ByteString)
-   [fileStore](#v:fileStore) :: FilePath -\>
    [TimedMapStore](Data-TimedMap.html#t:TimedMapStore) ByteString
    [[Role](Data-Role.html#t:Role)]
-   [fileRestore](#v:fileRestore) :: FilePath -\>
    [TimedMapRestore](Data-TimedMap.html#t:TimedMapRestore) ByteString
    [[Role](Data-Role.html#t:Role)]
-   [voidStore](#v:voidStore) :: Ord k =\>
    [TimedMapStore](Data-TimedMap.html#t:TimedMapStore) k a
-   [voidRestore](#v:voidRestore) :: Ord k =\>
    [TimedMapRestore](Data-TimedMap.html#t:TimedMapRestore) k a
-   [getRoles](#v:getRoles) :: MonadIO m =\>
    [RolePair](Data-Role.html#t:RolePair) ByteString -\> ByteString -\>
    m [[Role](Data-Role.html#t:Role)]
-   [updateTimeRole](#v:updateTimeRole) :: MonadIO m =\>
    [RolePair](Data-Role.html#t:RolePair) ByteString -\> ByteString -\>
    m ()
-   [may](#v:may) :: MonadIO m =\> [RolePair](Data-Role.html#t:RolePair)
    ByteString -\> [Resource](Data-Role.html#t:Resource) -\>
    [Role](Data-Role.html#t:Role) -\>
    [RestRight](Data-Role.html#t:RestRight) -\> m Bool
-   [addRole](#v:addRole) :: MonadIO m =\>
    [RolePair](Data-Role.html#t:RolePair) ByteString -\> ByteString -\>
    [Role](Data-Role.html#t:Role) -\> m ()
-   [dropRoles](#v:dropRoles) :: MonadIO m =\>
    [RolePair](Data-Role.html#t:RolePair) ByteString -\> ByteString -\>
    m ()
-   [runCleanup](#v:runCleanup) :: [RolePair](Data-Role.html#t:RolePair)
    ByteString -\> Int64 -\> IO ()
-   [initCleanup](#v:initCleanup) ::
    [RolePair](Data-Role.html#t:RolePair) ByteString -\> Int64 -\> IO
    ThreadId
-   [initStore](#v:initStore) :: [RolePair](Data-Role.html#t:RolePair)
    ByteString -\> [TimedMapStore](Data-TimedMap.html#t:TimedMapStore)
    ByteString [[Role](Data-Role.html#t:Role)] -\> IO ThreadId
-   [runRestore](#v:runRestore) :: [RolePair](Data-Role.html#t:RolePair)
    ByteString -\>
    [TimedMapRestore](Data-TimedMap.html#t:TimedMapRestore) ByteString
    [[Role](Data-Role.html#t:Role)] -\> IO ()
-   [dumpAll](#v:dumpAll) :: MonadIO m =\>
    [RolePair](Data-Role.html#t:RolePair) ByteString -\> m String
-   [may'](#v:may-39-) :: [RoleSet](Data-Role.html#t:RoleSet) -\>
    [Resource](Data-Role.html#t:Resource) -\>
    [Role](Data-Role.html#t:Role) -\>
    [RestRight](Data-Role.html#t:RestRight) -\> Bool
-   [roleSet](#v:roleSet) :: Parser
    [RoleSetFile](Data-Role.html#t:RoleSetFile)
-   [roleResources](#v:roleResources) :: Parser [(String, [String])]
-   [roleHeader](#v:roleHeader) :: Parser [String]
-   [resourceRule](#v:resourceRule) :: Parser (String, [String])
-   [hsep](#v:hsep) :: Parser Char
-   [defs](#v:defs) :: Parser String
-   [vsepB](#v:vsepB) :: Parser Char
-   [vsepH0](#v:vsepH0) :: Parser String
-   [vsepH](#v:vsepH) :: Parser String
-   [roles](#v:roles) :: Parser String
-   [identifier](#v:identifier) :: Parser Char
-   [zipRoleSet](#v:zipRoleSet) ::
    [RoleSetFile](Data-Role.html#t:RoleSetFile) -\>
    [RoleSet](Data-Role.html#t:RoleSet)
-   [readRole](#v:readRole) :: String -\> [Role](Data-Role.html#t:Role)

Documentation
=============

type RolePair k = ([TimedMap](Data-TimedMap.html#t:TimedMap) k
[[Role](Data-Role.html#t:Role)],
[RoleSetMap](Data-Role.html#t:RoleSetMap))

data RoleSetFile

Constructors

  -------------------------------------------------------------- ---
  Roles [String] [[RoleSetFile](Data-Role.html#t:RoleSetFile)]    
  Resource String [String]                                        
  -------------------------------------------------------------- ---

Instances

  -------------------------------------------------- ---
  Show [RoleSetFile](Data-Role.html#t:RoleSetFile)    
  -------------------------------------------------- ---

data RestRight

Constructors

  -------- ---
  Put       
  Get       
  Post      
  Delete    
  -------- ---

Instances

  ---------------------------------------------- ---
  Eq [RestRight](Data-Role.html#t:RestRight)      
  Show [RestRight](Data-Role.html#t:RestRight)    
  ---------------------------------------------- ---

newtype RoleSetMap

Constructors

RSM

 

Fields

unRSM :: TVar [RoleSet](Data-Role.html#t:RoleSet)
:    

type Resource = String

type Id = Integer

data Role

Constructors

  --------------------------------------------- ---
  Developer (Maybe [Id](Data-Role.html#t:Id))    
  User (Maybe [Id](Data-Role.html#t:Id))         
  Server (Maybe [Id](Data-Role.html#t:Id))       
  All                                            
  --------------------------------------------- ---

Instances

  -------------------------------------- ---
  Eq [Role](Data-Role.html#t:Role)        
  Ord [Role](Data-Role.html#t:Role)       
  Read [Role](Data-Role.html#t:Role)      
  Show [Role](Data-Role.html#t:Role)      
  Binary [Role](Data-Role.html#t:Role)    
  -------------------------------------- ---

data OpaqueRole

Constructors

  ------------ ---
  ODeveloper    
  OUser         
  OServer       
  OAll          
  ------------ ---

Instances

  ------------------------------------------------ ---
  Eq [OpaqueRole](Data-Role.html#t:OpaqueRole)      
  Ord [OpaqueRole](Data-Role.html#t:OpaqueRole)     
  Show [OpaqueRole](Data-Role.html#t:OpaqueRole)    
  ------------------------------------------------ ---

viewOpaque :: [Role](Data-Role.html#t:Role) -\>
[OpaqueRole](Data-Role.html#t:OpaqueRole)

newtype RoleSet

Constructors

RS

 

Fields

unRS :: Map [Resource](Data-Role.html#t:Resource) (Map [Role](Data-Role.html#t:Role) [[RestRight](Data-Role.html#t:RestRight)])
:    

Instances

  ------------------------------------------ ---
  Show [RoleSet](Data-Role.html#t:RoleSet)    
  ------------------------------------------ ---

initRP :: MonadIO m =\> FilePath -\> m
([RolePair](Data-Role.html#t:RolePair) ByteString)

fileStore :: FilePath -\>
[TimedMapStore](Data-TimedMap.html#t:TimedMapStore) ByteString
[[Role](Data-Role.html#t:Role)]

File store handler

fileRestore :: FilePath -\>
[TimedMapRestore](Data-TimedMap.html#t:TimedMapRestore) ByteString
[[Role](Data-Role.html#t:Role)]

File restore handler

voidStore :: Ord k =\>
[TimedMapStore](Data-TimedMap.html#t:TimedMapStore) k a

Empty Store handler

voidRestore :: Ord k =\>
[TimedMapRestore](Data-TimedMap.html#t:TimedMapRestore) k a

Empty Restore handler

getRoles :: MonadIO m =\> [RolePair](Data-Role.html#t:RolePair)
ByteString -\> ByteString -\> m [[Role](Data-Role.html#t:Role)]

Retrieve all the roles from a RoleState from the given token.

updateTimeRole :: MonadIO m =\> [RolePair](Data-Role.html#t:RolePair)
ByteString -\> ByteString -\> m ()

may :: MonadIO m =\> [RolePair](Data-Role.html#t:RolePair) ByteString
-\> [Resource](Data-Role.html#t:Resource) -\>
[Role](Data-Role.html#t:Role) -\>
[RestRight](Data-Role.html#t:RestRight) -\> m Bool

Lookup from the RoleState if a user may access a resource as role with
restright

addRole :: MonadIO m =\> [RolePair](Data-Role.html#t:RolePair)
ByteString -\> ByteString -\> [Role](Data-Role.html#t:Role) -\> m ()

Adds a role to the RoleState under the given token.

dropRoles :: MonadIO m =\> [RolePair](Data-Role.html#t:RolePair)
ByteString -\> ByteString -\> m ()

Drop all the roles from token in the RoleState

runCleanup :: [RolePair](Data-Role.html#t:RolePair) ByteString -\> Int64
-\> IO ()

Cleanup all expired tokens

initCleanup :: [RolePair](Data-Role.html#t:RolePair) ByteString -\>
Int64 -\> IO ThreadId

Start separated thread to cleanup all tokens wich are expired

initStore :: [RolePair](Data-Role.html#t:RolePair) ByteString -\>
[TimedMapStore](Data-TimedMap.html#t:TimedMapStore) ByteString
[[Role](Data-Role.html#t:Role)] -\> IO ThreadId

Start the storing thread, which periodically stores the whole RoleState
with the given handler

runRestore :: [RolePair](Data-Role.html#t:RolePair) ByteString -\>
[TimedMapRestore](Data-TimedMap.html#t:TimedMapRestore) ByteString
[[Role](Data-Role.html#t:Role)] -\> IO ()

Restore the roleState from the given handler

dumpAll :: MonadIO m =\> [RolePair](Data-Role.html#t:RolePair)
ByteString -\> m String

Debug function to dump the internal state

may' :: [RoleSet](Data-Role.html#t:RoleSet) -\>
[Resource](Data-Role.html#t:Resource) -\> [Role](Data-Role.html#t:Role)
-\> [RestRight](Data-Role.html#t:RestRight) -\> Bool

Pure function to lookup from a RoleSet if a Role can acces a resource
under the given rights

roleSet :: Parser [RoleSetFile](Data-Role.html#t:RoleSetFile)

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

zipRoleSet :: [RoleSetFile](Data-Role.html#t:RoleSetFile) -\>
[RoleSet](Data-Role.html#t:RoleSet)

readRole :: String -\> [Role](Data-Role.html#t:Role)

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
