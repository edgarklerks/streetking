===============
Model.CarMarket
===============

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Model.CarMarket

Documentation
=============

data CarMarket

Constructors

CarMarket

 

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
     
manufacturer\_name :: String
     
label :: String
     
car\_label :: String
     
models\_available :: Integer
     
price :: Integer
     

Instances

+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Eq `CarMarket <Model-CarMarket.html#t:CarMarket>`__                                                                                                    |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Show `CarMarket <Model-CarMarket.html#t:CarMarket>`__                                                                                                  |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| ToJSON `CarMarket <Model-CarMarket.html#t:CarMarket>`__                                                                                                |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| FromJSON `CarMarket <Model-CarMarket.html#t:CarMarket>`__                                                                                              |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Default `CarMarket <Model-CarMarket.html#t:CarMarket>`__                                                                                               |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-InRules.html#t:FromInRule>`__ `CarMarket <Model-CarMarket.html#t:CarMarket>`__                                                       |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `ToInRule <Data-InRules.html#t:ToInRule>`__ `CarMarket <Model-CarMarket.html#t:CarMarket>`__                                                           |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `CarMarket <Model-CarMarket.html#t:CarMarket>`__                                                            |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `CarMarket <Model-CarMarket.html#t:CarMarket>`__   |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+

relation :: `RelationM <Data-Relation.html#t:RelationM>`__

schema :: [[Char]]

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
