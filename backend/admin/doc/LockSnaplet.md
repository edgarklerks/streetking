-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

LockSnaplet

Documentation
=============

data Lock

getLock :: MonadState [Lock](LockSnaplet.html#t:Lock) m =\> m [Lock](LockSnaplet.html#t:Lock)

initLock :: SnapletInit b [Lock](LockSnaplet.html#t:Lock)

printLocks :: [Lock](LockSnaplet.html#t:Lock) -\> IO ()

withLockBlock :: (MonadIO m, Applicative m, Show a) =\> [Lock](LockSnaplet.html#t:Lock) -\> Namespace -\> a -\> m b -\> m b

withLockNonBlock :: (MonadIO m, Applicative m, Show a) =\> [Lock](LockSnaplet.html#t:Lock) -\> Namespace -\> a -\> m () -\> m ()

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
