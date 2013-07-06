=================
Model.TaskTrigger
=================

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Model.TaskTrigger

Documentation
=============

data TaskTrigger

Constructors

TaskTrigger

 

Fields

id :: `Id <Model-General.html#t:Id>`__
     
task\_id :: Integer
     
type :: Integer
     
target\_id :: Integer
     

Instances

+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Eq `TaskTrigger <Model-TaskTrigger.html#t:TaskTrigger>`__                                                                                                    |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Show `TaskTrigger <Model-TaskTrigger.html#t:TaskTrigger>`__                                                                                                  |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| ToJSON `TaskTrigger <Model-TaskTrigger.html#t:TaskTrigger>`__                                                                                                |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| FromJSON `TaskTrigger <Model-TaskTrigger.html#t:TaskTrigger>`__                                                                                              |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Default `TaskTrigger <Model-TaskTrigger.html#t:TaskTrigger>`__                                                                                               |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-InRules.html#t:FromInRule>`__ `TaskTrigger <Model-TaskTrigger.html#t:TaskTrigger>`__                                                       |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `ToInRule <Data-InRules.html#t:ToInRule>`__ `TaskTrigger <Model-TaskTrigger.html#t:TaskTrigger>`__                                                           |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `TaskTrigger <Model-TaskTrigger.html#t:TaskTrigger>`__                                                            |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `TaskTrigger <Model-TaskTrigger.html#t:TaskTrigger>`__   |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+

relation :: `RelationM <Data-Relation.html#t:RelationM>`__

schema :: [[Char]]

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
