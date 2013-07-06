% Model.PartModifier
% 
% 

-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Model.PartModifier

Documentation
=============

data PartModifier

Constructors

PartModifier

 

Fields

id :: [Id](Model-General.html#t:Id)
:    
name :: String
:    

Instances

  ------------------------------------------------------------------------------------------------------------------------------------------------------ ---
  Eq [PartModifier](Model-PartModifier.html#t:PartModifier)                                                                                               
  Show [PartModifier](Model-PartModifier.html#t:PartModifier)                                                                                             
  ToJSON [PartModifier](Model-PartModifier.html#t:PartModifier)                                                                                           
  FromJSON [PartModifier](Model-PartModifier.html#t:PartModifier)                                                                                         
  Default [PartModifier](Model-PartModifier.html#t:PartModifier)                                                                                          
  [FromInRule](Data-InRules.html#t:FromInRule) [PartModifier](Model-PartModifier.html#t:PartModifier)                                                     
  [ToInRule](Data-InRules.html#t:ToInRule) [PartModifier](Model-PartModifier.html#t:PartModifier)                                                         
  [Mapable](Model-General.html#t:Mapable) [PartModifier](Model-PartModifier.html#t:PartModifier)                                                          
  [Database](Model-General.html#t:Database) [Connection](Data-SqlTransaction.html#t:Connection) [PartModifier](Model-PartModifier.html#t:PartModifier)    
  ------------------------------------------------------------------------------------------------------------------------------------------------------ ---

relation :: [RelationM](Data-Relation.html#t:RelationM)

schema :: [[Char]]

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
