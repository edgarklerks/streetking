=============
Notifications
=============

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Notifications

Documentation
=============

data NotificationParam where

Constructors

LevelUp :: Integer -> Integer -> Integer -> Integer -> Integer ->
`NotificationParam <Notifications.html#t:NotificationParam>`__

 

Fields

level :: Integer
     
skill :: Integer
     
health :: Integer
     
money :: Integer
     
diamonds :: Integer
     

PartRepair :: Integer -> Integer ->
`NotificationParam <Notifications.html#t:NotificationParam>`__

 

Fields

part\_id :: Integer
     
repaired :: Integer
     

CarRepair :: Integer -> Integer ->
`NotificationParam <Notifications.html#t:NotificationParam>`__

 

Fields

car\_id :: Integer
     
repaired :: Integer
     

PartImprove :: Integer -> Integer ->
`NotificationParam <Notifications.html#t:NotificationParam>`__

 

Fields

part\_id :: Integer
     
improved :: Integer
     

RaceStart :: RaceType -> Integer ->
`NotificationParam <Notifications.html#t:NotificationParam>`__

 

Fields

race\_type :: RaceType
     
race\_id :: Integer
     

TournamentStart :: Integer ->
`NotificationParam <Notifications.html#t:NotificationParam>`__

 

Fields

tournament\_id :: Integer
     

CarMarket :: Integer -> Integer ->
`NotificationParam <Notifications.html#t:NotificationParam>`__

 

Fields

car\_id :: Integer
     
money :: Integer
     

PartMarket :: Integer -> Integer ->
`NotificationParam <Notifications.html#t:NotificationParam>`__

 

Fields

part\_id :: Integer
     
money :: Integer
     

ReturnCar :: Integer ->
`NotificationParam <Notifications.html#t:NotificationParam>`__

 

Fields

car\_id :: Integer
     

ReturnPart :: Integer ->
`NotificationParam <Notifications.html#t:NotificationParam>`__

 

Fields

part\_id :: Integer
     

Instances

+--------------------------------------------------------------------------------------------------------------+-----+
| Show `NotificationParam <Notifications.html#t:NotificationParam>`__                                          |     |
+--------------------------------------------------------------------------------------------------------------+-----+
| `ToInRule <Data-InRules.html#t:ToInRule>`__ `NotificationParam <Notifications.html#t:NotificationParam>`__   |     |
+--------------------------------------------------------------------------------------------------------------+-----+

sendCentralNotification :: `UserId <Data-Notifications.html#t:UserId>`__
-> `NotificationParam <Notifications.html#t:NotificationParam>`__ ->
`SqlTransactionUser <Data-SqlTransaction.html#t:SqlTransactionUser>`__
`Lock <LockSnaplet.html#t:Lock>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__
`Letter <Data-Notifications.html#t:Letter>`__

carMarket ::
`NotificationParam <Notifications.html#t:NotificationParam>`__

partMarket ::
`NotificationParam <Notifications.html#t:NotificationParam>`__

levelUp ::
`NotificationParam <Notifications.html#t:NotificationParam>`__

partRepair ::
`NotificationParam <Notifications.html#t:NotificationParam>`__

carRepair ::
`NotificationParam <Notifications.html#t:NotificationParam>`__

raceStart ::
`NotificationParam <Notifications.html#t:NotificationParam>`__

partImprove ::
`NotificationParam <Notifications.html#t:NotificationParam>`__

tournamentStart ::
`NotificationParam <Notifications.html#t:NotificationParam>`__

returnPart ::
`NotificationParam <Notifications.html#t:NotificationParam>`__

returnCar ::
`NotificationParam <Notifications.html#t:NotificationParam>`__

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
