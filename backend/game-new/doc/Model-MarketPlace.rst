=================
Model.MarketPlace
=================

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Model.MarketPlace

Documentation
=============

type MString = Maybe String

type MInteger = Maybe Integer

data MarketPlace

Constructors

MarketPlace

 

Fields

id :: `Id <Model-General.html#t:Id>`__
     
part\_type\_id :: Integer
     
weight :: Integer
     
parameter1 :: `MInteger <Model-MarketPlace.html#t:MInteger>`__
     
parameter1\_unit :: `MString <Model-MarketPlace.html#t:MString>`__
     
parameter1\_name :: `MString <Model-MarketPlace.html#t:MString>`__
     
parameter2 :: `MInteger <Model-MarketPlace.html#t:MInteger>`__
     
parameter2\_unit :: `MString <Model-MarketPlace.html#t:MString>`__
     
parameter2\_name :: `MString <Model-MarketPlace.html#t:MString>`__
     
parameter3 :: `MInteger <Model-MarketPlace.html#t:MInteger>`__
     
parameter3\_unit :: `MString <Model-MarketPlace.html#t:MString>`__
     
parameter3\_name :: `MString <Model-MarketPlace.html#t:MString>`__
     
car\_id :: `Id <Model-General.html#t:Id>`__
     
d3d\_model\_id :: Integer
     
level :: Integer
     
name :: String
     
price :: Integer
     
car\_model :: `MString <Model-MarketPlace.html#t:MString>`__
     
manufacturer\_name :: `MString <Model-MarketPlace.html#t:MString>`__
     
part\_modifier :: `MString <Model-MarketPlace.html#t:MString>`__
     
unique :: Bool
     
improvement :: Integer
     
wear :: Integer
     
account\_id :: Integer
     
part\_id :: Integer
     

Instances

+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Eq `MarketPlace <Model-MarketPlace.html#t:MarketPlace>`__                                                                                                    |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Show `MarketPlace <Model-MarketPlace.html#t:MarketPlace>`__                                                                                                  |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| ToJSON `MarketPlace <Model-MarketPlace.html#t:MarketPlace>`__                                                                                                |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| FromJSON `MarketPlace <Model-MarketPlace.html#t:MarketPlace>`__                                                                                              |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Default `MarketPlace <Model-MarketPlace.html#t:MarketPlace>`__                                                                                               |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-InRules.html#t:FromInRule>`__ `MarketPlace <Model-MarketPlace.html#t:MarketPlace>`__                                                       |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `ToInRule <Data-InRules.html#t:ToInRule>`__ `MarketPlace <Model-MarketPlace.html#t:MarketPlace>`__                                                           |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `MarketPlace <Model-MarketPlace.html#t:MarketPlace>`__                                                            |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `MarketPlace <Model-MarketPlace.html#t:MarketPlace>`__   |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+

relation :: `RelationM <Data-Relation.html#t:RelationM>`__

schema :: [[Char]]

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
