-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Model.General

Documentation
=============

class [IConnection](Data-SqlTransaction.html#t:IConnection) c =\> Database c a | a -\> c where

Methods

save :: a -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c Integer

load :: Integer -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c (Maybe a)

search :: [Constraints](Data-Database.html#t:Constraints) -\> [Orders](Data-Database.html#t:Orders) -\> Integer -\> Integer -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c [a]

delete :: a -\> [Constraints](Data-Database.html#t:Constraints) -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c ()

fields :: a -\> [(String, String)]

tableName :: a -\> String

Instances

||
|[Database](Model-General.html#t:Database) [Connection](Data-SqlTransaction.html#t:Connection) [Application](Model-Application.html#t:Application)| |
|[Database](Model-General.html#t:Database) [Connection](Data-SqlTransaction.html#t:Connection) [CarInstance](Model-CarInstance.html#t:CarInstance)| |
|[Database](Model-General.html#t:Database) [Connection](Data-SqlTransaction.html#t:Connection) [ParameterTable](Model-ParameterTable.html#t:ParameterTable)| |

class Mapable a where

Methods

fromMap :: Map String [SqlValue](Data-SqlTransaction.html#t:SqlValue) -\> Maybe a

toMap :: a -\> Map String [SqlValue](Data-SqlTransaction.html#t:SqlValue)

fromHashMap :: HashMap String [SqlValue](Data-SqlTransaction.html#t:SqlValue) -\> Maybe a

toHashMap :: a -\> HashMap String [SqlValue](Data-SqlTransaction.html#t:SqlValue)

updateMap :: Map String [SqlValue](Data-SqlTransaction.html#t:SqlValue) -\> a -\> a

updateHashMap :: HashMap String [SqlValue](Data-SqlTransaction.html#t:SqlValue) -\> a -\> a

Instances

||
|[Mapable](Model-General.html#t:Mapable) [Application](Model-Application.html#t:Application)| |
|[Mapable](Model-General.html#t:Mapable) [CarInstance](Model-CarInstance.html#t:CarInstance)| |
|[Mapable](Model-General.html#t:Mapable) [ParameterTable](Model-ParameterTable.html#t:ParameterTable)| |

type Id = Maybe Integer

nlookup :: Convertible [SqlValue](Data-SqlTransaction.html#t:SqlValue) a =\> String -\> HashMap String [SqlValue](Data-SqlTransaction.html#t:SqlValue) -\> Maybe a

nempty :: HashMap String [SqlValue](Data-SqlTransaction.html#t:SqlValue)

htsql :: Convertible a [SqlValue](Data-SqlTransaction.html#t:SqlValue) =\> a -\> [SqlValue](Data-SqlTransaction.html#t:SqlValue)

thsql :: [SqlValue](Data-SqlTransaction.html#t:SqlValue) -\> Integer

ninsert :: (Eq k, Hashable k) =\> k -\> v -\> HashMap k v -\> HashMap k v

sinsert :: Ord k =\> k -\> a -\> Map k a -\> Map k a

mlookup :: Convertible [SqlValue](Data-SqlTransaction.html#t:SqlValue) a =\> String -\> Map String [SqlValue](Data-SqlTransaction.html#t:SqlValue) -\> Maybe a

mco :: Functor f =\> f [SqlValue](Data-SqlTransaction.html#t:SqlValue) -\> f Integer

mfp :: (Functor f, [Mapable](Model-General.html#t:Mapable) a) =\> f [HashMap String [SqlValue](Data-SqlTransaction.html#t:SqlValue)] -\> f [a]

nhead :: (Functor f, [Mapable](Model-General.html#t:Mapable) a) =\> f [HashMap String [SqlValue](Data-SqlTransaction.html#t:SqlValue)] -\> f (Maybe a)

sempty :: Map String [SqlValue](Data-SqlTransaction.html#t:SqlValue)

aget :: [Database](Model-General.html#t:Database) [Connection](Data-SqlTransaction.html#t:Connection) a =\> [Constraints](Data-Database.html#t:Constraints) -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) a -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) a

agetlist :: [Database](Model-General.html#t:Database) [Connection](Data-SqlTransaction.html#t:Connection) a =\> [Constraints](Data-Database.html#t:Constraints) -\> [Orders](Data-Database.html#t:Orders) -\> Integer -\> Integer -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) [a] -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) [a]

aload :: [Database](Model-General.html#t:Database) [Connection](Data-SqlTransaction.html#t:Connection) a =\> Integer -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) a -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) a

adeny :: [Database](Model-General.html#t:Database) [Connection](Data-SqlTransaction.html#t:Connection) a =\> [Constraints](Data-Database.html#t:Constraints) -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) [a] -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) [a]

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
