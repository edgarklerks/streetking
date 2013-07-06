-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Model.RewardLogEvent

Documentation
=============

type MInteger = Maybe Integer

data RewardLogEvent

Constructors

RewardLogEvent

 

Fields

id :: [Id](Model-General.html#t:Id)  
 

account\_id :: [Id](Model-General.html#t:Id)  
 

rule :: String  
 

name :: String  
 

money :: Integer  
 

viewed :: Bool  
 

experience :: Integer  
 

type\_id :: Integer  
 

type :: String  
 

Instances

||
|Eq [RewardLogEvent](Model-RewardLogEvent.html#t:RewardLogEvent)| |
|Show [RewardLogEvent](Model-RewardLogEvent.html#t:RewardLogEvent)| |
|ToJSON [RewardLogEvent](Model-RewardLogEvent.html#t:RewardLogEvent)| |
|FromJSON [RewardLogEvent](Model-RewardLogEvent.html#t:RewardLogEvent)| |
|Default [RewardLogEvent](Model-RewardLogEvent.html#t:RewardLogEvent)| |
|[FromInRule](Data-InRules.html#t:FromInRule) [RewardLogEvent](Model-RewardLogEvent.html#t:RewardLogEvent)| |
|[ToInRule](Data-InRules.html#t:ToInRule) [RewardLogEvent](Model-RewardLogEvent.html#t:RewardLogEvent)| |
|[Mapable](Model-General.html#t:Mapable) [RewardLogEvent](Model-RewardLogEvent.html#t:RewardLogEvent)| |
|[Database](Model-General.html#t:Database) [Connection](Data-SqlTransaction.html#t:Connection) [RewardLogEvent](Model-RewardLogEvent.html#t:RewardLogEvent)| |

relation :: [RelationM](Data-Relation.html#t:RelationM)

schema :: [[Char]]

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
