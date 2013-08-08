======================
Model.TournamentResult
======================

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Model.TournamentResult

Documentation
=============

type RaceResultTuple = Maybe
(`RaceParticipant <Data-RaceParticipant.html#t:RaceParticipant>`__,
`RaceResult <Data-RacingNew.html#t:RaceResult>`__)

data TournamentResult

Constructors

TournamentResult

 

Fields

id :: `Id <Model-General.html#t:Id>`__
     
tournament\_id :: `Id <Model-General.html#t:Id>`__
     
race\_id :: `Id <Model-General.html#t:Id>`__
     
participant1\_id :: `Id <Model-General.html#t:Id>`__
     
participant2\_id :: `Id <Model-General.html#t:Id>`__
     
round :: Integer
     
race\_time1 :: Double
     
race\_time2 :: Double
     
car1\_id :: Integer
     
car2\_id :: Integer
     

Instances

+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Eq `TournamentResult <Model-TournamentResult.html#t:TournamentResult>`__                                                                                                    |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Show `TournamentResult <Model-TournamentResult.html#t:TournamentResult>`__                                                                                                  |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| ToJSON `TournamentResult <Model-TournamentResult.html#t:TournamentResult>`__                                                                                                |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| FromJSON `TournamentResult <Model-TournamentResult.html#t:TournamentResult>`__                                                                                              |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Default `TournamentResult <Model-TournamentResult.html#t:TournamentResult>`__                                                                                               |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-InRules.html#t:FromInRule>`__ `TournamentResult <Model-TournamentResult.html#t:TournamentResult>`__                                                       |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `ToInRule <Data-InRules.html#t:ToInRule>`__ `TournamentResult <Model-TournamentResult.html#t:TournamentResult>`__                                                           |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `TournamentResult <Model-TournamentResult.html#t:TournamentResult>`__                                                            |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `TournamentResult <Model-TournamentResult.html#t:TournamentResult>`__   |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+

relation :: `RelationM <Data-Relation.html#t:RelationM>`__

schema :: [[Char]]

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
