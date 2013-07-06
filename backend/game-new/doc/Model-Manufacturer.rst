==================
Model.Manufacturer
==================

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Model.Manufacturer

Documentation
=============

data Manufacturer

Constructors

Manufacturer

 

Fields

id :: `Id <Model-General.html#t:Id>`__
     
name :: String
     
picture :: String
     
text :: String
     
label :: String
     

Instances

+-----------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Eq `Manufacturer <Model-Manufacturer.html#t:Manufacturer>`__                                                                                                    |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Show `Manufacturer <Model-Manufacturer.html#t:Manufacturer>`__                                                                                                  |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| ToJSON `Manufacturer <Model-Manufacturer.html#t:Manufacturer>`__                                                                                                |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| FromJSON `Manufacturer <Model-Manufacturer.html#t:Manufacturer>`__                                                                                              |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Default `Manufacturer <Model-Manufacturer.html#t:Manufacturer>`__                                                                                               |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-InRules.html#t:FromInRule>`__ `Manufacturer <Model-Manufacturer.html#t:Manufacturer>`__                                                       |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `ToInRule <Data-InRules.html#t:ToInRule>`__ `Manufacturer <Model-Manufacturer.html#t:Manufacturer>`__                                                           |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `Manufacturer <Model-Manufacturer.html#t:Manufacturer>`__                                                            |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `Manufacturer <Model-Manufacturer.html#t:Manufacturer>`__   |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+

relation :: `RelationM <Data-Relation.html#t:RelationM>`__

schema :: [[Char]]

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
