=============
Model.General
=============

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Model.General

Documentation
=============

class `IConnection <Data-SqlTransaction.html#t:IConnection>`__ c =>
Database c a \| a -> c where

Methods

save :: a ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c Integer

load :: Integer ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c (Maybe
a)

search :: `Constraints <Data-Database.html#t:Constraints>`__ ->
`Orders <Data-Database.html#t:Orders>`__ -> Integer -> Integer ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c [a]

delete :: a -> `Constraints <Data-Database.html#t:Constraints>`__ ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c ()

fields :: a -> [(String, String)]

tableName :: a -> String

Instances

+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `PartDetails <Model-PartDetails.html#t:PartDetails>`__                     |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `Tournament <Model-Tournament.html#t:Tournament>`__                        |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `TournamentType <Model-TournamentType.html#t:TournamentType>`__            |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `EventStream <Model-EventStream.html#t:EventStream>`__                     |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `RaceReward <Model-RaceReward.html#t:RaceReward>`__                        |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `Report <Model-Report.html#t:Report>`__                                    |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `Task <Model-Task.html#t:Task>`__                                          |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `TrackDetails <Model-TrackDetails.html#t:TrackDetails>`__                  |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `TrackMaster <Model-TrackMaster.html#t:TrackMaster>`__                     |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `PreLetter <Model-PreLetter.html#t:PreLetter>`__                           |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `AccountProfile <Model-AccountProfile.html#t:AccountProfile>`__            |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `TaskTrigger <Model-TaskTrigger.html#t:TaskTrigger>`__                     |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `MenuModel <Model-MenuModel.html#t:MenuModel>`__                           |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `Reward <Model-Reward.html#t:Reward>`__                                    |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `RuleReward <Model-RuleReward.html#t:RuleReward>`__                        |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `Action <Model-Action.html#t:Action>`__                                    |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `Rule <Model-Rule.html#t:Rule>`__                                          |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `RewardLog <Model-RewardLog.html#t:RewardLog>`__                           |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `PartType <Model-PartType.html#t:PartType>`__                              |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `Part <Model-Part.html#t:Part>`__                                          |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `AccountGarage <Model-AccountGarage.html#t:AccountGarage>`__               |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `PartMarket <Model-PartMarket.html#t:PartMarket>`__                        |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `ParameterTable <Model-ParameterTable.html#t:ParameterTable>`__            |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `PersonnelInstance <Model-PersonnelInstance.html#t:PersonnelInstance>`__   |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `Personnel <Model-Personnel.html#t:Personnel>`__                           |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `Notification <Model-Notification.html#t:Notification>`__                  |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `GaragePart <Model-GarageParts.html#t:GaragePart>`__                       |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `Garage <Model-Garage.html#t:Garage>`__                                    |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `Config <Model-Config.html#t:Config>`__                                    |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `Continent <Model-Continent.html#t:Continent>`__                           |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `Country <Model-Country.html#t:Country>`__                                 |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `City <Model-City.html#t:City>`__                                          |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `Track <Model-Track.html#t:Track>`__                                       |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `ChallengeType <Model-ChallengeType.html#t:ChallengeType>`__               |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `ChallengeAccept <Model-ChallengeAccept.html#t:ChallengeAccept>`__         |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `Application <Model-Application.html#t:Application>`__                     |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `CarInstanceParts <Model-CarInstanceParts.html#t:CarInstanceParts>`__      |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `PartInstance <Model-PartInstance.html#t:PartInstance>`__                  |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `PartModifier <Model-PartModifier.html#t:PartModifier>`__                  |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `Account <Model-Account.html#t:Account>`__                                 |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `Transaction <Model-Transaction.html#t:Transaction>`__                     |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `Escrow <Model-Escrow.html#t:Escrow>`__                                    |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `AccountProfileMin <Model-AccountProfileMin.html#t:AccountProfileMin>`__   |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `CarOptions <Model-CarOptions.html#t:CarOptions>`__                        |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `CarInGarage <Model-CarInGarage.html#t:CarInGarage>`__                     |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `CarMinimal <Model-CarMinimal.html#t:CarMinimal>`__                        |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `TrackTime <Model-TrackTime.html#t:TrackTime>`__                           |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `Challenge <Model-Challenge.html#t:Challenge>`__                           |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `TournamentPlayer <Model-TournamentPlayers.html#t:TournamentPlayer>`__     |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `CarInstance <Model-CarInstance.html#t:CarInstance>`__                     |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `Race <Model-Race.html#t:Race>`__                                          |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `TournamentResult <Model-TournamentResult.html#t:TournamentResult>`__      |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `TournamentReport <Model-TournamentReport.html#t:TournamentReport>`__      |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `Car <Model-Car.html#t:Car>`__                                             |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+

