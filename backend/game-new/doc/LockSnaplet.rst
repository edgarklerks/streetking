===========
LockSnaplet
===========

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

LockSnaplet

Synopsis

-  data `Lock <#t:Lock>`__
-  `getLock <#v:getLock>`__ :: MonadState
   `Lock <LockSnaplet.html#t:Lock>`__ m => m
   `Lock <LockSnaplet.html#t:Lock>`__
-  `initLock <#v:initLock>`__ :: SnapletInit b
   `Lock <LockSnaplet.html#t:Lock>`__
-  `printLocks <#v:printLocks>`__ :: `Lock <LockSnaplet.html#t:Lock>`__
   -> IO ()
-  `withLockBlock <#v:withLockBlock>`__ :: (MonadIO m, Applicative m,
   Show a) => `Lock <LockSnaplet.html#t:Lock>`__ -> Namespace -> a -> m
   b -> m b
-  `withLockNonBlock <#v:withLockNonBlock>`__ :: (MonadIO m, Applicative
   m, Show a) => `Lock <LockSnaplet.html#t:Lock>`__ -> Namespace -> a ->
   m () -> m ()

Documentation
=============

data Lock

getLock :: MonadState `Lock <LockSnaplet.html#t:Lock>`__ m => m
`Lock <LockSnaplet.html#t:Lock>`__

Get the current lock manager

initLock :: SnapletInit b `Lock <LockSnaplet.html#t:Lock>`__

Initialize the lock snaplet

printLocks :: `Lock <LockSnaplet.html#t:Lock>`__ -> IO ()

(Debug) print out all the locks

withLockBlock :: (MonadIO m, Applicative m, Show a) =>
`Lock <LockSnaplet.html#t:Lock>`__ -> Namespace -> a -> m b -> m b

Do some action with a lock, block if lock isn't possible

withLockNonBlock :: (MonadIO m, Applicative m, Show a) =>
`Lock <LockSnaplet.html#t:Lock>`__ -> Namespace -> a -> m () -> m ()

Do some action with a lock, don't block if lock isn't possible

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
