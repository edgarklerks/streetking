-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Data.SqlTransaction

Synopsis

-   [quickInsert](#v:quickInsert) :: [IConnection](Data-SqlTransaction.html#t:IConnection) c =\> String -\> [(String, [SqlValue](Data-SqlTransaction.html#t:SqlValue))] -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c [SqlValue](Data-SqlTransaction.html#t:SqlValue)
-   data [Connection](#t:Connection)
-   class [IConnection](#t:IConnection) conn where
    -   [disconnect](#v:disconnect) :: conn -\> IO ()

-   data [SqlValue](#t:SqlValue)
    -   = [SqlString](#v:SqlString) String
    -   | [SqlByteString](#v:SqlByteString) ByteString
    -   | [SqlWord32](#v:SqlWord32) Word32
    -   | [SqlWord64](#v:SqlWord64) Word64
    -   | [SqlInt32](#v:SqlInt32) Int32
    -   | [SqlInt64](#v:SqlInt64) Int64
    -   | [SqlInteger](#v:SqlInteger) Integer
    -   | [SqlChar](#v:SqlChar) Char
    -   | [SqlBool](#v:SqlBool) Bool
    -   | [SqlDouble](#v:SqlDouble) Double
    -   | [SqlRational](#v:SqlRational) Rational
    -   | [SqlLocalDate](#v:SqlLocalDate) Day
    -   | [SqlLocalTimeOfDay](#v:SqlLocalTimeOfDay) TimeOfDay
    -   | [SqlZonedLocalTimeOfDay](#v:SqlZonedLocalTimeOfDay) TimeOfDay TimeZone
    -   | [SqlLocalTime](#v:SqlLocalTime) LocalTime
    -   | [SqlZonedTime](#v:SqlZonedTime) ZonedTime
    -   | [SqlUTCTime](#v:SqlUTCTime) UTCTime
    -   | [SqlDiffTime](#v:SqlDiffTime) NominalDiffTime
    -   | [SqlPOSIXTime](#v:SqlPOSIXTime) POSIXTime
    -   | [SqlEpochTime](#v:SqlEpochTime) Integer
    -   | [SqlTimeDiff](#v:SqlTimeDiff) Integer
    -   | [SqlNull](#v:SqlNull)

-   data [Statement](#t:Statement)
-   [disconnect](#v:disconnect) :: [IConnection](Data-SqlTransaction.html#t:IConnection) conn =\> conn -\> IO ()
-   data [Lock](#t:Lock)
    -   = [AccessShare](#v:AccessShare)
    -   | [RowShare](#v:RowShare)
    -   | [RowExclusive](#v:RowExclusive)
    -   | [ShareUpdateExclusive](#v:ShareUpdateExclusive)
    -   | [Share](#v:Share)
    -   | [ShareRowExclusive](#v:ShareRowExclusive)
    -   | [AccessExclusive](#v:AccessExclusive)

-   type [SqlTransaction](#t:SqlTransaction) c a = [SqlTransactionUser](Data-SqlTransaction.html#t:SqlTransactionUser) [Lock](LockSnaplet.html#t:Lock) c a
-   data [SqlTransactionUser](#t:SqlTransactionUser) l c a
-   [atomical](#v:atomical) :: [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) a -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) a
-   [catchSqlError](#v:catchSqlError) :: [IConnection](Data-SqlTransaction.html#t:IConnection) c =\> [SqlTransactionUser](Data-SqlTransaction.html#t:SqlTransactionUser) l c a -\> ([SqlError](Data-SqlTransaction.html#t:SqlError) -\> [SqlTransactionUser](Data-SqlTransaction.html#t:SqlTransactionUser) l c a) -\> [SqlTransactionUser](Data-SqlTransaction.html#t:SqlTransactionUser) l c a
-   [commit](#v:commit) :: [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) ()
-   [dbWithLockBlock](#v:dbWithLockBlock) :: Show a =\> Namespace -\> a -\> [SqlTransactionUser](Data-SqlTransaction.html#t:SqlTransactionUser) [Lock](LockSnaplet.html#t:Lock) c b -\> [SqlTransactionUser](Data-SqlTransaction.html#t:SqlTransactionUser) [Lock](LockSnaplet.html#t:Lock) c b
-   [dbWithLockNonBlock](#v:dbWithLockNonBlock) :: Show a =\> Namespace -\> a -\> [SqlTransactionUser](Data-SqlTransaction.html#t:SqlTransactionUser) [Lock](LockSnaplet.html#t:Lock) c () -\> [SqlTransactionUser](Data-SqlTransaction.html#t:SqlTransactionUser) [Lock](LockSnaplet.html#t:Lock) c ()
-   [doneFuture](#v:doneFuture) :: Future a -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c Bool
-   [emptyFuture](#v:emptyFuture) :: [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c (Future a)
-   [execute](#v:execute) :: [IConnection](Data-SqlTransaction.html#t:IConnection) c =\> [Statement](Data-SqlTransaction.html#t:Statement) -\> [[SqlValue](Data-SqlTransaction.html#t:SqlValue)] -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c Integer
-   [executeMany](#v:executeMany) :: [IConnection](Data-SqlTransaction.html#t:IConnection) c =\> [Statement](Data-SqlTransaction.html#t:Statement) -\> [[[SqlValue](Data-SqlTransaction.html#t:SqlValue)]] -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c ()
-   [executeRaw](#v:executeRaw) :: [IConnection](Data-SqlTransaction.html#t:IConnection) c =\> [Statement](Data-SqlTransaction.html#t:Statement) -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c ()
-   [fetchAllRows'](#v:fetchAllRows-39-) :: [IConnection](Data-SqlTransaction.html#t:IConnection) c =\> [Statement](Data-SqlTransaction.html#t:Statement) -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c [[[SqlValue](Data-SqlTransaction.html#t:SqlValue)]]
-   [fetchAllRows](#v:fetchAllRows) :: [IConnection](Data-SqlTransaction.html#t:IConnection) c =\> [Statement](Data-SqlTransaction.html#t:Statement) -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c [[[SqlValue](Data-SqlTransaction.html#t:SqlValue)]]
-   [fetchAllRowsAL'](#v:fetchAllRowsAL-39-) :: [IConnection](Data-SqlTransaction.html#t:IConnection) c =\> [Statement](Data-SqlTransaction.html#t:Statement) -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c [[(String, [SqlValue](Data-SqlTransaction.html#t:SqlValue))]]
-   [fetchAllRowsAL](#v:fetchAllRowsAL) :: [IConnection](Data-SqlTransaction.html#t:IConnection) c =\> [Statement](Data-SqlTransaction.html#t:Statement) -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c [[(String, [SqlValue](Data-SqlTransaction.html#t:SqlValue))]]
-   [fetchAllRowsMap](#v:fetchAllRowsMap) :: [IConnection](Data-SqlTransaction.html#t:IConnection) c =\> [Statement](Data-SqlTransaction.html#t:Statement) -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c [Map String [SqlValue](Data-SqlTransaction.html#t:SqlValue)]
-   [fetchRow](#v:fetchRow) :: [IConnection](Data-SqlTransaction.html#t:IConnection) c =\> [Statement](Data-SqlTransaction.html#t:Statement) -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c (Maybe [[SqlValue](Data-SqlTransaction.html#t:SqlValue)])
-   [fetchRowAl](#v:fetchRowAl) :: [IConnection](Data-SqlTransaction.html#t:IConnection) c =\> [Statement](Data-SqlTransaction.html#t:Statement) -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c (Maybe [(String, [SqlValue](Data-SqlTransaction.html#t:SqlValue))])
-   [fetchRowMap](#v:fetchRowMap) :: [IConnection](Data-SqlTransaction.html#t:IConnection) c =\> [Statement](Data-SqlTransaction.html#t:Statement) -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c (Maybe (Map String [SqlValue](Data-SqlTransaction.html#t:SqlValue)))
-   [fillFuture](#v:fillFuture) :: Future a -\> Either [SqlError](Data-SqlTransaction.html#t:SqlError) a -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c ()
-   [finish](#v:finish) :: [Statement](Data-SqlTransaction.html#t:Statement) -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c ()
-   [forkSqlTransaction](#v:forkSqlTransaction) :: [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) () -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) ThreadId
-   [get](#v:get) :: MonadState s m =\> m s
-   [getUser](#v:getUser) :: [SqlTransactionUser](Data-SqlTransaction.html#t:SqlTransactionUser) l c l
-   [lock](#v:lock) :: String -\> [Lock](Data-SqlTransaction.html#t:Lock) -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) a -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) a
-   [newFuture](#v:newFuture) :: [IConnection](Data-SqlTransaction.html#t:IConnection) c =\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c a -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c (Future a)
-   [par2](#v:par2) :: [IConnection](Data-SqlTransaction.html#t:IConnection) c =\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c a -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c b -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c (a, b)
-   [par3](#v:par3) :: [IConnection](Data-SqlTransaction.html#t:IConnection) c =\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c a -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c b -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c c -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c (a, b, c)
-   [par4](#v:par4) :: [IConnection](Data-SqlTransaction.html#t:IConnection) c =\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c p -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c q -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c r -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c s -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c (p, q, r, s)
-   [parN](#v:parN) :: [IConnection](Data-SqlTransaction.html#t:IConnection) c =\> [[SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c p] -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c [p]
-   [parSafe](#v:parSafe) :: [[SqlTransactionUser](Data-SqlTransaction.html#t:SqlTransactionUser) [Lock](LockSnaplet.html#t:Lock) [Connection](Data-SqlTransaction.html#t:Connection) b] -\> [SqlTransactionUser](Data-SqlTransaction.html#t:SqlTransactionUser) [Lock](LockSnaplet.html#t:Lock) [Connection](Data-SqlTransaction.html#t:Connection) [b]
-   [prepare](#v:prepare) :: [IConnection](Data-SqlTransaction.html#t:IConnection) c =\> String -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c [Statement](Data-SqlTransaction.html#t:Statement)
-   [putUser](#v:putUser) :: l -\> [SqlTransactionUser](Data-SqlTransaction.html#t:SqlTransactionUser) l c ()
-   [quickQuery'](#v:quickQuery-39-) :: [IConnection](Data-SqlTransaction.html#t:IConnection) c =\> String -\> [[SqlValue](Data-SqlTransaction.html#t:SqlValue)] -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c [[[SqlValue](Data-SqlTransaction.html#t:SqlValue)]]
-   [quickQuery](#v:quickQuery) :: [IConnection](Data-SqlTransaction.html#t:IConnection) c =\> String -\> [[SqlValue](Data-SqlTransaction.html#t:SqlValue)] -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c [[[SqlValue](Data-SqlTransaction.html#t:SqlValue)]]
-   [readFuture](#v:readFuture) :: [IConnection](Data-SqlTransaction.html#t:IConnection) c =\> Future a -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c a
-   [rollback](#v:rollback) :: [IConnection](Data-SqlTransaction.html#t:IConnection) m =\> String -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) m t
-   [run](#v:run) :: [IConnection](Data-SqlTransaction.html#t:IConnection) c =\> String -\> [[SqlValue](Data-SqlTransaction.html#t:SqlValue)] -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c Integer
-   [runSqlTransaction](#v:runSqlTransaction) :: (Applicative m, MonadIO m, [IConnection](Data-SqlTransaction.html#t:IConnection) conn) =\> [SqlTransactionUser](Data-SqlTransaction.html#t:SqlTransactionUser) l conn b -\> (String -\> m b) -\> conn -\> l -\> m b
-   [runTestDb](#v:runTestDb) :: [SqlTransactionUser](Data-SqlTransaction.html#t:SqlTransactionUser) l [Connection](Data-SqlTransaction.html#t:Connection) b -\> IO b
-   [sExecute](#v:sExecute) :: [IConnection](Data-SqlTransaction.html#t:IConnection) c =\> [Statement](Data-SqlTransaction.html#t:Statement) -\> [Maybe String] -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c Integer
-   [sExecuteMany](#v:sExecuteMany) :: [IConnection](Data-SqlTransaction.html#t:IConnection) c =\> [Statement](Data-SqlTransaction.html#t:Statement) -\> [[Maybe String]] -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c ()
-   [sFetchAllRows'](#v:sFetchAllRows-39-) :: [IConnection](Data-SqlTransaction.html#t:IConnection) c =\> [Statement](Data-SqlTransaction.html#t:Statement) -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c [[Maybe String]]
-   [sFetchAllRows](#v:sFetchAllRows) :: [IConnection](Data-SqlTransaction.html#t:IConnection) c =\> [Statement](Data-SqlTransaction.html#t:Statement) -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c [[Maybe String]]
-   [sFetchRow](#v:sFetchRow) :: [Statement](Data-SqlTransaction.html#t:Statement) -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c (Maybe [Maybe String])
-   [sRun](#v:sRun) :: [IConnection](Data-SqlTransaction.html#t:IConnection) c =\> String -\> [Maybe String] -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c Integer
-   data [SqlError](#t:SqlError)
    -   = [UError](#v:UError) String
    -   | [DBError](#v:DBError) String

-   [sqlExecute](#v:sqlExecute) :: [IConnection](Data-SqlTransaction.html#t:IConnection) c =\> String -\> [[SqlValue](Data-SqlTransaction.html#t:SqlValue)] -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c ()
-   [sqlGetAll](#v:sqlGetAll) :: [IConnection](Data-SqlTransaction.html#t:IConnection) c =\> String -\> [[SqlValue](Data-SqlTransaction.html#t:SqlValue)] -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c [[[SqlValue](Data-SqlTransaction.html#t:SqlValue)]]
-   [sqlGetAllAssoc](#v:sqlGetAllAssoc) :: [IConnection](Data-SqlTransaction.html#t:IConnection) c =\> String -\> [[SqlValue](Data-SqlTransaction.html#t:SqlValue)] -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c [HashMap String [SqlValue](Data-SqlTransaction.html#t:SqlValue)]
-   [sqlGetOne](#v:sqlGetOne) :: [IConnection](Data-SqlTransaction.html#t:IConnection) c =\> String -\> [[SqlValue](Data-SqlTransaction.html#t:SqlValue)] -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c [SqlValue](Data-SqlTransaction.html#t:SqlValue)
-   [sqlGetRow](#v:sqlGetRow) :: [IConnection](Data-SqlTransaction.html#t:IConnection) c =\> String -\> [[SqlValue](Data-SqlTransaction.html#t:SqlValue)] -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c [[SqlValue](Data-SqlTransaction.html#t:SqlValue)]
-   [waitUnless](#v:waitUnless) :: [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) Bool -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) ()
-   [waitWhen](#v:waitWhen) :: [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) Bool -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) ()
-   [withEncoding](#v:withEncoding) :: [IConnection](Data-SqlTransaction.html#t:IConnection) c =\> String -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c a -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c a

Documentation
=============

quickInsert :: [IConnection](Data-SqlTransaction.html#t:IConnection) c =\> String -\> [(String, [SqlValue](Data-SqlTransaction.html#t:SqlValue))] -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c [SqlValue](Data-SqlTransaction.html#t:SqlValue)

quickInsert: insert data map into a single specified table. data map has the form [(field, value)]. values are SqlValues. lastval() is returned.

data Connection

Instances

||
|[IConnection](Data-SqlTransaction.html#t:IConnection) [Connection](Data-SqlTransaction.html#t:Connection)| |
|[Database](Model-General.html#t:Database) [Connection](Data-SqlTransaction.html#t:Connection) [Application](Model-Application.html#t:Application)| |
|[Database](Model-General.html#t:Database) [Connection](Data-SqlTransaction.html#t:Connection) [CarInstance](Model-CarInstance.html#t:CarInstance)| |
|[Database](Model-General.html#t:Database) [Connection](Data-SqlTransaction.html#t:Connection) [ParameterTable](Model-ParameterTable.html#t:ParameterTable)| |

class IConnection conn where

Methods

disconnect :: conn -\> IO ()

Instances

||
|[IConnection](Data-SqlTransaction.html#t:IConnection) ConnWrapper| |
|[IConnection](Data-SqlTransaction.html#t:IConnection) [Connection](Data-SqlTransaction.html#t:Connection)| |

data SqlValue

Constructors

||
|SqlString String| |
|SqlByteString ByteString| |
|SqlWord32 Word32| |
|SqlWord64 Word64| |
|SqlInt32 Int32| |
|SqlInt64 Int64| |
|SqlInteger Integer| |
|SqlChar Char| |
|SqlBool Bool| |
|SqlDouble Double| |
|SqlRational Rational| |
|SqlLocalDate Day| |
|SqlLocalTimeOfDay TimeOfDay| |
|SqlZonedLocalTimeOfDay TimeOfDay TimeZone| |
|SqlLocalTime LocalTime| |
|SqlZonedTime ZonedTime| |
|SqlUTCTime UTCTime| |
|SqlDiffTime NominalDiffTime| |
|SqlPOSIXTime POSIXTime| |
|SqlEpochTime Integer| |
|SqlTimeDiff Integer| |
|SqlNull| |

Instances

Eq [SqlValue](Data-SqlTransaction.html#t:SqlValue)

 

Show [SqlValue](Data-SqlTransaction.html#t:SqlValue)

 

Show Result

 

Typeable [SqlValue](Data-SqlTransaction.html#t:SqlValue)

 

IsString [SqlValue](Data-SqlTransaction.html#t:SqlValue)

 

[FromInRule](Data-InRules.html#t:FromInRule) [SqlValue](Data-SqlTransaction.html#t:SqlValue)

 

[ToInRule](Data-InRules.html#t:ToInRule) [SqlValue](Data-SqlTransaction.html#t:SqlValue)

Renders InRule to String.

[StringLike](Data-Tools.html#t:StringLike) [SqlValue](Data-SqlTransaction.html#t:SqlValue)

 

ToValues Query

 

ToSql Query

 

[Expressable](Data-Database.html#t:Expressable) [Values](Data-Database.html#t:Values)

 

[Expressable](Data-Database.html#t:Expressable) [Value](Data-Database.html#t:Value)

 

[Expression](Data-Database.html#t:Expression) [Selections](Data-Database.html#t:Selections)

 

[Expression](Data-Database.html#t:Expression) [Pair](Data-Database.html#t:Pair)

 

Convertible Bool [SqlValue](Data-SqlTransaction.html#t:SqlValue)

 

Convertible Char [SqlValue](Data-SqlTransaction.html#t:SqlValue)

 

Convertible Double [SqlValue](Data-SqlTransaction.html#t:SqlValue)

 

Convertible Int [SqlValue](Data-SqlTransaction.html#t:SqlValue)

 

Convertible Int32 [SqlValue](Data-SqlTransaction.html#t:SqlValue)

 

Convertible Int64 [SqlValue](Data-SqlTransaction.html#t:SqlValue)

 

Convertible Integer [SqlValue](Data-SqlTransaction.html#t:SqlValue)

 

Convertible Rational [SqlValue](Data-SqlTransaction.html#t:SqlValue)

 

Convertible Word32 [SqlValue](Data-SqlTransaction.html#t:SqlValue)

 

Convertible Word64 [SqlValue](Data-SqlTransaction.html#t:SqlValue)

 

Convertible String [SqlValue](Data-SqlTransaction.html#t:SqlValue)

 

Convertible [SqlValue](Data-SqlTransaction.html#t:SqlValue) Bool

 

Convertible [SqlValue](Data-SqlTransaction.html#t:SqlValue) Char

 

Convertible [SqlValue](Data-SqlTransaction.html#t:SqlValue) Double

 

Convertible [SqlValue](Data-SqlTransaction.html#t:SqlValue) Int

 

Convertible [SqlValue](Data-SqlTransaction.html#t:SqlValue) Int32

 

Convertible [SqlValue](Data-SqlTransaction.html#t:SqlValue) Int64

 

Convertible [SqlValue](Data-SqlTransaction.html#t:SqlValue) Integer

 

Convertible [SqlValue](Data-SqlTransaction.html#t:SqlValue) Rational

 

Convertible [SqlValue](Data-SqlTransaction.html#t:SqlValue) Word32

 

Convertible [SqlValue](Data-SqlTransaction.html#t:SqlValue) Word64

 

Convertible [SqlValue](Data-SqlTransaction.html#t:SqlValue) String

 

Convertible [SqlValue](Data-SqlTransaction.html#t:SqlValue) [SqlValue](Data-SqlTransaction.html#t:SqlValue)

 

Convertible [SqlValue](Data-SqlTransaction.html#t:SqlValue) ByteString

 

Convertible [SqlValue](Data-SqlTransaction.html#t:SqlValue) ByteString

 

Convertible [SqlValue](Data-SqlTransaction.html#t:SqlValue) TimeDiff

 

Convertible [SqlValue](Data-SqlTransaction.html#t:SqlValue) Text

 

Convertible [SqlValue](Data-SqlTransaction.html#t:SqlValue) Text

 

Convertible [SqlValue](Data-SqlTransaction.html#t:SqlValue) ZonedTime

 

Convertible [SqlValue](Data-SqlTransaction.html#t:SqlValue) UTCTime

 

Convertible [SqlValue](Data-SqlTransaction.html#t:SqlValue) NominalDiffTime

 

Convertible [SqlValue](Data-SqlTransaction.html#t:SqlValue) LocalTime

 

Convertible [SqlValue](Data-SqlTransaction.html#t:SqlValue) DiffTime

 

Convertible [SqlValue](Data-SqlTransaction.html#t:SqlValue) Day

 

Convertible [SqlValue](Data-SqlTransaction.html#t:SqlValue) ClockTime

 

Convertible [SqlValue](Data-SqlTransaction.html#t:SqlValue) CalendarTime

 

Convertible [SqlValue](Data-SqlTransaction.html#t:SqlValue) TimeOfDay

 

Convertible [SqlValue](Data-SqlTransaction.html#t:SqlValue) [HStore](Data-Hstore.html#t:HStore)

 

Convertible ByteString [SqlValue](Data-SqlTransaction.html#t:SqlValue)

 

Convertible ByteString [SqlValue](Data-SqlTransaction.html#t:SqlValue)

 

Convertible TimeDiff [SqlValue](Data-SqlTransaction.html#t:SqlValue)

 

Convertible Text [SqlValue](Data-SqlTransaction.html#t:SqlValue)

 

Convertible Text [SqlValue](Data-SqlTransaction.html#t:SqlValue)

 

Convertible ZonedTime [SqlValue](Data-SqlTransaction.html#t:SqlValue)

 

Convertible UTCTime [SqlValue](Data-SqlTransaction.html#t:SqlValue)

 

Convertible NominalDiffTime [SqlValue](Data-SqlTransaction.html#t:SqlValue)

 

Convertible LocalTime [SqlValue](Data-SqlTransaction.html#t:SqlValue)

 

Convertible DiffTime [SqlValue](Data-SqlTransaction.html#t:SqlValue)

 

Convertible Day [SqlValue](Data-SqlTransaction.html#t:SqlValue)

 

Convertible ClockTime [SqlValue](Data-SqlTransaction.html#t:SqlValue)

 

Convertible CalendarTime [SqlValue](Data-SqlTransaction.html#t:SqlValue)

 

Convertible TimeOfDay [SqlValue](Data-SqlTransaction.html#t:SqlValue)

 

Convertible [HStore](Data-Hstore.html#t:HStore) [SqlValue](Data-SqlTransaction.html#t:SqlValue)

 

Convertible [SqlValue](Data-SqlTransaction.html#t:SqlValue) a =\> Convertible [SqlValue](Data-SqlTransaction.html#t:SqlValue) (Maybe a)

 

Convertible [SqlValue](Data-SqlTransaction.html#t:SqlValue) (TimeOfDay, TimeZone)

 

Convertible a [SqlValue](Data-SqlTransaction.html#t:SqlValue) =\> Convertible (Maybe a) [SqlValue](Data-SqlTransaction.html#t:SqlValue)

 

Convertible (TimeOfDay, TimeZone) [SqlValue](Data-SqlTransaction.html#t:SqlValue)

 

data Statement

disconnect :: [IConnection](Data-SqlTransaction.html#t:IConnection) conn =\> conn -\> IO ()

data Lock

Several locks in the postgresql database

Constructors

||
|AccessShare| |
|RowShare| |
|RowExclusive| |
|ShareUpdateExclusive| |
|Share| |
|ShareRowExclusive| |
|AccessExclusive| |

Instances

||
|Show [Lock](Data-SqlTransaction.html#t:Lock)| |

type SqlTransaction c a = [SqlTransactionUser](Data-SqlTransaction.html#t:SqlTransactionUser) [Lock](LockSnaplet.html#t:Lock) c a

Sql transaction is a monad, which encapsulate computations in a transaction By throwing an error the transaction will be rolled back The SqlTransactionUser gives the possibility to add a user state In SqlTransaction the user state is a mechanism to lock a certain operation Other capabilities are:

-   paralel queries
-   atomical actions
-   exception catching (`Error`)
-   error handling
-   server level locking

The monad is hand rolled and CPS transformed for efficiency

data SqlTransactionUser l c a

This is the core monad. It is a hand rolled CPS transformed monadstack. It handles state and exception handling

It is derived from the following stack:

       newtype SqlTransaction l c a = SqlTransaction {
         unsafeRunSqlTransaction :: StateT (c,l) (ErrorT String IO) a 
       } deriving (Functor, Alternative, Applicative, Monad, MonadPlus, MonadFix, MonadState c, MonadError String, MonadIO) 

Instances

MonadState c ([SqlTransactionUser](Data-SqlTransaction.html#t:SqlTransactionUser) l c)

 

MonadReader c ([SqlTransactionUser](Data-SqlTransaction.html#t:SqlTransactionUser) l c)

The Reader class is accessing the state. This was needed for some legacy code.

[IConnection](Data-SqlTransaction.html#t:IConnection) c =\> MonadError [SqlError](Data-SqlTransaction.html#t:SqlError) ([SqlTransactionUser](Data-SqlTransaction.html#t:SqlTransactionUser) l c)

 

Monad ([SqlTransactionUser](Data-SqlTransaction.html#t:SqlTransactionUser) l c)

 

Functor ([SqlTransactionUser](Data-SqlTransaction.html#t:SqlTransactionUser) l c)

 

[IConnection](Data-SqlTransaction.html#t:IConnection) c =\> MonadPlus ([SqlTransactionUser](Data-SqlTransaction.html#t:SqlTransactionUser) l c)

The same as alternative

Applicative ([SqlTransactionUser](Data-SqlTransaction.html#t:SqlTransactionUser) l c)

 

MonadIO ([SqlTransactionUser](Data-SqlTransaction.html#t:SqlTransactionUser) l c)

 

[IConnection](Data-SqlTransaction.html#t:IConnection) c =\> Alternative ([SqlTransactionUser](Data-SqlTransaction.html#t:SqlTransactionUser) l c)

The alternative instance catches an error and runs the next computation when failed

atomical :: [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) a -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) a

Explicitly encapsulates a computation in a transaction block. This commits the previous computation

catchSqlError :: [IConnection](Data-SqlTransaction.html#t:IConnection) c =\> [SqlTransactionUser](Data-SqlTransaction.html#t:SqlTransactionUser) l c a -\> ([SqlError](Data-SqlTransaction.html#t:SqlError) -\> [SqlTransactionUser](Data-SqlTransaction.html#t:SqlTransactionUser) l c a) -\> [SqlTransactionUser](Data-SqlTransaction.html#t:SqlTransactionUser) l c a

Catch an error thrown in the SqlTransaction monad, if there is an error the continuation provided by the user will be run

commit :: [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) ()

Commits the current data to the database and starts a new transaction

dbWithLockBlock :: Show a =\> Namespace -\> a -\> [SqlTransactionUser](Data-SqlTransaction.html#t:SqlTransactionUser) [Lock](LockSnaplet.html#t:Lock) c b -\> [SqlTransactionUser](Data-SqlTransaction.html#t:SqlTransactionUser) [Lock](LockSnaplet.html#t:Lock) c b

Do a SqlTransaction action, lock on server level only blocks until lock is acquired

dbWithLockNonBlock :: Show a =\> Namespace -\> a -\> [SqlTransactionUser](Data-SqlTransaction.html#t:SqlTransactionUser) [Lock](LockSnaplet.html#t:Lock) c () -\> [SqlTransactionUser](Data-SqlTransaction.html#t:SqlTransactionUser) [Lock](LockSnaplet.html#t:Lock) c ()

Do a SqlTransaction action and put a lock on the provided label. If the lock can't be acquired, don't block.

Example

     withLockNonBlock namespace key $ do ... 

doneFuture :: Future a -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c Bool

Check if the future is done calculating

emptyFuture :: [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c (Future a)

Create an empty future

execute :: [IConnection](Data-SqlTransaction.html#t:IConnection) c =\> [Statement](Data-SqlTransaction.html#t:Statement) -\> [[SqlValue](Data-SqlTransaction.html#t:SqlValue)] -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c Integer

executeMany :: [IConnection](Data-SqlTransaction.html#t:IConnection) c =\> [Statement](Data-SqlTransaction.html#t:Statement) -\> [[[SqlValue](Data-SqlTransaction.html#t:SqlValue)]] -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c ()

executeRaw :: [IConnection](Data-SqlTransaction.html#t:IConnection) c =\> [Statement](Data-SqlTransaction.html#t:Statement) -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c ()

fetchAllRows' :: [IConnection](Data-SqlTransaction.html#t:IConnection) c =\> [Statement](Data-SqlTransaction.html#t:Statement) -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c [[[SqlValue](Data-SqlTransaction.html#t:SqlValue)]]

fetchAllRows :: [IConnection](Data-SqlTransaction.html#t:IConnection) c =\> [Statement](Data-SqlTransaction.html#t:Statement) -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c [[[SqlValue](Data-SqlTransaction.html#t:SqlValue)]]

fetchAllRowsAL' :: [IConnection](Data-SqlTransaction.html#t:IConnection) c =\> [Statement](Data-SqlTransaction.html#t:Statement) -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c [[(String, [SqlValue](Data-SqlTransaction.html#t:SqlValue))]]

fetchAllRowsAL :: [IConnection](Data-SqlTransaction.html#t:IConnection) c =\> [Statement](Data-SqlTransaction.html#t:Statement) -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c [[(String, [SqlValue](Data-SqlTransaction.html#t:SqlValue))]]

fetchAllRowsMap :: [IConnection](Data-SqlTransaction.html#t:IConnection) c =\> [Statement](Data-SqlTransaction.html#t:Statement) -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c [Map String [SqlValue](Data-SqlTransaction.html#t:SqlValue)]

fetchRow :: [IConnection](Data-SqlTransaction.html#t:IConnection) c =\> [Statement](Data-SqlTransaction.html#t:Statement) -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c (Maybe [[SqlValue](Data-SqlTransaction.html#t:SqlValue)])

fetchRowAl :: [IConnection](Data-SqlTransaction.html#t:IConnection) c =\> [Statement](Data-SqlTransaction.html#t:Statement) -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c (Maybe [(String, [SqlValue](Data-SqlTransaction.html#t:SqlValue))])

fetchRowMap :: [IConnection](Data-SqlTransaction.html#t:IConnection) c =\> [Statement](Data-SqlTransaction.html#t:Statement) -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c (Maybe (Map String [SqlValue](Data-SqlTransaction.html#t:SqlValue)))

fillFuture :: Future a -\> Either [SqlError](Data-SqlTransaction.html#t:SqlError) a -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c ()

Fill a future with a value This is an internal function

finish :: [Statement](Data-SqlTransaction.html#t:Statement) -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c ()

forkSqlTransaction :: [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) () -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) ThreadId

Fork a SqlTransaction, so it can calculate the computation concurrently This shares the database connection, so it the parent should be done with all the operations on the database. Errors don't roll back the parent

get :: MonadState s m =\> m s

getUser :: [SqlTransactionUser](Data-SqlTransaction.html#t:SqlTransactionUser) l c l

Retrieve the user state

lock :: String -\> [Lock](Data-SqlTransaction.html#t:Lock) -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) a -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) a

Lock a table with Lock and do a computation when locked

Example

     f = lock account RowExclusive $ do ... 

newFuture

Arguments

:: [IConnection](Data-SqlTransaction.html#t:IConnection) c

 

=\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c a

calculation needed in the future

-\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c (Future a)

 

Creates a new future in the SqlTransaction monad with a calculation The database connection will be cloned, so it is safe for the parent to operate on the database

par2 :: [IConnection](Data-SqlTransaction.html#t:IConnection) c =\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c a -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c b -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c (a, b)

Run two computations paralel

par3 :: [IConnection](Data-SqlTransaction.html#t:IConnection) c =\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c a -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c b -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c c -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c (a, b, c)

Run three computations paralel

par4 :: [IConnection](Data-SqlTransaction.html#t:IConnection) c =\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c p -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c q -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c r -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c s -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c (p, q, r, s)

Run four computations in paralel

parN :: [IConnection](Data-SqlTransaction.html#t:IConnection) c =\> [[SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c p] -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c [p]

run n computations in paralel

parSafe :: [[SqlTransactionUser](Data-SqlTransaction.html#t:SqlTransactionUser) [Lock](LockSnaplet.html#t:Lock) [Connection](Data-SqlTransaction.html#t:Connection) b] -\> [SqlTransactionUser](Data-SqlTransaction.html#t:SqlTransactionUser) [Lock](LockSnaplet.html#t:Lock) [Connection](Data-SqlTransaction.html#t:Connection) [b]

Run queries in paralel Example:

`  parSafe [comp1, comp2, comp3]  ` This will return all the results or roll back the parent computation on an error

prepare :: [IConnection](Data-SqlTransaction.html#t:IConnection) c =\> String -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c [Statement](Data-SqlTransaction.html#t:Statement)

putUser :: l -\> [SqlTransactionUser](Data-SqlTransaction.html#t:SqlTransactionUser) l c ()

Put the user state

quickQuery' :: [IConnection](Data-SqlTransaction.html#t:IConnection) c =\> String -\> [[SqlValue](Data-SqlTransaction.html#t:SqlValue)] -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c [[[SqlValue](Data-SqlTransaction.html#t:SqlValue)]]

quickQuery :: [IConnection](Data-SqlTransaction.html#t:IConnection) c =\> String -\> [[SqlValue](Data-SqlTransaction.html#t:SqlValue)] -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c [[[SqlValue](Data-SqlTransaction.html#t:SqlValue)]]

readFuture :: [IConnection](Data-SqlTransaction.html#t:IConnection) c =\> Future a -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c a

Read the future, this will force the calculation. Any exception will be thrown in the parent

rollback :: [IConnection](Data-SqlTransaction.html#t:IConnection) m =\> String -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) m t

Rollback the computation, throws an user error

run :: [IConnection](Data-SqlTransaction.html#t:IConnection) c =\> String -\> [[SqlValue](Data-SqlTransaction.html#t:SqlValue)] -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c Integer

runSqlTransaction :: (Applicative m, MonadIO m, [IConnection](Data-SqlTransaction.html#t:IConnection) conn) =\> [SqlTransactionUser](Data-SqlTransaction.html#t:SqlTransactionUser) l conn b -\> (String -\> m b) -\> conn -\> l -\> m b

Encapsulates the computation in a transaction and handles any errors in the user supplied function

runTestDb :: [SqlTransactionUser](Data-SqlTransaction.html#t:SqlTransactionUser) l [Connection](Data-SqlTransaction.html#t:Connection) b -\> IO b

sExecute :: [IConnection](Data-SqlTransaction.html#t:IConnection) c =\> [Statement](Data-SqlTransaction.html#t:Statement) -\> [Maybe String] -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c Integer

sExecuteMany :: [IConnection](Data-SqlTransaction.html#t:IConnection) c =\> [Statement](Data-SqlTransaction.html#t:Statement) -\> [[Maybe String]] -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c ()

sFetchAllRows' :: [IConnection](Data-SqlTransaction.html#t:IConnection) c =\> [Statement](Data-SqlTransaction.html#t:Statement) -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c [[Maybe String]]

sFetchAllRows :: [IConnection](Data-SqlTransaction.html#t:IConnection) c =\> [Statement](Data-SqlTransaction.html#t:Statement) -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c [[Maybe String]]

sFetchRow :: [Statement](Data-SqlTransaction.html#t:Statement) -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c (Maybe [Maybe String])

sRun :: [IConnection](Data-SqlTransaction.html#t:IConnection) c =\> String -\> [Maybe String] -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c Integer

data SqlError

Exception data type.

Constructors

UError String

User error

DBError String

Database error

Instances

Show [SqlError](Data-SqlTransaction.html#t:SqlError)

 

IsString [SqlError](Data-SqlTransaction.html#t:SqlError)

For usability SqlError is a `IsString`

Error [SqlError](Data-SqlTransaction.html#t:SqlError)

 

[IConnection](Data-SqlTransaction.html#t:IConnection) c =\> MonadError [SqlError](Data-SqlTransaction.html#t:SqlError) ([SqlTransactionUser](Data-SqlTransaction.html#t:SqlTransactionUser) l c)

 

sqlExecute :: [IConnection](Data-SqlTransaction.html#t:IConnection) c =\> String -\> [[SqlValue](Data-SqlTransaction.html#t:SqlValue)] -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c ()

Execute a statement

sqlGetAll :: [IConnection](Data-SqlTransaction.html#t:IConnection) c =\> String -\> [[SqlValue](Data-SqlTransaction.html#t:SqlValue)] -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c [[[SqlValue](Data-SqlTransaction.html#t:SqlValue)]]

Get all rows from the query

sqlGetAllAssoc :: [IConnection](Data-SqlTransaction.html#t:IConnection) c =\> String -\> [[SqlValue](Data-SqlTransaction.html#t:SqlValue)] -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c [HashMap String [SqlValue](Data-SqlTransaction.html#t:SqlValue)]

Get all rows as a `HashMap`

sqlGetOne :: [IConnection](Data-SqlTransaction.html#t:IConnection) c =\> String -\> [[SqlValue](Data-SqlTransaction.html#t:SqlValue)] -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c [SqlValue](Data-SqlTransaction.html#t:SqlValue)

Get the first value from the query

sqlGetRow :: [IConnection](Data-SqlTransaction.html#t:IConnection) c =\> String -\> [[SqlValue](Data-SqlTransaction.html#t:SqlValue)] -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c [[SqlValue](Data-SqlTransaction.html#t:SqlValue)]

get one row from the query

waitUnless :: [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) Bool -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) ()

The reverse of waitWhen

waitWhen :: [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) Bool -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) ()

Wait on an event in the database. If the computation returns true, go further

withEncoding :: [IConnection](Data-SqlTransaction.html#t:IConnection) c =\> String -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c a -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c a

Change the encoding of the database

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
