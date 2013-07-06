% Model.RaceReward
% 
% 

-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Model.RaceReward

Documentation
=============

data RaceReward

Constructors

RaceReward

 

Fields

id :: [Id](Model-General.html#t:Id)
:    
race\_id :: Integer
:    
account\_id :: Integer
:    
time :: Integer
:    
rewards :: [RaceRewards](Data-RaceReward.html#t:RaceRewards)
:    

Instances

  ------------------------------------------------------------------------------------------------------------------------------------------------ ---
  Eq [RaceReward](Model-RaceReward.html#t:RaceReward)                                                                                               
  Show [RaceReward](Model-RaceReward.html#t:RaceReward)                                                                                             
  ToJSON [RaceReward](Model-RaceReward.html#t:RaceReward)                                                                                           
  FromJSON [RaceReward](Model-RaceReward.html#t:RaceReward)                                                                                         
  Default [RaceReward](Model-RaceReward.html#t:RaceReward)                                                                                          
  [FromInRule](Data-InRules.html#t:FromInRule) [RaceReward](Model-RaceReward.html#t:RaceReward)                                                     
  [ToInRule](Data-InRules.html#t:ToInRule) [RaceReward](Model-RaceReward.html#t:RaceReward)                                                         
  [Mapable](Model-General.html#t:Mapable) [RaceReward](Model-RaceReward.html#t:RaceReward)                                                          
  [Database](Model-General.html#t:Database) [Connection](Data-SqlTransaction.html#t:Connection) [RaceReward](Model-RaceReward.html#t:RaceReward)    
  ------------------------------------------------------------------------------------------------------------------------------------------------ ---

relation :: [RelationM](Data-Relation.html#t:RelationM)

schema :: [[Char]]

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
