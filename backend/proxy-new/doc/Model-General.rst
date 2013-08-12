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

+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `Application <Model-Application.html#t:Application>`__   |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+

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

+-----------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `Application <Model-Application.html#t:Application>`__   |     |
+-----------------------------------------------------------------------------------------------------+-----+

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
