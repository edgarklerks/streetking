=======================
Model.TournamentPlayers
=======================

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Model.TournamentPlayers

Documentation
=============

data TournamentPlayer

Constructors

TournamentPlayer

 

Fields

id :: `Id <Model-General.html#t:Id>`__
     
account\_id :: `Id <Model-General.html#t:Id>`__
     
tournament\_id :: `Id <Model-General.html#t:Id>`__
     
car\_instance\_id :: `Id <Model-General.html#t:Id>`__
     
deleted :: Bool
     

Instances

+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Eq `TournamentPlayer <Model-TournamentPlayers.html#t:TournamentPlayer>`__                                                                                                    |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Show `TournamentPlayer <Model-TournamentPlayers.html#t:TournamentPlayer>`__                                                                                                  |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| ToJSON `TournamentPlayer <Model-TournamentPlayers.html#t:TournamentPlayer>`__                                                                                                |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| FromJSON `TournamentPlayer <Model-TournamentPlayers.html#t:TournamentPlayer>`__                                                                                              |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Default `TournamentPlayer <Model-TournamentPlayers.html#t:TournamentPlayer>`__                                                                                               |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-InRules.html#t:FromInRule>`__ `TournamentPlayer <Model-TournamentPlayers.html#t:TournamentPlayer>`__                                                       |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `ToInRule <Data-InRules.html#t:ToInRule>`__ `TournamentPlayer <Model-TournamentPlayers.html#t:TournamentPlayer>`__                                                           |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `TournamentPlayer <Model-TournamentPlayers.html#t:TournamentPlayer>`__                                                            |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `TournamentPlayer <Model-TournamentPlayers.html#t:TournamentPlayer>`__   |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+

relation :: `RelationM <Data-Relation.html#t:RelationM>`__

schema :: [[Char]]

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
