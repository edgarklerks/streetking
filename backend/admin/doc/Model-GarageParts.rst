=================
Model.GarageParts
=================

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Model.GarageParts

Documentation
=============

type MString = Maybe String

type MInteger = Maybe Integer

type MBool = Maybe Bool

data GaragePart

Constructors

GaragePart

 

Fields

id :: `Id <Model-General.html#t:Id>`__
     
account\_id :: Integer
     
part\_type\_id :: Integer
     
weight :: Integer
     
parameter1 :: `MInteger <Model-GarageParts.html#t:MInteger>`__
     
parameter1\_unit :: `MString <Model-GarageParts.html#t:MString>`__
     
parameter1\_name :: `MString <Model-GarageParts.html#t:MString>`__
     
parameter1\_is\_modifier :: `MBool <Model-GarageParts.html#t:MBool>`__
     
parameter2 :: `MInteger <Model-GarageParts.html#t:MInteger>`__
     
parameter2\_unit :: `MString <Model-GarageParts.html#t:MString>`__
     
parameter2\_name :: `MString <Model-GarageParts.html#t:MString>`__
     
parameter2\_is\_modifier :: `MBool <Model-GarageParts.html#t:MBool>`__
     
parameter3 :: `MInteger <Model-GarageParts.html#t:MInteger>`__
     
parameter3\_unit :: `MString <Model-GarageParts.html#t:MString>`__
     
parameter3\_name :: `MString <Model-GarageParts.html#t:MString>`__
     
parameter3\_is\_modifier :: `MBool <Model-GarageParts.html#t:MBool>`__
     
car\_id :: `Id <Model-General.html#t:Id>`__
     
d3d\_model\_id :: Integer
     
level :: Integer
     
name :: String
     
price :: Integer
     
car\_model :: `MString <Model-GarageParts.html#t:MString>`__
     
manufacturer\_name :: `MString <Model-GarageParts.html#t:MString>`__
     
part\_modifier :: `MString <Model-GarageParts.html#t:MString>`__
     
wear :: Integer
     
improvement :: Integer
     
unique :: Bool
     
part\_instance\_id :: Integer
     
trash\_price :: Integer
     
required :: Bool
     
fixed :: Bool
     
task\_subject :: Bool
     
hidden :: Bool
     

Instances

+------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Eq `GaragePart <Model-GarageParts.html#t:GaragePart>`__                                                                                                    |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Show `GaragePart <Model-GarageParts.html#t:GaragePart>`__                                                                                                  |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| ToJSON `GaragePart <Model-GarageParts.html#t:GaragePart>`__                                                                                                |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| FromJSON `GaragePart <Model-GarageParts.html#t:GaragePart>`__                                                                                              |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Default `GaragePart <Model-GarageParts.html#t:GaragePart>`__                                                                                               |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-InRules.html#t:FromInRule>`__ `GaragePart <Model-GarageParts.html#t:GaragePart>`__                                                       |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `ToInRule <Data-InRules.html#t:ToInRule>`__ `GaragePart <Model-GarageParts.html#t:GaragePart>`__                                                           |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `GaragePart <Model-GarageParts.html#t:GaragePart>`__                                                            |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `GaragePart <Model-GarageParts.html#t:GaragePart>`__   |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+

relation :: `RelationM <Data-Relation.html#t:RelationM>`__

schema :: [[Char]]

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
