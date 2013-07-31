===============
Model.Personnel
===============

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Model.Personnel

Documentation
=============

type MInteger = Maybe Integer

data Personnel

Constructors

Personnel

 

Fields

id :: `Id <Model-General.html#t:Id>`__
     
name :: String
     
country\_id :: Integer
     
gender :: Bool
     
picture :: String
     
salary :: Integer
     
price :: Integer
     
skill\_repair :: Integer
     
skill\_engineering :: Integer
     
sort :: Integer
     

Instances

+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Eq `Personnel <Model-Personnel.html#t:Personnel>`__                                                                                                    |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Show `Personnel <Model-Personnel.html#t:Personnel>`__                                                                                                  |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| ToJSON `Personnel <Model-Personnel.html#t:Personnel>`__                                                                                                |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| FromJSON `Personnel <Model-Personnel.html#t:Personnel>`__                                                                                              |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Default `Personnel <Model-Personnel.html#t:Personnel>`__                                                                                               |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-InRules.html#t:FromInRule>`__ `Personnel <Model-Personnel.html#t:Personnel>`__                                                       |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `ToInRule <Data-InRules.html#t:ToInRule>`__ `Personnel <Model-Personnel.html#t:Personnel>`__                                                           |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `Personnel <Model-Personnel.html#t:Personnel>`__                                                            |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `Personnel <Model-Personnel.html#t:Personnel>`__   |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+

relation :: `RelationM <Data-Relation.html#t:RelationM>`__

schema :: [[Char]]

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
