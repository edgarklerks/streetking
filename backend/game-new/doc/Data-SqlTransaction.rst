===================
Data.SqlTransaction
===================

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Data.SqlTransaction

Synopsis

-  `quickInsert <#v:quickInsert>`__ ::
   `IConnection <Data-SqlTransaction.html#t:IConnection>`__ c => String
   -> [(String, `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__)] ->
   `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c
   `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__
-  data `Connection <#t:Connection>`__
-  class `IConnection <#t:IConnection>`__ conn where

   -  `disconnect <#v:disconnect>`__ :: conn -> IO ()

-  data `SqlValue <#t:SqlValue>`__

   -  = `SqlString <#v:SqlString>`__ String
   -  \| `SqlByteString <#v:SqlByteString>`__ ByteString
   -  \| `SqlWord32 <#v:SqlWord32>`__ Word32
   -  \| `SqlWord64 <#v:SqlWord64>`__ Word64
   -  \| `SqlInt32 <#v:SqlInt32>`__ Int32
   -  \| `SqlInt64 <#v:SqlInt64>`__ Int64
   -  \| `SqlInteger <#v:SqlInteger>`__ Integer
   -  \| `SqlChar <#v:SqlChar>`__ Char
   -  \| `SqlBool <#v:SqlBool>`__ Bool
   -  \| `SqlDouble <#v:SqlDouble>`__ Double
   -  \| `SqlRational <#v:SqlRational>`__ Rational
   -  \| `SqlLocalDate <#v:SqlLocalDate>`__ Day
   -  \| `SqlLocalTimeOfDay <#v:SqlLocalTimeOfDay>`__ TimeOfDay
   -  \| `SqlZonedLocalTimeOfDay <#v:SqlZonedLocalTimeOfDay>`__
      TimeOfDay TimeZone
   -  \| `SqlLocalTime <#v:SqlLocalTime>`__ LocalTime
   -  \| `SqlZonedTime <#v:SqlZonedTime>`__ ZonedTime
   -  \| `SqlUTCTime <#v:SqlUTCTime>`__ UTCTime
   -  \| `SqlDiffTime <#v:SqlDiffTime>`__ NominalDiffTime
   -  \| `SqlPOSIXTime <#v:SqlPOSIXTime>`__ POSIXTime
   -  \| `SqlEpochTime <#v:SqlEpochTime>`__ Integer
   -  \| `SqlTimeDiff <#v:SqlTimeDiff>`__ Integer
   -  \| `SqlNull <#v:SqlNull>`__

-  data `Statement <#t:Statement>`__
-  `disconnect <#v:disconnect>`__ ::
   `IConnection <Data-SqlTransaction.html#t:IConnection>`__ conn => conn
   -> IO ()
-  data `Lock <#t:Lock>`__

   -  = `AccessShare <#v:AccessShare>`__
   -  \| `RowShare <#v:RowShare>`__
   -  \| `RowExclusive <#v:RowExclusive>`__
   -  \| `ShareUpdateExclusive <#v:ShareUpdateExclusive>`__
   -  \| `Share <#v:Share>`__
   -  \| `ShareRowExclusive <#v:ShareRowExclusive>`__
   -  \| `AccessExclusive <#v:AccessExclusive>`__

-  type `SqlTransaction <#t:SqlTransaction>`__ c a =
   `SqlTransactionUser <Data-SqlTransaction.html#t:SqlTransactionUser>`__
   `Lock <LockSnaplet.html#t:Lock>`__ c a
-  data `SqlTransactionUser <#t:SqlTransactionUser>`__ l c a
-  `atomical <#v:atomical>`__ ::
   `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
   `Connection <Data-SqlTransaction.html#t:Connection>`__ a ->
   `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
   `Connection <Data-SqlTransaction.html#t:Connection>`__ a
-  `catchSqlError <#v:catchSqlError>`__ ::
   `IConnection <Data-SqlTransaction.html#t:IConnection>`__ c =>
   `SqlTransactionUser <Data-SqlTransaction.html#t:SqlTransactionUser>`__
   l c a -> (`SqlError <Data-SqlTransaction.html#t:SqlError>`__ ->
   `SqlTransactionUser <Data-SqlTransaction.html#t:SqlTransactionUser>`__
   l c a) ->
   `SqlTransactionUser <Data-SqlTransaction.html#t:SqlTransactionUser>`__
   l c a
-  `commit <#v:commit>`__ ::
   `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
   `Connection <Data-SqlTransaction.html#t:Connection>`__ ()
-  `dbWithLockBlock <#v:dbWithLockBlock>`__ :: Show a => Namespace -> a
   ->
   `SqlTransactionUser <Data-SqlTransaction.html#t:SqlTransactionUser>`__
   `Lock <LockSnaplet.html#t:Lock>`__ c b ->
   `SqlTransactionUser <Data-SqlTransaction.html#t:SqlTransactionUser>`__
   `Lock <LockSnaplet.html#t:Lock>`__ c b
-  `dbWithLockNonBlock <#v:dbWithLockNonBlock>`__ :: Show a => Namespace
   -> a ->
   `SqlTransactionUser <Data-SqlTransaction.html#t:SqlTransactionUser>`__
   `Lock <LockSnaplet.html#t:Lock>`__ c () ->
   `SqlTransactionUser <Data-SqlTransaction.html#t:SqlTransactionUser>`__
   `Lock <LockSnaplet.html#t:Lock>`__ c ()
-  `doneFuture <#v:doneFuture>`__ :: Future a ->
   `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c Bool
-  `emptyFuture <#v:emptyFuture>`__ ::
   `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c
   (Future a)
-  `execute <#v:execute>`__ ::
   `IConnection <Data-SqlTransaction.html#t:IConnection>`__ c =>
   `Statement <Data-SqlTransaction.html#t:Statement>`__ ->
   [`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__\ ] ->
   `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c
   Integer
-  `executeMany <#v:executeMany>`__ ::
   `IConnection <Data-SqlTransaction.html#t:IConnection>`__ c =>
   `Statement <Data-SqlTransaction.html#t:Statement>`__ ->
   [[`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__\ ]] ->
   `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c ()
-  `executeRaw <#v:executeRaw>`__ ::
   `IConnection <Data-SqlTransaction.html#t:IConnection>`__ c =>
   `Statement <Data-SqlTransaction.html#t:Statement>`__ ->
   `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c ()
-  `fetchAllRows' <#v:fetchAllRows-39->`__ ::
   `IConnection <Data-SqlTransaction.html#t:IConnection>`__ c =>
   `Statement <Data-SqlTransaction.html#t:Statement>`__ ->
   `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c
   [[`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__\ ]]
-  `fetchAllRows <#v:fetchAllRows>`__ ::
   `IConnection <Data-SqlTransaction.html#t:IConnection>`__ c =>
   `Statement <Data-SqlTransaction.html#t:Statement>`__ ->
   `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c
   [[`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__\ ]]
-  `fetchAllRowsAL' <#v:fetchAllRowsAL-39->`__ ::
   `IConnection <Data-SqlTransaction.html#t:IConnection>`__ c =>
   `Statement <Data-SqlTransaction.html#t:Statement>`__ ->
   `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c
   [[(String, `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__)]]
