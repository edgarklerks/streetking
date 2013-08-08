=============
Model.TaskLog
=============

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Model.TaskLog

Documentation
=============

type MInteger = Maybe Integer

data TaskLog

Constructors

TaskLog

 

Fields

id :: `Id <Model-General.html#t:Id>`__
     
time :: Integer
     
activity :: String
     
task\_id :: `MInteger <Model-TaskLog.html#t:MInteger>`__
     
entry :: `Data <Data-DataPack.html#t:Data>`__
     

Instances

+--------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Eq `TaskLog <Model-TaskLog.html#t:TaskLog>`__                                                                                                    |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Show `TaskLog <Model-TaskLog.html#t:TaskLog>`__                                                                                                  |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| ToJSON `TaskLog <Model-TaskLog.html#t:TaskLog>`__                                                                                                |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| FromJSON `TaskLog <Model-TaskLog.html#t:TaskLog>`__                                                                                              |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Default `TaskLog <Model-TaskLog.html#t:TaskLog>`__                                                                                               |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-InRules.html#t:FromInRule>`__ `TaskLog <Model-TaskLog.html#t:TaskLog>`__                                                       |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `ToInRule <Data-InRules.html#t:ToInRule>`__ `TaskLog <Model-TaskLog.html#t:TaskLog>`__                                                           |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `TaskLog <Model-TaskLog.html#t:TaskLog>`__                                                            |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `TaskLog <Model-TaskLog.html#t:TaskLog>`__   |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------+-----+

relation :: `RelationM <Data-Relation.html#t:RelationM>`__

schema :: [[Char]]

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
