============
Model.Escrow
============

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Model.Escrow

Documentation
=============

data Escrow

Constructors

Escrow

 

Fields

id :: `Id <Model-General.html#t:Id>`__
     
account\_id :: Integer
     
amount :: Integer
     
deleted :: Bool
     

Instances

+-----------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Eq `Escrow <Model-Escrow.html#t:Escrow>`__                                                                                                    |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Show `Escrow <Model-Escrow.html#t:Escrow>`__                                                                                                  |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------+-----+
| ToJSON `Escrow <Model-Escrow.html#t:Escrow>`__                                                                                                |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------+-----+
| FromJSON `Escrow <Model-Escrow.html#t:Escrow>`__                                                                                              |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Default `Escrow <Model-Escrow.html#t:Escrow>`__                                                                                               |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-InRules.html#t:FromInRule>`__ `Escrow <Model-Escrow.html#t:Escrow>`__                                                       |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `ToInRule <Data-InRules.html#t:ToInRule>`__ `Escrow <Model-Escrow.html#t:Escrow>`__                                                           |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `Escrow <Model-Escrow.html#t:Escrow>`__                                                            |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `Escrow <Model-Escrow.html#t:Escrow>`__   |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------+-----+

relation :: `RelationM <Data-Relation.html#t:RelationM>`__

schema :: [[Char]]

deposit :: Integer -> Integer ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ Integer

cancel :: Integer ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ ()

release :: Integer -> Integer ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ ()

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
