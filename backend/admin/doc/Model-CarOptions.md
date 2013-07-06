-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Model.CarOptions

Documentation
=============

type MString = Maybe String

data CarOptions

Constructors

CarOptions

 

Fields

id :: [Id](Model-General.html#t:Id)  
 

car\_instance\_id :: Integer  
 

key :: String  
 

value :: [MString](Model-CarOptions.html#t:MString)  
 

Instances

||
|Eq [CarOptions](Model-CarOptions.html#t:CarOptions)| |
|Show [CarOptions](Model-CarOptions.html#t:CarOptions)| |
|ToJSON [CarOptions](Model-CarOptions.html#t:CarOptions)| |
|FromJSON [CarOptions](Model-CarOptions.html#t:CarOptions)| |
|Default [CarOptions](Model-CarOptions.html#t:CarOptions)| |
|[FromInRule](Data-InRules.html#t:FromInRule) [CarOptions](Model-CarOptions.html#t:CarOptions)| |
|[ToInRule](Data-InRules.html#t:ToInRule) [CarOptions](Model-CarOptions.html#t:CarOptions)| |
|[Mapable](Model-General.html#t:Mapable) [CarOptions](Model-CarOptions.html#t:CarOptions)| |
|[Database](Model-General.html#t:Database) [Connection](Data-SqlTransaction.html#t:Connection) [CarOptions](Model-CarOptions.html#t:CarOptions)| |

relation :: [RelationM](Data-Relation.html#t:RelationM)

schema :: [[Char]]

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