-  `fetchAllRowsAL <#v:fetchAllRowsAL>`__ ::
   `IConnection <Data-SqlTransaction.html#t:IConnection>`__ c =>
   `Statement <Data-SqlTransaction.html#t:Statement>`__ ->
   `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c
   [[(String, `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__)]]
-  `fetchAllRowsMap <#v:fetchAllRowsMap>`__ ::
   `IConnection <Data-SqlTransaction.html#t:IConnection>`__ c =>
   `Statement <Data-SqlTransaction.html#t:Statement>`__ ->
   `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c [Map
   String `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__]
-  `fetchRow <#v:fetchRow>`__ ::
   `IConnection <Data-SqlTransaction.html#t:IConnection>`__ c =>
   `Statement <Data-SqlTransaction.html#t:Statement>`__ ->
   `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c
   (Maybe [`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__\ ])
-  `fetchRowAl <#v:fetchRowAl>`__ ::
   `IConnection <Data-SqlTransaction.html#t:IConnection>`__ c =>
   `Statement <Data-SqlTransaction.html#t:Statement>`__ ->
   `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c
   (Maybe [(String,
   `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__)])
-  `fetchRowMap <#v:fetchRowMap>`__ ::
   `IConnection <Data-SqlTransaction.html#t:IConnection>`__ c =>
   `Statement <Data-SqlTransaction.html#t:Statement>`__ ->
   `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c
   (Maybe (Map String
   `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__))
-  `fillFuture <#v:fillFuture>`__ :: Future a -> Either
   `SqlError <Data-SqlTransaction.html#t:SqlError>`__ a ->
   `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c ()
-  `finish <#v:finish>`__ ::
   `Statement <Data-SqlTransaction.html#t:Statement>`__ ->
   `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c ()
-  `forkSqlTransaction <#v:forkSqlTransaction>`__ ::
   `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
   `Connection <Data-SqlTransaction.html#t:Connection>`__ () ->
   `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
   `Connection <Data-SqlTransaction.html#t:Connection>`__ ThreadId
-  `get <#v:get>`__ :: MonadState s m => m s
-  `getUser <#v:getUser>`__ ::
   `SqlTransactionUser <Data-SqlTransaction.html#t:SqlTransactionUser>`__
   l c l
-  `lock <#v:lock>`__ :: String ->
   `Lock <Data-SqlTransaction.html#t:Lock>`__ ->
   `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
   `Connection <Data-SqlTransaction.html#t:Connection>`__ a ->
   `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
   `Connection <Data-SqlTransaction.html#t:Connection>`__ a
-  `newFuture <#v:newFuture>`__ ::
   `IConnection <Data-SqlTransaction.html#t:IConnection>`__ c =>
   `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c a ->
   `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c
   (Future a)
