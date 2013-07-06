% Model.RuleReward
% 
% 

-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Model.RuleReward

Documentation
=============

data RuleReward

Constructors

RuleReward

 

Fields

id :: [Id](Model-General.html#t:Id)
:    
rule :: String
:    
name :: String
:    
change :: Integer
:    
money :: Integer
:    
experience :: Integer
:    

Instances

  ------------------------------------------------------------------------------------------------------------------------------------------------ ---
  Eq [RuleReward](Model-RuleReward.html#t:RuleReward)                                                                                               
  Show [RuleReward](Model-RuleReward.html#t:RuleReward)                                                                                             
  ToJSON [RuleReward](Model-RuleReward.html#t:RuleReward)                                                                                           
  FromJSON [RuleReward](Model-RuleReward.html#t:RuleReward)                                                                                         
  Default [RuleReward](Model-RuleReward.html#t:RuleReward)                                                                                          
  [FromInRule](Data-InRules.html#t:FromInRule) [RuleReward](Model-RuleReward.html#t:RuleReward)                                                     
  [ToInRule](Data-InRules.html#t:ToInRule) [RuleReward](Model-RuleReward.html#t:RuleReward)                                                         
  [Mapable](Model-General.html#t:Mapable) [RuleReward](Model-RuleReward.html#t:RuleReward)                                                          
  [Database](Model-General.html#t:Database) [Connection](Data-SqlTransaction.html#t:Connection) [RuleReward](Model-RuleReward.html#t:RuleReward)    
  ------------------------------------------------------------------------------------------------------------------------------------------------ ---

relation :: [RelationM](Data-Relation.html#t:RelationM)

schema :: [[Char]]

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
