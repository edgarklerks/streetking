-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Model.CarMinimal

Documentation
=============

data CarMinimal

Constructors

CarMinimal

 

Fields

id :: [Id](Model-General.html#t:Id)  
 

manufacturer\_name :: String  
 

manufacturer\_picture :: String  
 

weight :: Integer  
 

top\_speed :: Integer  
 

acceleration :: Integer  
 

stopping :: Integer  
 

cornering :: Integer  
 

nitrous :: Integer  
 

power :: Integer  
 

traction :: Integer  
 

handling :: Integer  
 

braking :: Integer  
 

aero :: Integer  
 

nos :: Integer  
 

name :: String  
 

level :: Integer  
 

year :: Integer  
 

Instances

||
|Eq [CarMinimal](Model-CarMinimal.html#t:CarMinimal)| |
|Show [CarMinimal](Model-CarMinimal.html#t:CarMinimal)| |
|ToJSON [CarMinimal](Model-CarMinimal.html#t:CarMinimal)| |
|FromJSON [CarMinimal](Model-CarMinimal.html#t:CarMinimal)| |
|Default [CarMinimal](Model-CarMinimal.html#t:CarMinimal)| |
|[FromInRule](Data-InRules.html#t:FromInRule) [CarMinimal](Model-CarMinimal.html#t:CarMinimal)| |
|[ToInRule](Data-InRules.html#t:ToInRule) [CarMinimal](Model-CarMinimal.html#t:CarMinimal)| |
|[Mapable](Model-General.html#t:Mapable) [CarMinimal](Model-CarMinimal.html#t:CarMinimal)| |
|[Database](Model-General.html#t:Database) [Connection](Data-SqlTransaction.html#t:Connection) [CarMinimal](Model-CarMinimal.html#t:CarMinimal)| |

relation :: [RelationM](Data-Relation.html#t:RelationM)

schema :: [[Char]]

class ToCarMinimal a where

Methods

toCM :: a -\> [CarMinimal](Model-CarMinimal.html#t:CarMinimal)

Instances

||
|[ToCarMinimal](Model-CarMinimal.html#t:ToCarMinimal) [CarInGarage](Model-CarInGarage.html#t:CarInGarage)| |

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
