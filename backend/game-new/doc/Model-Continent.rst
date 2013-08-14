===============
Model.Continent
===============

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Model.Continent

Documentation
=============

data Continent

Constructors

Continent

 

Fields

id :: `Id <Model-General.html#t:Id>`__
     
name :: String
     
data :: String
     

Instances

+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Eq `Continent <Model-Continent.html#t:Continent>`__                                                                                                    |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Show `Continent <Model-Continent.html#t:Continent>`__                                                                                                  |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| ToJSON `Continent <Model-Continent.html#t:Continent>`__                                                                                                |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| FromJSON `Continent <Model-Continent.html#t:Continent>`__                                                                                              |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Default `Continent <Model-Continent.html#t:Continent>`__                                                                                               |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-InRules.html#t:FromInRule>`__ `Continent <Model-Continent.html#t:Continent>`__                                                       |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `ToInRule <Data-InRules.html#t:ToInRule>`__ `Continent <Model-Continent.html#t:Continent>`__                                                           |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `Continent <Model-Continent.html#t:Continent>`__                                                            |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `Continent <Model-Continent.html#t:Continent>`__   |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+

relation :: `RelationM <Data-Relation.html#t:RelationM>`__

schema :: [[Char]]

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