class Mapable a where

Methods

fromMap :: Map String `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__
-> Maybe a

toMap :: a -> Map String
`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__

fromHashMap :: HashMap String
`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__ -> Maybe a

toHashMap :: a -> HashMap String
`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__

updateMap :: Map String
`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__ -> a -> a

updateHashMap :: HashMap String
`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__ -> a -> a

Instances

+-------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `PartDetails <Model-PartDetails.html#t:PartDetails>`__                                   |     |
+-------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `RaceRewards <Data-RaceReward.html#t:RaceRewards>`__                                     |     |
+-------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `Tournament <Model-Tournament.html#t:Tournament>`__                                      |     |
+-------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `TournamentType <Model-TournamentType.html#t:TournamentType>`__                          |     |
+-------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `EventStream <Model-EventStream.html#t:EventStream>`__                                   |     |
+-------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `RaceReward <Model-RaceReward.html#t:RaceReward>`__                                      |     |
+-------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `Report <Model-Report.html#t:Report>`__                                                  |     |
+-------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `Task <Model-Task.html#t:Task>`__                                                        |     |
+-------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `TrackDetails <Model-TrackDetails.html#t:TrackDetails>`__                                |     |
+-------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `TrackMaster <Model-TrackMaster.html#t:TrackMaster>`__                                   |     |
+-------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `PreLetter <Model-PreLetter.html#t:PreLetter>`__                                         |     |
+-------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `RaceSectionPerformance <Data-RaceSectionPerformance.html#t:RaceSectionPerformance>`__   |     |
+-------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `AccountProfile <Model-AccountProfile.html#t:AccountProfile>`__                          |     |
+-------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `TaskTrigger <Model-TaskTrigger.html#t:TaskTrigger>`__                                   |     |
+-------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `MenuModel <Model-MenuModel.html#t:MenuModel>`__                                         |     |
+-------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `Reward <Model-Reward.html#t:Reward>`__                                                  |     |
+-------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `RuleReward <Model-RuleReward.html#t:RuleReward>`__                                      |     |
+-------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `Action <Model-Action.html#t:Action>`__                                                  |     |
+-------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `Rule <Model-Rule.html#t:Rule>`__                                                        |     |
+-------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `RewardLog <Model-RewardLog.html#t:RewardLog>`__                                         |     |
+-------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `PartType <Model-PartType.html#t:PartType>`__                                            |     |
+-------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `Part <Model-Part.html#t:Part>`__                                                        |     |
+-------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `AccountGarage <Model-AccountGarage.html#t:AccountGarage>`__                             |     |
+-------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `PartMarket <Model-PartMarket.html#t:PartMarket>`__                                      |     |
+-------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `ParameterTable <Model-ParameterTable.html#t:ParameterTable>`__                          |     |
+-------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `PersonnelInstance <Model-PersonnelInstance.html#t:PersonnelInstance>`__                 |     |
+-------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `Personnel <Model-Personnel.html#t:Personnel>`__                                         |     |
+-------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `Notification <Model-Notification.html#t:Notification>`__                                |     |
+-------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `GaragePart <Model-GarageParts.html#t:GaragePart>`__                                     |     |
+-------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `Garage <Model-Garage.html#t:Garage>`__                                                  |     |
+-------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `Config <Model-Config.html#t:Config>`__                                                  |     |
+-------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `Continent <Model-Continent.html#t:Continent>`__                                         |     |
+-------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `Country <Model-Country.html#t:Country>`__                                               |     |
+-------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `City <Model-City.html#t:City>`__                                                        |     |
+-------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `Track <Model-Track.html#t:Track>`__                                                     |     |
+-------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `ChallengeType <Model-ChallengeType.html#t:ChallengeType>`__                             |     |
+-------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `ChallengeAccept <Model-ChallengeAccept.html#t:ChallengeAccept>`__                       |     |
+-------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `Application <Model-Application.html#t:Application>`__                                   |     |
+-------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `CarInstanceParts <Model-CarInstanceParts.html#t:CarInstanceParts>`__                    |     |
+-------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `PartInstance <Model-PartInstance.html#t:PartInstance>`__                                |     |
+-------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `PartModifier <Model-PartModifier.html#t:PartModifier>`__                                |     |
+-------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `Account <Model-Account.html#t:Account>`__                                               |     |
+-------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `Transaction <Model-Transaction.html#t:Transaction>`__                                   |     |
+-------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `Escrow <Model-Escrow.html#t:Escrow>`__                                                  |     |
+-------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `AccountProfileMin <Model-AccountProfileMin.html#t:AccountProfileMin>`__                 |     |
+-------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `CarOptions <Model-CarOptions.html#t:CarOptions>`__                                      |     |
+-------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `CarInGarage <Model-CarInGarage.html#t:CarInGarage>`__                                   |     |
+-------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `CarMinimal <Model-CarMinimal.html#t:CarMinimal>`__                                      |     |
+-------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `TrackTime <Model-TrackTime.html#t:TrackTime>`__                                         |     |
+-------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `RaceParticipant <Data-RaceParticipant.html#t:RaceParticipant>`__                        |     |
+-------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `Challenge <Model-Challenge.html#t:Challenge>`__                                         |     |
+-------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ SectionResult                                                                            |     |
+-------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ RaceResult                                                                               |     |
+-------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ RaceParticipant                                                                          |     |
+-------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ RaceRewards                                                                              |     |
+-------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ RaceData                                                                                 |     |
+-------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `TournamentPlayer <Model-TournamentPlayers.html#t:TournamentPlayer>`__                   |     |
+-------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `CarInstance <Model-CarInstance.html#t:CarInstance>`__                                   |     |
+-------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `SectionResult <Data-RacingNew.html#t:SectionResult>`__                                  |     |
+-------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `RaceResult <Data-RacingNew.html#t:RaceResult>`__                                        |     |
+-------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `RaceData <Data-RacingNew.html#t:RaceData>`__                                            |     |
+-------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `Race <Model-Race.html#t:Race>`__                                                        |     |
+-------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `TournamentResult <Model-TournamentResult.html#t:TournamentResult>`__                    |     |
+-------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `TournamentReport <Model-TournamentReport.html#t:TournamentReport>`__                    |     |
+-------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ RoundResult                                                                              |     |
+-------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ TournamentFullData                                                                       |     |
+-------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `Car <Model-Car.html#t:Car>`__                                                           |     |
+-------------------------------------------------------------------------------------------------------------------------------------+-----+

