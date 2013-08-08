============================
Model.MarketCarInstanceParts
============================

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Model.MarketCarInstanceParts

Documentation
=============

type MString = Maybe String

type MInteger = Maybe Integer

data MarketCarInstanceParts

Constructors

MarketCarInstanceParts

 

Fields

part\_instance\_id :: Integer
     
car\_instance\_id :: Integer
     
part\_id :: Integer
     
name :: String
     
part\_type\_id :: Integer
     
weight :: Integer
     
improvement :: Integer
     
wear :: Integer
     
parameter1 ::
`MInteger <Model-MarketCarInstanceParts.html#t:MInteger>`__
     
parameter1\_unit ::
`MString <Model-MarketCarInstanceParts.html#t:MString>`__
     
parameter1\_name ::
`MString <Model-MarketCarInstanceParts.html#t:MString>`__
     
parameter2 ::
`MInteger <Model-MarketCarInstanceParts.html#t:MInteger>`__
     
parameter2\_unit ::
`MString <Model-MarketCarInstanceParts.html#t:MString>`__
     
parameter2\_name ::
`MString <Model-MarketCarInstanceParts.html#t:MString>`__
     
parameter3 ::
`MInteger <Model-MarketCarInstanceParts.html#t:MInteger>`__
     
parameter3\_unit ::
`MString <Model-MarketCarInstanceParts.html#t:MString>`__
     
parameter3\_name ::
`MString <Model-MarketCarInstanceParts.html#t:MString>`__
     
car\_id :: `Id <Model-General.html#t:Id>`__
     
d3d\_model\_id :: Integer
     
level :: Integer
     
price :: Integer
     
car\_model :: `MString <Model-MarketCarInstanceParts.html#t:MString>`__
     
manufacturer\_name ::
`MString <Model-MarketCarInstanceParts.html#t:MString>`__
     
part\_modifier ::
`MString <Model-MarketCarInstanceParts.html#t:MString>`__
     
unique :: Bool
     
sort\_part\_type :: Integer
     
new\_price :: Integer
     
account\_id ::
`MInteger <Model-MarketCarInstanceParts.html#t:MInteger>`__
     
required :: Bool
     
fixed :: Bool
     
hidden :: Bool
     

Instances

+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Eq `MarketCarInstanceParts <Model-MarketCarInstanceParts.html#t:MarketCarInstanceParts>`__                                                                                                    |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Show `MarketCarInstanceParts <Model-MarketCarInstanceParts.html#t:MarketCarInstanceParts>`__                                                                                                  |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| ToJSON `MarketCarInstanceParts <Model-MarketCarInstanceParts.html#t:MarketCarInstanceParts>`__                                                                                                |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| FromJSON `MarketCarInstanceParts <Model-MarketCarInstanceParts.html#t:MarketCarInstanceParts>`__                                                                                              |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Default `MarketCarInstanceParts <Model-MarketCarInstanceParts.html#t:MarketCarInstanceParts>`__                                                                                               |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-InRules.html#t:FromInRule>`__ `MarketCarInstanceParts <Model-MarketCarInstanceParts.html#t:MarketCarInstanceParts>`__                                                       |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `ToInRule <Data-InRules.html#t:ToInRule>`__ `MarketCarInstanceParts <Model-MarketCarInstanceParts.html#t:MarketCarInstanceParts>`__                                                           |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `MarketCarInstanceParts <Model-MarketCarInstanceParts.html#t:MarketCarInstanceParts>`__                                                            |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `MarketCarInstanceParts <Model-MarketCarInstanceParts.html#t:MarketCarInstanceParts>`__   |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+

relation :: `RelationM <Data-Relation.html#t:RelationM>`__

schema :: [[Char]]

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
