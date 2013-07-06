% Model.TournamentResult
% 
% 

-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Model.TournamentResult

Documentation
=============

type RaceResultTuple = Maybe
([RaceParticipant](Data-RaceParticipant.html#t:RaceParticipant),
[RaceResult](Data-RacingNew.html#t:RaceResult))

data TournamentResult

Constructors

TournamentResult

 

Fields

id :: [Id](Model-General.html#t:Id)
:    
tournament\_id :: [Id](Model-General.html#t:Id)
:    
race\_id :: [Id](Model-General.html#t:Id)
:    
participant1\_id :: [Id](Model-General.html#t:Id)
:    
participant2\_id :: [Id](Model-General.html#t:Id)
:    
round :: Integer
:    
race\_time1 :: Double
:    
race\_time2 :: Double
:    
car1\_id :: Integer
:    
car2\_id :: Integer
:    

Instances

  ------------------------------------------------------------------------------------------------------------------------------------------------------------------ ---
  Eq [TournamentResult](Model-TournamentResult.html#t:TournamentResult)                                                                                               
  Show [TournamentResult](Model-TournamentResult.html#t:TournamentResult)                                                                                             
  ToJSON [TournamentResult](Model-TournamentResult.html#t:TournamentResult)                                                                                           
  FromJSON [TournamentResult](Model-TournamentResult.html#t:TournamentResult)                                                                                         
  Default [TournamentResult](Model-TournamentResult.html#t:TournamentResult)                                                                                          
  [FromInRule](Data-InRules.html#t:FromInRule) [TournamentResult](Model-TournamentResult.html#t:TournamentResult)                                                     
  [ToInRule](Data-InRules.html#t:ToInRule) [TournamentResult](Model-TournamentResult.html#t:TournamentResult)                                                         
  [Mapable](Model-General.html#t:Mapable) [TournamentResult](Model-TournamentResult.html#t:TournamentResult)                                                          
  [Database](Model-General.html#t:Database) [Connection](Data-SqlTransaction.html#t:Connection) [TournamentResult](Model-TournamentResult.html#t:TournamentResult)    
  ------------------------------------------------------------------------------------------------------------------------------------------------------------------ ---

relation :: [RelationM](Data-Relation.html#t:RelationM)

schema :: [[Char]]

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
