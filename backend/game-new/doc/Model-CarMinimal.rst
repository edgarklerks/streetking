================
Model.CarMinimal
================

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Model.CarMinimal

Documentation
=============

data CarMinimal

Constructors

CarMinimal

 

Fields

id :: `Id <Model-General.html#t:Id>`__
     
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
     
level :: Integer
     
year :: Integer
     

Instances

+-----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Eq `CarMinimal <Model-CarMinimal.html#t:CarMinimal>`__                                                                                                    |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Show `CarMinimal <Model-CarMinimal.html#t:CarMinimal>`__                                                                                                  |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| ToJSON `CarMinimal <Model-CarMinimal.html#t:CarMinimal>`__                                                                                                |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| FromJSON `CarMinimal <Model-CarMinimal.html#t:CarMinimal>`__                                                                                              |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Default `CarMinimal <Model-CarMinimal.html#t:CarMinimal>`__                                                                                               |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-InRules.html#t:FromInRule>`__ `CarMinimal <Model-CarMinimal.html#t:CarMinimal>`__                                                       |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `ToInRule <Data-InRules.html#t:ToInRule>`__ `CarMinimal <Model-CarMinimal.html#t:CarMinimal>`__                                                           |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `CarMinimal <Model-CarMinimal.html#t:CarMinimal>`__                                                            |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `CarMinimal <Model-CarMinimal.html#t:CarMinimal>`__   |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+

relation :: `RelationM <Data-Relation.html#t:RelationM>`__

schema :: [[Char]]

class ToCarMinimal a where

Methods

toCM :: a -> `CarMinimal <Model-CarMinimal.html#t:CarMinimal>`__

Instances

+------------------------------------------------------------------------------------------------------------------+-----+
| `ToCarMinimal <Model-CarMinimal.html#t:ToCarMinimal>`__ `CarInGarage <Model-CarInGarage.html#t:CarInGarage>`__   |     |
+------------------------------------------------------------------------------------------------------------------+-----+

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
