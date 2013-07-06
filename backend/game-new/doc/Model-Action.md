% Model.Action
% 
% 

-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Model.Action

Documentation
=============

data Action

Constructors

Action

 

Fields

id :: [Id](Model-General.html#t:Id)
:    
reward\_id :: [Id](Model-General.html#t:Id)
:    
rule\_id :: [Id](Model-General.html#t:Id)
:    
change :: Integer
:    

Instances

  ------------------------------------------------------------------------------------------------------------------------------------ ---
  Eq [Action](Model-Action.html#t:Action)                                                                                               
  Show [Action](Model-Action.html#t:Action)                                                                                             
  ToJSON [Action](Model-Action.html#t:Action)                                                                                           
  FromJSON [Action](Model-Action.html#t:Action)                                                                                         
  Default [Action](Model-Action.html#t:Action)                                                                                          
  [FromInRule](Data-InRules.html#t:FromInRule) [Action](Model-Action.html#t:Action)                                                     
  [ToInRule](Data-InRules.html#t:ToInRule) [Action](Model-Action.html#t:Action)                                                         
  [Mapable](Model-General.html#t:Mapable) [Action](Model-Action.html#t:Action)                                                          
  [Database](Model-General.html#t:Database) [Connection](Data-SqlTransaction.html#t:Connection) [Action](Model-Action.html#t:Action)    
  ------------------------------------------------------------------------------------------------------------------------------------ ---

relation :: [RelationM](Data-Relation.html#t:RelationM)

schema :: [[Char]]

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
