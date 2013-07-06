-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Model.TournamentExtended

Documentation
=============

type MRaceReward = Maybe [RaceRewards](Data-RaceReward.html#t:RaceRewards)

type MInteger = Maybe Integer

data TournamentExtended

Constructors

TournamentExtended

 

Fields

id :: [Id](Model-General.html#t:Id)  
 

car\_id :: [Id](Model-General.html#t:Id)  
 

start\_time :: [MInteger](Model-TournamentExtended.html#t:MInteger)  
 

costs :: Integer  
 

minlevel :: Integer  
 

maxlevel :: Integer  
 

rewards :: [MRaceReward](Model-TournamentExtended.html#t:MRaceReward)  
 

track\_id :: Integer  
 

players :: Integer  
 

name :: String  
 

current\_players :: Integer  
 

done :: Bool  
 

running :: Bool  
 

tournament\_type\_id :: Integer  
 

tournament\_type :: String  
 

Instances

||
|Eq [TournamentExtended](Model-TournamentExtended.html#t:TournamentExtended)| |
|Show [TournamentExtended](Model-TournamentExtended.html#t:TournamentExtended)| |
|ToJSON [TournamentExtended](Model-TournamentExtended.html#t:TournamentExtended)| |
|FromJSON [TournamentExtended](Model-TournamentExtended.html#t:TournamentExtended)| |
|Default [TournamentExtended](Model-TournamentExtended.html#t:TournamentExtended)| |
|[FromInRule](Data-InRules.html#t:FromInRule) [TournamentExtended](Model-TournamentExtended.html#t:TournamentExtended)| |
|[ToInRule](Data-InRules.html#t:ToInRule) [TournamentExtended](Model-TournamentExtended.html#t:TournamentExtended)| |
|[Mapable](Model-General.html#t:Mapable) [TournamentExtended](Model-TournamentExtended.html#t:TournamentExtended)| |
|[Database](Model-General.html#t:Database) [Connection](Data-SqlTransaction.html#t:Connection) [TournamentExtended](Model-TournamentExtended.html#t:TournamentExtended)| |

relation :: [RelationM](Data-Relation.html#t:RelationM)

schema :: [[Char]]

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
