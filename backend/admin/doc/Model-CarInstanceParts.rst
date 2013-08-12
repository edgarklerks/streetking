======================
Model.CarInstanceParts
======================

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Model.CarInstanceParts

Documentation
=============

type MString = Maybe String

type MInteger = Maybe Integer

type MBool = Maybe Bool

data CarInstanceParts

Constructors

CarInstanceParts

 

Fields

part\_instance\_id :: Integer
     
car\_instance\_id :: Integer
     
part\_id :: Integer
     
name :: String
     
part\_type\_id :: Integer
     
weight :: Integer
     
improvement :: Integer
     
wear :: Integer
     
parameter1 :: `MInteger <Model-CarInstanceParts.html#t:MInteger>`__
     
parameter1\_unit :: `MString <Model-CarInstanceParts.html#t:MString>`__
     
parameter1\_name :: `MString <Model-CarInstanceParts.html#t:MString>`__
     
parameter1\_is\_modifier ::
`MBool <Model-CarInstanceParts.html#t:MBool>`__
     
parameter2 :: `MInteger <Model-CarInstanceParts.html#t:MInteger>`__
     
parameter2\_unit :: `MString <Model-CarInstanceParts.html#t:MString>`__
     
parameter2\_name :: `MString <Model-CarInstanceParts.html#t:MString>`__
     
parameter2\_is\_modifier ::
`MBool <Model-CarInstanceParts.html#t:MBool>`__
     
parameter3 :: `MInteger <Model-CarInstanceParts.html#t:MInteger>`__
     
parameter3\_unit :: `MString <Model-CarInstanceParts.html#t:MString>`__
     
parameter3\_name :: `MString <Model-CarInstanceParts.html#t:MString>`__
     
parameter3\_is\_modifier ::
`MBool <Model-CarInstanceParts.html#t:MBool>`__
     
car\_id :: `Id <Model-General.html#t:Id>`__
     
d3d\_model\_id :: Integer
     
level :: Integer
     
price :: Integer
     
car\_model :: `MString <Model-CarInstanceParts.html#t:MString>`__
     
manufacturer\_name ::
`MString <Model-CarInstanceParts.html#t:MString>`__
     
part\_modifier :: `MString <Model-CarInstanceParts.html#t:MString>`__
     
unique :: Bool
     
sort\_part\_type :: Integer
     
new\_price :: Integer
     
account\_id :: `MInteger <Model-CarInstanceParts.html#t:MInteger>`__
     
required :: Bool
     
fixed :: Bool
     
hidden :: Bool
     

Instances

+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Eq `CarInstanceParts <Model-CarInstanceParts.html#t:CarInstanceParts>`__                                                                                                    |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Show `CarInstanceParts <Model-CarInstanceParts.html#t:CarInstanceParts>`__                                                                                                  |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| ToJSON `CarInstanceParts <Model-CarInstanceParts.html#t:CarInstanceParts>`__                                                                                                |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| FromJSON `CarInstanceParts <Model-CarInstanceParts.html#t:CarInstanceParts>`__                                                                                              |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Default `CarInstanceParts <Model-CarInstanceParts.html#t:CarInstanceParts>`__                                                                                               |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-InRules.html#t:FromInRule>`__ `CarInstanceParts <Model-CarInstanceParts.html#t:CarInstanceParts>`__                                                       |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `ToInRule <Data-InRules.html#t:ToInRule>`__ `CarInstanceParts <Model-CarInstanceParts.html#t:CarInstanceParts>`__                                                           |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `CarInstanceParts <Model-CarInstanceParts.html#t:CarInstanceParts>`__                                                            |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `CarInstanceParts <Model-CarInstanceParts.html#t:CarInstanceParts>`__   |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+

relation :: `RelationM <Data-Relation.html#t:RelationM>`__

schema :: [[Char]]

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
