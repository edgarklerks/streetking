-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

NotificationSnaplet

Documentation
=============

sendLetter :: (MonadState [SqlTransactionConfig](SqlTransactionSnaplet.html#t:SqlTransactionConfig) (m b [SqlTransactionConfig](SqlTransactionSnaplet.html#t:SqlTransactionConfig)), MonadState [NotificationConfig](NotificationSnaplet.html#t:NotificationConfig) (m b [NotificationConfig](NotificationSnaplet.html#t:NotificationConfig)), MonadSnaplet m, MonadSnap (m b [SqlTransactionConfig](SqlTransactionSnaplet.html#t:SqlTransactionConfig))) =\> [UserId](Data-Notifications.html#t:UserId) -\> [Letter](Data-Notifications.html#t:Letter) -\> m b [NotificationConfig](NotificationSnaplet.html#t:NotificationConfig) [Letter](Data-Notifications.html#t:Letter)

checkMailBox :: (MonadState [SqlTransactionConfig](SqlTransactionSnaplet.html#t:SqlTransactionConfig) (m b [SqlTransactionConfig](SqlTransactionSnaplet.html#t:SqlTransactionConfig)), MonadState [NotificationConfig](NotificationSnaplet.html#t:NotificationConfig) (m b [NotificationConfig](NotificationSnaplet.html#t:NotificationConfig)), MonadSnaplet m, MonadSnap (m b [SqlTransactionConfig](SqlTransactionSnaplet.html#t:SqlTransactionConfig))) =\> [UserId](Data-Notifications.html#t:UserId) -\> m b [NotificationConfig](NotificationSnaplet.html#t:NotificationConfig) [Letters](Data-Notifications.html#t:Letters)

setArchive :: (MonadState [SqlTransactionConfig](SqlTransactionSnaplet.html#t:SqlTransactionConfig) (m b [SqlTransactionConfig](SqlTransactionSnaplet.html#t:SqlTransactionConfig)), MonadState [NotificationConfig](NotificationSnaplet.html#t:NotificationConfig) (m b [NotificationConfig](NotificationSnaplet.html#t:NotificationConfig)), MonadSnaplet m, MonadSnap (m b [SqlTransactionConfig](SqlTransactionSnaplet.html#t:SqlTransactionConfig))) =\> [UserId](Data-Notifications.html#t:UserId) -\> Integer -\> m b [NotificationConfig](NotificationSnaplet.html#t:NotificationConfig) ()

setRead :: (MonadState [SqlTransactionConfig](SqlTransactionSnaplet.html#t:SqlTransactionConfig) (m b [SqlTransactionConfig](SqlTransactionSnaplet.html#t:SqlTransactionConfig)), MonadState [NotificationConfig](NotificationSnaplet.html#t:NotificationConfig) (m b [NotificationConfig](NotificationSnaplet.html#t:NotificationConfig)), MonadSnaplet m, MonadSnap (m b [SqlTransactionConfig](SqlTransactionSnaplet.html#t:SqlTransactionConfig))) =\> [UserId](Data-Notifications.html#t:UserId) -\> Integer -\> m b [NotificationConfig](NotificationSnaplet.html#t:NotificationConfig) ()

initNotificationSnaplet :: Snaplet [SqlTransactionConfig](SqlTransactionSnaplet.html#t:SqlTransactionConfig) -\> Maybe (MVar [PostOffice](Data-Notifications.html#t:PostOffice)) -\> SnapletInit b [NotificationConfig](NotificationSnaplet.html#t:NotificationConfig)

data NotificationConfig

data NotificationError

Constructors

||
|NE ByteString| |

Instances

||
|Show [NotificationError](NotificationSnaplet.html#t:NotificationError)| |
|Typeable [NotificationError](NotificationSnaplet.html#t:NotificationError)| |
|Exception [NotificationError](NotificationSnaplet.html#t:NotificationError)| |

getPostOffice :: MonadState [NotificationConfig](NotificationSnaplet.html#t:NotificationConfig) m =\> m [PostOffice](Data-Notifications.html#t:PostOffice)

\_po :: [NotificationConfig](NotificationSnaplet.html#t:NotificationConfig) -\> [PostOffice](Data-Notifications.html#t:PostOffice)

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
