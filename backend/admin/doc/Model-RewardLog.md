-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Model.RewardLog

Documentation
=============

data RewardLog

Constructors

RewardLog

 

Fields

id :: [Id](Model-General.html#t:Id)  
 

account\_id :: [Id](Model-General.html#t:Id)  
 

rule :: String  
 

name :: String  
 

money :: Integer  
 

viewed :: Bool  
 

experience :: Integer  
 

Instances

||
|Eq [RewardLog](Model-RewardLog.html#t:RewardLog)| |
|Show [RewardLog](Model-RewardLog.html#t:RewardLog)| |
|ToJSON [RewardLog](Model-RewardLog.html#t:RewardLog)| |
|FromJSON [RewardLog](Model-RewardLog.html#t:RewardLog)| |
|Default [RewardLog](Model-RewardLog.html#t:RewardLog)| |
|[FromInRule](Data-InRules.html#t:FromInRule) [RewardLog](Model-RewardLog.html#t:RewardLog)| |
|[ToInRule](Data-InRules.html#t:ToInRule) [RewardLog](Model-RewardLog.html#t:RewardLog)| |
|[Mapable](Model-General.html#t:Mapable) [RewardLog](Model-RewardLog.html#t:RewardLog)| |
|[Database](Model-General.html#t:Database) [Connection](Data-SqlTransaction.html#t:Connection) [RewardLog](Model-RewardLog.html#t:RewardLog)| |

relation :: [RelationM](Data-Relation.html#t:RelationM)

schema :: [[Char]]

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
