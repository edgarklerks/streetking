-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Application

Description

This module defines our application's state type and an alias for its handler monad.

Synopsis

-   data [ApplicationException](#t:ApplicationException) = [UserErrorE](#v:UserErrorE) ByteString
-   data [App](#t:App) = [App](#v:App) {
    -   [\_db](#v:_db) :: Snaplet [SqlTransactionConfig](SqlTransactionSnaplet.html#t:SqlTransactionConfig)
    -   [\_config](#v:_config) :: Snaplet [ConfigSnaplet](ConfigSnaplet.html#t:ConfigSnaplet)
    -   [\_rnd](#v:_rnd) :: Snaplet [RandomConfig](RandomSnaplet.html#t:RandomConfig)
    -   [\_nde](#v:_nde) :: Snaplet [DHTConfig](NodeSnapletTest.html#t:DHTConfig)
    -   [\_notf](#v:_notf) :: Snaplet [NotificationConfig](NotificationSnaplet.html#t:NotificationConfig)
    -   [\_slock](#v:_slock) :: Snaplet [Lock](LockSnaplet.html#t:Lock)
    -   [\_logcycle](#v:_logcycle) :: Snaplet [Cycle](Data-ExternalLog.html#t:Cycle)

    }
-   [slock](#v:slock) :: Lens' [App](Application.html#t:App) (Snaplet [Lock](LockSnaplet.html#t:Lock))
-   [rnd](#v:rnd) :: Lens' [App](Application.html#t:App) (Snaplet [RandomConfig](RandomSnaplet.html#t:RandomConfig))
-   [notf](#v:notf) :: Lens' [App](Application.html#t:App) (Snaplet [NotificationConfig](NotificationSnaplet.html#t:NotificationConfig))
-   [nde](#v:nde) :: Lens' [App](Application.html#t:App) (Snaplet [DHTConfig](NodeSnapletTest.html#t:DHTConfig))
-   [logcycle](#v:logcycle) :: Lens' [App](Application.html#t:App) (Snaplet [Cycle](Data-ExternalLog.html#t:Cycle))
-   [db](#v:db) :: Lens' [App](Application.html#t:App) (Snaplet [SqlTransactionConfig](SqlTransactionSnaplet.html#t:SqlTransactionConfig))
-   [config](#v:config) :: Lens' [App](Application.html#t:App) (Snaplet [ConfigSnaplet](ConfigSnaplet.html#t:ConfigSnaplet))
-   [getUniqueKey](#v:getUniqueKey) :: [Application](Application.html#t:Application) ByteString
-   [runDb](#v:runDb) :: [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) b -\> Handler [App](Application.html#t:App) [App](Application.html#t:App) b
-   [sendLetter](#v:sendLetter) :: (MonadState [NotificationConfig](NotificationSnaplet.html#t:NotificationConfig) (m b [NotificationConfig](NotificationSnaplet.html#t:NotificationConfig)), MonadState [SqlTransactionConfig](SqlTransactionSnaplet.html#t:SqlTransactionConfig) (m b [SqlTransactionConfig](SqlTransactionSnaplet.html#t:SqlTransactionConfig)), MonadSnaplet m, MonadSnap (m b [SqlTransactionConfig](SqlTransactionSnaplet.html#t:SqlTransactionConfig))) =\> [UserId](Data-Notifications.html#t:UserId) -\> [Letter](Data-Notifications.html#t:Letter) -\> m b [App](Application.html#t:App) [Letter](Data-Notifications.html#t:Letter)
-   [setRead](#v:setRead) :: (MonadState [NotificationConfig](NotificationSnaplet.html#t:NotificationConfig) (m b [NotificationConfig](NotificationSnaplet.html#t:NotificationConfig)), MonadState [SqlTransactionConfig](SqlTransactionSnaplet.html#t:SqlTransactionConfig) (m b [SqlTransactionConfig](SqlTransactionSnaplet.html#t:SqlTransactionConfig)), MonadSnaplet m, MonadSnap (m b [SqlTransactionConfig](SqlTransactionSnaplet.html#t:SqlTransactionConfig))) =\> [UserId](Data-Notifications.html#t:UserId) -\> Integer -\> m b [App](Application.html#t:App) ()
-   [setArchive](#v:setArchive) :: (MonadState [NotificationConfig](NotificationSnaplet.html#t:NotificationConfig) (m b [NotificationConfig](NotificationSnaplet.html#t:NotificationConfig)), MonadState [SqlTransactionConfig](SqlTransactionSnaplet.html#t:SqlTransactionConfig) (m b [SqlTransactionConfig](SqlTransactionSnaplet.html#t:SqlTransactionConfig)), MonadSnaplet m, MonadSnap (m b [SqlTransactionConfig](SqlTransactionSnaplet.html#t:SqlTransactionConfig))) =\> [UserId](Data-Notifications.html#t:UserId) -\> Integer -\> m b [App](Application.html#t:App) ()
-   [checkMailBox](#v:checkMailBox) :: (MonadState [NotificationConfig](NotificationSnaplet.html#t:NotificationConfig) (m b [NotificationConfig](NotificationSnaplet.html#t:NotificationConfig)), MonadState [SqlTransactionConfig](SqlTransactionSnaplet.html#t:SqlTransactionConfig) (m b [SqlTransactionConfig](SqlTransactionSnaplet.html#t:SqlTransactionConfig)), MonadSnaplet m, MonadSnap (m b [SqlTransactionConfig](SqlTransactionSnaplet.html#t:SqlTransactionConfig))) =\> [UserId](Data-Notifications.html#t:UserId) -\> m b [App](Application.html#t:App) [Letters](Data-Notifications.html#t:Letters)
-   type [AppHandler](#t:AppHandler) = Handler [App](Application.html#t:App) [App](Application.html#t:App)
-   type [Application](#t:Application) = [AppHandler](Application.html#t:AppHandler)
-   [toAeson](#v:toAeson) :: [InRule](Data-InRules.html#t:InRule) -\> ByteString
-   [writeAeson](#v:writeAeson) :: [ToInRule](Data-InRules.html#t:ToInRule) a =\> a -\> [Application](Application.html#t:Application) ()
-   [writeError](#v:writeError) :: [ToInRule](Data-InRules.html#t:ToInRule) a =\> a -\> [Application](Application.html#t:Application) ()
-   [writeResult](#v:writeResult) :: [ToInRule](Data-InRules.html#t:ToInRule) a =\> a -\> [Application](Application.html#t:Application) ()
-   [writeResult'](#v:writeResult-39-) :: ToJSON a =\> a -\> [Application](Application.html#t:Application) ()
-   [writeMapable](#v:writeMapable) :: [Mapable](Model-General.html#t:Mapable) a =\> a -\> [Application](Application.html#t:Application) ()
-   [writeMapables](#v:writeMapables) :: [Mapable](Model-General.html#t:Mapable) a =\> [a] -\> [Application](Application.html#t:Application) ()
-   [getUserId](#v:getUserId) :: [Application](Application.html#t:Application) Integer
-   [getOParam](#v:getOParam) :: ByteString -\> [Application](Application.html#t:Application) ByteString
-   type [SqlMap](#t:SqlMap) = HashMap String [SqlValue](Data-SqlTransaction.html#t:SqlValue)
-   [getJson](#v:getJson) :: [Application](Application.html#t:Application) [SqlMap](Application.html#t:SqlMap)
-   [getJsons](#v:getJsons) :: [Application](Application.html#t:Application) [[SqlMap](Application.html#t:SqlMap)]
-   [getPagesWithDTDOrdered](#v:getPagesWithDTDOrdered) :: [String] -\> [DTD](Data-DatabaseTemplate.html#t:DTD) -\> [Application](Application.html#t:Application) (((Integer, Integer), [Constraints](Data-Database.html#t:Constraints)), [Orders](Data-Database.html#t:Orders))
-   [getPagesWithDTDOrderedAndParams](#v:getPagesWithDTDOrderedAndParams) :: [SqlMap](Application.html#t:SqlMap) -\> [String] -\> [DTD](Data-DatabaseTemplate.html#t:DTD) -\> [Application](Application.html#t:Application) (((Integer, Integer), [Constraints](Data-Database.html#t:Constraints)), [Orders](Data-Database.html#t:Orders))
-   [getPagesWithDTD](#v:getPagesWithDTD) :: [DTD](Data-DatabaseTemplate.html#t:DTD) -\> [Application](Application.html#t:Application) ((Integer, Integer), [Constraints](Data-Database.html#t:Constraints))
-   [addRole](#v:addRole) :: (MonadIO (m b [DHTConfig](NodeSnapletTest.html#t:DHTConfig)), MonadState [DHTConfig](NodeSnapletTest.html#t:DHTConfig) (m b [DHTConfig](NodeSnapletTest.html#t:DHTConfig)), MonadSnaplet m) =\> [Id](Data-Role.html#t:Id) -\> ByteString -\> m b [App](Application.html#t:App) [Proto](ProtoExtended.html#t:Proto)
-   [writeError'](#v:writeError-39-) :: ToJSON a =\> a -\> [Application](Application.html#t:Application) ()
-   [writeAeson'](#v:writeAeson-39-) :: ToJSON a =\> a -\> [Application](Application.html#t:Application) ()
-   [internalError](#v:internalError) :: String -\> [Application](Application.html#t:Application) a
-   [runCompose](#v:runCompose) :: [ComposeMonad](Data-ComposeModel.html#t:ComposeMonad) a [Connection](Data-SqlTransaction.html#t:Connection) a -\> Handler [App](Application.html#t:App) [App](Application.html#t:App) (HashMap String [InRule](Data-InRules.html#t:InRule))
-   [withLockBlock](#v:withLockBlock) :: Show a =\> Namespace -\> a -\> Handler [App](Application.html#t:App) [Lock](LockSnaplet.html#t:Lock) b -\> Handler [App](Application.html#t:App) [App](Application.html#t:App) b
-   [withLockNonBlock](#v:withLockNonBlock) :: Show a =\> Namespace -\> a -\> Handler [App](Application.html#t:App) [Lock](LockSnaplet.html#t:Lock) () -\> Handler [App](Application.html#t:App) [App](Application.html#t:App) ()
-   [getLock](#v:getLock) :: [Application](Application.html#t:Application) [Lock](LockSnaplet.html#t:Lock)

Documentation
=============

data ApplicationException

Constructors

||
|UserErrorE ByteString| |

Instances

||
|Show [ApplicationException](Application.html#t:ApplicationException)| |
|Typeable [ApplicationException](Application.html#t:ApplicationException)| |
|Exception [ApplicationException](Application.html#t:ApplicationException)| |

data App

Constructors

App

 

Fields

\_db :: Snaplet [SqlTransactionConfig](SqlTransactionSnaplet.html#t:SqlTransactionConfig)  
 

\_config :: Snaplet [ConfigSnaplet](ConfigSnaplet.html#t:ConfigSnaplet)  
 

\_rnd :: Snaplet [RandomConfig](RandomSnaplet.html#t:RandomConfig)  
 

\_nde :: Snaplet [DHTConfig](NodeSnapletTest.html#t:DHTConfig)  
 

\_notf :: Snaplet [NotificationConfig](NotificationSnaplet.html#t:NotificationConfig)  
 

\_slock :: Snaplet [Lock](LockSnaplet.html#t:Lock)  
 

\_logcycle :: Snaplet [Cycle](Data-ExternalLog.html#t:Cycle)  
 

slock :: Lens' [App](Application.html#t:App) (Snaplet [Lock](LockSnaplet.html#t:Lock))

rnd :: Lens' [App](Application.html#t:App) (Snaplet [RandomConfig](RandomSnaplet.html#t:RandomConfig))

notf :: Lens' [App](Application.html#t:App) (Snaplet [NotificationConfig](NotificationSnaplet.html#t:NotificationConfig))

nde :: Lens' [App](Application.html#t:App) (Snaplet [DHTConfig](NodeSnapletTest.html#t:DHTConfig))

logcycle :: Lens' [App](Application.html#t:App) (Snaplet [Cycle](Data-ExternalLog.html#t:Cycle))

db :: Lens' [App](Application.html#t:App) (Snaplet [SqlTransactionConfig](SqlTransactionSnaplet.html#t:SqlTransactionConfig))

config :: Lens' [App](Application.html#t:App) (Snaplet [ConfigSnaplet](ConfigSnaplet.html#t:ConfigSnaplet))

getUniqueKey :: [Application](Application.html#t:Application) ByteString

runDb :: [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) b -\> Handler [App](Application.html#t:App) [App](Application.html#t:App) b

sendLetter :: (MonadState [NotificationConfig](NotificationSnaplet.html#t:NotificationConfig) (m b [NotificationConfig](NotificationSnaplet.html#t:NotificationConfig)), MonadState [SqlTransactionConfig](SqlTransactionSnaplet.html#t:SqlTransactionConfig) (m b [SqlTransactionConfig](SqlTransactionSnaplet.html#t:SqlTransactionConfig)), MonadSnaplet m, MonadSnap (m b [SqlTransactionConfig](SqlTransactionSnaplet.html#t:SqlTransactionConfig))) =\> [UserId](Data-Notifications.html#t:UserId) -\> [Letter](Data-Notifications.html#t:Letter) -\> m b [App](Application.html#t:App) [Letter](Data-Notifications.html#t:Letter)

setRead :: (MonadState [NotificationConfig](NotificationSnaplet.html#t:NotificationConfig) (m b [NotificationConfig](NotificationSnaplet.html#t:NotificationConfig)), MonadState [SqlTransactionConfig](SqlTransactionSnaplet.html#t:SqlTransactionConfig) (m b [SqlTransactionConfig](SqlTransactionSnaplet.html#t:SqlTransactionConfig)), MonadSnaplet m, MonadSnap (m b [SqlTransactionConfig](SqlTransactionSnaplet.html#t:SqlTransactionConfig))) =\> [UserId](Data-Notifications.html#t:UserId) -\> Integer -\> m b [App](Application.html#t:App) ()

setArchive :: (MonadState [NotificationConfig](NotificationSnaplet.html#t:NotificationConfig) (m b [NotificationConfig](NotificationSnaplet.html#t:NotificationConfig)), MonadState [SqlTransactionConfig](SqlTransactionSnaplet.html#t:SqlTransactionConfig) (m b [SqlTransactionConfig](SqlTransactionSnaplet.html#t:SqlTransactionConfig)), MonadSnaplet m, MonadSnap (m b [SqlTransactionConfig](SqlTransactionSnaplet.html#t:SqlTransactionConfig))) =\> [UserId](Data-Notifications.html#t:UserId) -\> Integer -\> m b [App](Application.html#t:App) ()

checkMailBox :: (MonadState [NotificationConfig](NotificationSnaplet.html#t:NotificationConfig) (m b [NotificationConfig](NotificationSnaplet.html#t:NotificationConfig)), MonadState [SqlTransactionConfig](SqlTransactionSnaplet.html#t:SqlTransactionConfig) (m b [SqlTransactionConfig](SqlTransactionSnaplet.html#t:SqlTransactionConfig)), MonadSnaplet m, MonadSnap (m b [SqlTransactionConfig](SqlTransactionSnaplet.html#t:SqlTransactionConfig))) =\> [UserId](Data-Notifications.html#t:UserId) -\> m b [App](Application.html#t:App) [Letters](Data-Notifications.html#t:Letters)

type AppHandler = Handler [App](Application.html#t:App) [App](Application.html#t:App)

type Application = [AppHandler](Application.html#t:AppHandler)

toAeson :: [InRule](Data-InRules.html#t:InRule) -\> ByteString

writeAeson :: [ToInRule](Data-InRules.html#t:ToInRule) a =\> a -\> [Application](Application.html#t:Application) ()

Write Aeson to user

writeError :: [ToInRule](Data-InRules.html#t:ToInRule) a =\> a -\> [Application](Application.html#t:Application) ()

Write an error to the http client

writeResult :: [ToInRule](Data-InRules.html#t:ToInRule) a =\> a -\> [Application](Application.html#t:Application) ()

Write a InRule to the http client

writeResult' :: ToJSON a =\> a -\> [Application](Application.html#t:Application) ()

Write a JSON to the http client

writeMapable :: [Mapable](Model-General.html#t:Mapable) a =\> a -\> [Application](Application.html#t:Application) ()

Write a mapable to the client

writeMapables :: [Mapable](Model-General.html#t:Mapable) a =\> [a] -\> [Application](Application.html#t:Application) ()

Write multiple mapables as a json array

getUserId :: [Application](Application.html#t:Application) Integer

get the user id from the proxy

getOParam :: ByteString -\> [Application](Application.html#t:Application) ByteString

get a GET param faults when param doesn't exist

type SqlMap = HashMap String [SqlValue](Data-SqlTransaction.html#t:SqlValue)

getJson :: [Application](Application.html#t:Application) [SqlMap](Application.html#t:SqlMap)

get json in the form of a `SqlMap`

getJsons :: [Application](Application.html#t:Application) [[SqlMap](Application.html#t:SqlMap)]

Get multiple jsons as a `SqlMap`

getPagesWithDTDOrdered

Arguments

:: [String]

Allowed order fields

-\> [DTD](Data-DatabaseTemplate.html#t:DTD)

search expression

-\> [Application](Application.html#t:Application) (((Integer, Integer), [Constraints](Data-Database.html#t:Constraints)), [Orders](Data-Database.html#t:Orders))

 

Generates a constraint and returns an (((limit, offset), Constraints),Orders)

getPagesWithDTDOrderedAndParams

Arguments

:: [SqlMap](Application.html#t:SqlMap)

Default values

-\> [String]

Allowed ordered fields

-\> [DTD](Data-DatabaseTemplate.html#t:DTD)

search expression, see `DatabaseTemplate`

-\> [Application](Application.html#t:Application) (((Integer, Integer), [Constraints](Data-Database.html#t:Constraints)), [Orders](Data-Database.html#t:Orders))

 

Same as `getPagsWithDTDOrdered`, only then provide default values

getPagesWithDTD :: [DTD](Data-DatabaseTemplate.html#t:DTD) -\> [Application](Application.html#t:Application) ((Integer, Integer), [Constraints](Data-Database.html#t:Constraints))

Generate a constraint and a limit and offset

addRole :: (MonadIO (m b [DHTConfig](NodeSnapletTest.html#t:DHTConfig)), MonadState [DHTConfig](NodeSnapletTest.html#t:DHTConfig) (m b [DHTConfig](NodeSnapletTest.html#t:DHTConfig)), MonadSnaplet m) =\> [Id](Data-Role.html#t:Id) -\> ByteString -\> m b [App](Application.html#t:App) [Proto](ProtoExtended.html#t:Proto)

Add a role to a user id

writeError' :: ToJSON a =\> a -\> [Application](Application.html#t:Application) ()

write an json error

writeAeson' :: ToJSON a =\> a -\> [Application](Application.html#t:Application) ()

Write an error to the client

internalError :: String -\> [Application](Application.html#t:Application) a

Throws an internal error code 500

runCompose :: [ComposeMonad](Data-ComposeModel.html#t:ComposeMonad) a [Connection](Data-SqlTransaction.html#t:Connection) a -\> Handler [App](Application.html#t:App) [App](Application.html#t:App) (HashMap String [InRule](Data-InRules.html#t:InRule))

Run a composemonad in the SqlTransaction monad

withLockBlock :: Show a =\> Namespace -\> a -\> Handler [App](Application.html#t:App) [Lock](LockSnaplet.html#t:Lock) b -\> Handler [App](Application.html#t:App) [App](Application.html#t:App) b

Do an SqlTransaction action with a non blocking lock

withLockNonBlock :: Show a =\> Namespace -\> a -\> Handler [App](Application.html#t:App) [Lock](LockSnaplet.html#t:Lock) () -\> Handler [App](Application.html#t:App) [App](Application.html#t:App) ()

Do a SqlTransaction with a blocking lock

getLock :: [Application](Application.html#t:Application) [Lock](LockSnaplet.html#t:Lock)

Retrieve the lock manager

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
