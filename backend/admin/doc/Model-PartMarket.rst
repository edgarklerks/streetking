================
Model.PartMarket
================

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Model.PartMarket

Documentation
=============

type MString = Maybe String

type MInteger = Maybe Integer

data PartMarket

Constructors

PartMarket

 

Fields

id :: `Id <Model-General.html#t:Id>`__
     
part\_type\_id :: Integer
     
weight :: Integer
     
parameter1 :: `MInteger <Model-PartMarket.html#t:MInteger>`__
     
parameter1\_unit :: `MString <Model-PartMarket.html#t:MString>`__
     
parameter1\_name :: `MString <Model-PartMarket.html#t:MString>`__
     
parameter2 :: `MInteger <Model-PartMarket.html#t:MInteger>`__
     
parameter2\_unit :: `MString <Model-PartMarket.html#t:MString>`__
     
parameter2\_name :: `MString <Model-PartMarket.html#t:MString>`__
     
parameter3 :: `MInteger <Model-PartMarket.html#t:MInteger>`__
     
parameter3\_unit :: `MString <Model-PartMarket.html#t:MString>`__
     
parameter3\_name :: `MString <Model-PartMarket.html#t:MString>`__
     
car\_id :: `Id <Model-General.html#t:Id>`__
     
d3d\_model\_id :: Integer
     
level :: Integer
     
name :: String
     
price :: Integer
     
car\_model :: `MString <Model-PartMarket.html#t:MString>`__
     
manufacturer\_name :: `MString <Model-PartMarket.html#t:MString>`__
     
part\_modifier :: `MString <Model-PartMarket.html#t:MString>`__
     
unique :: Bool
     
required :: Bool
     
fixed :: Bool
     
hidden :: Bool
     

Instances

+-----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Eq `PartMarket <Model-PartMarket.html#t:PartMarket>`__                                                                                                    |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Show `PartMarket <Model-PartMarket.html#t:PartMarket>`__                                                                                                  |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| ToJSON `PartMarket <Model-PartMarket.html#t:PartMarket>`__                                                                                                |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| FromJSON `PartMarket <Model-PartMarket.html#t:PartMarket>`__                                                                                              |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Default `PartMarket <Model-PartMarket.html#t:PartMarket>`__                                                                                               |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-InRules.html#t:FromInRule>`__ `PartMarket <Model-PartMarket.html#t:PartMarket>`__                                                       |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `ToInRule <Data-InRules.html#t:ToInRule>`__ `PartMarket <Model-PartMarket.html#t:PartMarket>`__                                                           |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `PartMarket <Model-PartMarket.html#t:PartMarket>`__                                                            |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `PartMarket <Model-PartMarket.html#t:PartMarket>`__   |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+

relation :: `RelationM <Data-Relation.html#t:RelationM>`__

schema :: [[Char]]

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
