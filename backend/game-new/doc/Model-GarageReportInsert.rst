========================
Model.GarageReportInsert
========================

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Model.GarageReportInsert

Documentation
=============

type MInteger = Maybe Integer

type MString = Maybe String

type MBool = Maybe Bool

data GarageReportInsert

Constructors

GarageReportInsert

 

Fields

id :: `Id <Model-General.html#t:Id>`__
     
account\_id :: Integer
     
time :: Integer
     
report\_type\_id :: Integer
     
report\_descriptor :: String
     
personnel\_instance\_id :: Integer
     
part\_instance\_id :: Integer
     
ready :: Bool
     
data :: String
     
task :: String
     

Instances

+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Eq `GarageReportInsert <Model-GarageReportInsert.html#t:GarageReportInsert>`__                                                                                                    |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Show `GarageReportInsert <Model-GarageReportInsert.html#t:GarageReportInsert>`__                                                                                                  |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| ToJSON `GarageReportInsert <Model-GarageReportInsert.html#t:GarageReportInsert>`__                                                                                                |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| FromJSON `GarageReportInsert <Model-GarageReportInsert.html#t:GarageReportInsert>`__                                                                                              |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Default `GarageReportInsert <Model-GarageReportInsert.html#t:GarageReportInsert>`__                                                                                               |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-InRules.html#t:FromInRule>`__ `GarageReportInsert <Model-GarageReportInsert.html#t:GarageReportInsert>`__                                                       |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `ToInRule <Data-InRules.html#t:ToInRule>`__ `GarageReportInsert <Model-GarageReportInsert.html#t:GarageReportInsert>`__                                                           |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `GarageReportInsert <Model-GarageReportInsert.html#t:GarageReportInsert>`__                                                            |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `GarageReportInsert <Model-GarageReportInsert.html#t:GarageReportInsert>`__   |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+

relation :: `RelationM <Data-Relation.html#t:RelationM>`__

schema :: [[Char]]

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
