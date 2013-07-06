% Data.ComposeModel
% 
% 

-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Data.ComposeModel

Description

This module is a writer like monad, which builds a tree like map of
InRules values from SqlTransaction Actions This is handy for building
complex return objects

Synopsis

-   data [ComposeMonad](#t:ComposeMonad) r c a
-   [abort](#v:abort) :: r -\>
    [ComposeMonad](Data-ComposeModel.html#t:ComposeMonad) r c a
-   [action](#v:action) ::
    ([IConnection](Data-SqlTransaction.html#t:IConnection) c,
    [ToInRule](Data-InRules.html#t:ToInRule) a) =\> String -\>
    [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c a -\>
    [ComposeMonad](Data-ComposeModel.html#t:ComposeMonad) r c a
-   [deep](#v:deep) :: String -\>
    [ComposeMonad](Data-ComposeModel.html#t:ComposeMonad) a
    [Connection](Data-SqlTransaction.html#t:Connection) a -\>
    [ComposeMonad](Data-ComposeModel.html#t:ComposeMonad) r
    [Connection](Data-SqlTransaction.html#t:Connection) ()
-   [getComposeUser](#v:getComposeUser) ::
    [ComposeMonad](Data-ComposeModel.html#t:ComposeMonad) r c
    [Lock](LockSnaplet.html#t:Lock)
-   [label](#v:label) ::
    ([IConnection](Data-SqlTransaction.html#t:IConnection) c,
    [ToInRule](Data-InRules.html#t:ToInRule) a) =\> String -\> a -\>
    [ComposeMonad](Data-ComposeModel.html#t:ComposeMonad) r c ()
-   [liftDb](#v:liftDb) ::
    [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c a -\>
    [ComposeMonad](Data-ComposeModel.html#t:ComposeMonad) r c a
-   [runComposeMonad](#v:runComposeMonad) :: (Applicative m,
    [IConnection](Data-SqlTransaction.html#t:IConnection) conn, MonadIO
    m) =\> [Lock](LockSnaplet.html#t:Lock) -\>
    [ComposeMonad](Data-ComposeModel.html#t:ComposeMonad) a conn a -\>
    (String -\> m (HashMap String [InRule](Data-InRules.html#t:InRule)))
    -\> conn -\> m (HashMap String [InRule](Data-InRules.html#t:InRule))

Documentation
=============

data ComposeMonad r c a

ComposeMonad, is a continutation monad to jump out of a composition A
Reader to store the connection And a writer to build up our map

Instances

  ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ ---
  MonadReader c ([ComposeMonad](Data-ComposeModel.html#t:ComposeMonad) r c)                                                                                                             
  [IConnection](Data-SqlTransaction.html#t:IConnection) c =\> MonadError [SqlError](Data-SqlTransaction.html#t:SqlError) ([ComposeMonad](Data-ComposeModel.html#t:ComposeMonad) r c)    
  [IConnection](Data-SqlTransaction.html#t:IConnection) c =\> MonadWriter ComposeMap ([ComposeMonad](Data-ComposeModel.html#t:ComposeMonad) r c)                                        
  Monad ([ComposeMonad](Data-ComposeModel.html#t:ComposeMonad) r c)                                                                                                                     
  Functor ([ComposeMonad](Data-ComposeModel.html#t:ComposeMonad) r c)                                                                                                                   
  [IConnection](Data-SqlTransaction.html#t:IConnection) c =\> MonadPlus ([ComposeMonad](Data-ComposeModel.html#t:ComposeMonad) r c)                                                     
  Applicative ([ComposeMonad](Data-ComposeModel.html#t:ComposeMonad) r c)                                                                                                               
  [IConnection](Data-SqlTransaction.html#t:IConnection) c =\> Alternative ([ComposeMonad](Data-ComposeModel.html#t:ComposeMonad) r c)                                                   
  MonadIO ([ComposeMonad](Data-ComposeModel.html#t:ComposeMonad) r c)                                                                                                                   
  MonadCont ([ComposeMonad](Data-ComposeModel.html#t:ComposeMonad) r c)                                                                                                                 
  [IConnection](Data-SqlTransaction.html#t:IConnection) c =\> Monoid ([ComposeMonad](Data-ComposeModel.html#t:ComposeMonad) r c ())                                                     
  ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ ---

abort :: r -\> [ComposeMonad](Data-ComposeModel.html#t:ComposeMonad) r c
a

action :: ([IConnection](Data-SqlTransaction.html#t:IConnection) c,
[ToInRule](Data-InRules.html#t:ToInRule) a) =\> String -\>
[SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c a -\>
[ComposeMonad](Data-ComposeModel.html#t:ComposeMonad) r c a

Run an SqlTransaction action into the compose monad under a label

deep :: String -\> [ComposeMonad](Data-ComposeModel.html#t:ComposeMonad)
a [Connection](Data-SqlTransaction.html#t:Connection) a -\>
[ComposeMonad](Data-ComposeModel.html#t:ComposeMonad) r
[Connection](Data-SqlTransaction.html#t:Connection) ()

run a compose map computation and store it under a label as leaf

getComposeUser :: [ComposeMonad](Data-ComposeModel.html#t:ComposeMonad)
r c [Lock](LockSnaplet.html#t:Lock)

Function to get the user state

label :: ([IConnection](Data-SqlTransaction.html#t:IConnection) c,
[ToInRule](Data-InRules.html#t:ToInRule) a) =\> String -\> a -\>
[ComposeMonad](Data-ComposeModel.html#t:ComposeMonad) r c ()

Label the value

liftDb :: [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c
a -\> [ComposeMonad](Data-ComposeModel.html#t:ComposeMonad) r c a

Lift an SqlTransaction into the ComposeMonad

runComposeMonad :: (Applicative m,
[IConnection](Data-SqlTransaction.html#t:IConnection) conn, MonadIO m)
=\> [Lock](LockSnaplet.html#t:Lock) -\>
[ComposeMonad](Data-ComposeModel.html#t:ComposeMonad) a conn a -\>
(String -\> m (HashMap String [InRule](Data-InRules.html#t:InRule))) -\>
conn -\> m (HashMap String [InRule](Data-InRules.html#t:InRule))

     runComposeMonad :: (Applicative m, MonadIO m) => ComposeMonad a Connection a -> (String -> m (H.HashMap String InRule)) -> Connection -> m (H.HashMap String InRule)

run Compose map safely

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
