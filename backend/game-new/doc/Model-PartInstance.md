% Model.PartInstance
% 
% 

-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Model.PartInstance

Documentation
=============

data PartInstance

Constructors

PartInstance

 

Fields

id :: [Id](Model-General.html#t:Id)
:    
part\_id :: Integer
:    
garage\_id :: [Id](Model-General.html#t:Id)
:    
car\_instance\_id :: [Id](Model-General.html#t:Id)
:    
improvement :: Integer
:    
wear :: Integer
:    
account\_id :: Integer
:    
deleted :: Bool
:    
immutable :: Integer
:    

Instances

  ------------------------------------------------------------------------------------------------------------------------------------------------------ ---
  Eq [PartInstance](Model-PartInstance.html#t:PartInstance)                                                                                               
  Show [PartInstance](Model-PartInstance.html#t:PartInstance)                                                                                             
  ToJSON [PartInstance](Model-PartInstance.html#t:PartInstance)                                                                                           
  FromJSON [PartInstance](Model-PartInstance.html#t:PartInstance)                                                                                         
  Default [PartInstance](Model-PartInstance.html#t:PartInstance)                                                                                          
  [FromInRule](Data-InRules.html#t:FromInRule) [PartInstance](Model-PartInstance.html#t:PartInstance)                                                     
  [ToInRule](Data-InRules.html#t:ToInRule) [PartInstance](Model-PartInstance.html#t:PartInstance)                                                         
  [Mapable](Model-General.html#t:Mapable) [PartInstance](Model-PartInstance.html#t:PartInstance)                                                          
  [Database](Model-General.html#t:Database) [Connection](Data-SqlTransaction.html#t:Connection) [PartInstance](Model-PartInstance.html#t:PartInstance)    
  ------------------------------------------------------------------------------------------------------------------------------------------------------ ---

relation :: [RelationM](Data-Relation.html#t:RelationM)

schema :: [[Char]]

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
