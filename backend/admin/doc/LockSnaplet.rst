===========
LockSnaplet
===========

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

LockSnaplet

Documentation
=============

data Lock

getLock :: MonadState `Lock <LockSnaplet.html#t:Lock>`__ m => m
`Lock <LockSnaplet.html#t:Lock>`__

initLock :: SnapletInit b `Lock <LockSnaplet.html#t:Lock>`__

printLocks :: `Lock <LockSnaplet.html#t:Lock>`__ -> IO ()

withLockBlock :: (MonadIO m, Applicative m, Show a) =>
`Lock <LockSnaplet.html#t:Lock>`__ -> Namespace -> a -> m b -> m b

withLockNonBlock :: (MonadIO m, Applicative m, Show a) =>
`Lock <LockSnaplet.html#t:Lock>`__ -> Namespace -> a -> m () -> m ()

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
