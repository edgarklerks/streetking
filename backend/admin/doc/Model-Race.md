-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Model.Race

Documentation
=============

data Race

Constructors

Race

 

Fields

id :: [Id](Model-General.html#t:Id)  
 

track\_id :: Integer  
 

start\_time :: Integer  
 

end\_time :: Integer  
 

type :: Integer  
 

data :: [RaceDataList](Data-RacingNew.html#t:RaceDataList)  
 

Instances

||
|Eq [Race](Model-Race.html#t:Race)| |
|Show [Race](Model-Race.html#t:Race)| |
|ToJSON [Race](Model-Race.html#t:Race)| |
|FromJSON [Race](Model-Race.html#t:Race)| |
|Default [Race](Model-Race.html#t:Race)| |
|[FromInRule](Data-InRules.html#t:FromInRule) [Race](Model-Race.html#t:Race)| |
|[ToInRule](Data-InRules.html#t:ToInRule) [Race](Model-Race.html#t:Race)| |
|[Mapable](Model-General.html#t:Mapable) [Race](Model-Race.html#t:Race)| |
|[Database](Model-General.html#t:Database) [Connection](Data-SqlTransaction.html#t:Connection) [Race](Model-Race.html#t:Race)| |

relation :: [RelationM](Data-Relation.html#t:RelationM)

schema :: [[Char]]

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
