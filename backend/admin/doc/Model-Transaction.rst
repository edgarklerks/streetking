=================
Model.Transaction
=================

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Model.Transaction

Documentation
=============

data Transaction

Constructors

Transaction

 

Fields

id :: `Id <Model-General.html#t:Id>`__
     
amount :: Integer
     
current :: Integer
     
type :: String
     
type\_id :: Integer
     
time :: Integer
     
account\_id :: Integer
     

Instances

+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Eq `Transaction <Model-Transaction.html#t:Transaction>`__                                                                                                    |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Show `Transaction <Model-Transaction.html#t:Transaction>`__                                                                                                  |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| ToJSON `Transaction <Model-Transaction.html#t:Transaction>`__                                                                                                |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| FromJSON `Transaction <Model-Transaction.html#t:Transaction>`__                                                                                              |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Default `Transaction <Model-Transaction.html#t:Transaction>`__                                                                                               |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-InRules.html#t:FromInRule>`__ `Transaction <Model-Transaction.html#t:Transaction>`__                                                       |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `ToInRule <Data-InRules.html#t:ToInRule>`__ `Transaction <Model-Transaction.html#t:Transaction>`__                                                           |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `Transaction <Model-Transaction.html#t:Transaction>`__                                                            |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `Transaction <Model-Transaction.html#t:Transaction>`__   |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+

relation :: `RelationM <Data-Relation.html#t:RelationM>`__

schema :: [[Char]]

transactionMoney :: Integer ->
`Transaction <Model-Transaction.html#t:Transaction>`__ ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ ()

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
