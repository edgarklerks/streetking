-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Notifications

Documentation
=============

data NotificationParam where

Constructors

LevelUp :: Integer -\> Integer -\> Integer -\> Integer -\> Integer -\> [NotificationParam](Notifications.html#t:NotificationParam)

 

Fields

level :: Integer  
 

skill :: Integer  
 

health :: Integer  
 

money :: Integer  
 

diamonds :: Integer  
 

PartRepair :: Integer -\> Integer -\> [NotificationParam](Notifications.html#t:NotificationParam)

 

Fields

part\_id :: Integer  
 

repaired :: Integer  
 

CarRepair :: Integer -\> Integer -\> [NotificationParam](Notifications.html#t:NotificationParam)

 

Fields

car\_id :: Integer  
 

repaired :: Integer  
 

PartImprove :: Integer -\> Integer -\> [NotificationParam](Notifications.html#t:NotificationParam)

 

Fields

part\_id :: Integer  
 

improved :: Integer  
 

RaceStart :: RaceType -\> Integer -\> [NotificationParam](Notifications.html#t:NotificationParam)

 

Fields

race\_type :: RaceType  
 

race\_id :: Integer  
 

TournamentStart :: Integer -\> [NotificationParam](Notifications.html#t:NotificationParam)

 

Fields

tournament\_id :: Integer  
 

CarMarket :: Integer -\> Integer -\> [NotificationParam](Notifications.html#t:NotificationParam)

 

Fields

car\_id :: Integer  
 

money :: Integer  
 

PartMarket :: Integer -\> Integer -\> [NotificationParam](Notifications.html#t:NotificationParam)

 

Fields

part\_id :: Integer  
 

money :: Integer  
 

ReturnCar :: Integer -\> [NotificationParam](Notifications.html#t:NotificationParam)

 

Fields

car\_id :: Integer  
 

ReturnPart :: Integer -\> [NotificationParam](Notifications.html#t:NotificationParam)

 

Fields

part\_id :: Integer  
 

Instances

||
|Show [NotificationParam](Notifications.html#t:NotificationParam)| |
|[ToInRule](Data-InRules.html#t:ToInRule) [NotificationParam](Notifications.html#t:NotificationParam)| |

sendCentralNotification :: [UserId](Data-Notifications.html#t:UserId) -\> [NotificationParam](Notifications.html#t:NotificationParam) -\> [SqlTransactionUser](Data-SqlTransaction.html#t:SqlTransactionUser) [Lock](LockSnaplet.html#t:Lock) [Connection](Data-SqlTransaction.html#t:Connection) [Letter](Data-Notifications.html#t:Letter)

carMarket :: [NotificationParam](Notifications.html#t:NotificationParam)

partMarket :: [NotificationParam](Notifications.html#t:NotificationParam)

levelUp :: [NotificationParam](Notifications.html#t:NotificationParam)

partRepair :: [NotificationParam](Notifications.html#t:NotificationParam)

carRepair :: [NotificationParam](Notifications.html#t:NotificationParam)

raceStart :: [NotificationParam](Notifications.html#t:NotificationParam)

partImprove :: [NotificationParam](Notifications.html#t:NotificationParam)

tournamentStart :: [NotificationParam](Notifications.html#t:NotificationParam)

returnPart :: [NotificationParam](Notifications.html#t:NotificationParam)

returnCar :: [NotificationParam](Notifications.html#t:NotificationParam)

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
