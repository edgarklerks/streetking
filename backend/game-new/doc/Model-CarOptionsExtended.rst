========================
Model.CarOptionsExtended
========================

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Model.CarOptionsExtended

Documentation
=============

type MString = Maybe String

data CarOptionsExtended

Constructors

CarOptionsExtended

 

Fields

car\_instance\_id :: Integer
     
account\_id :: Integer
     
key :: String
     
value :: `MString <Model-CarOptionsExtended.html#t:MString>`__
     

Instances

+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Eq `CarOptionsExtended <Model-CarOptionsExtended.html#t:CarOptionsExtended>`__                                                                                                    |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Show `CarOptionsExtended <Model-CarOptionsExtended.html#t:CarOptionsExtended>`__                                                                                                  |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| ToJSON `CarOptionsExtended <Model-CarOptionsExtended.html#t:CarOptionsExtended>`__                                                                                                |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| FromJSON `CarOptionsExtended <Model-CarOptionsExtended.html#t:CarOptionsExtended>`__                                                                                              |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Default `CarOptionsExtended <Model-CarOptionsExtended.html#t:CarOptionsExtended>`__                                                                                               |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-InRules.html#t:FromInRule>`__ `CarOptionsExtended <Model-CarOptionsExtended.html#t:CarOptionsExtended>`__                                                       |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `ToInRule <Data-InRules.html#t:ToInRule>`__ `CarOptionsExtended <Model-CarOptionsExtended.html#t:CarOptionsExtended>`__                                                           |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `CarOptionsExtended <Model-CarOptionsExtended.html#t:CarOptionsExtended>`__                                                            |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `CarOptionsExtended <Model-CarOptionsExtended.html#t:CarOptionsExtended>`__   |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+

relation :: `RelationM <Data-Relation.html#t:RelationM>`__

schema :: [[Char]]

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
