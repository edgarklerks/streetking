-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Model.Rule

Documentation
=============

data Rule

Constructors

Rule

 

Fields

id :: [Id](Model-General.html#t:Id)  
 

rule :: String  
 

name :: String  
 

once :: Bool  
 

Instances

||
|Eq [Rule](Model-Rule.html#t:Rule)| |
|Show [Rule](Model-Rule.html#t:Rule)| |
|ToJSON [Rule](Model-Rule.html#t:Rule)| |
|FromJSON [Rule](Model-Rule.html#t:Rule)| |
|Default [Rule](Model-Rule.html#t:Rule)| |
|[FromInRule](Data-InRules.html#t:FromInRule) [Rule](Model-Rule.html#t:Rule)| |
|[ToInRule](Data-InRules.html#t:ToInRule) [Rule](Model-Rule.html#t:Rule)| |
|[Mapable](Model-General.html#t:Mapable) [Rule](Model-Rule.html#t:Rule)| |
|[Database](Model-General.html#t:Database) [Connection](Data-SqlTransaction.html#t:Connection) [Rule](Model-Rule.html#t:Rule)| |

relation :: [RelationM](Data-Relation.html#t:RelationM)

schema :: [[Char]]

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
