===================
NotificationSnaplet
===================

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

NotificationSnaplet

Documentation
=============

sendLetter :: (MonadState
`SqlTransactionConfig <SqlTransactionSnaplet.html#t:SqlTransactionConfig>`__
(m b
`SqlTransactionConfig <SqlTransactionSnaplet.html#t:SqlTransactionConfig>`__),
MonadState
`NotificationConfig <NotificationSnaplet.html#t:NotificationConfig>`__
(m b
`NotificationConfig <NotificationSnaplet.html#t:NotificationConfig>`__),
MonadSnaplet m, MonadSnap (m b
`SqlTransactionConfig <SqlTransactionSnaplet.html#t:SqlTransactionConfig>`__))
=> `UserId <Data-Notifications.html#t:UserId>`__ ->
`Letter <Data-Notifications.html#t:Letter>`__ -> m b
`NotificationConfig <NotificationSnaplet.html#t:NotificationConfig>`__
`Letter <Data-Notifications.html#t:Letter>`__

checkMailBox :: (MonadState
`SqlTransactionConfig <SqlTransactionSnaplet.html#t:SqlTransactionConfig>`__
(m b
`SqlTransactionConfig <SqlTransactionSnaplet.html#t:SqlTransactionConfig>`__),
MonadState
`NotificationConfig <NotificationSnaplet.html#t:NotificationConfig>`__
(m b
`NotificationConfig <NotificationSnaplet.html#t:NotificationConfig>`__),
MonadSnaplet m, MonadSnap (m b
`SqlTransactionConfig <SqlTransactionSnaplet.html#t:SqlTransactionConfig>`__))
=> `UserId <Data-Notifications.html#t:UserId>`__ -> m b
`NotificationConfig <NotificationSnaplet.html#t:NotificationConfig>`__
`Letters <Data-Notifications.html#t:Letters>`__

setArchive :: (MonadState
`SqlTransactionConfig <SqlTransactionSnaplet.html#t:SqlTransactionConfig>`__
(m b
`SqlTransactionConfig <SqlTransactionSnaplet.html#t:SqlTransactionConfig>`__),
MonadState
`NotificationConfig <NotificationSnaplet.html#t:NotificationConfig>`__
(m b
`NotificationConfig <NotificationSnaplet.html#t:NotificationConfig>`__),
MonadSnaplet m, MonadSnap (m b
`SqlTransactionConfig <SqlTransactionSnaplet.html#t:SqlTransactionConfig>`__))
=> `UserId <Data-Notifications.html#t:UserId>`__ -> Integer -> m b
`NotificationConfig <NotificationSnaplet.html#t:NotificationConfig>`__
()

setRead :: (MonadState
`SqlTransactionConfig <SqlTransactionSnaplet.html#t:SqlTransactionConfig>`__
(m b
`SqlTransactionConfig <SqlTransactionSnaplet.html#t:SqlTransactionConfig>`__),
MonadState
`NotificationConfig <NotificationSnaplet.html#t:NotificationConfig>`__
(m b
`NotificationConfig <NotificationSnaplet.html#t:NotificationConfig>`__),
MonadSnaplet m, MonadSnap (m b
`SqlTransactionConfig <SqlTransactionSnaplet.html#t:SqlTransactionConfig>`__))
=> `UserId <Data-Notifications.html#t:UserId>`__ -> Integer -> m b
`NotificationConfig <NotificationSnaplet.html#t:NotificationConfig>`__
()

initNotificationSnaplet :: Snaplet
`SqlTransactionConfig <SqlTransactionSnaplet.html#t:SqlTransactionConfig>`__
-> Maybe (MVar `PostOffice <Data-Notifications.html#t:PostOffice>`__) ->
SnapletInit b
`NotificationConfig <NotificationSnaplet.html#t:NotificationConfig>`__

data NotificationConfig

data NotificationError

Constructors

+-----------------+-----+
| NE ByteString   |     |
+-----------------+-----+

Instances

+----------------------------------------------------------------------------------+-----+
| Show `NotificationError <NotificationSnaplet.html#t:NotificationError>`__        |     |
+----------------------------------------------------------------------------------+-----+
| Typeable `NotificationError <NotificationSnaplet.html#t:NotificationError>`__    |     |
+----------------------------------------------------------------------------------+-----+
| Exception `NotificationError <NotificationSnaplet.html#t:NotificationError>`__   |     |
+----------------------------------------------------------------------------------+-----+

getPostOffice :: MonadState
`NotificationConfig <NotificationSnaplet.html#t:NotificationConfig>`__ m
=> m `PostOffice <Data-Notifications.html#t:PostOffice>`__

\_po ::
`NotificationConfig <NotificationSnaplet.html#t:NotificationConfig>`__
-> `PostOffice <Data-Notifications.html#t:PostOffice>`__

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
