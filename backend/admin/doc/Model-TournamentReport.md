% Model.TournamentReport
% 
% 

-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Model.TournamentReport

Documentation
=============

type MRaceReward = Maybe
[RaceRewards](Data-RaceReward.html#t:RaceRewards)

type TournamentResults =
[[TournamentResult](Model-TournamentResult.html#t:TournamentResult)]

type Tournament = Maybe [Tournament](Model-Tournament.html#t:Tournament)

type Players =
[[TournamentPlayer](Model-TournamentPlayers.html#t:TournamentPlayer)]

data TournamentReport

Constructors

TournamentReport

 

Fields

id :: [Id](Model-General.html#t:Id)
:    
tournament\_id :: Integer
:    
tournament\_result :: [TournamentResults](Model-TournamentReport.html#t:TournamentResults)
:    
account\_id :: Integer
:    
tournament :: [Tournament](Model-TournamentReport.html#t:Tournament)
:    
players :: [Players](Model-TournamentReport.html#t:Players)
:    
created :: Integer
:    

Instances

  ------------------------------------------------------------------------------------------------------------------------------------------------------------------ ---
  Eq [TournamentReport](Model-TournamentReport.html#t:TournamentReport)                                                                                               
  Show [TournamentReport](Model-TournamentReport.html#t:TournamentReport)                                                                                             
  ToJSON [TournamentReport](Model-TournamentReport.html#t:TournamentReport)                                                                                           
  FromJSON [TournamentReport](Model-TournamentReport.html#t:TournamentReport)                                                                                         
  Default [TournamentReport](Model-TournamentReport.html#t:TournamentReport)                                                                                          
  [FromInRule](Data-InRules.html#t:FromInRule) [TournamentReport](Model-TournamentReport.html#t:TournamentReport)                                                     
  [ToInRule](Data-InRules.html#t:ToInRule) [TournamentReport](Model-TournamentReport.html#t:TournamentReport)                                                         
  [Mapable](Model-General.html#t:Mapable) [TournamentReport](Model-TournamentReport.html#t:TournamentReport)                                                          
  [Database](Model-General.html#t:Database) [Connection](Data-SqlTransaction.html#t:Connection) [TournamentReport](Model-TournamentReport.html#t:TournamentReport)    
  ------------------------------------------------------------------------------------------------------------------------------------------------------------------ ---

relation :: [RelationM](Data-Relation.html#t:RelationM)

schema :: [[Char]]

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
