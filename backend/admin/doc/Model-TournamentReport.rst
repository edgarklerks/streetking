======================
Model.TournamentReport
======================

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Model.TournamentReport

Documentation
=============

type MRaceReward = Maybe
`RaceRewards <Data-RaceReward.html#t:RaceRewards>`__

type TournamentResults =
[`TournamentResult <Model-TournamentResult.html#t:TournamentResult>`__\ ]

type Tournament = Maybe
`Tournament <Model-Tournament.html#t:Tournament>`__

type Players =
[`TournamentPlayer <Model-TournamentPlayers.html#t:TournamentPlayer>`__\ ]

data TournamentReport

Constructors

TournamentReport

 

Fields

id :: `Id <Model-General.html#t:Id>`__
     
tournament\_id :: Integer
     
tournament\_result ::
`TournamentResults <Model-TournamentReport.html#t:TournamentResults>`__
     
account\_id :: Integer
     
tournament :: `Tournament <Model-TournamentReport.html#t:Tournament>`__
     
players :: `Players <Model-TournamentReport.html#t:Players>`__
     
created :: Integer
     

Instances

+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Eq `TournamentReport <Model-TournamentReport.html#t:TournamentReport>`__                                                                                                    |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Show `TournamentReport <Model-TournamentReport.html#t:TournamentReport>`__                                                                                                  |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| ToJSON `TournamentReport <Model-TournamentReport.html#t:TournamentReport>`__                                                                                                |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| FromJSON `TournamentReport <Model-TournamentReport.html#t:TournamentReport>`__                                                                                              |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Default `TournamentReport <Model-TournamentReport.html#t:TournamentReport>`__                                                                                               |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-InRules.html#t:FromInRule>`__ `TournamentReport <Model-TournamentReport.html#t:TournamentReport>`__                                                       |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `ToInRule <Data-InRules.html#t:ToInRule>`__ `TournamentReport <Model-TournamentReport.html#t:TournamentReport>`__                                                           |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `TournamentReport <Model-TournamentReport.html#t:TournamentReport>`__                                                            |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `TournamentReport <Model-TournamentReport.html#t:TournamentReport>`__   |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+

relation :: `RelationM <Data-Relation.html#t:RelationM>`__

schema :: [[Char]]

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
