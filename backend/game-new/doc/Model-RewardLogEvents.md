-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Model.RewardLogEvents

Documentation
=============

type MInteger = Maybe Integer

data RewardLogEvents

Constructors

RewardLogEvents

 

Fields

id :: [Id](Model-General.html#t:Id)  
 

type :: String  
 

type\_id :: Integer  
 

reward\_log\_id :: Integer  
 

Instances

||
|Eq [RewardLogEvents](Model-RewardLogEvents.html#t:RewardLogEvents)| |
|Show [RewardLogEvents](Model-RewardLogEvents.html#t:RewardLogEvents)| |
|ToJSON [RewardLogEvents](Model-RewardLogEvents.html#t:RewardLogEvents)| |
|FromJSON [RewardLogEvents](Model-RewardLogEvents.html#t:RewardLogEvents)| |
|Default [RewardLogEvents](Model-RewardLogEvents.html#t:RewardLogEvents)| |
|[FromInRule](Data-InRules.html#t:FromInRule) [RewardLogEvents](Model-RewardLogEvents.html#t:RewardLogEvents)| |
|[ToInRule](Data-InRules.html#t:ToInRule) [RewardLogEvents](Model-RewardLogEvents.html#t:RewardLogEvents)| |
|[Mapable](Model-General.html#t:Mapable) [RewardLogEvents](Model-RewardLogEvents.html#t:RewardLogEvents)| |
|[Database](Model-General.html#t:Database) [Connection](Data-SqlTransaction.html#t:Connection) [RewardLogEvents](Model-RewardLogEvents.html#t:RewardLogEvents)| |

relation :: [RelationM](Data-Relation.html#t:RelationM)

schema :: [[Char]]

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
