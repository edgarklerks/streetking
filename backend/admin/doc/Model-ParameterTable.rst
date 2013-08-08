====================
Model.ParameterTable
====================

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Model.ParameterTable

Documentation
=============

data ParameterTable

Constructors

ParameterTable

 

Fields

id :: `Id <Model-General.html#t:Id>`__
     
name :: String
     
unit :: String
     

Instances

+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Eq `ParameterTable <Model-ParameterTable.html#t:ParameterTable>`__                                                                                                    |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Show `ParameterTable <Model-ParameterTable.html#t:ParameterTable>`__                                                                                                  |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| ToJSON `ParameterTable <Model-ParameterTable.html#t:ParameterTable>`__                                                                                                |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| FromJSON `ParameterTable <Model-ParameterTable.html#t:ParameterTable>`__                                                                                              |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Default `ParameterTable <Model-ParameterTable.html#t:ParameterTable>`__                                                                                               |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-InRules.html#t:FromInRule>`__ `ParameterTable <Model-ParameterTable.html#t:ParameterTable>`__                                                       |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `ToInRule <Data-InRules.html#t:ToInRule>`__ `ParameterTable <Model-ParameterTable.html#t:ParameterTable>`__                                                           |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `ParameterTable <Model-ParameterTable.html#t:ParameterTable>`__                                                            |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `ParameterTable <Model-ParameterTable.html#t:ParameterTable>`__   |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+

relation :: `RelationM <Data-Relation.html#t:RelationM>`__

schema :: [[Char]]

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
