-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Model.GeneralReport

Documentation
=============

type MInteger = Maybe Integer

data GeneralReport

Constructors

GeneralReport

 

Fields

id :: [Id](Model-General.html#t:Id)  
 

account\_id :: Integer  
 

time :: Integer  
 

report\_type\_id :: Integer  
 

report\_type :: String  
 

report\_descriptor :: String  
 

Instances

||
|Eq [GeneralReport](Model-GeneralReport.html#t:GeneralReport)| |
|Show [GeneralReport](Model-GeneralReport.html#t:GeneralReport)| |
|ToJSON [GeneralReport](Model-GeneralReport.html#t:GeneralReport)| |
|FromJSON [GeneralReport](Model-GeneralReport.html#t:GeneralReport)| |
|Default [GeneralReport](Model-GeneralReport.html#t:GeneralReport)| |
|[FromInRule](Data-InRules.html#t:FromInRule) [GeneralReport](Model-GeneralReport.html#t:GeneralReport)| |
|[ToInRule](Data-InRules.html#t:ToInRule) [GeneralReport](Model-GeneralReport.html#t:GeneralReport)| |
|[Mapable](Model-General.html#t:Mapable) [GeneralReport](Model-GeneralReport.html#t:GeneralReport)| |
|[Database](Model-General.html#t:Database) [Connection](Data-SqlTransaction.html#t:Connection) [GeneralReport](Model-GeneralReport.html#t:GeneralReport)| |

relation :: [RelationM](Data-Relation.html#t:RelationM)

schema :: [[Char]]

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
