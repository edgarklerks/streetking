-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

LockSnaplet

Synopsis

-   data [Lock](#t:Lock)
-   [getLock](#v:getLock) :: MonadState [Lock](LockSnaplet.html#t:Lock) m =\> m [Lock](LockSnaplet.html#t:Lock)
-   [initLock](#v:initLock) :: SnapletInit b [Lock](LockSnaplet.html#t:Lock)
-   [printLocks](#v:printLocks) :: [Lock](LockSnaplet.html#t:Lock) -\> IO ()
-   [withLockBlock](#v:withLockBlock) :: (MonadIO m, Applicative m, Show a) =\> [Lock](LockSnaplet.html#t:Lock) -\> Namespace -\> a -\> m b -\> m b
-   [withLockNonBlock](#v:withLockNonBlock) :: (MonadIO m, Applicative m, Show a) =\> [Lock](LockSnaplet.html#t:Lock) -\> Namespace -\> a -\> m () -\> m ()

Documentation
=============

data Lock

getLock :: MonadState [Lock](LockSnaplet.html#t:Lock) m =\> m [Lock](LockSnaplet.html#t:Lock)

Get the current lock manager

initLock :: SnapletInit b [Lock](LockSnaplet.html#t:Lock)

Initialize the lock snaplet

printLocks :: [Lock](LockSnaplet.html#t:Lock) -\> IO ()

(Debug) print out all the locks

withLockBlock :: (MonadIO m, Applicative m, Show a) =\> [Lock](LockSnaplet.html#t:Lock) -\> Namespace -\> a -\> m b -\> m b

Do some action with a lock, block if lock isn't possible

withLockNonBlock :: (MonadIO m, Applicative m, Show a) =\> [Lock](LockSnaplet.html#t:Lock) -\> Namespace -\> a -\> m () -\> m ()

Do some action with a lock, don't block if lock isn't possible

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
