-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Model.Challenge

Documentation
=============

type MInteger = Maybe Integer

data Challenge

Constructors

Challenge

 

Fields

id :: [Id](Model-General.html#t:Id)  
 

account\_id :: Integer  
 

track\_id :: Integer  
 

participants :: Integer  
 

type :: Integer  
 

account\_min :: [AccountProfileMin](Model-AccountProfileMin.html#t:AccountProfileMin)  
 

car\_min :: [CarMinimal](Model-CarMinimal.html#t:CarMinimal)  
 

challenger :: [RaceParticipant](Data-RaceParticipant.html#t:RaceParticipant)  
 

deleted :: Bool  
 

amount :: Integer  
 

Instances

||
|Eq [Challenge](Model-Challenge.html#t:Challenge)| |
|Show [Challenge](Model-Challenge.html#t:Challenge)| |
|ToJSON [Challenge](Model-Challenge.html#t:Challenge)| |
|FromJSON [Challenge](Model-Challenge.html#t:Challenge)| |
|Default [Challenge](Model-Challenge.html#t:Challenge)| |
|[FromInRule](Data-InRules.html#t:FromInRule) [Challenge](Model-Challenge.html#t:Challenge)| |
|[ToInRule](Data-InRules.html#t:ToInRule) [Challenge](Model-Challenge.html#t:Challenge)| |
|[Mapable](Model-General.html#t:Mapable) [Challenge](Model-Challenge.html#t:Challenge)| |
|[Database](Model-General.html#t:Database) [Connection](Data-SqlTransaction.html#t:Connection) [Challenge](Model-Challenge.html#t:Challenge)| |

relation :: [RelationM](Data-Relation.html#t:RelationM)

schema :: [[Char]]

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
