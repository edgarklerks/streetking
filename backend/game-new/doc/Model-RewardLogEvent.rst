====================
Model.RewardLogEvent
====================

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Model.RewardLogEvent

Documentation
=============

type MInteger = Maybe Integer

data RewardLogEvent

Constructors

RewardLogEvent

 

Fields

id :: `Id <Model-General.html#t:Id>`__
     
account\_id :: `Id <Model-General.html#t:Id>`__
     
rule :: String
     
name :: String
     
money :: Integer
     
viewed :: Bool
     
experience :: Integer
     
type\_id :: Integer
     
type :: String
     

Instances

+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Eq `RewardLogEvent <Model-RewardLogEvent.html#t:RewardLogEvent>`__                                                                                                    |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Show `RewardLogEvent <Model-RewardLogEvent.html#t:RewardLogEvent>`__                                                                                                  |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| ToJSON `RewardLogEvent <Model-RewardLogEvent.html#t:RewardLogEvent>`__                                                                                                |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| FromJSON `RewardLogEvent <Model-RewardLogEvent.html#t:RewardLogEvent>`__                                                                                              |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Default `RewardLogEvent <Model-RewardLogEvent.html#t:RewardLogEvent>`__                                                                                               |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-InRules.html#t:FromInRule>`__ `RewardLogEvent <Model-RewardLogEvent.html#t:RewardLogEvent>`__                                                       |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `ToInRule <Data-InRules.html#t:ToInRule>`__ `RewardLogEvent <Model-RewardLogEvent.html#t:RewardLogEvent>`__                                                           |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `RewardLogEvent <Model-RewardLogEvent.html#t:RewardLogEvent>`__                                                            |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `RewardLogEvent <Model-RewardLogEvent.html#t:RewardLogEvent>`__   |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+

relation :: `RelationM <Data-Relation.html#t:RelationM>`__

schema :: [[Char]]

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
