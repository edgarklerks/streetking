-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Model.TournamentType

Documentation
=============

type MRaceReward = Maybe [RaceRewards](Data-RaceReward.html#t:RaceRewards)

type MInteger = Maybe Integer

data TournamentType

Constructors

TournamentType

 

Fields

id :: [Id](Model-General.html#t:Id)  
 

name :: String  
 

Instances

||
|Eq [TournamentType](Model-TournamentType.html#t:TournamentType)| |
|Show [TournamentType](Model-TournamentType.html#t:TournamentType)| |
|ToJSON [TournamentType](Model-TournamentType.html#t:TournamentType)| |
|FromJSON [TournamentType](Model-TournamentType.html#t:TournamentType)| |
|Default [TournamentType](Model-TournamentType.html#t:TournamentType)| |
|[FromInRule](Data-InRules.html#t:FromInRule) [TournamentType](Model-TournamentType.html#t:TournamentType)| |
|[ToInRule](Data-InRules.html#t:ToInRule) [TournamentType](Model-TournamentType.html#t:TournamentType)| |
|[Mapable](Model-General.html#t:Mapable) [TournamentType](Model-TournamentType.html#t:TournamentType)| |
|[Database](Model-General.html#t:Database) [Connection](Data-SqlTransaction.html#t:Connection) [TournamentType](Model-TournamentType.html#t:TournamentType)| |

relation :: [RelationM](Data-Relation.html#t:RelationM)

schema :: [[Char]]

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
