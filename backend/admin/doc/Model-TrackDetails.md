-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Model.TrackDetails

Documentation
=============

data TrackDetails

Constructors

TrackDetails

 

Fields

id :: [Id](Model-General.html#t:Id)  
 

track\_id :: Integer  
 

radius :: Double  
 

length :: Double  
 

segment :: String  
 

Instances

||
|Eq [TrackDetails](Model-TrackDetails.html#t:TrackDetails)| |
|Show [TrackDetails](Model-TrackDetails.html#t:TrackDetails)| |
|ToJSON [TrackDetails](Model-TrackDetails.html#t:TrackDetails)| |
|FromJSON [TrackDetails](Model-TrackDetails.html#t:TrackDetails)| |
|Default [TrackDetails](Model-TrackDetails.html#t:TrackDetails)| |
|[FromInRule](Data-InRules.html#t:FromInRule) [TrackDetails](Model-TrackDetails.html#t:TrackDetails)| |
|[ToInRule](Data-InRules.html#t:ToInRule) [TrackDetails](Model-TrackDetails.html#t:TrackDetails)| |
|[Mapable](Model-General.html#t:Mapable) [TrackDetails](Model-TrackDetails.html#t:TrackDetails)| |
|[Database](Model-General.html#t:Database) [Connection](Data-SqlTransaction.html#t:Connection) [TrackDetails](Model-TrackDetails.html#t:TrackDetails)| |

relation :: [RelationM](Data-Relation.html#t:RelationM)

schema :: [[Char]]

type TrackDetailss = [[TrackDetails](Model-TrackDetails.html#t:TrackDetails)]

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
