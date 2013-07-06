-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Model.GarageParts

Documentation
=============

type MString = Maybe String

type MInteger = Maybe Integer

type MBool = Maybe Bool

data GaragePart

Constructors

GaragePart

 

Fields

id :: [Id](Model-General.html#t:Id)  
 

account\_id :: Integer  
 

part\_type\_id :: Integer  
 

weight :: Integer  
 

parameter1 :: [MInteger](Model-GarageParts.html#t:MInteger)  
 

parameter1\_unit :: [MString](Model-GarageParts.html#t:MString)  
 

parameter1\_name :: [MString](Model-GarageParts.html#t:MString)  
 

parameter1\_is\_modifier :: [MBool](Model-GarageParts.html#t:MBool)  
 

parameter2 :: [MInteger](Model-GarageParts.html#t:MInteger)  
 

parameter2\_unit :: [MString](Model-GarageParts.html#t:MString)  
 

parameter2\_name :: [MString](Model-GarageParts.html#t:MString)  
 

parameter2\_is\_modifier :: [MBool](Model-GarageParts.html#t:MBool)  
 

parameter3 :: [MInteger](Model-GarageParts.html#t:MInteger)  
 

parameter3\_unit :: [MString](Model-GarageParts.html#t:MString)  
 

parameter3\_name :: [MString](Model-GarageParts.html#t:MString)  
 

parameter3\_is\_modifier :: [MBool](Model-GarageParts.html#t:MBool)  
 

car\_id :: [Id](Model-General.html#t:Id)  
 

d3d\_model\_id :: Integer  
 

level :: Integer  
 

name :: String  
 

price :: Integer  
 

car\_model :: [MString](Model-GarageParts.html#t:MString)  
 

manufacturer\_name :: [MString](Model-GarageParts.html#t:MString)  
 

part\_modifier :: [MString](Model-GarageParts.html#t:MString)  
 

wear :: Integer  
 

improvement :: Integer  
 

unique :: Bool  
 

part\_instance\_id :: Integer  
 

trash\_price :: Integer  
 

required :: Bool  
 

fixed :: Bool  
 

task\_subject :: Bool  
 

hidden :: Bool  
 

Instances

||
|Eq [GaragePart](Model-GarageParts.html#t:GaragePart)| |
|Show [GaragePart](Model-GarageParts.html#t:GaragePart)| |
|ToJSON [GaragePart](Model-GarageParts.html#t:GaragePart)| |
|FromJSON [GaragePart](Model-GarageParts.html#t:GaragePart)| |
|Default [GaragePart](Model-GarageParts.html#t:GaragePart)| |
|[FromInRule](Data-InRules.html#t:FromInRule) [GaragePart](Model-GarageParts.html#t:GaragePart)| |
|[ToInRule](Data-InRules.html#t:ToInRule) [GaragePart](Model-GarageParts.html#t:GaragePart)| |
|[Mapable](Model-General.html#t:Mapable) [GaragePart](Model-GarageParts.html#t:GaragePart)| |
|[Database](Model-General.html#t:Database) [Connection](Data-SqlTransaction.html#t:Connection) [GaragePart](Model-GarageParts.html#t:GaragePart)| |

relation :: [RelationM](Data-Relation.html#t:RelationM)

schema :: [[Char]]

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
