=================
Model.Application
=================

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Model.Application

Documentation
=============

data Application

Constructors

Application

 

Fields

id :: `Id <Model-General.html#t:Id>`__
     
platform :: String
     
token :: String
     

Instances

+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Eq `Application <Model-Application.html#t:Application>`__                                                                                                    |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Show `Application <Model-Application.html#t:Application>`__                                                                                                  |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Default `Application <Model-Application.html#t:Application>`__                                                                                               |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| ToJSON `Application <Model-Application.html#t:Application>`__                                                                                                |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| FromJSON `Application <Model-Application.html#t:Application>`__                                                                                              |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-InRules.html#t:FromInRule>`__ `Application <Model-Application.html#t:Application>`__                                                       |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `ToInRule <Data-InRules.html#t:ToInRule>`__ `Application <Model-Application.html#t:Application>`__                                                           |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `Application <Model-Application.html#t:Application>`__                                                            |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `Application <Model-Application.html#t:Application>`__   |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+

relation :: `RelationM <Data-Relation.html#t:RelationM>`__

schema :: [[Char]]

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
