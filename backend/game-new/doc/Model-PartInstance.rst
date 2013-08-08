==================
Model.PartInstance
==================

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Model.PartInstance

Documentation
=============

data PartInstance

Constructors

PartInstance

 

Fields

id :: `Id <Model-General.html#t:Id>`__
     
part\_id :: Integer
     
garage\_id :: `Id <Model-General.html#t:Id>`__
     
car\_instance\_id :: `Id <Model-General.html#t:Id>`__
     
improvement :: Integer
     
wear :: Integer
     
account\_id :: Integer
     
deleted :: Bool
     
immutable :: Integer
     

Instances

+-----------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Eq `PartInstance <Model-PartInstance.html#t:PartInstance>`__                                                                                                    |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Show `PartInstance <Model-PartInstance.html#t:PartInstance>`__                                                                                                  |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| ToJSON `PartInstance <Model-PartInstance.html#t:PartInstance>`__                                                                                                |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| FromJSON `PartInstance <Model-PartInstance.html#t:PartInstance>`__                                                                                              |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Default `PartInstance <Model-PartInstance.html#t:PartInstance>`__                                                                                               |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-InRules.html#t:FromInRule>`__ `PartInstance <Model-PartInstance.html#t:PartInstance>`__                                                       |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `ToInRule <Data-InRules.html#t:ToInRule>`__ `PartInstance <Model-PartInstance.html#t:PartInstance>`__                                                           |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `PartInstance <Model-PartInstance.html#t:PartInstance>`__                                                            |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `PartInstance <Model-PartInstance.html#t:PartInstance>`__   |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+

relation :: `RelationM <Data-Relation.html#t:RelationM>`__

schema :: [[Char]]

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
