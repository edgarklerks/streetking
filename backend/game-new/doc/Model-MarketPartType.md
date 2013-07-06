% Model.MarketPartType
% 
% 

-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Model.MarketPartType

Documentation
=============

data MarketPartType

Constructors

MarketPartType

 

Fields

car\_id :: [Id](Model-General.html#t:Id)
:    
name :: String
:    
level :: Integer
:    

Instances

  ------------------------------------------------------------------------------------------------------------------------------------------------------------ ---
  Eq [MarketPartType](Model-MarketPartType.html#t:MarketPartType)                                                                                               
  Show [MarketPartType](Model-MarketPartType.html#t:MarketPartType)                                                                                             
  ToJSON [MarketPartType](Model-MarketPartType.html#t:MarketPartType)                                                                                           
  FromJSON [MarketPartType](Model-MarketPartType.html#t:MarketPartType)                                                                                         
  Default [MarketPartType](Model-MarketPartType.html#t:MarketPartType)                                                                                          
  [FromInRule](Data-InRules.html#t:FromInRule) [MarketPartType](Model-MarketPartType.html#t:MarketPartType)                                                     
  [ToInRule](Data-InRules.html#t:ToInRule) [MarketPartType](Model-MarketPartType.html#t:MarketPartType)                                                         
  [Mapable](Model-General.html#t:Mapable) [MarketPartType](Model-MarketPartType.html#t:MarketPartType)                                                          
  [Database](Model-General.html#t:Database) [Connection](Data-SqlTransaction.html#t:Connection) [MarketPartType](Model-MarketPartType.html#t:MarketPartType)    
  ------------------------------------------------------------------------------------------------------------------------------------------------------------ ---

relation :: [RelationM](Data-Relation.html#t:RelationM)

schema :: [[Char]]

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
