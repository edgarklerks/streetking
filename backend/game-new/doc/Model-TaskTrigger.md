-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Model.TaskTrigger

Documentation
=============

data TaskTrigger

Constructors

TaskTrigger

 

Fields

id :: [Id](Model-General.html#t:Id)  
 

task\_id :: Integer  
 

type :: Integer  
 

target\_id :: Integer  
 

Instances

||
|Eq [TaskTrigger](Model-TaskTrigger.html#t:TaskTrigger)| |
|Show [TaskTrigger](Model-TaskTrigger.html#t:TaskTrigger)| |
|ToJSON [TaskTrigger](Model-TaskTrigger.html#t:TaskTrigger)| |
|FromJSON [TaskTrigger](Model-TaskTrigger.html#t:TaskTrigger)| |
|Default [TaskTrigger](Model-TaskTrigger.html#t:TaskTrigger)| |
|[FromInRule](Data-InRules.html#t:FromInRule) [TaskTrigger](Model-TaskTrigger.html#t:TaskTrigger)| |
|[ToInRule](Data-InRules.html#t:ToInRule) [TaskTrigger](Model-TaskTrigger.html#t:TaskTrigger)| |
|[Mapable](Model-General.html#t:Mapable) [TaskTrigger](Model-TaskTrigger.html#t:TaskTrigger)| |
|[Database](Model-General.html#t:Database) [Connection](Data-SqlTransaction.html#t:Connection) [TaskTrigger](Model-TaskTrigger.html#t:TaskTrigger)| |

relation :: [RelationM](Data-Relation.html#t:RelationM)

schema :: [[Char]]

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
