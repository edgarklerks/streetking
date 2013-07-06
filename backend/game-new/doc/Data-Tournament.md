% Data.Tournament
% 
% 

-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Data.Tournament

Documentation
=============

createTournament :: [Tournament](Data-Tournament.html#t:Tournament) -\>
[SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction)
[Connection](Data-SqlTransaction.html#t:Connection) ()

joinTournament :: Integer -\> Integer -\> Integer -\>
[SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction)
[Connection](Data-SqlTransaction.html#t:Connection) ()

data Tournament

Instances

  ----------------------------------------------------------------------------------------------------------------------------------------------- ---
  Eq [Tournament](Data-Tournament.html#t:Tournament)                                                                                               
  Show [Tournament](Data-Tournament.html#t:Tournament)                                                                                             
  ToJSON [Tournament](Data-Tournament.html#t:Tournament)                                                                                           
  FromJSON [Tournament](Data-Tournament.html#t:Tournament)                                                                                         
  Default [Tournament](Data-Tournament.html#t:Tournament)                                                                                          
  [FromInRule](Data-InRules.html#t:FromInRule) [Tournament](Data-Tournament.html#t:Tournament)                                                     
  [ToInRule](Data-InRules.html#t:ToInRule) [Tournament](Data-Tournament.html#t:Tournament)                                                         
  [Mapable](Model-General.html#t:Mapable) [Tournament](Data-Tournament.html#t:Tournament)                                                          
  [Database](Model-General.html#t:Database) [Connection](Data-SqlTransaction.html#t:Connection) [Tournament](Data-Tournament.html#t:Tournament)    
  ----------------------------------------------------------------------------------------------------------------------------------------------- ---

runTournament :: [Task](Model-Task.html#t:Task) -\> t -\>
[SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction)
[Connection](Data-SqlTransaction.html#t:Connection) Bool

initTournament :: t -\> IO ()

getResults :: Integer -\>
[SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction)
[Connection](Data-SqlTransaction.html#t:Connection)
[[TournamentResult](Model-TournamentResult.html#t:TournamentResult)]

getPlayers :: Integer -\>
[SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction)
[Connection](Data-SqlTransaction.html#t:Connection)
[[([AccountProfileMin](Model-AccountProfileMin.html#t:AccountProfileMin),
[AccountProfileMin](Model-AccountProfileMin.html#t:AccountProfileMin),
[Id](Model-General.html#t:Id))]]

processTournamentRace :: Integer -\>
[[RaceParticipant](Data-RaceParticipant.html#t:RaceParticipant)] -\>
Integer -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction)
[Connection](Data-SqlTransaction.html#t:Connection) (Integer,
[([RaceParticipant](Data-RaceParticipant.html#t:RaceParticipant),
[RaceResult](Data-RacingNew.html#t:RaceResult))], Integer)

runTournamentRounds :: t -\> TournamentFullData -\>
[SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction)
[Connection](Data-SqlTransaction.html#t:Connection) [[(Integer,
[([RaceParticipant](Data-RaceParticipant.html#t:RaceParticipant),
[RaceResult](Data-RacingNew.html#t:RaceResult))])]]

loadTournamentFull :: Integer -\>
[SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction)
[Connection](Data-SqlTransaction.html#t:Connection) TournamentFullData

testTournament :: IO ()

loadTournament :: Integer -\>
[SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction)
[Connection](Data-SqlTransaction.html#t:Connection)
[Tournament](Data-Tournament.html#t:Tournament)

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
