================
Model.CarOptions
================

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Model.CarOptions

Documentation
=============

type MString = Maybe String

data CarOptions

Constructors

CarOptions

 

Fields

id :: `Id <Model-General.html#t:Id>`__
     
car\_instance\_id :: Integer
     
key :: String
     
value :: `MString <Model-CarOptions.html#t:MString>`__
     

Instances

+-----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Eq `CarOptions <Model-CarOptions.html#t:CarOptions>`__                                                                                                    |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Show `CarOptions <Model-CarOptions.html#t:CarOptions>`__                                                                                                  |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| ToJSON `CarOptions <Model-CarOptions.html#t:CarOptions>`__                                                                                                |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| FromJSON `CarOptions <Model-CarOptions.html#t:CarOptions>`__                                                                                              |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Default `CarOptions <Model-CarOptions.html#t:CarOptions>`__                                                                                               |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-InRules.html#t:FromInRule>`__ `CarOptions <Model-CarOptions.html#t:CarOptions>`__                                                       |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `ToInRule <Data-InRules.html#t:ToInRule>`__ `CarOptions <Model-CarOptions.html#t:CarOptions>`__                                                           |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `CarOptions <Model-CarOptions.html#t:CarOptions>`__                                                            |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `CarOptions <Model-CarOptions.html#t:CarOptions>`__   |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+

relation :: `RelationM <Data-Relation.html#t:RelationM>`__

schema :: [[Char]]

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
