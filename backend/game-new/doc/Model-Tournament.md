-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Model.Tournament

Documentation
=============

type MRaceReward = Maybe [RaceRewards](Data-RaceReward.html#t:RaceRewards)

type MInteger = Maybe Integer

data Tournament

Constructors

Tournament

 

Fields

id :: [Id](Model-General.html#t:Id)  
 

car\_id :: [Id](Model-General.html#t:Id)  
 

start\_time :: [MInteger](Model-Tournament.html#t:MInteger)  
 

costs :: Integer  
 

minlevel :: Integer  
 

maxlevel :: Integer  
 

rewards :: [MRaceReward](Model-Tournament.html#t:MRaceReward)  
 

track\_id :: Integer  
 

players :: Integer  
 

name :: String  
 

done :: Bool  
 

running :: Bool  
 

image :: String  
 

tournament\_type\_id :: Integer  
 

Instances

||
|Eq [Tournament](Model-Tournament.html#t:Tournament)| |
|Show [Tournament](Model-Tournament.html#t:Tournament)| |
|ToJSON [Tournament](Model-Tournament.html#t:Tournament)| |
|FromJSON [Tournament](Model-Tournament.html#t:Tournament)| |
|Default [Tournament](Model-Tournament.html#t:Tournament)| |
|[FromInRule](Data-InRules.html#t:FromInRule) [Tournament](Model-Tournament.html#t:Tournament)| |
|[ToInRule](Data-InRules.html#t:ToInRule) [Tournament](Model-Tournament.html#t:Tournament)| |
|[Mapable](Model-General.html#t:Mapable) [Tournament](Model-Tournament.html#t:Tournament)| |
|[Database](Model-General.html#t:Database) [Connection](Data-SqlTransaction.html#t:Connection) [Tournament](Model-Tournament.html#t:Tournament)| |

relation :: [RelationM](Data-Relation.html#t:RelationM)

schema :: [[Char]]

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
