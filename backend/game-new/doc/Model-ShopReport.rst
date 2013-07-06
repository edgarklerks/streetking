================
Model.ShopReport
================

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Model.ShopReport

Documentation
=============

type MInteger = Maybe Integer

type MString = Maybe String

type MBool = Maybe Bool

data ShopReport

Constructors

ShopReport

 

Fields

id :: `Id <Model-General.html#t:Id>`__
     
account\_id :: Integer
     
time :: Integer
     
report\_type\_id :: Integer
     
report\_type :: String
     
report\_descriptor :: String
     
part\_instance\_id :: `MInteger <Model-ShopReport.html#t:MInteger>`__
     
car\_instance\_id :: `MInteger <Model-ShopReport.html#t:MInteger>`__
     
car\_id :: `MInteger <Model-ShopReport.html#t:MInteger>`__
     
part\_id :: `MInteger <Model-ShopReport.html#t:MInteger>`__
     
amount :: Integer
     
car\_manufacturer\_name :: `MString <Model-ShopReport.html#t:MString>`__
     
car\_top\_speed :: `MInteger <Model-ShopReport.html#t:MInteger>`__
     
car\_acceleration :: `MInteger <Model-ShopReport.html#t:MInteger>`__
     
car\_braking :: `MInteger <Model-ShopReport.html#t:MInteger>`__
     
car\_nos :: `MInteger <Model-ShopReport.html#t:MInteger>`__
     
car\_handling :: `MInteger <Model-ShopReport.html#t:MInteger>`__
     
car\_name :: `MString <Model-ShopReport.html#t:MString>`__
     
car\_level :: `MInteger <Model-ShopReport.html#t:MInteger>`__
     
car\_year :: `MInteger <Model-ShopReport.html#t:MInteger>`__
     
car\_price :: `MInteger <Model-ShopReport.html#t:MInteger>`__
     
car\_weight :: `MInteger <Model-ShopReport.html#t:MInteger>`__
     
car\_improvement :: `MInteger <Model-ShopReport.html#t:MInteger>`__
     
car\_wear :: `MInteger <Model-ShopReport.html#t:MInteger>`__
     
part\_weight :: `MInteger <Model-ShopReport.html#t:MInteger>`__
     
part\_level :: `MInteger <Model-ShopReport.html#t:MInteger>`__
     
part\_car\_model :: `MString <Model-ShopReport.html#t:MString>`__
     
part\_parameter1 :: `MInteger <Model-ShopReport.html#t:MInteger>`__
     
part\_parameter2 :: `MInteger <Model-ShopReport.html#t:MInteger>`__
     
part\_parameter3 :: `MInteger <Model-ShopReport.html#t:MInteger>`__
     
part\_parameter1\_type :: `MString <Model-ShopReport.html#t:MString>`__
     
part\_parameter2\_type :: `MString <Model-ShopReport.html#t:MString>`__
     
part\_parameter3\_type :: `MString <Model-ShopReport.html#t:MString>`__
     
part\_parameter1\_name :: `MString <Model-ShopReport.html#t:MString>`__
     
part\_parameter2\_name :: `MString <Model-ShopReport.html#t:MString>`__
     
part\_parameter3\_name :: `MString <Model-ShopReport.html#t:MString>`__
     
part\_modifier :: `MString <Model-ShopReport.html#t:MString>`__
     
part\_unique :: `MBool <Model-ShopReport.html#t:MBool>`__
     
part\_improvement :: `MInteger <Model-ShopReport.html#t:MInteger>`__
     
part\_wear :: `MInteger <Model-ShopReport.html#t:MInteger>`__
     
part\_type :: `MString <Model-ShopReport.html#t:MString>`__
     
part\_manufacturer\_name ::
`MString <Model-ShopReport.html#t:MString>`__
     
part\_parameter1\_modifier ::
`MString <Model-ShopReport.html#t:MString>`__
     
part\_parameter2\_modifier ::
`MString <Model-ShopReport.html#t:MString>`__
     
part\_parameter3\_modifier ::
`MString <Model-ShopReport.html#t:MString>`__
     

Instances

+-----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Eq `ShopReport <Model-ShopReport.html#t:ShopReport>`__                                                                                                    |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Show `ShopReport <Model-ShopReport.html#t:ShopReport>`__                                                                                                  |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| ToJSON `ShopReport <Model-ShopReport.html#t:ShopReport>`__                                                                                                |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| FromJSON `ShopReport <Model-ShopReport.html#t:ShopReport>`__                                                                                              |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Default `ShopReport <Model-ShopReport.html#t:ShopReport>`__                                                                                               |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-InRules.html#t:FromInRule>`__ `ShopReport <Model-ShopReport.html#t:ShopReport>`__                                                       |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `ToInRule <Data-InRules.html#t:ToInRule>`__ `ShopReport <Model-ShopReport.html#t:ShopReport>`__                                                           |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `ShopReport <Model-ShopReport.html#t:ShopReport>`__                                                            |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `ShopReport <Model-ShopReport.html#t:ShopReport>`__   |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+

relation :: `RelationM <Data-Relation.html#t:RelationM>`__

schema :: [[Char]]

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
