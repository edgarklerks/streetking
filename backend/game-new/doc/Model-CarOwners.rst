===============
Model.CarOwners
===============

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Model.CarOwners

Documentation
=============

type MString = Maybe String

data CarOwners

Constructors

CarOwners

 

Fields

id :: `Id <Model-General.html#t:Id>`__
     
account\_id :: Integer
     

Instances

+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Eq `CarOwners <Model-CarOwners.html#t:CarOwners>`__                                                                                                    |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Show `CarOwners <Model-CarOwners.html#t:CarOwners>`__                                                                                                  |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| ToJSON `CarOwners <Model-CarOwners.html#t:CarOwners>`__                                                                                                |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| FromJSON `CarOwners <Model-CarOwners.html#t:CarOwners>`__                                                                                              |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Default `CarOwners <Model-CarOwners.html#t:CarOwners>`__                                                                                               |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-InRules.html#t:FromInRule>`__ `CarOwners <Model-CarOwners.html#t:CarOwners>`__                                                       |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `ToInRule <Data-InRules.html#t:ToInRule>`__ `CarOwners <Model-CarOwners.html#t:CarOwners>`__                                                           |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `CarOwners <Model-CarOwners.html#t:CarOwners>`__                                                            |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `CarOwners <Model-CarOwners.html#t:CarOwners>`__   |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+

relation :: `RelationM <Data-Relation.html#t:RelationM>`__

schema :: [[Char]]

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
