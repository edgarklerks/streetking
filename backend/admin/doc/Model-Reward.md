-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Model.Reward

Documentation
=============

data Reward

Constructors

Reward

 

Fields

id :: [Id](Model-General.html#t:Id)  
 

money :: Integer  
 

experience :: Integer  
 

name :: String  
 

Instances

||
|Eq [Reward](Model-Reward.html#t:Reward)| |
|Show [Reward](Model-Reward.html#t:Reward)| |
|ToJSON [Reward](Model-Reward.html#t:Reward)| |
|FromJSON [Reward](Model-Reward.html#t:Reward)| |
|Default [Reward](Model-Reward.html#t:Reward)| |
|[FromInRule](Data-InRules.html#t:FromInRule) [Reward](Model-Reward.html#t:Reward)| |
|[ToInRule](Data-InRules.html#t:ToInRule) [Reward](Model-Reward.html#t:Reward)| |
|[Mapable](Model-General.html#t:Mapable) [Reward](Model-Reward.html#t:Reward)| |
|[Database](Model-General.html#t:Database) [Connection](Data-SqlTransaction.html#t:Connection) [Reward](Model-Reward.html#t:Reward)| |

relation :: [RelationM](Data-Relation.html#t:RelationM)

schema :: [[Char]]

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
