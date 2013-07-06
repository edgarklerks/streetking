% Model.PartType
% 
% 

-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Model.PartType

Documentation
=============

data PartType

Constructors

PartType

 

Fields

id :: [Id](Model-General.html#t:Id)
:    
name :: String
:    
sort :: Integer
:    
use\_3d :: String
:    
required :: Bool
:    
fixed :: Bool
:    
hidden :: Bool
:    

Instances

  ------------------------------------------------------------------------------------------------------------------------------------------ ---
  Eq [PartType](Model-PartType.html#t:PartType)                                                                                               
  Show [PartType](Model-PartType.html#t:PartType)                                                                                             
  ToJSON [PartType](Model-PartType.html#t:PartType)                                                                                           
  FromJSON [PartType](Model-PartType.html#t:PartType)                                                                                         
  Default [PartType](Model-PartType.html#t:PartType)                                                                                          
  [FromInRule](Data-InRules.html#t:FromInRule) [PartType](Model-PartType.html#t:PartType)                                                     
  [ToInRule](Data-InRules.html#t:ToInRule) [PartType](Model-PartType.html#t:PartType)                                                         
  [Mapable](Model-General.html#t:Mapable) [PartType](Model-PartType.html#t:PartType)                                                          
  [Database](Model-General.html#t:Database) [Connection](Data-SqlTransaction.html#t:Connection) [PartType](Model-PartType.html#t:PartType)    
  ------------------------------------------------------------------------------------------------------------------------------------------ ---

relation :: [RelationM](Data-Relation.html#t:RelationM)

schema :: [[Char]]

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
