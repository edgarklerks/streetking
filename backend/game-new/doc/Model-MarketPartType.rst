====================
Model.MarketPartType
====================

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Model.MarketPartType

Documentation
=============

data MarketPartType

Constructors

MarketPartType

 

Fields

car\_id :: `Id <Model-General.html#t:Id>`__
     
name :: String
     
level :: Integer
     

Instances

+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Eq `MarketPartType <Model-MarketPartType.html#t:MarketPartType>`__                                                                                                    |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Show `MarketPartType <Model-MarketPartType.html#t:MarketPartType>`__                                                                                                  |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| ToJSON `MarketPartType <Model-MarketPartType.html#t:MarketPartType>`__                                                                                                |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| FromJSON `MarketPartType <Model-MarketPartType.html#t:MarketPartType>`__                                                                                              |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Default `MarketPartType <Model-MarketPartType.html#t:MarketPartType>`__                                                                                               |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-InRules.html#t:FromInRule>`__ `MarketPartType <Model-MarketPartType.html#t:MarketPartType>`__                                                       |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `ToInRule <Data-InRules.html#t:ToInRule>`__ `MarketPartType <Model-MarketPartType.html#t:MarketPartType>`__                                                           |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `MarketPartType <Model-MarketPartType.html#t:MarketPartType>`__                                                            |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `MarketPartType <Model-MarketPartType.html#t:MarketPartType>`__   |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+

relation :: `RelationM <Data-Relation.html#t:RelationM>`__

schema :: [[Char]]

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
