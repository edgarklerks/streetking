=================
Model.CarInGarage
=================

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Model.CarInGarage

Documentation
=============

type MInteger = Maybe Integer

data CarInGarage

Constructors

CarInGarage

 

Fields

id :: `Id <Model-General.html#t:Id>`__
     
car\_id :: Integer
     
manufacturer\_id :: Integer
     
manufacturer\_name :: String
     
manufacturer\_picture :: String
     
weight :: Integer
     
top\_speed :: Integer
     
acceleration :: Integer
     
stopping :: Integer
     
cornering :: Integer
     
nitrous :: Integer
     
power :: Integer
     
traction :: Integer
     
handling :: Integer
     
braking :: Integer
     
aero :: Integer
     
nos :: Integer
     
name :: String
     
parts\_price :: Integer
     
total\_price :: Integer
     
account\_id :: Integer
     
level :: Integer
     
parts\_level :: `MInteger <Model-CarInGarage.html#t:MInteger>`__
     
wear :: Integer
     
improvement :: Integer
     
active :: Bool
     
ready :: Bool
     
year :: Integer
     
car\_label :: String
     
prototype :: Bool
     
prototype\_name :: String
     
prototype\_available :: Bool
     
prototype\_claimable :: Bool
     
car\_color :: String
     

Instances

+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Eq `CarInGarage <Model-CarInGarage.html#t:CarInGarage>`__                                                                                                    |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Show `CarInGarage <Model-CarInGarage.html#t:CarInGarage>`__                                                                                                  |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| ToJSON `CarInGarage <Model-CarInGarage.html#t:CarInGarage>`__                                                                                                |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| FromJSON `CarInGarage <Model-CarInGarage.html#t:CarInGarage>`__                                                                                              |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Default `CarInGarage <Model-CarInGarage.html#t:CarInGarage>`__                                                                                               |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-InRules.html#t:FromInRule>`__ `CarInGarage <Model-CarInGarage.html#t:CarInGarage>`__                                                       |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `ToInRule <Data-InRules.html#t:ToInRule>`__ `CarInGarage <Model-CarInGarage.html#t:CarInGarage>`__                                                           |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `CarInGarage <Model-CarInGarage.html#t:CarInGarage>`__                                                            |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `ToCarMinimal <Model-CarMinimal.html#t:ToCarMinimal>`__ `CarInGarage <Model-CarInGarage.html#t:CarInGarage>`__                                               |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `CarInGarage <Model-CarInGarage.html#t:CarInGarage>`__   |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+

relation :: `RelationM <Data-Relation.html#t:RelationM>`__

schema :: [[Char]]

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
