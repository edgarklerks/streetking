================
Model.Car3dModel
================

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Model.Car3dModel

Documentation
=============

data Car3dModel

Constructors

Car3dModel

 

Fields

id :: `Id <Model-General.html#t:Id>`__
     
name :: String
     
use\_3d :: String
     
part\_instance\_id :: String
     
part\_type\_id :: Integer
     

Instances

+-----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Eq `Car3dModel <Model-Car3dModel.html#t:Car3dModel>`__                                                                                                    |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Show `Car3dModel <Model-Car3dModel.html#t:Car3dModel>`__                                                                                                  |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| ToJSON `Car3dModel <Model-Car3dModel.html#t:Car3dModel>`__                                                                                                |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| FromJSON `Car3dModel <Model-Car3dModel.html#t:Car3dModel>`__                                                                                              |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Default `Car3dModel <Model-Car3dModel.html#t:Car3dModel>`__                                                                                               |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-InRules.html#t:FromInRule>`__ `Car3dModel <Model-Car3dModel.html#t:Car3dModel>`__                                                       |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `ToInRule <Data-InRules.html#t:ToInRule>`__ `Car3dModel <Model-Car3dModel.html#t:Car3dModel>`__                                                           |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `Car3dModel <Model-Car3dModel.html#t:Car3dModel>`__                                                            |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `Car3dModel <Model-Car3dModel.html#t:Car3dModel>`__   |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+

relation :: `RelationM <Data-Relation.html#t:RelationM>`__

schema :: [[Char]]

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
