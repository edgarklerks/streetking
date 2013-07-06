-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Model.PartMarketType

Documentation
=============

data PartMarketType

Constructors

PartMarketType

 

Fields

id :: [Id](Model-General.html#t:Id)  
 

name :: String  
 

min\_level :: Integer  
 

max\_level :: Integer  
 

min\_price :: Integer  
 

max\_price :: Integer  
 

sort :: Integer  
 

use\_3d :: String  
 

required :: Bool  
 

fixed :: Bool  
 

hidden :: Bool  
 

Instances

||
|Eq [PartMarketType](Model-PartMarketType.html#t:PartMarketType)| |
|Show [PartMarketType](Model-PartMarketType.html#t:PartMarketType)| |
|ToJSON [PartMarketType](Model-PartMarketType.html#t:PartMarketType)| |
|FromJSON [PartMarketType](Model-PartMarketType.html#t:PartMarketType)| |
|Default [PartMarketType](Model-PartMarketType.html#t:PartMarketType)| |
|[FromInRule](Data-InRules.html#t:FromInRule) [PartMarketType](Model-PartMarketType.html#t:PartMarketType)| |
|[ToInRule](Data-InRules.html#t:ToInRule) [PartMarketType](Model-PartMarketType.html#t:PartMarketType)| |
|[Mapable](Model-General.html#t:Mapable) [PartMarketType](Model-PartMarketType.html#t:PartMarketType)| |
|[Database](Model-General.html#t:Database) [Connection](Data-SqlTransaction.html#t:Connection) [PartMarketType](Model-PartMarketType.html#t:PartMarketType)| |

relation :: [RelationM](Data-Relation.html#t:RelationM)

schema :: [[Char]]

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
