============
Model.Report
============

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Model.Report

Documentation
=============

data Type

Constructors

+-------------+-----+
| Race        |     |
+-------------+-----+
| Shopper     |     |
+-------------+-----+
| Personnel   |     |
+-------------+-----+
| Garage      |     |
+-------------+-----+

Instances

+---------------------------------------------------------------------------------------+-----+
| Enum `Type <Model-Report.html#t:Type>`__                                              |     |
+---------------------------------------------------------------------------------------+-----+
| Eq `Type <Model-Report.html#t:Type>`__                                                |     |
+---------------------------------------------------------------------------------------+-----+
| Show `Type <Model-Report.html#t:Type>`__                                              |     |
+---------------------------------------------------------------------------------------+-----+
| IsString `Type <Model-Report.html#t:Type>`__                                          |     |
+---------------------------------------------------------------------------------------+-----+
| ToJSON `Type <Model-Report.html#t:Type>`__                                            |     |
+---------------------------------------------------------------------------------------+-----+
| FromJSON `Type <Model-Report.html#t:Type>`__                                          |     |
+---------------------------------------------------------------------------------------+-----+
| Default `Type <Model-Report.html#t:Type>`__                                           |     |
+---------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-InRules.html#t:FromInRule>`__ `Type <Model-Report.html#t:Type>`__   |     |
+---------------------------------------------------------------------------------------+-----+
| `ToInRule <Data-InRules.html#t:ToInRule>`__ `Type <Model-Report.html#t:Type>`__       |     |
+---------------------------------------------------------------------------------------+-----+

data Report

Constructors

Report

 

Fields

id :: `Id <Model-General.html#t:Id>`__
     
account\_id :: Integer
     
time :: Integer
     
type :: `Type <Model-Report.html#t:Type>`__
     
data :: `Data <Data-DataPack.html#t:Data>`__
     

Instances

+-----------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Eq `Report <Model-Report.html#t:Report>`__                                                                                                    |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Show `Report <Model-Report.html#t:Report>`__                                                                                                  |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------+-----+
| ToJSON `Report <Model-Report.html#t:Report>`__                                                                                                |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------+-----+
| FromJSON `Report <Model-Report.html#t:Report>`__                                                                                              |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Default `Report <Model-Report.html#t:Report>`__                                                                                               |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-InRules.html#t:FromInRule>`__ `Report <Model-Report.html#t:Report>`__                                                       |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `ToInRule <Data-InRules.html#t:ToInRule>`__ `Report <Model-Report.html#t:Report>`__                                                           |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `Report <Model-Report.html#t:Report>`__                                                            |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `Report <Model-Report.html#t:Report>`__   |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------+-----+

relation :: `RelationM <Data-Relation.html#t:RelationM>`__

schema :: [[Char]]

report :: `Type <Model-Report.html#t:Type>`__ -> Integer -> Integer ->
`Data <Data-DataPack.html#t:Data>`__ ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ Integer

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
