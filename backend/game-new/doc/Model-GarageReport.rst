==================
Model.GarageReport
==================

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Model.GarageReport

Documentation
=============

type MInteger = Maybe Integer

type MString = Maybe String

type MBool = Maybe Bool

data GarageReport

Constructors

GarageReport

 

Fields

id :: `Id <Model-General.html#t:Id>`__
     
account\_id :: `MInteger <Model-GarageReport.html#t:MInteger>`__
     
time :: `MInteger <Model-GarageReport.html#t:MInteger>`__
     
report\_type\_id :: `MInteger <Model-GarageReport.html#t:MInteger>`__
     
report\_descriptor :: `MString <Model-GarageReport.html#t:MString>`__
     
personnel\_instance\_id ::
`MInteger <Model-GarageReport.html#t:MInteger>`__
     
part\_instance\_id :: `MInteger <Model-GarageReport.html#t:MInteger>`__
     
personnel\_id :: `Id <Model-General.html#t:Id>`__
     
name :: `MString <Model-GarageReport.html#t:MString>`__
     
country\_name :: `MString <Model-GarageReport.html#t:MString>`__
     
country\_shortname :: `MString <Model-GarageReport.html#t:MString>`__
     
gender :: `MBool <Model-GarageReport.html#t:MBool>`__
     
picture :: `MString <Model-GarageReport.html#t:MString>`__
     
salary :: `MInteger <Model-GarageReport.html#t:MInteger>`__
     
skill\_repair :: `MInteger <Model-GarageReport.html#t:MInteger>`__
     
skill\_engineering :: `MInteger <Model-GarageReport.html#t:MInteger>`__
     
training\_cost\_repair ::
`MInteger <Model-GarageReport.html#t:MInteger>`__
     
training\_cost\_engineering ::
`MInteger <Model-GarageReport.html#t:MInteger>`__
     
paid\_until :: `MInteger <Model-GarageReport.html#t:MInteger>`__
     
part\_type :: `MString <Model-GarageReport.html#t:MString>`__
     
weight :: `MInteger <Model-GarageReport.html#t:MInteger>`__
     
parameter1 :: `MInteger <Model-GarageReport.html#t:MInteger>`__
     
parameter1\_unit :: `MString <Model-GarageReport.html#t:MString>`__
     
parameter1\_name :: `MString <Model-GarageReport.html#t:MString>`__
     
parameter2 :: `MInteger <Model-GarageReport.html#t:MInteger>`__
     
parameter2\_unit :: `MString <Model-GarageReport.html#t:MString>`__
     
parameter2\_name :: `MString <Model-GarageReport.html#t:MString>`__
     
parameter3 :: `MInteger <Model-GarageReport.html#t:MInteger>`__
     
parameter3\_unit :: `MString <Model-GarageReport.html#t:MString>`__
     
parameter3\_name :: `MString <Model-GarageReport.html#t:MString>`__
     
level :: `MInteger <Model-GarageReport.html#t:MInteger>`__
     
price :: `MInteger <Model-GarageReport.html#t:MInteger>`__
     
car\_model :: `MString <Model-GarageReport.html#t:MString>`__
     
manufacturer\_name :: `MString <Model-GarageReport.html#t:MString>`__
     
part\_modifier :: `MString <Model-GarageReport.html#t:MString>`__
     
unique :: `MBool <Model-GarageReport.html#t:MBool>`__
     
improvement :: `MInteger <Model-GarageReport.html#t:MInteger>`__
     
improvement\_change :: `MInteger <Model-GarageReport.html#t:MInteger>`__
     
wear :: `MInteger <Model-GarageReport.html#t:MInteger>`__
     
wear\_change :: `MInteger <Model-GarageReport.html#t:MInteger>`__
     
task :: `MString <Model-GarageReport.html#t:MString>`__
     
part\_id :: `MInteger <Model-GarageReport.html#t:MInteger>`__
     

Instances

+-----------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Eq `GarageReport <Model-GarageReport.html#t:GarageReport>`__                                                                                                    |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Show `GarageReport <Model-GarageReport.html#t:GarageReport>`__                                                                                                  |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| ToJSON `GarageReport <Model-GarageReport.html#t:GarageReport>`__                                                                                                |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| FromJSON `GarageReport <Model-GarageReport.html#t:GarageReport>`__                                                                                              |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Default `GarageReport <Model-GarageReport.html#t:GarageReport>`__                                                                                               |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-InRules.html#t:FromInRule>`__ `GarageReport <Model-GarageReport.html#t:GarageReport>`__                                                       |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `ToInRule <Data-InRules.html#t:ToInRule>`__ `GarageReport <Model-GarageReport.html#t:GarageReport>`__                                                           |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `GarageReport <Model-GarageReport.html#t:GarageReport>`__                                                            |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `GarageReport <Model-GarageReport.html#t:GarageReport>`__   |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+

relation :: `RelationM <Data-Relation.html#t:RelationM>`__

schema :: [[Char]]

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
