================
Model.RuleReward
================

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Model.RuleReward

Documentation
=============

data RuleReward

Constructors

RuleReward

 

Fields

id :: `Id <Model-General.html#t:Id>`__
     
rule :: String
     
name :: String
     
change :: Integer
     
money :: Integer
     
experience :: Integer
     

Instances

+-----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Eq `RuleReward <Model-RuleReward.html#t:RuleReward>`__                                                                                                    |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Show `RuleReward <Model-RuleReward.html#t:RuleReward>`__                                                                                                  |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| ToJSON `RuleReward <Model-RuleReward.html#t:RuleReward>`__                                                                                                |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| FromJSON `RuleReward <Model-RuleReward.html#t:RuleReward>`__                                                                                              |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Default `RuleReward <Model-RuleReward.html#t:RuleReward>`__                                                                                               |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-InRules.html#t:FromInRule>`__ `RuleReward <Model-RuleReward.html#t:RuleReward>`__                                                       |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `ToInRule <Data-InRules.html#t:ToInRule>`__ `RuleReward <Model-RuleReward.html#t:RuleReward>`__                                                           |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `RuleReward <Model-RuleReward.html#t:RuleReward>`__                                                            |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `RuleReward <Model-RuleReward.html#t:RuleReward>`__   |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+

relation :: `RelationM <Data-Relation.html#t:RelationM>`__

schema :: [[Char]]

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
