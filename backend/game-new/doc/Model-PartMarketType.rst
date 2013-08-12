====================
Model.PartMarketType
====================

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Model.PartMarketType

Documentation
=============

data PartMarketType

Constructors

PartMarketType

 

Fields

id :: `Id <Model-General.html#t:Id>`__
     
name :: String
     
min\_level :: Integer
     
max\_level :: Integer
     
min\_price :: Integer
     
max\_price :: Integer
     
sort :: Integer
     
use\_3d :: String
     
required :: Bool
     
fixed :: Bool
     
hidden :: Bool
     

Instances

+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Eq `PartMarketType <Model-PartMarketType.html#t:PartMarketType>`__                                                                                                    |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Show `PartMarketType <Model-PartMarketType.html#t:PartMarketType>`__                                                                                                  |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| ToJSON `PartMarketType <Model-PartMarketType.html#t:PartMarketType>`__                                                                                                |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| FromJSON `PartMarketType <Model-PartMarketType.html#t:PartMarketType>`__                                                                                              |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Default `PartMarketType <Model-PartMarketType.html#t:PartMarketType>`__                                                                                               |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-InRules.html#t:FromInRule>`__ `PartMarketType <Model-PartMarketType.html#t:PartMarketType>`__                                                       |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `ToInRule <Data-InRules.html#t:ToInRule>`__ `PartMarketType <Model-PartMarketType.html#t:PartMarketType>`__                                                           |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `PartMarketType <Model-PartMarketType.html#t:PartMarketType>`__                                                            |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `PartMarketType <Model-PartMarketType.html#t:PartMarketType>`__   |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+

relation :: `RelationM <Data-Relation.html#t:RelationM>`__

schema :: [[Char]]

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
