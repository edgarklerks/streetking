=================
Model.PartDetails
=================

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Model.PartDetails

Documentation
=============

type MInteger = Maybe Integer

type MString = Maybe String

data PartDetails

Constructors

PartDetails

 

Fields

id :: `Id <Model-General.html#t:Id>`__
     
name :: String
     
weight :: Integer
     
parameter1 :: `MInteger <Model-PartDetails.html#t:MInteger>`__
     
parameter1\_name :: `MString <Model-PartDetails.html#t:MString>`__
     
parameter1\_unit :: `MString <Model-PartDetails.html#t:MString>`__
     
parameter2 :: `MInteger <Model-PartDetails.html#t:MInteger>`__
     
parameter2\_name :: `MString <Model-PartDetails.html#t:MString>`__
     
parameter2\_unit :: `MString <Model-PartDetails.html#t:MString>`__
     
parameter3 :: `MInteger <Model-PartDetails.html#t:MInteger>`__
     
parameter3\_name :: `MString <Model-PartDetails.html#t:MString>`__
     
parameter3\_unit :: `MString <Model-PartDetails.html#t:MString>`__
     
car\_id :: Integer
     
d3d\_model\_id :: Integer
     
level :: Integer
     
price :: Integer
     
car\_model :: `MString <Model-PartDetails.html#t:MString>`__
     
manufacturer\_name :: `MString <Model-PartDetails.html#t:MString>`__
     
part\_modifier :: String
     
unique :: Bool
     
sort\_part\_type :: Integer
     
required :: Bool
     
fixed :: Bool
     
hidden :: Bool
     

Instances

+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Eq `PartDetails <Model-PartDetails.html#t:PartDetails>`__                                                                                                    |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Show `PartDetails <Model-PartDetails.html#t:PartDetails>`__                                                                                                  |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| ToJSON `PartDetails <Model-PartDetails.html#t:PartDetails>`__                                                                                                |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| FromJSON `PartDetails <Model-PartDetails.html#t:PartDetails>`__                                                                                              |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Default `PartDetails <Model-PartDetails.html#t:PartDetails>`__                                                                                               |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-InRules.html#t:FromInRule>`__ `PartDetails <Model-PartDetails.html#t:PartDetails>`__                                                       |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `ToInRule <Data-InRules.html#t:ToInRule>`__ `PartDetails <Model-PartDetails.html#t:PartDetails>`__                                                           |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `PartDetails <Model-PartDetails.html#t:PartDetails>`__                                                            |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `PartDetails <Model-PartDetails.html#t:PartDetails>`__   |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+

relation :: `RelationM <Data-Relation.html#t:RelationM>`__

schema :: [[Char]]

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
