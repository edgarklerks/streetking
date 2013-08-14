=========================
Model.PartMarketPlaceType
=========================

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Model.PartMarketPlaceType

Documentation
=============

data PartMarketPlaceType

Constructors

PartMarketPlaceType

 

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

+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Eq `PartMarketPlaceType <Model-PartMarketPlaceType.html#t:PartMarketPlaceType>`__                                                                                                    |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Show `PartMarketPlaceType <Model-PartMarketPlaceType.html#t:PartMarketPlaceType>`__                                                                                                  |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| ToJSON `PartMarketPlaceType <Model-PartMarketPlaceType.html#t:PartMarketPlaceType>`__                                                                                                |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| FromJSON `PartMarketPlaceType <Model-PartMarketPlaceType.html#t:PartMarketPlaceType>`__                                                                                              |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Default `PartMarketPlaceType <Model-PartMarketPlaceType.html#t:PartMarketPlaceType>`__                                                                                               |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-InRules.html#t:FromInRule>`__ `PartMarketPlaceType <Model-PartMarketPlaceType.html#t:PartMarketPlaceType>`__                                                       |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `ToInRule <Data-InRules.html#t:ToInRule>`__ `PartMarketPlaceType <Model-PartMarketPlaceType.html#t:PartMarketPlaceType>`__                                                           |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `PartMarketPlaceType <Model-PartMarketPlaceType.html#t:PartMarketPlaceType>`__                                                            |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `PartMarketPlaceType <Model-PartMarketPlaceType.html#t:PartMarketPlaceType>`__   |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+

relation :: `RelationM <Data-Relation.html#t:RelationM>`__

schema :: [[Char]]

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
