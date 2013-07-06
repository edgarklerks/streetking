% Model.CarInGarage
% 
% 

-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Model.CarInGarage

Documentation
=============

type MInteger = Maybe Integer

data CarInGarage

Constructors

CarInGarage

 

Fields

id :: [Id](Model-General.html#t:Id)
:    
car\_id :: Integer
:    
manufacturer\_id :: Integer
:    
manufacturer\_name :: String
:    
manufacturer\_picture :: String
:    
weight :: Integer
:    
top\_speed :: Integer
:    
acceleration :: Integer
:    
stopping :: Integer
:    
cornering :: Integer
:    
nitrous :: Integer
:    
power :: Integer
:    
traction :: Integer
:    
handling :: Integer
:    
braking :: Integer
:    
aero :: Integer
:    
nos :: Integer
:    
name :: String
:    
parts\_price :: Integer
:    
total\_price :: Integer
:    
account\_id :: Integer
:    
level :: Integer
:    
parts\_level :: [MInteger](Model-CarInGarage.html#t:MInteger)
:    
wear :: Integer
:    
improvement :: Integer
:    
active :: Bool
:    
ready :: Bool
:    
year :: Integer
:    
car\_label :: String
:    
prototype :: Bool
:    
prototype\_name :: String
:    
prototype\_available :: Bool
:    
prototype\_claimable :: Bool
:    
car\_color :: String
:    

Instances

  --------------------------------------------------------------------------------------------------------------------------------------------------- ---
  Eq [CarInGarage](Model-CarInGarage.html#t:CarInGarage)                                                                                               
  Show [CarInGarage](Model-CarInGarage.html#t:CarInGarage)                                                                                             
  ToJSON [CarInGarage](Model-CarInGarage.html#t:CarInGarage)                                                                                           
  FromJSON [CarInGarage](Model-CarInGarage.html#t:CarInGarage)                                                                                         
  Default [CarInGarage](Model-CarInGarage.html#t:CarInGarage)                                                                                          
  [FromInRule](Data-InRules.html#t:FromInRule) [CarInGarage](Model-CarInGarage.html#t:CarInGarage)                                                     
  [ToInRule](Data-InRules.html#t:ToInRule) [CarInGarage](Model-CarInGarage.html#t:CarInGarage)                                                         
  [Mapable](Model-General.html#t:Mapable) [CarInGarage](Model-CarInGarage.html#t:CarInGarage)                                                          
  [ToCarMinimal](Model-CarMinimal.html#t:ToCarMinimal) [CarInGarage](Model-CarInGarage.html#t:CarInGarage)                                             
  [Database](Model-General.html#t:Database) [Connection](Data-SqlTransaction.html#t:Connection) [CarInGarage](Model-CarInGarage.html#t:CarInGarage)    
  --------------------------------------------------------------------------------------------------------------------------------------------------- ---

relation :: [RelationM](Data-Relation.html#t:RelationM)

schema :: [[Char]]

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
