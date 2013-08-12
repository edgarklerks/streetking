====================
Model.TournamentType
====================

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Model.TournamentType

Documentation
=============

type MRaceReward = Maybe
`RaceRewards <Data-RaceReward.html#t:RaceRewards>`__

type MInteger = Maybe Integer

data TournamentType

Constructors

TournamentType

 

Fields

id :: `Id <Model-General.html#t:Id>`__
     
name :: String
     

Instances

+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Eq `TournamentType <Model-TournamentType.html#t:TournamentType>`__                                                                                                    |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Show `TournamentType <Model-TournamentType.html#t:TournamentType>`__                                                                                                  |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| ToJSON `TournamentType <Model-TournamentType.html#t:TournamentType>`__                                                                                                |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| FromJSON `TournamentType <Model-TournamentType.html#t:TournamentType>`__                                                                                              |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Default `TournamentType <Model-TournamentType.html#t:TournamentType>`__                                                                                               |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-InRules.html#t:FromInRule>`__ `TournamentType <Model-TournamentType.html#t:TournamentType>`__                                                       |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `ToInRule <Data-InRules.html#t:ToInRule>`__ `TournamentType <Model-TournamentType.html#t:TournamentType>`__                                                           |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `TournamentType <Model-TournamentType.html#t:TournamentType>`__                                                            |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `TournamentType <Model-TournamentType.html#t:TournamentType>`__   |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+

relation :: `RelationM <Data-Relation.html#t:RelationM>`__

schema :: [[Char]]

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
