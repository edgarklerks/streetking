==============
Model.PartType
==============

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Model.PartType

Documentation
=============

data PartType

Constructors

PartType

 

Fields

id :: `Id <Model-General.html#t:Id>`__
     
name :: String
     
sort :: Integer
     
use\_3d :: String
     
required :: Bool
     

Instances

+-----------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Eq `PartType <Model-PartType.html#t:PartType>`__                                                                                                    |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Show `PartType <Model-PartType.html#t:PartType>`__                                                                                                  |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| ToJSON `PartType <Model-PartType.html#t:PartType>`__                                                                                                |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| FromJSON `PartType <Model-PartType.html#t:PartType>`__                                                                                              |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Default `PartType <Model-PartType.html#t:PartType>`__                                                                                               |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-InRules.html#t:FromInRule>`__ `PartType <Model-PartType.html#t:PartType>`__                                                       |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `ToInRule <Data-InRules.html#t:ToInRule>`__ `PartType <Model-PartType.html#t:PartType>`__                                                           |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `PartType <Model-PartType.html#t:PartType>`__                                                            |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `PartType <Model-PartType.html#t:PartType>`__   |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------+-----+

relation :: `RelationM <Data-Relation.html#t:RelationM>`__

schema :: [[Char]]

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
