=====================
Model.ChallengeAccept
=====================

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Model.ChallengeAccept

Documentation
=============

data ChallengeAccept

Constructors

ChallengeAccept

 

Fields

id :: `Id <Model-General.html#t:Id>`__
     
challenge\_id :: Integer
     
account\_id :: Integer
     

Instances

+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Eq `ChallengeAccept <Model-ChallengeAccept.html#t:ChallengeAccept>`__                                                                                                    |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Show `ChallengeAccept <Model-ChallengeAccept.html#t:ChallengeAccept>`__                                                                                                  |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| ToJSON `ChallengeAccept <Model-ChallengeAccept.html#t:ChallengeAccept>`__                                                                                                |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| FromJSON `ChallengeAccept <Model-ChallengeAccept.html#t:ChallengeAccept>`__                                                                                              |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Default `ChallengeAccept <Model-ChallengeAccept.html#t:ChallengeAccept>`__                                                                                               |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-InRules.html#t:FromInRule>`__ `ChallengeAccept <Model-ChallengeAccept.html#t:ChallengeAccept>`__                                                       |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `ToInRule <Data-InRules.html#t:ToInRule>`__ `ChallengeAccept <Model-ChallengeAccept.html#t:ChallengeAccept>`__                                                           |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `ChallengeAccept <Model-ChallengeAccept.html#t:ChallengeAccept>`__                                                            |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `ChallengeAccept <Model-ChallengeAccept.html#t:ChallengeAccept>`__   |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+

relation :: `RelationM <Data-Relation.html#t:RelationM>`__

schema :: [[Char]]

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
