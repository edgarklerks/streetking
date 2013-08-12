=================
Model.CarInstance
=================

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Model.CarInstance

Documentation
=============

type MInteger = Maybe Integer

data CarInstance

Constructors

CarInstance

 

Fields

id :: `Id <Model-General.html#t:Id>`__
     
car\_id :: Integer
     
garage\_id :: `MInteger <Model-CarInstance.html#t:MInteger>`__
     
deleted :: Bool
     
prototype :: Bool
     
active :: Bool
     
immutable :: Integer
     
prototype\_name :: String
     
prototype\_available :: Bool
     
prototype\_claimable :: Bool
     

Instances

+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Eq `CarInstance <Model-CarInstance.html#t:CarInstance>`__                                                                                                    |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Show `CarInstance <Model-CarInstance.html#t:CarInstance>`__                                                                                                  |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| ToJSON `CarInstance <Model-CarInstance.html#t:CarInstance>`__                                                                                                |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| FromJSON `CarInstance <Model-CarInstance.html#t:CarInstance>`__                                                                                              |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Default `CarInstance <Model-CarInstance.html#t:CarInstance>`__                                                                                               |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-InRules.html#t:FromInRule>`__ `CarInstance <Model-CarInstance.html#t:CarInstance>`__                                                       |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `ToInRule <Data-InRules.html#t:ToInRule>`__ `CarInstance <Model-CarInstance.html#t:CarInstance>`__                                                           |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `CarInstance <Model-CarInstance.html#t:CarInstance>`__                                                            |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `CarInstance <Model-CarInstance.html#t:CarInstance>`__   |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+

relation :: `RelationM <Data-Relation.html#t:RelationM>`__

schema :: [[Char]]

isMutable :: Integer ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ Bool

setImmutable :: Integer ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ Integer

setMutable :: Integer ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ Integer

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
