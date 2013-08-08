=========
Model.Car
=========

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Model.Car

Documentation
=============

data Car

Constructors

Car

 

Fields

id :: `Id <Model-General.html#t:Id>`__
     
manufacturer\_id :: Integer
     
top\_speed :: Integer
     
acceleration :: Integer
     
braking :: Integer
     
nos :: Integer
     
handling :: Integer
     
name :: String
     
use\_3d :: String
     
year :: Integer
     
level :: Integer
     
price :: Integer
     

Instances

+--------------------------------------------------------------------------------------------------------------------------------------+-----+
| Eq `Car <Model-Car.html#t:Car>`__                                                                                                    |     |
+--------------------------------------------------------------------------------------------------------------------------------------+-----+
| Show `Car <Model-Car.html#t:Car>`__                                                                                                  |     |
+--------------------------------------------------------------------------------------------------------------------------------------+-----+
| ToJSON `Car <Model-Car.html#t:Car>`__                                                                                                |     |
+--------------------------------------------------------------------------------------------------------------------------------------+-----+
| FromJSON `Car <Model-Car.html#t:Car>`__                                                                                              |     |
+--------------------------------------------------------------------------------------------------------------------------------------+-----+
| Default `Car <Model-Car.html#t:Car>`__                                                                                               |     |
+--------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-InRules.html#t:FromInRule>`__ `Car <Model-Car.html#t:Car>`__                                                       |     |
+--------------------------------------------------------------------------------------------------------------------------------------+-----+
| `ToInRule <Data-InRules.html#t:ToInRule>`__ `Car <Model-Car.html#t:Car>`__                                                           |     |
+--------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `Car <Model-Car.html#t:Car>`__                                                            |     |
+--------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `Car <Model-Car.html#t:Car>`__   |     |
+--------------------------------------------------------------------------------------------------------------------------------------+-----+

relation :: `RelationM <Data-Relation.html#t:RelationM>`__

schema :: [[Char]]

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
