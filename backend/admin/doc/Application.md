% Application
% 
% 

-   [Contents](index.html)
-   [Index](doc-index.html)

 

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

  ----------------------- ---
  UserErrorE ByteString    
  ----------------------- ---

Instances

  --------------------------------------------------------------------------- ---
  Show [ApplicationException](Application.html#t:ApplicationException)         
  Typeable [ApplicationException](Application.html#t:ApplicationException)     
  Exception [ApplicationException](Application.html#t:ApplicationException)    
  --------------------------------------------------------------------------- ---

data App

Constructors

App

 

Fields

\_sess :: Snaplet SessionManager
:    
\_auth :: Snaplet (AuthManager [App](Application.html#t:App))
:    
\_sql :: Snaplet [SqlTransactionConfig](SqlTransactionSnaplet.html#t:SqlTransactionConfig)
:    

sql :: Lens' [App](Application.html#t:App) (Snaplet
[SqlTransactionConfig](SqlTransactionSnaplet.html#t:SqlTransactionConfig))

sess :: Lens' [App](Application.html#t:App) (Snaplet SessionManager)

auth :: Lens' [App](Application.html#t:App) (Snaplet (AuthManager
[App](Application.html#t:App)))

type AppHandler = Handler [App](Application.html#t:App)
[App](Application.html#t:App)

type Application = [AppHandler](Application.html#t:AppHandler)

toAeson :: [InRule](Data-InRules.html#t:InRule) -\> ByteString

writeAeson :: [ToInRule](Data-InRules.html#t:ToInRule) a =\> a -\>
[Application](Application.html#t:Application) ()

writeError :: [ToInRule](Data-InRules.html#t:ToInRule) a =\> a -\>
[Application](Application.html#t:Application) ()

writeResult :: [ToInRule](Data-InRules.html#t:ToInRule) a =\> a -\>
[Application](Application.html#t:Application) ()

writeResult' :: ToJSON a =\> a -\>
[Application](Application.html#t:Application) ()

writeMapable :: [Mapable](Model-General.html#t:Mapable) a =\> a -\>
[Application](Application.html#t:Application) ()

writeMapables :: [Mapable](Model-General.html#t:Mapable) a =\> [a] -\>
[Application](Application.html#t:Application) ()

getUserId :: [Application](Application.html#t:Application) Integer

getOParam :: ByteString -\>
[Application](Application.html#t:Application) ByteString

type SqlMap = HashMap String
[SqlValue](Data-SqlTransaction.html#t:SqlValue)

getJson :: [Application](Application.html#t:Application)
[SqlMap](Application.html#t:SqlMap)

getJsons :: [Application](Application.html#t:Application)
[[SqlMap](Application.html#t:SqlMap)]

getPagesWithDTDOrdered :: [String] -\>
[DTD](Data-DatabaseTemplate.html#t:DTD) -\>
[Application](Application.html#t:Application) (((Integer, Integer),
[Constraints](Data-Database.html#t:Constraints)),
[Orders](Data-Database.html#t:Orders))

getPagesWithDTD :: [DTD](Data-DatabaseTemplate.html#t:DTD) -\>
[Application](Application.html#t:Application) ((Integer, Integer),
[Constraints](Data-Database.html#t:Constraints))

writeError' :: ToJSON a =\> a -\>
[Application](Application.html#t:Application) ()

writeAeson' :: ToJSON a =\> a -\>
[Application](Application.html#t:Application) ()

internalError :: String -\>
[Application](Application.html#t:Application) a

runCompose :: (Applicative (m b
[SqlTransactionConfig](SqlTransactionSnaplet.html#t:SqlTransactionConfig)),
MonadState
[SqlTransactionConfig](SqlTransactionSnaplet.html#t:SqlTransactionConfig)
(m b
[SqlTransactionConfig](SqlTransactionSnaplet.html#t:SqlTransactionConfig)),
MonadSnaplet m, MonadCatchIO (m b
[SqlTransactionConfig](SqlTransactionSnaplet.html#t:SqlTransactionConfig)))
=\> [ComposeMonad](Data-ComposeModel.html#t:ComposeMonad) a
[Connection](Data-SqlTransaction.html#t:Connection) a -\> m b
[App](Application.html#t:App) (HashMap String
[InRule](Data-InRules.html#t:InRule))

runDb :: (Applicative (m b
[SqlTransactionConfig](SqlTransactionSnaplet.html#t:SqlTransactionConfig)),
MonadState
[SqlTransactionConfig](SqlTransactionSnaplet.html#t:SqlTransactionConfig)
(m b
[SqlTransactionConfig](SqlTransactionSnaplet.html#t:SqlTransactionConfig)),
MonadSnaplet m, MonadCatchIO (m b
[SqlTransactionConfig](SqlTransactionSnaplet.html#t:SqlTransactionConfig)))
=\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction)
[Connection](Data-SqlTransaction.html#t:Connection) a -\> m b
[App](Application.html#t:App) a

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
