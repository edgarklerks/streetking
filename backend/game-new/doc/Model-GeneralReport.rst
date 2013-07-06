===================
Model.GeneralReport
===================

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Model.GeneralReport

Documentation
=============

type MInteger = Maybe Integer

data GeneralReport

Constructors

GeneralReport

 

Fields

id :: `Id <Model-General.html#t:Id>`__
     
account\_id :: Integer
     
time :: Integer
     
report\_type\_id :: Integer
     
report\_type :: String
     
report\_descriptor :: String
     

Instances

+--------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Eq `GeneralReport <Model-GeneralReport.html#t:GeneralReport>`__                                                                                                    |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Show `GeneralReport <Model-GeneralReport.html#t:GeneralReport>`__                                                                                                  |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| ToJSON `GeneralReport <Model-GeneralReport.html#t:GeneralReport>`__                                                                                                |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| FromJSON `GeneralReport <Model-GeneralReport.html#t:GeneralReport>`__                                                                                              |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Default `GeneralReport <Model-GeneralReport.html#t:GeneralReport>`__                                                                                               |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-InRules.html#t:FromInRule>`__ `GeneralReport <Model-GeneralReport.html#t:GeneralReport>`__                                                       |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `ToInRule <Data-InRules.html#t:ToInRule>`__ `GeneralReport <Model-GeneralReport.html#t:GeneralReport>`__                                                           |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `GeneralReport <Model-GeneralReport.html#t:GeneralReport>`__                                                            |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `GeneralReport <Model-GeneralReport.html#t:GeneralReport>`__   |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+

relation :: `RelationM <Data-Relation.html#t:RelationM>`__

schema :: [[Char]]

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
