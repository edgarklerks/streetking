-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Model.Car

Documentation
=============

data Car

Constructors

Car

 

Fields

id :: [Id](Model-General.html#t:Id)  
 

manufacturer\_id :: Integer  
 

top\_speed :: Integer  
 

acceleration :: Integer  
 

braking :: Integer  
 

nos :: Integer  
 

handling :: Integer  
 

name :: String  
 

use\_3d :: String  
 

year :: Integer  
 

level :: Integer  
 

price :: Integer  
 

Instances

||
|Eq [Car](Model-Car.html#t:Car)| |
|Show [Car](Model-Car.html#t:Car)| |
|ToJSON [Car](Model-Car.html#t:Car)| |
|FromJSON [Car](Model-Car.html#t:Car)| |
|Default [Car](Model-Car.html#t:Car)| |
|[FromInRule](Data-InRules.html#t:FromInRule) [Car](Model-Car.html#t:Car)| |
|[ToInRule](Data-InRules.html#t:ToInRule) [Car](Model-Car.html#t:Car)| |
|[Mapable](Model-General.html#t:Mapable) [Car](Model-Car.html#t:Car)| |
|[Database](Model-General.html#t:Database) [Connection](Data-SqlTransaction.html#t:Connection) [Car](Model-Car.html#t:Car)| |

relation :: [RelationM](Data-Relation.html#t:RelationM)

schema :: [[Char]]

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
