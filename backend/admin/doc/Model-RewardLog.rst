===============
Model.RewardLog
===============

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Model.RewardLog

Documentation
=============

data RewardLog

Constructors

RewardLog

 

Fields

id :: `Id <Model-General.html#t:Id>`__
     
account\_id :: `Id <Model-General.html#t:Id>`__
     
rule :: String
     
name :: String
     
money :: Integer
     
viewed :: Bool
     
experience :: Integer
     

Instances

+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Eq `RewardLog <Model-RewardLog.html#t:RewardLog>`__                                                                                                    |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Show `RewardLog <Model-RewardLog.html#t:RewardLog>`__                                                                                                  |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| ToJSON `RewardLog <Model-RewardLog.html#t:RewardLog>`__                                                                                                |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| FromJSON `RewardLog <Model-RewardLog.html#t:RewardLog>`__                                                                                              |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Default `RewardLog <Model-RewardLog.html#t:RewardLog>`__                                                                                               |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-InRules.html#t:FromInRule>`__ `RewardLog <Model-RewardLog.html#t:RewardLog>`__                                                       |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `ToInRule <Data-InRules.html#t:ToInRule>`__ `RewardLog <Model-RewardLog.html#t:RewardLog>`__                                                           |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `RewardLog <Model-RewardLog.html#t:RewardLog>`__                                                            |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `RewardLog <Model-RewardLog.html#t:RewardLog>`__   |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+

relation :: `RelationM <Data-Relation.html#t:RelationM>`__

schema :: [[Char]]

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
