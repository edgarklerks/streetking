==============
Model.Diamonds
==============

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Model.Diamonds

Documentation
=============

data DiamondTransaction

Constructors

DiamondTransaction

 

Fields

id :: `Id <Model-General.html#t:Id>`__
     
amount :: Integer
     
current :: Integer
     
type :: String
     
type\_id :: Integer
     
time :: Integer
     
account\_id :: Integer
     

Instances

+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Eq `DiamondTransaction <Model-Diamonds.html#t:DiamondTransaction>`__                                                                                                    |     |
+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Show `DiamondTransaction <Model-Diamonds.html#t:DiamondTransaction>`__                                                                                                  |     |
+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| ToJSON `DiamondTransaction <Model-Diamonds.html#t:DiamondTransaction>`__                                                                                                |     |
+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| FromJSON `DiamondTransaction <Model-Diamonds.html#t:DiamondTransaction>`__                                                                                              |     |
+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Default `DiamondTransaction <Model-Diamonds.html#t:DiamondTransaction>`__                                                                                               |     |
+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-InRules.html#t:FromInRule>`__ `DiamondTransaction <Model-Diamonds.html#t:DiamondTransaction>`__                                                       |     |
+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `ToInRule <Data-InRules.html#t:ToInRule>`__ `DiamondTransaction <Model-Diamonds.html#t:DiamondTransaction>`__                                                           |     |
+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `DiamondTransaction <Model-Diamonds.html#t:DiamondTransaction>`__                                                            |     |
+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `DiamondTransaction <Model-Diamonds.html#t:DiamondTransaction>`__   |     |
+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+

relation :: `RelationM <Data-Relation.html#t:RelationM>`__

schema :: [[Char]]

transactionDiamonds :: Integer ->
`DiamondTransaction <Model-Diamonds.html#t:DiamondTransaction>`__ ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ ()

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
