===============
Data.Tournament
===============

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Data.Tournament

Documentation
=============

createTournament :: `Tournament <Data-Tournament.html#t:Tournament>`__
-> `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ ()

joinTournament :: Integer -> Integer -> Integer ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ ()

data Tournament

Instances

+----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Eq `Tournament <Data-Tournament.html#t:Tournament>`__                                                                                                    |     |
+----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Show `Tournament <Data-Tournament.html#t:Tournament>`__                                                                                                  |     |
+----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| ToJSON `Tournament <Data-Tournament.html#t:Tournament>`__                                                                                                |     |
+----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| FromJSON `Tournament <Data-Tournament.html#t:Tournament>`__                                                                                              |     |
+----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Default `Tournament <Data-Tournament.html#t:Tournament>`__                                                                                               |     |
+----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-InRules.html#t:FromInRule>`__ `Tournament <Data-Tournament.html#t:Tournament>`__                                                       |     |
+----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `ToInRule <Data-InRules.html#t:ToInRule>`__ `Tournament <Data-Tournament.html#t:Tournament>`__                                                           |     |
+----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `Tournament <Data-Tournament.html#t:Tournament>`__                                                            |     |
+----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `Tournament <Data-Tournament.html#t:Tournament>`__   |     |
+----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+

runTournament :: `Task <Model-Task.html#t:Task>`__ -> t ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ Bool

initTournament :: t -> IO ()

getResults :: Integer ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__
[`TournamentResult <Model-TournamentResult.html#t:TournamentResult>`__\ ]

getPlayers :: Integer ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__
[[(`AccountProfileMin <Model-AccountProfileMin.html#t:AccountProfileMin>`__,
`AccountProfileMin <Model-AccountProfileMin.html#t:AccountProfileMin>`__,
`Id <Model-General.html#t:Id>`__)]]

processTournamentRace :: Integer ->
[`RaceParticipant <Data-RaceParticipant.html#t:RaceParticipant>`__\ ] ->
Integer ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ (Integer,
[(`RaceParticipant <Data-RaceParticipant.html#t:RaceParticipant>`__,
`RaceResult <Data-RacingNew.html#t:RaceResult>`__)], Integer)

runTournamentRounds :: t -> TournamentFullData ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ [[(Integer,
[(`RaceParticipant <Data-RaceParticipant.html#t:RaceParticipant>`__,
`RaceResult <Data-RacingNew.html#t:RaceResult>`__)])]]

loadTournamentFull :: Integer ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__
TournamentFullData

testTournament :: IO ()

loadTournament :: Integer ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__
`Tournament <Data-Tournament.html#t:Tournament>`__

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
