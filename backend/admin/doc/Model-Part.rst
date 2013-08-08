==========
Model.Part
==========

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Model.Part

Documentation
=============

type MInteger = Maybe Integer

data Part

Constructors

Part

 

Fields

id :: `Id <Model-General.html#t:Id>`__
     
part\_type\_id :: Integer
     
weight :: Integer
     
parameter1 :: `MInteger <Model-Part.html#t:MInteger>`__
     
parameter2 :: `MInteger <Model-Part.html#t:MInteger>`__
     
parameter3 :: `MInteger <Model-Part.html#t:MInteger>`__
     
parameter1\_type\_id :: `MInteger <Model-Part.html#t:MInteger>`__
     
parameter2\_type\_id :: `MInteger <Model-Part.html#t:MInteger>`__
     
parameter3\_type\_id :: `MInteger <Model-Part.html#t:MInteger>`__
     
car\_id :: `Id <Model-General.html#t:Id>`__
     
d3d\_model\_id :: Integer
     
level :: Integer
     
price :: Integer
     
part\_modifier\_id :: `MInteger <Model-Part.html#t:MInteger>`__
     
unique :: Bool
     

Instances

+-----------------------------------------------------------------------------------------------------------------------------------------+-----+
| Eq `Part <Model-Part.html#t:Part>`__                                                                                                    |     |
+-----------------------------------------------------------------------------------------------------------------------------------------+-----+
| Show `Part <Model-Part.html#t:Part>`__                                                                                                  |     |
+-----------------------------------------------------------------------------------------------------------------------------------------+-----+
| ToJSON `Part <Model-Part.html#t:Part>`__                                                                                                |     |
+-----------------------------------------------------------------------------------------------------------------------------------------+-----+
| FromJSON `Part <Model-Part.html#t:Part>`__                                                                                              |     |
+-----------------------------------------------------------------------------------------------------------------------------------------+-----+
| Default `Part <Model-Part.html#t:Part>`__                                                                                               |     |
+-----------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-InRules.html#t:FromInRule>`__ `Part <Model-Part.html#t:Part>`__                                                       |     |
+-----------------------------------------------------------------------------------------------------------------------------------------+-----+
| `ToInRule <Data-InRules.html#t:ToInRule>`__ `Part <Model-Part.html#t:Part>`__                                                           |     |
+-----------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `Part <Model-Part.html#t:Part>`__                                                            |     |
+-----------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `Part <Model-Part.html#t:Part>`__   |     |
+-----------------------------------------------------------------------------------------------------------------------------------------+-----+

relation :: `RelationM <Data-Relation.html#t:RelationM>`__

schema :: [[Char]]

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
