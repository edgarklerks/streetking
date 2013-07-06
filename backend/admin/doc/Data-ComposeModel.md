-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Data.ComposeModel

Documentation
=============

action :: [ToInRule](Data-InRules.html#t:ToInRule) a =\> String -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c a -\> [ComposeMonad](Data-ComposeModel.html#t:ComposeMonad) r c a

label :: [ToInRule](Data-InRules.html#t:ToInRule) a =\> String -\> a -\> [ComposeMonad](Data-ComposeModel.html#t:ComposeMonad) r c ()

runComposeMonad :: (Applicative m, MonadIO m, [IConnection](Data-SqlTransaction.html#t:IConnection) conn) =\> [Lock](LockSnaplet.html#t:Lock) -\> [ComposeMonad](Data-ComposeModel.html#t:ComposeMonad) a conn a -\> (String -\> m (HashMap String [InRule](Data-InRules.html#t:InRule))) -\> conn -\> m (HashMap String [InRule](Data-InRules.html#t:InRule))

data ComposeMonad r c a

Instances

||
|MonadReader c ([ComposeMonad](Data-ComposeModel.html#t:ComposeMonad) r c)| |
|MonadError String ([ComposeMonad](Data-ComposeModel.html#t:ComposeMonad) r c)| |
|MonadWriter ComposeMap ([ComposeMonad](Data-ComposeModel.html#t:ComposeMonad) r c)| |
|Monad ([ComposeMonad](Data-ComposeModel.html#t:ComposeMonad) r c)| |
|Functor ([ComposeMonad](Data-ComposeModel.html#t:ComposeMonad) r c)| |
|MonadPlus ([ComposeMonad](Data-ComposeModel.html#t:ComposeMonad) r c)| |
|Applicative ([ComposeMonad](Data-ComposeModel.html#t:ComposeMonad) r c)| |
|Alternative ([ComposeMonad](Data-ComposeModel.html#t:ComposeMonad) r c)| |
|MonadIO ([ComposeMonad](Data-ComposeModel.html#t:ComposeMonad) r c)| |
|MonadCont ([ComposeMonad](Data-ComposeModel.html#t:ComposeMonad) r c)| |
|Monoid ([ComposeMonad](Data-ComposeModel.html#t:ComposeMonad) r c ())| |

deep :: String -\> [ComposeMonad](Data-ComposeModel.html#t:ComposeMonad) a [Connection](Data-SqlTransaction.html#t:Connection) a -\> [ComposeMonad](Data-ComposeModel.html#t:ComposeMonad) r [Connection](Data-SqlTransaction.html#t:Connection) ()

abort :: r -\> [ComposeMonad](Data-ComposeModel.html#t:ComposeMonad) r c a

liftDb :: [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c a -\> [ComposeMonad](Data-ComposeModel.html#t:ComposeMonad) r c a

getComposeUser :: [ComposeMonad](Data-ComposeModel.html#t:ComposeMonad) r c [Lock](LockSnaplet.html#t:Lock)

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
