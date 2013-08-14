===================
Model.CarStockParts
===================

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Model.CarStockParts

Documentation
=============

type MInteger = Maybe Integer

data CarStockPart

Constructors

CarStockPart

 

Fields

id :: `Id <Model-General.html#t:Id>`__
     
part\_type\_id :: Integer
     
weight :: Integer
     
parameter1 :: `MInteger <Model-CarStockParts.html#t:MInteger>`__
     
parameter2 :: `MInteger <Model-CarStockParts.html#t:MInteger>`__
     
parameter3 :: `MInteger <Model-CarStockParts.html#t:MInteger>`__
     
parameter1\_type\_id ::
`MInteger <Model-CarStockParts.html#t:MInteger>`__
     
parameter2\_type\_id ::
`MInteger <Model-CarStockParts.html#t:MInteger>`__
     
parameter3\_type\_id ::
`MInteger <Model-CarStockParts.html#t:MInteger>`__
     
car\_id :: `Id <Model-General.html#t:Id>`__
     
d3d\_model\_id :: Integer
     
level :: Integer
     
price :: Integer
     
part\_modifier\_id :: `MInteger <Model-CarStockParts.html#t:MInteger>`__
     
unique :: Bool
     

Instances

+------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Eq `CarStockPart <Model-CarStockParts.html#t:CarStockPart>`__                                                                                                    |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Show `CarStockPart <Model-CarStockParts.html#t:CarStockPart>`__                                                                                                  |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| ToJSON `CarStockPart <Model-CarStockParts.html#t:CarStockPart>`__                                                                                                |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| FromJSON `CarStockPart <Model-CarStockParts.html#t:CarStockPart>`__                                                                                              |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Default `CarStockPart <Model-CarStockParts.html#t:CarStockPart>`__                                                                                               |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-InRules.html#t:FromInRule>`__ `CarStockPart <Model-CarStockParts.html#t:CarStockPart>`__                                                       |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `ToInRule <Data-InRules.html#t:ToInRule>`__ `CarStockPart <Model-CarStockParts.html#t:CarStockPart>`__                                                           |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `CarStockPart <Model-CarStockParts.html#t:CarStockPart>`__                                                            |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `CarStockPart <Model-CarStockParts.html#t:CarStockPart>`__   |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+

relation :: `RelationM <Data-Relation.html#t:RelationM>`__

schema :: [[Char]]

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