-  `par2 <#v:par2>`__ ::
   `IConnection <Data-SqlTransaction.html#t:IConnection>`__ c =>
   `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c a ->
   `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c b ->
   `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c (a,
   b)
-  `par3 <#v:par3>`__ ::
   `IConnection <Data-SqlTransaction.html#t:IConnection>`__ c =>
   `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c a ->
   `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c b ->
   `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c c ->
   `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c (a,
   b, c)
-  `par4 <#v:par4>`__ ::
   `IConnection <Data-SqlTransaction.html#t:IConnection>`__ c =>
   `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c p ->
   `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c q ->
   `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c r ->
   `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c s ->
   `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c (p,
   q, r, s)
-  `parN <#v:parN>`__ ::
   `IConnection <Data-SqlTransaction.html#t:IConnection>`__ c =>
   [`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c p]
   -> `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c
   [p]
-  `parSafe <#v:parSafe>`__ ::
   [`SqlTransactionUser <Data-SqlTransaction.html#t:SqlTransactionUser>`__
   `Lock <LockSnaplet.html#t:Lock>`__
   `Connection <Data-SqlTransaction.html#t:Connection>`__ b] ->
   `SqlTransactionUser <Data-SqlTransaction.html#t:SqlTransactionUser>`__
   `Lock <LockSnaplet.html#t:Lock>`__
   `Connection <Data-SqlTransaction.html#t:Connection>`__ [b]
-  `prepare <#v:prepare>`__ ::
   `IConnection <Data-SqlTransaction.html#t:IConnection>`__ c => String
   -> `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c
   `Statement <Data-SqlTransaction.html#t:Statement>`__
-  `putUser <#v:putUser>`__ :: l ->
   `SqlTransactionUser <Data-SqlTransaction.html#t:SqlTransactionUser>`__
   l c ()
-  `quickQuery' <#v:quickQuery-39->`__ ::
   `IConnection <Data-SqlTransaction.html#t:IConnection>`__ c => String
   -> [`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__\ ] ->
   `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c
   [[`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__\ ]]
-  `quickQuery <#v:quickQuery>`__ ::
   `IConnection <Data-SqlTransaction.html#t:IConnection>`__ c => String
   -> [`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__\ ] ->
   `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c
   [[`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__\ ]]
-  `readFuture <#v:readFuture>`__ ::
   `IConnection <Data-SqlTransaction.html#t:IConnection>`__ c => Future
   a -> `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c
   a
-  `rollback <#v:rollback>`__ ::
   `IConnection <Data-SqlTransaction.html#t:IConnection>`__ m => String
   -> `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ m t
-  `run <#v:run>`__ ::
   `IConnection <Data-SqlTransaction.html#t:IConnection>`__ c => String
   -> [`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__\ ] ->
   `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c
   Integer
-  `runSqlTransaction <#v:runSqlTransaction>`__ :: (Applicative m,
   `IConnection <Data-SqlTransaction.html#t:IConnection>`__ conn,
   MonadIO m) =>
   `SqlTransactionUser <Data-SqlTransaction.html#t:SqlTransactionUser>`__
   l conn b -> (String -> m b) -> conn -> l -> m b
-  `runTestDb <#v:runTestDb>`__ ::
   `SqlTransactionUser <Data-SqlTransaction.html#t:SqlTransactionUser>`__
   l `Connection <Data-SqlTransaction.html#t:Connection>`__ b -> IO b
-  `sExecute <#v:sExecute>`__ ::
   `IConnection <Data-SqlTransaction.html#t:IConnection>`__ c =>
   `Statement <Data-SqlTransaction.html#t:Statement>`__ -> [Maybe
   String] ->
   `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c
   Integer
-  `sExecuteMany <#v:sExecuteMany>`__ ::
   `IConnection <Data-SqlTransaction.html#t:IConnection>`__ c =>
   `Statement <Data-SqlTransaction.html#t:Statement>`__ -> [[Maybe
   String]] ->
   `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c ()
-  `sFetchAllRows' <#v:sFetchAllRows-39->`__ ::
   `IConnection <Data-SqlTransaction.html#t:IConnection>`__ c =>
   `Statement <Data-SqlTransaction.html#t:Statement>`__ ->
   `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c
   [[Maybe String]]
-  `sFetchAllRows <#v:sFetchAllRows>`__ ::
   `IConnection <Data-SqlTransaction.html#t:IConnection>`__ c =>
   `Statement <Data-SqlTransaction.html#t:Statement>`__ ->
   `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c
   [[Maybe String]]
-  `sFetchRow <#v:sFetchRow>`__ ::
   `Statement <Data-SqlTransaction.html#t:Statement>`__ ->
   `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c
   (Maybe [Maybe String])
-  `sRun <#v:sRun>`__ ::
   `IConnection <Data-SqlTransaction.html#t:IConnection>`__ c => String
   -> [Maybe String] ->
   `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c
   Integer
-  data `SqlError <#t:SqlError>`__

   -  = `UError <#v:UError>`__ String
   -  \| `DBError <#v:DBError>`__ String

-  `sqlExecute <#v:sqlExecute>`__ ::
   `IConnection <Data-SqlTransaction.html#t:IConnection>`__ c => String
   -> [`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__\ ] ->
   `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c ()
-  `sqlGetAll <#v:sqlGetAll>`__ ::
   `IConnection <Data-SqlTransaction.html#t:IConnection>`__ c => String
   -> [`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__\ ] ->
   `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c
   [[`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__\ ]]
-  `sqlGetAllAssoc <#v:sqlGetAllAssoc>`__ ::
   `IConnection <Data-SqlTransaction.html#t:IConnection>`__ c => String
   -> [`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__\ ] ->
   `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c
   [HashMap String `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__]
-  `sqlGetOne <#v:sqlGetOne>`__ ::
   `IConnection <Data-SqlTransaction.html#t:IConnection>`__ c => String
   -> [`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__\ ] ->
   `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c
   `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__
-  `sqlGetRow <#v:sqlGetRow>`__ ::
   `IConnection <Data-SqlTransaction.html#t:IConnection>`__ c => String
   -> [`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__\ ] ->
   `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c
   [`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__\ ]
-  `waitUnless <#v:waitUnless>`__ ::
   `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
   `Connection <Data-SqlTransaction.html#t:Connection>`__ Bool ->
   `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
   `Connection <Data-SqlTransaction.html#t:Connection>`__ ()
-  `waitWhen <#v:waitWhen>`__ ::
   `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
   `Connection <Data-SqlTransaction.html#t:Connection>`__ Bool ->
   `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
   `Connection <Data-SqlTransaction.html#t:Connection>`__ ()
-  `withEncoding <#v:withEncoding>`__ ::
   `IConnection <Data-SqlTransaction.html#t:IConnection>`__ c => String
   -> `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c a
   -> `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c a

Documentation
=============

quickInsert :: `IConnection <Data-SqlTransaction.html#t:IConnection>`__
c => String -> [(String,
`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__)] ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c
`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__

quickInsert: insert data map into a single specified table. data map has
the form [(field, value)]. values are SqlValues. lastval() is returned.

data Connection

Instances

+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `IConnection <Data-SqlTransaction.html#t:IConnection>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__                                                                                     |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `Account <Model-Account.html#t:Account>`__                                                      |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `Transaction <Model-Transaction.html#t:Transaction>`__                                          |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `Escrow <Model-Escrow.html#t:Escrow>`__                                                         |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `DiamondTransaction <Model-Diamonds.html#t:DiamondTransaction>`__                               |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `AccountProfile <Model-AccountProfile.html#t:AccountProfile>`__                                 |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `AccountProfileMin <Model-AccountProfileMin.html#t:AccountProfileMin>`__                        |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `Car <Model-Car.html#t:Car>`__                                                                  |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `Car3dModel <Model-Car3dModel.html#t:Car3dModel>`__                                             |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `CarInGarage <Model-CarInGarage.html#t:CarInGarage>`__                                          |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `CarInstance <Model-CarInstance.html#t:CarInstance>`__                                          |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `CarInstanceParts <Model-CarInstanceParts.html#t:CarInstanceParts>`__                           |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `CarMarket <Model-CarMarket.html#t:CarMarket>`__                                                |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `CarMinimal <Model-CarMinimal.html#t:CarMinimal>`__                                             |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `TrackTime <Model-TrackTime.html#t:TrackTime>`__                                                |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `CarOptions <Model-CarOptions.html#t:CarOptions>`__                                             |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `CarOptionsExtended <Model-CarOptionsExtended.html#t:CarOptionsExtended>`__                     |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `CarOwners <Model-CarOwners.html#t:CarOwners>`__                                                |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `CarStockPart <Model-CarStockParts.html#t:CarStockPart>`__                                      |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `Challenge <Model-Challenge.html#t:Challenge>`__                                                |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `ChallengeAccept <Model-ChallengeAccept.html#t:ChallengeAccept>`__                              |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `ChallengeExtended <Model-ChallengeExtended.html#t:ChallengeExtended>`__                        |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `ChallengeType <Model-ChallengeType.html#t:ChallengeType>`__                                    |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `City <Model-City.html#t:City>`__                                                               |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `Config <Model-Config.html#t:Config>`__                                                         |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `Continent <Model-Continent.html#t:Continent>`__                                                |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `EventStream <Model-EventStream.html#t:EventStream>`__                                          |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `Garage <Model-Garage.html#t:Garage>`__                                                         |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `GaragePart <Model-GarageParts.html#t:GaragePart>`__                                            |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `GarageReport <Model-GarageReport.html#t:GarageReport>`__                                       |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `GarageReportInsert <Model-GarageReportInsert.html#t:GarageReportInsert>`__                     |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `GeneralReport <Model-GeneralReport.html#t:GeneralReport>`__                                    |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `Manufacturer <Model-Manufacturer.html#t:Manufacturer>`__                                       |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `ManufacturerMarket <Model-ManufacturerMarket.html#t:ManufacturerMarket>`__                     |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `MarketCarInstanceParts <Model-MarketCarInstanceParts.html#t:MarketCarInstanceParts>`__         |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `MarketItem <Model-MarketItem.html#t:MarketItem>`__                                             |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `MarketPartType <Model-MarketPartType.html#t:MarketPartType>`__                                 |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `MarketPlace <Model-MarketPlace.html#t:MarketPlace>`__                                          |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `MarketPlaceCar <Model-MarketPlaceCar.html#t:MarketPlaceCar>`__                                 |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `MenuModel <Model-MenuModel.html#t:MenuModel>`__                                                |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `Part <Model-Part.html#t:Part>`__                                                               |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `PartDetails <Model-PartDetails.html#t:PartDetails>`__                                          |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `RaceReward <Model-RaceReward.html#t:RaceReward>`__                                             |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `Tournament <Model-Tournament.html#t:Tournament>`__                                             |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `TournamentExtended <Model-TournamentExtended.html#t:TournamentExtended>`__                     |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `PartInstance <Model-PartInstance.html#t:PartInstance>`__                                       |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `PartMarket <Model-PartMarket.html#t:PartMarket>`__                                             |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `PartMarketPlaceType <Model-PartMarketPlaceType.html#t:PartMarketPlaceType>`__                  |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `PartMarketType <Model-PartMarketType.html#t:PartMarketType>`__                                 |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `PartType <Model-PartType.html#t:PartType>`__                                                   |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `Personnel <Model-Personnel.html#t:Personnel>`__                                                |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `PersonnelDetails <Model-PersonnelDetails.html#t:PersonnelDetails>`__                           |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `PersonnelInstance <Model-PersonnelInstance.html#t:PersonnelInstance>`__                        |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `PersonnelInstanceDetails <Model-PersonnelInstanceDetails.html#t:PersonnelInstanceDetails>`__   |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `PersonnelReport <Model-PersonnelReport.html#t:PersonnelReport>`__                              |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `PersonnelTaskType <Model-PersonnelTaskType.html#t:PersonnelTaskType>`__                        |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `PreLetter <Model-PreLetter.html#t:PreLetter>`__                                                |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `Report <Model-Report.html#t:Report>`__                                                         |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `RewardLog <Model-RewardLog.html#t:RewardLog>`__                                                |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `RewardLogEvent <Model-RewardLogEvent.html#t:RewardLogEvent>`__                                 |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `ShopReport <Model-ShopReport.html#t:ShopReport>`__                                             |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `Support <Model-Support.html#t:Support>`__                                                      |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `TrackCity <Model-TrackCity.html#t:TrackCity>`__                                                |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `TrackContinent <Model-TrackContinent.html#t:TrackContinent>`__                                 |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `TrackDetails <Model-TrackDetails.html#t:TrackDetails>`__                                       |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `TrackMaster <Model-TrackMaster.html#t:TrackMaster>`__                                          |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `TravelReport <Model-TravelReport.html#t:TravelReport>`__                                       |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `Notification <Model-Notification.html#t:Notification>`__                                       |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `Task <Model-Task.html#t:Task>`__                                                               |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `TaskTrigger <Model-TaskTrigger.html#t:TaskTrigger>`__                                          |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `TaskLog <Model-TaskLog.html#t:TaskLog>`__                                                      |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `Action <Model-Action.html#t:Action>`__                                                         |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `RewardLogEvents <Model-RewardLogEvents.html#t:RewardLogEvents>`__                              |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `Rule <Model-Rule.html#t:Rule>`__                                                               |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `RuleReward <Model-RuleReward.html#t:RuleReward>`__                                             |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `Race <Model-Race.html#t:Race>`__                                                               |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `RaceDetails <Model-RaceDetails.html#t:RaceDetails>`__                                          |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `TournamentPlayer <Model-TournamentPlayers.html#t:TournamentPlayer>`__                          |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `TournamentResult <Model-TournamentResult.html#t:TournamentResult>`__                           |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `TournamentReport <Model-TournamentReport.html#t:TournamentReport>`__                           |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+

class IConnection conn where

Methods

disconnect :: conn -> IO ()

Instances

+-------------------------------------------------------------------------------------------------------------------+-----+
| `IConnection <Data-SqlTransaction.html#t:IConnection>`__ ConnWrapper                                              |     |
+-------------------------------------------------------------------------------------------------------------------+-----+
| `IConnection <Data-SqlTransaction.html#t:IConnection>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__   |     |
+-------------------------------------------------------------------------------------------------------------------+-----+

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

 

ToValues Query

 

ToSql Query

 

`Expressable <Data-Database.html#t:Expressable>`__
`Values <Data-Database.html#t:Values>`__

 

`Expressable <Data-Database.html#t:Expressable>`__
`Value <Data-Database.html#t:Value>`__

 

`Expression <Data-Database.html#t:Expression>`__
`Selections <Data-Database.html#t:Selections>`__

 

`Expression <Data-Database.html#t:Expression>`__
`Pair <Data-Database.html#t:Pair>`__

 

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

 

Convertible UTCTime `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__

 

Convertible NominalDiffTime
`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__

 

Convertible DiffTime `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__

 

Convertible Day `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__

 

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

 

Convertible `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__ UTCTime

 

Convertible `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__
NominalDiffTime

 

Convertible `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__ DiffTime

 

Convertible `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__ Day

 

Convertible `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__
`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__

 

Convertible `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__ TimeDiff

 

Convertible `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__ Text

 

Convertible `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__ Text

 

Convertible `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__ ZonedTime

 

Convertible `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__ LocalTime

 

Convertible `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__ ClockTime

 

Convertible `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__
CalendarTime

 

Convertible `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__
ByteString

 

Convertible `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__
ByteString

 

Convertible `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__ TimeOfDay

 

Convertible `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__
`HStore <Data-Hstore.html#t:HStore>`__

 

Convertible TimeDiff `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__

 

Convertible Text `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__

 

Convertible Text `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__

 

Convertible ZonedTime `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__

 

Convertible LocalTime `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__

 

Convertible ClockTime `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__

 

Convertible CalendarTime
`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__

 

Convertible ByteString
`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__

 

Convertible ByteString
`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__

 

Convertible TimeOfDay `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__

 

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

 

data Statement

disconnect :: `IConnection <Data-SqlTransaction.html#t:IConnection>`__
conn => conn -> IO ()

data Lock

Several locks in the postgresql database

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

type SqlTransaction c a =
`SqlTransactionUser <Data-SqlTransaction.html#t:SqlTransactionUser>`__
`Lock <LockSnaplet.html#t:Lock>`__ c a

Sql transaction is a monad, which encapsulate computations in a
transaction By throwing an error the transaction will be rolled back The
SqlTransactionUser gives the possibility to add a user state In
SqlTransaction the user state is a mechanism to lock a certain operation
Other capabilities are:

-  paralel queries
-  atomical actions
-  exception catching (``Error``)
-  error handling
-  server level locking

The monad is hand rolled and CPS transformed for efficiency

data SqlTransactionUser l c a

This is the core monad. It is a hand rolled CPS transformed monadstack.
It handles state and exception handling

It is derived from the following stack:

::

       newtype SqlTransaction l c a = SqlTransaction {
         unsafeRunSqlTransaction :: StateT (c,l) (ErrorT String IO) a 
       } deriving (Functor, Alternative, Applicative, Monad, MonadPlus, MonadFix, MonadState c, MonadError String, MonadIO) 

Instances

MonadState c
(`SqlTransactionUser <Data-SqlTransaction.html#t:SqlTransactionUser>`__
l c)

 

MonadReader c
(`SqlTransactionUser <Data-SqlTransaction.html#t:SqlTransactionUser>`__
l c)

The Reader class is accessing the state. This was needed for some legacy
code.

`IConnection <Data-SqlTransaction.html#t:IConnection>`__ c => MonadError
`SqlError <Data-SqlTransaction.html#t:SqlError>`__
(`SqlTransactionUser <Data-SqlTransaction.html#t:SqlTransactionUser>`__
l c)

 

Monad
(`SqlTransactionUser <Data-SqlTransaction.html#t:SqlTransactionUser>`__
l c)

 

Functor
(`SqlTransactionUser <Data-SqlTransaction.html#t:SqlTransactionUser>`__
l c)

 

`IConnection <Data-SqlTransaction.html#t:IConnection>`__ c => MonadPlus
(`SqlTransactionUser <Data-SqlTransaction.html#t:SqlTransactionUser>`__
l c)

The same as alternative

Applicative
(`SqlTransactionUser <Data-SqlTransaction.html#t:SqlTransactionUser>`__
l c)

 

`IConnection <Data-SqlTransaction.html#t:IConnection>`__ c =>
Alternative
(`SqlTransactionUser <Data-SqlTransaction.html#t:SqlTransactionUser>`__
l c)

The alternative instance catches an error and runs the next computation
when failed

MonadIO
(`SqlTransactionUser <Data-SqlTransaction.html#t:SqlTransactionUser>`__
l c)

 

atomical ::
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ a ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ a

Explicitly encapsulates a computation in a transaction block. This
commits the previous computation

catchSqlError ::
`IConnection <Data-SqlTransaction.html#t:IConnection>`__ c =>
`SqlTransactionUser <Data-SqlTransaction.html#t:SqlTransactionUser>`__ l
c a -> (`SqlError <Data-SqlTransaction.html#t:SqlError>`__ ->
`SqlTransactionUser <Data-SqlTransaction.html#t:SqlTransactionUser>`__ l
c a) ->
`SqlTransactionUser <Data-SqlTransaction.html#t:SqlTransactionUser>`__ l
c a

Catch an error thrown in the SqlTransaction monad, if there is an error
the continuation provided by the user will be run

commit :: `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ ()

Commits the current data to the database and starts a new transaction

dbWithLockBlock :: Show a => Namespace -> a ->
`SqlTransactionUser <Data-SqlTransaction.html#t:SqlTransactionUser>`__
`Lock <LockSnaplet.html#t:Lock>`__ c b ->
`SqlTransactionUser <Data-SqlTransaction.html#t:SqlTransactionUser>`__
`Lock <LockSnaplet.html#t:Lock>`__ c b

Do a SqlTransaction action, lock on server level only blocks until lock
is acquired

dbWithLockNonBlock :: Show a => Namespace -> a ->
`SqlTransactionUser <Data-SqlTransaction.html#t:SqlTransactionUser>`__
`Lock <LockSnaplet.html#t:Lock>`__ c () ->
`SqlTransactionUser <Data-SqlTransaction.html#t:SqlTransactionUser>`__
`Lock <LockSnaplet.html#t:Lock>`__ c ()

Do a SqlTransaction action and put a lock on the provided label. If the
lock can't be acquired, don't block.

Example

::

     withLockNonBlock namespace key $ do ... 

doneFuture :: Future a ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c Bool

Check if the future is done calculating

emptyFuture ::
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c (Future
a)

Create an empty future

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

fetchAllRows' ::
`IConnection <Data-SqlTransaction.html#t:IConnection>`__ c =>
`Statement <Data-SqlTransaction.html#t:Statement>`__ ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c
[[`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__\ ]]

fetchAllRows :: `IConnection <Data-SqlTransaction.html#t:IConnection>`__
c => `Statement <Data-SqlTransaction.html#t:Statement>`__ ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c
[[`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__\ ]]

fetchAllRowsAL' ::
`IConnection <Data-SqlTransaction.html#t:IConnection>`__ c =>
`Statement <Data-SqlTransaction.html#t:Statement>`__ ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c
[[(String, `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__)]]

fetchAllRowsAL ::
`IConnection <Data-SqlTransaction.html#t:IConnection>`__ c =>
`Statement <Data-SqlTransaction.html#t:Statement>`__ ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c
[[(String, `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__)]]

fetchAllRowsMap ::
`IConnection <Data-SqlTransaction.html#t:IConnection>`__ c =>
`Statement <Data-SqlTransaction.html#t:Statement>`__ ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c [Map
String `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__]

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

fillFuture :: Future a -> Either
`SqlError <Data-SqlTransaction.html#t:SqlError>`__ a ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c ()

Fill a future with a value This is an internal function

finish :: `Statement <Data-SqlTransaction.html#t:Statement>`__ ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c ()

forkSqlTransaction ::
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ () ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ ThreadId

Fork a SqlTransaction, so it can calculate the computation concurrently
This shares the database connection, so it the parent should be done
with all the operations on the database. Errors don't roll back the
parent

get :: MonadState s m => m s

getUser ::
`SqlTransactionUser <Data-SqlTransaction.html#t:SqlTransactionUser>`__ l
c l

Retrieve the user state

lock :: String -> `Lock <Data-SqlTransaction.html#t:Lock>`__ ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ a ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ a

Lock a table with Lock and do a computation when locked

Example

::

     f = lock account RowExclusive $ do ... 

newFuture

Arguments

:: `IConnection <Data-SqlTransaction.html#t:IConnection>`__ c

 

=> `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c a

calculation needed in the future

-> `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c
(Future a)

 

Creates a new future in the SqlTransaction monad with a calculation The
database connection will be cloned, so it is safe for the parent to
operate on the database

par2 :: `IConnection <Data-SqlTransaction.html#t:IConnection>`__ c =>
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c a ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c b ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c (a, b)

Run two computations paralel

par3 :: `IConnection <Data-SqlTransaction.html#t:IConnection>`__ c =>
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c a ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c b ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c c ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c (a, b,
c)

Run three computations paralel

par4 :: `IConnection <Data-SqlTransaction.html#t:IConnection>`__ c =>
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c p ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c q ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c r ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c s ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c (p, q,
r, s)

Run four computations in paralel

parN :: `IConnection <Data-SqlTransaction.html#t:IConnection>`__ c =>
[`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c p] ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c [p]

run n computations in paralel

parSafe ::
[`SqlTransactionUser <Data-SqlTransaction.html#t:SqlTransactionUser>`__
`Lock <LockSnaplet.html#t:Lock>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ b] ->
`SqlTransactionUser <Data-SqlTransaction.html#t:SqlTransactionUser>`__
`Lock <LockSnaplet.html#t:Lock>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ [b]

Run queries in paralel Example:

``  parSafe [comp1, comp2, comp3]  `` This will return all the results
or roll back the parent computation on an error

prepare :: `IConnection <Data-SqlTransaction.html#t:IConnection>`__ c =>
String -> `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
c `Statement <Data-SqlTransaction.html#t:Statement>`__

putUser :: l ->
`SqlTransactionUser <Data-SqlTransaction.html#t:SqlTransactionUser>`__ l
c ()

Put the user state

quickQuery' :: `IConnection <Data-SqlTransaction.html#t:IConnection>`__
c => String -> [`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__\ ] ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c
[[`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__\ ]]

quickQuery :: `IConnection <Data-SqlTransaction.html#t:IConnection>`__ c
=> String -> [`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__\ ] ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c
[[`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__\ ]]

readFuture :: `IConnection <Data-SqlTransaction.html#t:IConnection>`__ c
=> Future a ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c a

Read the future, this will force the calculation. Any exception will be
thrown in the parent

rollback :: `IConnection <Data-SqlTransaction.html#t:IConnection>`__ m
=> String ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ m t

Rollback the computation, throws an user error

run :: `IConnection <Data-SqlTransaction.html#t:IConnection>`__ c =>
String -> [`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__\ ] ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c Integer

runSqlTransaction :: (Applicative m,
`IConnection <Data-SqlTransaction.html#t:IConnection>`__ conn, MonadIO
m) =>
`SqlTransactionUser <Data-SqlTransaction.html#t:SqlTransactionUser>`__ l
conn b -> (String -> m b) -> conn -> l -> m b

Encapsulates the computation in a transaction and handles any errors in
the user supplied function

runTestDb ::
`SqlTransactionUser <Data-SqlTransaction.html#t:SqlTransactionUser>`__ l
`Connection <Data-SqlTransaction.html#t:Connection>`__ b -> IO b

sExecute :: `IConnection <Data-SqlTransaction.html#t:IConnection>`__ c
=> `Statement <Data-SqlTransaction.html#t:Statement>`__ -> [Maybe
String] ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c Integer

sExecuteMany :: `IConnection <Data-SqlTransaction.html#t:IConnection>`__
c => `Statement <Data-SqlTransaction.html#t:Statement>`__ -> [[Maybe
String]] ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c ()

sFetchAllRows' ::
`IConnection <Data-SqlTransaction.html#t:IConnection>`__ c =>
`Statement <Data-SqlTransaction.html#t:Statement>`__ ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c [[Maybe
String]]

sFetchAllRows ::
`IConnection <Data-SqlTransaction.html#t:IConnection>`__ c =>
`Statement <Data-SqlTransaction.html#t:Statement>`__ ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c [[Maybe
String]]

sFetchRow :: `Statement <Data-SqlTransaction.html#t:Statement>`__ ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c (Maybe
[Maybe String])

sRun :: `IConnection <Data-SqlTransaction.html#t:IConnection>`__ c =>
String -> [Maybe String] ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c Integer

data SqlError

Exception data type.

Constructors

UError String

User error

DBError String

Database error

Instances

Show `SqlError <Data-SqlTransaction.html#t:SqlError>`__

 

IsString `SqlError <Data-SqlTransaction.html#t:SqlError>`__

For usability SqlError is a ``IsString``

Error `SqlError <Data-SqlTransaction.html#t:SqlError>`__

 

`IConnection <Data-SqlTransaction.html#t:IConnection>`__ c => MonadError
`SqlError <Data-SqlTransaction.html#t:SqlError>`__
(`SqlTransactionUser <Data-SqlTransaction.html#t:SqlTransactionUser>`__
l c)

 

`IConnection <Data-SqlTransaction.html#t:IConnection>`__ c => MonadError
`SqlError <Data-SqlTransaction.html#t:SqlError>`__
(`ComposeMonad <Data-ComposeModel.html#t:ComposeMonad>`__ r c)

 

sqlExecute :: `IConnection <Data-SqlTransaction.html#t:IConnection>`__ c
=> String -> [`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__\ ] ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c ()

Execute a statement

sqlGetAll :: `IConnection <Data-SqlTransaction.html#t:IConnection>`__ c
=> String -> [`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__\ ] ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c
[[`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__\ ]]

Get all rows from the query

sqlGetAllAssoc ::
`IConnection <Data-SqlTransaction.html#t:IConnection>`__ c => String ->
[`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__\ ] ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c
[HashMap String `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__]

Get all rows as a ``HashMap``

sqlGetOne :: `IConnection <Data-SqlTransaction.html#t:IConnection>`__ c
=> String -> [`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__\ ] ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c
`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__

Get the first value from the query

sqlGetRow :: `IConnection <Data-SqlTransaction.html#t:IConnection>`__ c
=> String -> [`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__\ ] ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c
[`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__\ ]

get one row from the query

waitUnless ::
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ Bool ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ ()

The reverse of waitWhen

waitWhen ::
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ Bool ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ ()

Wait on an event in the database. If the computation returns true, go
further

withEncoding :: `IConnection <Data-SqlTransaction.html#t:IConnection>`__
c => String ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c a ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c a

Change the encoding of the database

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