type Id = Maybe Integer

nlookup :: Convertible
`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__ a => String ->
HashMap String `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__ ->
Maybe a

nempty :: HashMap String
`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__

htsql :: Convertible a
`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__ => a ->
`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__

thsql :: `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__ -> Integer

ninsert :: (Eq k, Hashable k) => k -> v -> HashMap k v -> HashMap k v

sinsert :: Ord k => k -> a -> Map k a -> Map k a

mlookup :: Convertible
`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__ a => String -> Map
String `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__ -> Maybe a

mco :: Functor f => f `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__
-> f Integer

mfp :: (Functor f, `Mapable <Model-General.html#t:Mapable>`__ a) => f
[HashMap String `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__] -> f
[a]

nhead :: (Functor f, `Mapable <Model-General.html#t:Mapable>`__ a) => f
[HashMap String `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__] -> f
(Maybe a)

sempty :: Map String `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__

aget :: `Database <Model-General.html#t:Database>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ a =>
`Constraints <Data-Database.html#t:Constraints>`__ ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ a ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ a

agetlist :: `Database <Model-General.html#t:Database>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ a =>
`Constraints <Data-Database.html#t:Constraints>`__ ->
`Orders <Data-Database.html#t:Orders>`__ -> Integer -> Integer ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ [a] ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ [a]

aload :: `Database <Model-General.html#t:Database>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ a => Integer ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ a ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ a

adeny :: `Database <Model-General.html#t:Database>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ a =>
`Constraints <Data-Database.html#t:Constraints>`__ ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ [a] ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ [a]

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
