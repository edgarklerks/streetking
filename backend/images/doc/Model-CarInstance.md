-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Model.CarInstance

Documentation
=============

type MInteger = Maybe Integer

data CarInstance

Constructors

CarInstance

 

Fields

id :: [Id](Model-General.html#t:Id)  
 

car\_id :: Integer  
 

garage\_id :: [MInteger](Model-CarInstance.html#t:MInteger)  
 

deleted :: Bool  
 

immutable :: Bool  
 

Instances

||
|Eq [CarInstance](Model-CarInstance.html#t:CarInstance)| |
|Show [CarInstance](Model-CarInstance.html#t:CarInstance)| |
|Default [CarInstance](Model-CarInstance.html#t:CarInstance)| |
|ToJSON [CarInstance](Model-CarInstance.html#t:CarInstance)| |
|FromJSON [CarInstance](Model-CarInstance.html#t:CarInstance)| |
|[FromInRule](Data-InRules.html#t:FromInRule) [CarInstance](Model-CarInstance.html#t:CarInstance)| |
|[ToInRule](Data-InRules.html#t:ToInRule) [CarInstance](Model-CarInstance.html#t:CarInstance)| |
|[Mapable](Model-General.html#t:Mapable) [CarInstance](Model-CarInstance.html#t:CarInstance)| |
|[Database](Model-General.html#t:Database) [Connection](Data-SqlTransaction.html#t:Connection) [CarInstance](Model-CarInstance.html#t:CarInstance)| |

relation :: [RelationM](Data-Relation.html#t:RelationM)

schema :: [[Char]]

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
