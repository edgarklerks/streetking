-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Model.TournamentPlayers

Documentation
=============

data TournamentPlayer

Constructors

TournamentPlayer

 

Fields

id :: [Id](Model-General.html#t:Id)  
 

account\_id :: [Id](Model-General.html#t:Id)  
 

tournament\_id :: [Id](Model-General.html#t:Id)  
 

car\_instance\_id :: [Id](Model-General.html#t:Id)  
 

deleted :: Bool  
 

Instances

||
|Eq [TournamentPlayer](Model-TournamentPlayers.html#t:TournamentPlayer)| |
|Show [TournamentPlayer](Model-TournamentPlayers.html#t:TournamentPlayer)| |
|ToJSON [TournamentPlayer](Model-TournamentPlayers.html#t:TournamentPlayer)| |
|FromJSON [TournamentPlayer](Model-TournamentPlayers.html#t:TournamentPlayer)| |
|Default [TournamentPlayer](Model-TournamentPlayers.html#t:TournamentPlayer)| |
|[FromInRule](Data-InRules.html#t:FromInRule) [TournamentPlayer](Model-TournamentPlayers.html#t:TournamentPlayer)| |
|[ToInRule](Data-InRules.html#t:ToInRule) [TournamentPlayer](Model-TournamentPlayers.html#t:TournamentPlayer)| |
|[Mapable](Model-General.html#t:Mapable) [TournamentPlayer](Model-TournamentPlayers.html#t:TournamentPlayer)| |
|[Database](Model-General.html#t:Database) [Connection](Data-SqlTransaction.html#t:Connection) [TournamentPlayer](Model-TournamentPlayers.html#t:TournamentPlayer)| |

relation :: [RelationM](Data-Relation.html#t:RelationM)

schema :: [[Char]]

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
