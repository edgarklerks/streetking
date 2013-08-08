================
Model.RaceReward
================

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Model.RaceReward

Documentation
=============

data RaceReward

Constructors

RaceReward

 

Fields

id :: `Id <Model-General.html#t:Id>`__
     
race\_id :: Integer
     
account\_id :: Integer
     
time :: Integer
     
rewards :: `RaceRewards <Data-RaceReward.html#t:RaceRewards>`__
     

Instances

+-----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Eq `RaceReward <Model-RaceReward.html#t:RaceReward>`__                                                                                                    |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Show `RaceReward <Model-RaceReward.html#t:RaceReward>`__                                                                                                  |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| ToJSON `RaceReward <Model-RaceReward.html#t:RaceReward>`__                                                                                                |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| FromJSON `RaceReward <Model-RaceReward.html#t:RaceReward>`__                                                                                              |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Default `RaceReward <Model-RaceReward.html#t:RaceReward>`__                                                                                               |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-InRules.html#t:FromInRule>`__ `RaceReward <Model-RaceReward.html#t:RaceReward>`__                                                       |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `ToInRule <Data-InRules.html#t:ToInRule>`__ `RaceReward <Model-RaceReward.html#t:RaceReward>`__                                                           |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `RaceReward <Model-RaceReward.html#t:RaceReward>`__                                                            |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `RaceReward <Model-RaceReward.html#t:RaceReward>`__   |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+

relation :: `RelationM <Data-Relation.html#t:RelationM>`__

schema :: [[Char]]

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
