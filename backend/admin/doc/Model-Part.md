-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Model.Part

Documentation
=============

type MInteger = Maybe Integer

data Part

Constructors

Part

 

Fields

id :: [Id](Model-General.html#t:Id)  
 

part\_type\_id :: Integer  
 

weight :: Integer  
 

parameter1 :: [MInteger](Model-Part.html#t:MInteger)  
 

parameter2 :: [MInteger](Model-Part.html#t:MInteger)  
 

parameter3 :: [MInteger](Model-Part.html#t:MInteger)  
 

parameter1\_type\_id :: [MInteger](Model-Part.html#t:MInteger)  
 

parameter2\_type\_id :: [MInteger](Model-Part.html#t:MInteger)  
 

parameter3\_type\_id :: [MInteger](Model-Part.html#t:MInteger)  
 

car\_id :: [Id](Model-General.html#t:Id)  
 

d3d\_model\_id :: Integer  
 

level :: Integer  
 

price :: Integer  
 

part\_modifier\_id :: [MInteger](Model-Part.html#t:MInteger)  
 

unique :: Bool  
 

Instances

||
|Eq [Part](Model-Part.html#t:Part)| |
|Show [Part](Model-Part.html#t:Part)| |
|ToJSON [Part](Model-Part.html#t:Part)| |
|FromJSON [Part](Model-Part.html#t:Part)| |
|Default [Part](Model-Part.html#t:Part)| |
|[FromInRule](Data-InRules.html#t:FromInRule) [Part](Model-Part.html#t:Part)| |
|[ToInRule](Data-InRules.html#t:ToInRule) [Part](Model-Part.html#t:Part)| |
|[Mapable](Model-General.html#t:Mapable) [Part](Model-Part.html#t:Part)| |
|[Database](Model-General.html#t:Database) [Connection](Data-SqlTransaction.html#t:Connection) [Part](Model-Part.html#t:Part)| |

relation :: [RelationM](Data-Relation.html#t:RelationM)

schema :: [[Char]]

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
