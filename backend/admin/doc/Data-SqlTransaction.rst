===================
Data.SqlTransaction
===================

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Data.SqlTransaction

Documentation
=============

atomical ::
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ a ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ a

prepare :: `IConnection <Data-SqlTransaction.html#t:IConnection>`__ c =>
String -> `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
c `Statement <Data-SqlTransaction.html#t:Statement>`__

quickQuery :: `IConnection <Data-SqlTransaction.html#t:IConnection>`__ c
=> String -> [`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__\ ] ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c
[[`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__\ ]]

quickQuery' :: `IConnection <Data-SqlTransaction.html#t:IConnection>`__
c => String -> [`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__\ ] ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c
[[`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__\ ]]

rollback :: String ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ m t

waitWhen ::
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ Bool ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ ()

waitUnless ::
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ Bool ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ ()

run :: `IConnection <Data-SqlTransaction.html#t:IConnection>`__ c =>
String -> [`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__\ ] ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c Integer

getUser ::
`SqlTransactionUser <Data-SqlTransaction.html#t:SqlTransactionUser>`__ l
c l

putUser :: l ->
`SqlTransactionUser <Data-SqlTransaction.html#t:SqlTransactionUser>`__ l
c ()

sRun :: `IConnection <Data-SqlTransaction.html#t:IConnection>`__ c =>
String -> [Maybe String] ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c Integer

execute :: `IConnection <Data-SqlTransaction.html#t:IConnection>`__ c =>
`Statement <Data-SqlTransaction.html#t:Statement>`__ ->
[`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__\ ] ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c Integer

executeMany :: `IConnection <Data-SqlTransaction.html#t:IConnection>`__
c => `Statement <Data-SqlTransaction.html#t:Statement>`__ ->
[[`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__\ ]] ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c ()

executeRaw :: `IConnection <Data-SqlTransaction.html#t:IConnection>`__ c
=> `Statement <Data-SqlTransaction.html#t:Statement>`__ ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c ()

sExecute :: `IConnection <Data-SqlTransaction.html#t:IConnection>`__ c
=> `Statement <Data-SqlTransaction.html#t:Statement>`__ -> [Maybe
String] ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c Integer

sExecuteMany :: `IConnection <Data-SqlTransaction.html#t:IConnection>`__
c => `Statement <Data-SqlTransaction.html#t:Statement>`__ -> [[Maybe
String]] ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c ()

fetchRow :: `IConnection <Data-SqlTransaction.html#t:IConnection>`__ c
=> `Statement <Data-SqlTransaction.html#t:Statement>`__ ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c (Maybe
[`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__\ ])

fetchRowAl :: `IConnection <Data-SqlTransaction.html#t:IConnection>`__ c
=> `Statement <Data-SqlTransaction.html#t:Statement>`__ ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c (Maybe
[(String, `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__)])

fetchRowMap :: `IConnection <Data-SqlTransaction.html#t:IConnection>`__
c => `Statement <Data-SqlTransaction.html#t:Statement>`__ ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c (Maybe
(Map String `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__))

fetchAllRows :: `IConnection <Data-SqlTransaction.html#t:IConnection>`__
c => `Statement <Data-SqlTransaction.html#t:Statement>`__ ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c
[[`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__\ ]]

fetchAllRows' ::
`IConnection <Data-SqlTransaction.html#t:IConnection>`__ c =>
`Statement <Data-SqlTransaction.html#t:Statement>`__ ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c
[[`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__\ ]]

fetchAllRowsAL ::
`IConnection <Data-SqlTransaction.html#t:IConnection>`__ c =>
`Statement <Data-SqlTransaction.html#t:Statement>`__ ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c
[[(String, `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__)]]

fetchAllRowsAL' ::
`IConnection <Data-SqlTransaction.html#t:IConnection>`__ c =>
`Statement <Data-SqlTransaction.html#t:Statement>`__ ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c
[[(String, `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__)]]

fetchAllRowsMap ::
`IConnection <Data-SqlTransaction.html#t:IConnection>`__ c =>
`Statement <Data-SqlTransaction.html#t:Statement>`__ ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c [Map
String `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__]

sFetchRow :: `Statement <Data-SqlTransaction.html#t:Statement>`__ ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c (Maybe
[Maybe String])

sFetchAllRows ::
`IConnection <Data-SqlTransaction.html#t:IConnection>`__ c =>
`Statement <Data-SqlTransaction.html#t:Statement>`__ ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c [[Maybe
String]]

sFetchAllRows' ::
`IConnection <Data-SqlTransaction.html#t:IConnection>`__ c =>
`Statement <Data-SqlTransaction.html#t:Statement>`__ ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c [[Maybe
String]]

finish :: `Statement <Data-SqlTransaction.html#t:Statement>`__ ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c ()

type SqlTransaction c a =
`SqlTransactionUser <Data-SqlTransaction.html#t:SqlTransactionUser>`__
`Lock <LockSnaplet.html#t:Lock>`__ c a

data SqlTransactionUser l c a

Instances

+--------------------------------------------------------------------------------------------------+-----+
| MonadState c (`SqlTransactionUser <Data-SqlTransaction.html#t:SqlTransactionUser>`__ l c)        |     |
+--------------------------------------------------------------------------------------------------+-----+
| MonadReader c (`SqlTransactionUser <Data-SqlTransaction.html#t:SqlTransactionUser>`__ l c)       |     |
+--------------------------------------------------------------------------------------------------+-----+
| MonadError String (`SqlTransactionUser <Data-SqlTransaction.html#t:SqlTransactionUser>`__ l c)   |     |
+--------------------------------------------------------------------------------------------------+-----+
| Monad (`SqlTransactionUser <Data-SqlTransaction.html#t:SqlTransactionUser>`__ l c)               |     |
+--------------------------------------------------------------------------------------------------+-----+
| Functor (`SqlTransactionUser <Data-SqlTransaction.html#t:SqlTransactionUser>`__ l c)             |     |
+--------------------------------------------------------------------------------------------------+-----+
| MonadPlus (`SqlTransactionUser <Data-SqlTransaction.html#t:SqlTransactionUser>`__ l c)           |     |
+--------------------------------------------------------------------------------------------------+-----+
| Applicative (`SqlTransactionUser <Data-SqlTransaction.html#t:SqlTransactionUser>`__ l c)         |     |
+--------------------------------------------------------------------------------------------------+-----+
| Alternative (`SqlTransactionUser <Data-SqlTransaction.html#t:SqlTransactionUser>`__ l c)         |     |
+--------------------------------------------------------------------------------------------------+-----+
| MonadIO (`SqlTransactionUser <Data-SqlTransaction.html#t:SqlTransactionUser>`__ l c)             |     |
+--------------------------------------------------------------------------------------------------+-----+

runSqlTransaction :: (Applicative m, MonadIO m,
`IConnection <Data-SqlTransaction.html#t:IConnection>`__ conn) =>
`SqlTransactionUser <Data-SqlTransaction.html#t:SqlTransactionUser>`__ l
conn b -> (String -> m b) -> conn -> l -> m b

data SqlValue

Constructors

+---------------------------------------------+-----+
| SqlString String                            |     |
+---------------------------------------------+-----+
| SqlByteString ByteString                    |     |
+---------------------------------------------+-----+
| SqlWord32 Word32                            |     |
+---------------------------------------------+-----+
| SqlWord64 Word64                            |     |
+---------------------------------------------+-----+
| SqlInt32 Int32                              |     |
+---------------------------------------------+-----+
| SqlInt64 Int64                              |     |
+---------------------------------------------+-----+
| SqlInteger Integer                          |     |
+---------------------------------------------+-----+
| SqlChar Char                                |     |
+---------------------------------------------+-----+
| SqlBool Bool                                |     |
+---------------------------------------------+-----+
| SqlDouble Double                            |     |
+---------------------------------------------+-----+
| SqlRational Rational                        |     |
+---------------------------------------------+-----+
| SqlLocalDate Day                            |     |
+---------------------------------------------+-----+
| SqlLocalTimeOfDay TimeOfDay                 |     |
+---------------------------------------------+-----+
| SqlZonedLocalTimeOfDay TimeOfDay TimeZone   |     |
+---------------------------------------------+-----+
| SqlLocalTime LocalTime                      |     |
+---------------------------------------------+-----+
| SqlZonedTime ZonedTime                      |     |
+---------------------------------------------+-----+
| SqlUTCTime UTCTime                          |     |
+---------------------------------------------+-----+
| SqlDiffTime NominalDiffTime                 |     |
+---------------------------------------------+-----+
| SqlPOSIXTime POSIXTime                      |     |
+---------------------------------------------+-----+
| SqlEpochTime Integer                        |     |
+---------------------------------------------+-----+
| SqlTimeDiff Integer                         |     |
+---------------------------------------------+-----+
| SqlNull                                     |     |
+---------------------------------------------+-----+

Instances

Eq `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__

 

Show `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__

 

Show Result

 

Typeable `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__

 

IsString `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__

 

`FromInRule <Data-InRules.html#t:FromInRule>`__
`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__

 

`ToInRule <Data-InRules.html#t:ToInRule>`__
`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__

Renders InRule to String.

`StringLike <Data-Tools.html#t:StringLike>`__
`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__

 

`Expressable <Data-Database.html#t:Expressable>`__
`Values <Data-Database.html#t:Values>`__

 

`Expressable <Data-Database.html#t:Expressable>`__
`Value <Data-Database.html#t:Value>`__

 

`Expression <Data-Database.html#t:Expression>`__
`Selections <Data-Database.html#t:Selections>`__

 

`Expression <Data-Database.html#t:Expression>`__
`Pair <Data-Database.html#t:Pair>`__

 

ToValues Query

 

ToSql Query

 

Convertible Bool `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__

 

Convertible Char `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__

 

Convertible Double `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__

 

Convertible Int `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__

 

Convertible Int32 `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__

 

Convertible Int64 `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__

 

Convertible Integer `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__

 

Convertible Rational `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__

 

Convertible Word32 `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__

 

Convertible Word64 `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__

 

Convertible String `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__

 

Convertible ByteString
`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__

 

Convertible Text `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__

 

Convertible ByteString
`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__

 

Convertible ZonedTime `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__

 

Convertible Text `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__

 

Convertible UTCTime `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__

 

Convertible Day `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__

 

Convertible TimeOfDay `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__

 

Convertible LocalTime `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__

 

Convertible DiffTime `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__

 

Convertible NominalDiffTime
`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__

 

Convertible `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__ Bool

 

Convertible `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__ Char

 

Convertible `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__ Double

 

Convertible `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__ Int

 

Convertible `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__ Int32

 

Convertible `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__ Int64

 

Convertible `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__ Integer

 

Convertible `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__ Rational

 

Convertible `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__ Word32

 

Convertible `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__ Word64

 

Convertible `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__ String

 

Convertible `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__
ByteString

 

Convertible `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__ Text

 

Convertible `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__
ByteString

 

Convertible `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__ ZonedTime

 

Convertible `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__ Text

 

Convertible `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__ UTCTime

 

Convertible `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__ Day

 

Convertible `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__ TimeOfDay

 

Convertible `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__ LocalTime

 

Convertible `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__ DiffTime

 

Convertible `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__
NominalDiffTime

 

Convertible `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__
`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__

 

Convertible `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__ TimeDiff

 

Convertible `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__ ClockTime

 

Convertible `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__
CalendarTime

 

Convertible `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__
`HStore <Data-Hstore.html#t:HStore>`__

 

Convertible TimeDiff `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__

 

Convertible ClockTime `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__

 

Convertible CalendarTime
`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__

 

Convertible `HStore <Data-Hstore.html#t:HStore>`__
`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__

 

Convertible `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__ a =>
Convertible `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__ (Maybe a)

 

Convertible `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__
(TimeOfDay, TimeZone)

 

Convertible a `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__ =>
Convertible (Maybe a) `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__

 

Convertible (TimeOfDay, TimeZone)
`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__

 

class IConnection conn where

Methods

disconnect :: conn -> IO ()

Instances

+-------------------------------------------------------------------------------------------------------------------+-----+
| `IConnection <Data-SqlTransaction.html#t:IConnection>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__   |     |
+-------------------------------------------------------------------------------------------------------------------+-----+
| `IConnection <Data-SqlTransaction.html#t:IConnection>`__ ConnWrapper                                              |     |
+-------------------------------------------------------------------------------------------------------------------+-----+

data Statement

disconnect :: `IConnection <Data-SqlTransaction.html#t:IConnection>`__
conn => conn -> IO ()

sqlGetOne :: `IConnection <Data-SqlTransaction.html#t:IConnection>`__ c
=> String -> [`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__\ ] ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c
`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__

sqlGetRow :: `IConnection <Data-SqlTransaction.html#t:IConnection>`__ c
=> String -> [`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__\ ] ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c
[`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__\ ]

sqlGetAll :: `IConnection <Data-SqlTransaction.html#t:IConnection>`__ c
=> String -> [`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__\ ] ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c
[[`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__\ ]]

sqlGetAllAssoc ::
`IConnection <Data-SqlTransaction.html#t:IConnection>`__ c => String ->
[`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__\ ] ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c
[HashMap String `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__]

sqlExecute :: `IConnection <Data-SqlTransaction.html#t:IConnection>`__ c
=> String -> [`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__\ ] ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c ()

quickInsert :: `IConnection <Data-SqlTransaction.html#t:IConnection>`__
c => String -> [(String,
`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__)] ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c
`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__

forkSqlTransaction ::
`SqlTransactionUser <Data-SqlTransaction.html#t:SqlTransactionUser>`__ l
c r ->
`SqlTransactionUser <Data-SqlTransaction.html#t:SqlTransactionUser>`__ l
c ThreadId

data Connection

Instances

+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `IConnection <Data-SqlTransaction.html#t:IConnection>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__                                                                |     |
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

withEncoding :: `IConnection <Data-SqlTransaction.html#t:IConnection>`__
c => String ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c a ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c a

newFuture :: `IConnection <Data-SqlTransaction.html#t:IConnection>`__ c
=> `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c a ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c (Future
a)

readFuture :: Future a ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c a

doneFuture :: Future a ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c Bool

emptyFuture ::
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c (Future
a)

par2 :: `IConnection <Data-SqlTransaction.html#t:IConnection>`__ c =>
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c a ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c b ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c (a, b)

par3 :: `IConnection <Data-SqlTransaction.html#t:IConnection>`__ c =>
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c a ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c b ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c c ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c (a, b,
c)

par4 :: `IConnection <Data-SqlTransaction.html#t:IConnection>`__ c =>
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c p ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c q ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c r ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c s ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c (p, q,
r, s)

parN :: `IConnection <Data-SqlTransaction.html#t:IConnection>`__ c =>
[`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c p] ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c [p]

parSafe ::
[`SqlTransactionUser <Data-SqlTransaction.html#t:SqlTransactionUser>`__
`Lock <LockSnaplet.html#t:Lock>`__ c b] ->
`SqlTransactionUser <Data-SqlTransaction.html#t:SqlTransactionUser>`__
`Lock <LockSnaplet.html#t:Lock>`__ c [b]

fillFuture :: Future a -> Either String a ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c ()

lock :: String -> `Lock <Data-SqlTransaction.html#t:Lock>`__ ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ a ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ a

data Lock

Constructors

+------------------------+-----+
| AccessShare            |     |
+------------------------+-----+
| RowShare               |     |
+------------------------+-----+
| RowExclusive           |     |
+------------------------+-----+
| ShareUpdateExclusive   |     |
+------------------------+-----+
| Share                  |     |
+------------------------+-----+
| ShareRowExclusive      |     |
+------------------------+-----+
| AccessExclusive        |     |
+------------------------+-----+

Instances

+---------------------------------------------------+-----+
| Show `Lock <Data-SqlTransaction.html#t:Lock>`__   |     |
+---------------------------------------------------+-----+

runTestDb ::
`SqlTransactionUser <Data-SqlTransaction.html#t:SqlTransactionUser>`__ l
`Connection <Data-SqlTransaction.html#t:Connection>`__ b -> IO b

catchSqlError ::
`SqlTransactionUser <Data-SqlTransaction.html#t:SqlTransactionUser>`__ l
c a -> ([Char] ->
`SqlTransactionUser <Data-SqlTransaction.html#t:SqlTransactionUser>`__ l
c a) ->
`SqlTransactionUser <Data-SqlTransaction.html#t:SqlTransactionUser>`__ l
c a

commit :: `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ ()

dbWithLockBlock :: Show a => Namespace -> a ->
`SqlTransactionUser <Data-SqlTransaction.html#t:SqlTransactionUser>`__
`Lock <LockSnaplet.html#t:Lock>`__ c b ->
`SqlTransactionUser <Data-SqlTransaction.html#t:SqlTransactionUser>`__
`Lock <LockSnaplet.html#t:Lock>`__ c b

dbWithLockNonBlock :: Show a => Namespace -> a ->
`SqlTransactionUser <Data-SqlTransaction.html#t:SqlTransactionUser>`__
`Lock <LockSnaplet.html#t:Lock>`__ c () ->
`SqlTransactionUser <Data-SqlTransaction.html#t:SqlTransactionUser>`__
`Lock <LockSnaplet.html#t:Lock>`__ c ()

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
