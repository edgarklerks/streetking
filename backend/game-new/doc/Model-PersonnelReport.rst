=====================
Model.PersonnelReport
=====================

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Model.PersonnelReport

Documentation
=============

type MInteger = Maybe Integer

type MString = Maybe String

type MBool = Maybe Bool

data PersonnelReport

Constructors

PersonnelReport

 

Fields

id :: `Id <Model-General.html#t:Id>`__
     
account\_id :: Integer
     
time :: Integer
     
report\_type\_id :: Integer
     
report\_type :: String
     
report\_descriptor :: String
     
personnel\_instance\_id ::
`MInteger <Model-PersonnelReport.html#t:MInteger>`__
     
part\_instance\_id ::
`MInteger <Model-PersonnelReport.html#t:MInteger>`__
     
cost :: `MInteger <Model-PersonnelReport.html#t:MInteger>`__
     
result :: String
     
data :: `MString <Model-PersonnelReport.html#t:MString>`__
     
personnel\_id :: `Id <Model-General.html#t:Id>`__
     
name :: `MString <Model-PersonnelReport.html#t:MString>`__
     
country\_name :: `MString <Model-PersonnelReport.html#t:MString>`__
     
country\_shortname :: `MString <Model-PersonnelReport.html#t:MString>`__
     
gender :: `MBool <Model-PersonnelReport.html#t:MBool>`__
     
picture :: `MString <Model-PersonnelReport.html#t:MString>`__
     
salary :: `MInteger <Model-PersonnelReport.html#t:MInteger>`__
     
price :: `MInteger <Model-PersonnelReport.html#t:MInteger>`__
     
skill\_repair :: `MInteger <Model-PersonnelReport.html#t:MInteger>`__
     
skill\_engineering ::
`MInteger <Model-PersonnelReport.html#t:MInteger>`__
     
sort :: `MInteger <Model-PersonnelReport.html#t:MInteger>`__
     
type :: `MString <Model-PersonnelReport.html#t:MString>`__
     

Instances

+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Eq `PersonnelReport <Model-PersonnelReport.html#t:PersonnelReport>`__                                                                                                    |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Show `PersonnelReport <Model-PersonnelReport.html#t:PersonnelReport>`__                                                                                                  |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| ToJSON `PersonnelReport <Model-PersonnelReport.html#t:PersonnelReport>`__                                                                                                |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| FromJSON `PersonnelReport <Model-PersonnelReport.html#t:PersonnelReport>`__                                                                                              |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Default `PersonnelReport <Model-PersonnelReport.html#t:PersonnelReport>`__                                                                                               |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-InRules.html#t:FromInRule>`__ `PersonnelReport <Model-PersonnelReport.html#t:PersonnelReport>`__                                                       |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `ToInRule <Data-InRules.html#t:ToInRule>`__ `PersonnelReport <Model-PersonnelReport.html#t:PersonnelReport>`__                                                           |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `PersonnelReport <Model-PersonnelReport.html#t:PersonnelReport>`__                                                            |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `PersonnelReport <Model-PersonnelReport.html#t:PersonnelReport>`__   |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+

relation :: `RelationM <Data-Relation.html#t:RelationM>`__

schema :: [[Char]]

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
