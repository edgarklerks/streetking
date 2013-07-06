% RoleSnaplet
% 
% 

-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

RoleSnaplet

Synopsis

-   [may](#v:may) :: (MonadState
    [DHTConfig](NodeSnapletTest.html#t:DHTConfig) (m b
    [DHTConfig](NodeSnapletTest.html#t:DHTConfig)), MonadState
    [RoleSnaplet](RoleSnaplet.html#t:RoleSnaplet) (m b
    [RoleSnaplet](RoleSnaplet.html#t:RoleSnaplet)), MonadState
    [Cycle](Data-ExternalLog.html#t:Cycle) (m b
    [Cycle](Data-ExternalLog.html#t:Cycle)), MonadIO (m b
    [DHTConfig](NodeSnapletTest.html#t:DHTConfig)), MonadIO (m b
    [Cycle](Data-ExternalLog.html#t:Cycle)), MonadSnaplet m, MonadSnap
    (m b [RoleSnaplet](RoleSnaplet.html#t:RoleSnaplet))) =\>
    [Resource](RoleSnaplet.html#t:Resource) -\>
    [RestRight](RoleSnaplet.html#t:RestRight) -\> m b
    [RoleSnaplet](RoleSnaplet.html#t:RoleSnaplet) Bool
-   [addRole](#v:addRole) :: (MonadState
    [DHTConfig](NodeSnapletTest.html#t:DHTConfig) (m b
    [DHTConfig](NodeSnapletTest.html#t:DHTConfig)), MonadState
    [Cycle](Data-ExternalLog.html#t:Cycle) (m b
    [Cycle](Data-ExternalLog.html#t:Cycle)), MonadState
    [RandomConfig](RandomSnaplet.html#t:RandomConfig) (m b
    [RandomConfig](RandomSnaplet.html#t:RandomConfig)), MonadState
    [RoleSnaplet](RoleSnaplet.html#t:RoleSnaplet) (m b
    [RoleSnaplet](RoleSnaplet.html#t:RoleSnaplet)), MonadIO (m b
    [DHTConfig](NodeSnapletTest.html#t:DHTConfig)), MonadIO (m b
    [Cycle](Data-ExternalLog.html#t:Cycle)), MonadIO (m b
    [RandomConfig](RandomSnaplet.html#t:RandomConfig)), Binary a,
    MonadSnaplet m, MonadSnap (m b
    [RoleSnaplet](RoleSnaplet.html#t:RoleSnaplet))) =\> ByteString -\> a
    -\> m b [RoleSnaplet](RoleSnaplet.html#t:RoleSnaplet) ()
-   [withRoleState](#v:withRoleState) :: MonadState
    [RoleSnaplet](RoleSnaplet.html#t:RoleSnaplet) m =\>
    ([RolePair](Data-Role.html#t:RolePair) ByteString -\> m a) -\> m a
-   [dumpAll](#v:dumpAll) :: MonadIO m =\>
    [RolePair](Data-Role.html#t:RolePair) ByteString -\> m String
-   data [Role](#t:Role)
    -   = [Developer](#v:Developer) (Maybe [Id](RoleSnaplet.html#t:Id))
    -   | [User](#v:User) (Maybe [Id](RoleSnaplet.html#t:Id))
    -   | [Server](#v:Server) (Maybe [Id](RoleSnaplet.html#t:Id))
    -   | [All](#v:All)

-   data [RestRight](#t:RestRight)
    -   = [Put](#v:Put)
    -   | [Get](#v:Get)
    -   | [Post](#v:Post)
    -   | [Delete](#v:Delete)

-   type [Resource](#t:Resource) = String
-   [dropRoles](#v:dropRoles) :: (MonadState
    [RoleSnaplet](RoleSnaplet.html#t:RoleSnaplet) m, MonadSnap m) =\>
    ByteString -\> m ()
-   [getRoles](#v:getRoles) :: (MonadState
    [DHTConfig](NodeSnapletTest.html#t:DHTConfig) (m b
    [DHTConfig](NodeSnapletTest.html#t:DHTConfig)), MonadState
    [Cycle](Data-ExternalLog.html#t:Cycle) (m b
    [Cycle](Data-ExternalLog.html#t:Cycle)), MonadIO (m b
    [DHTConfig](NodeSnapletTest.html#t:DHTConfig)), MonadIO (m b
    [Cycle](Data-ExternalLog.html#t:Cycle)), MonadSnaplet m, MonadSnap
    (m b [RoleSnaplet](RoleSnaplet.html#t:RoleSnaplet))) =\> ByteString
    -\> m b [RoleSnaplet](RoleSnaplet.html#t:RoleSnaplet)
    [[Role](RoleSnaplet.html#t:Role)]
-   type [Id](#t:Id) = Integer
-   data [RoleSnaplet](#t:RoleSnaplet) = [RoleSnaplet](#v:RoleSnaplet) {
    -   [runRS](#v:runRS) :: [RolePair](Data-Role.html#t:RolePair)
        ByteString
    -   [\_random](#v:_random) :: Snaplet
        [RandomConfig](RandomSnaplet.html#t:RandomConfig)
    -   [\_dht](#v:_dht) :: Snaplet
        [DHTConfig](NodeSnapletTest.html#t:DHTConfig)
    -   [\_log\_cycler](#v:_log_cycler) :: Snaplet
        [Cycle](Data-ExternalLog.html#t:Cycle)

    }
-   class [HasRoleSnaplet](#t:HasRoleSnaplet) b where
    -   [roleLens](#v:roleLens) :: SnapletLens (Snaplet b) (Snaplet
        [RoleSnaplet](RoleSnaplet.html#t:RoleSnaplet))

-   [initRoleSnaplet](#v:initRoleSnaplet) :: Snaplet
    [RandomConfig](RandomSnaplet.html#t:RandomConfig) -\> Snaplet
    [DHTConfig](NodeSnapletTest.html#t:DHTConfig) -\> Snaplet
    [Cycle](Data-ExternalLog.html#t:Cycle) -\> SnapletInit b
    [RoleSnaplet](RoleSnaplet.html#t:RoleSnaplet)

Documentation
=============

may :: (MonadState [DHTConfig](NodeSnapletTest.html#t:DHTConfig) (m b
[DHTConfig](NodeSnapletTest.html#t:DHTConfig)), MonadState
[RoleSnaplet](RoleSnaplet.html#t:RoleSnaplet) (m b
[RoleSnaplet](RoleSnaplet.html#t:RoleSnaplet)), MonadState
[Cycle](Data-ExternalLog.html#t:Cycle) (m b
[Cycle](Data-ExternalLog.html#t:Cycle)), MonadIO (m b
[DHTConfig](NodeSnapletTest.html#t:DHTConfig)), MonadIO (m b
[Cycle](Data-ExternalLog.html#t:Cycle)), MonadSnaplet m, MonadSnap (m b
[RoleSnaplet](RoleSnaplet.html#t:RoleSnaplet))) =\>
[Resource](RoleSnaplet.html#t:Resource) -\>
[RestRight](RoleSnaplet.html#t:RestRight) -\> m b
[RoleSnaplet](RoleSnaplet.html#t:RoleSnaplet) Bool

addRole :: (MonadState [DHTConfig](NodeSnapletTest.html#t:DHTConfig) (m
b [DHTConfig](NodeSnapletTest.html#t:DHTConfig)), MonadState
[Cycle](Data-ExternalLog.html#t:Cycle) (m b
[Cycle](Data-ExternalLog.html#t:Cycle)), MonadState
[RandomConfig](RandomSnaplet.html#t:RandomConfig) (m b
[RandomConfig](RandomSnaplet.html#t:RandomConfig)), MonadState
[RoleSnaplet](RoleSnaplet.html#t:RoleSnaplet) (m b
[RoleSnaplet](RoleSnaplet.html#t:RoleSnaplet)), MonadIO (m b
[DHTConfig](NodeSnapletTest.html#t:DHTConfig)), MonadIO (m b
[Cycle](Data-ExternalLog.html#t:Cycle)), MonadIO (m b
[RandomConfig](RandomSnaplet.html#t:RandomConfig)), Binary a,
MonadSnaplet m, MonadSnap (m b
[RoleSnaplet](RoleSnaplet.html#t:RoleSnaplet))) =\> ByteString -\> a -\>
m b [RoleSnaplet](RoleSnaplet.html#t:RoleSnaplet) ()

withRoleState :: MonadState
[RoleSnaplet](RoleSnaplet.html#t:RoleSnaplet) m =\>
([RolePair](Data-Role.html#t:RolePair) ByteString -\> m a) -\> m a

dumpAll :: MonadIO m =\> [RolePair](Data-Role.html#t:RolePair)
ByteString -\> m String

Debug function to dump the internal state

data Role

Constructors

  ----------------------------------------------- ---
  Developer (Maybe [Id](RoleSnaplet.html#t:Id))    
  User (Maybe [Id](RoleSnaplet.html#t:Id))         
  Server (Maybe [Id](RoleSnaplet.html#t:Id))       
  All                                              
  ----------------------------------------------- ---

Instances

  ---------------------------------------- ---
  Eq [Role](RoleSnaplet.html#t:Role)        
  Ord [Role](RoleSnaplet.html#t:Role)       
  Read [Role](RoleSnaplet.html#t:Role)      
  Show [Role](RoleSnaplet.html#t:Role)      
  Binary [Role](RoleSnaplet.html#t:Role)    
  ---------------------------------------- ---

data RestRight

Constructors

  -------- ---
  Put       
  Get       
  Post      
  Delete    
  -------- ---

Instances

  ------------------------------------------------ ---
  Eq [RestRight](RoleSnaplet.html#t:RestRight)      
  Show [RestRight](RoleSnaplet.html#t:RestRight)    
  ------------------------------------------------ ---

type Resource = String

dropRoles :: (MonadState [RoleSnaplet](RoleSnaplet.html#t:RoleSnaplet)
m, MonadSnap m) =\> ByteString -\> m ()

getRoles :: (MonadState [DHTConfig](NodeSnapletTest.html#t:DHTConfig) (m
b [DHTConfig](NodeSnapletTest.html#t:DHTConfig)), MonadState
[Cycle](Data-ExternalLog.html#t:Cycle) (m b
[Cycle](Data-ExternalLog.html#t:Cycle)), MonadIO (m b
[DHTConfig](NodeSnapletTest.html#t:DHTConfig)), MonadIO (m b
[Cycle](Data-ExternalLog.html#t:Cycle)), MonadSnaplet m, MonadSnap (m b
[RoleSnaplet](RoleSnaplet.html#t:RoleSnaplet))) =\> ByteString -\> m b
[RoleSnaplet](RoleSnaplet.html#t:RoleSnaplet)
[[Role](RoleSnaplet.html#t:Role)]

type Id = Integer

data RoleSnaplet

Constructors

RoleSnaplet

 

Fields

runRS :: [RolePair](Data-Role.html#t:RolePair) ByteString
:    
\_random :: Snaplet [RandomConfig](RandomSnaplet.html#t:RandomConfig)
:    
\_dht :: Snaplet [DHTConfig](NodeSnapletTest.html#t:DHTConfig)
:    
\_log\_cycler :: Snaplet [Cycle](Data-ExternalLog.html#t:Cycle)
:    

class HasRoleSnaplet b where

Methods

roleLens :: SnapletLens (Snaplet b) (Snaplet
[RoleSnaplet](RoleSnaplet.html#t:RoleSnaplet))

initRoleSnaplet :: Snaplet
[RandomConfig](RandomSnaplet.html#t:RandomConfig) -\> Snaplet
[DHTConfig](NodeSnapletTest.html#t:DHTConfig) -\> Snaplet
[Cycle](Data-ExternalLog.html#t:Cycle) -\> SnapletInit b
[RoleSnaplet](RoleSnaplet.html#t:RoleSnaplet)

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
