=====================
Model.RewardLogEvents
=====================

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Model.RewardLogEvents

Documentation
=============

type MInteger = Maybe Integer

data RewardLogEvents

Constructors

RewardLogEvents

 

Fields

id :: `Id <Model-General.html#t:Id>`__
     
type :: String
     
type\_id :: Integer
     
reward\_log\_id :: Integer
     

Instances

+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Eq `RewardLogEvents <Model-RewardLogEvents.html#t:RewardLogEvents>`__                                                                                                    |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Show `RewardLogEvents <Model-RewardLogEvents.html#t:RewardLogEvents>`__                                                                                                  |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| ToJSON `RewardLogEvents <Model-RewardLogEvents.html#t:RewardLogEvents>`__                                                                                                |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| FromJSON `RewardLogEvents <Model-RewardLogEvents.html#t:RewardLogEvents>`__                                                                                              |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Default `RewardLogEvents <Model-RewardLogEvents.html#t:RewardLogEvents>`__                                                                                               |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-InRules.html#t:FromInRule>`__ `RewardLogEvents <Model-RewardLogEvents.html#t:RewardLogEvents>`__                                                       |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `ToInRule <Data-InRules.html#t:ToInRule>`__ `RewardLogEvents <Model-RewardLogEvents.html#t:RewardLogEvents>`__                                                           |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `RewardLogEvents <Model-RewardLogEvents.html#t:RewardLogEvents>`__                                                            |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `RewardLogEvents <Model-RewardLogEvents.html#t:RewardLogEvents>`__   |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+

relation :: `RelationM <Data-Relation.html#t:RelationM>`__

schema :: [[Char]]

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
