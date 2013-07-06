% Model.PartMarketPlaceType
% 
% 

-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Model.PartMarketPlaceType

Documentation
=============

data PartMarketPlaceType

Constructors

PartMarketPlaceType

 

Fields

id :: [Id](Model-General.html#t:Id)
:    
name :: String
:    
min\_level :: Integer
:    
max\_level :: Integer
:    
min\_price :: Integer
:    
max\_price :: Integer
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

  --------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ---
  Eq [PartMarketPlaceType](Model-PartMarketPlaceType.html#t:PartMarketPlaceType)                                                                                               
  Show [PartMarketPlaceType](Model-PartMarketPlaceType.html#t:PartMarketPlaceType)                                                                                             
  ToJSON [PartMarketPlaceType](Model-PartMarketPlaceType.html#t:PartMarketPlaceType)                                                                                           
  FromJSON [PartMarketPlaceType](Model-PartMarketPlaceType.html#t:PartMarketPlaceType)                                                                                         
  Default [PartMarketPlaceType](Model-PartMarketPlaceType.html#t:PartMarketPlaceType)                                                                                          
  [FromInRule](Data-InRules.html#t:FromInRule) [PartMarketPlaceType](Model-PartMarketPlaceType.html#t:PartMarketPlaceType)                                                     
  [ToInRule](Data-InRules.html#t:ToInRule) [PartMarketPlaceType](Model-PartMarketPlaceType.html#t:PartMarketPlaceType)                                                         
  [Mapable](Model-General.html#t:Mapable) [PartMarketPlaceType](Model-PartMarketPlaceType.html#t:PartMarketPlaceType)                                                          
  [Database](Model-General.html#t:Database) [Connection](Data-SqlTransaction.html#t:Connection) [PartMarketPlaceType](Model-PartMarketPlaceType.html#t:PartMarketPlaceType)    
  --------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ---

relation :: [RelationM](Data-Relation.html#t:RelationM)

schema :: [[Char]]

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
