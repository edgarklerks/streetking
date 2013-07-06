-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Model.CarInstanceParts

Documentation
=============

type MString = Maybe String

type MInteger = Maybe Integer

type MBool = Maybe Bool

data CarInstanceParts

Constructors

CarInstanceParts

 

Fields

part\_instance\_id :: Integer  
 

car\_instance\_id :: Integer  
 

part\_id :: Integer  
 

name :: String  
 

part\_type\_id :: Integer  
 

weight :: Integer  
 

improvement :: Integer  
 

wear :: Integer  
 

parameter1 :: [MInteger](Model-CarInstanceParts.html#t:MInteger)  
 

parameter1\_unit :: [MString](Model-CarInstanceParts.html#t:MString)  
 

parameter1\_name :: [MString](Model-CarInstanceParts.html#t:MString)  
 

parameter1\_is\_modifier :: [MBool](Model-CarInstanceParts.html#t:MBool)  
 

parameter2 :: [MInteger](Model-CarInstanceParts.html#t:MInteger)  
 

parameter2\_unit :: [MString](Model-CarInstanceParts.html#t:MString)  
 

parameter2\_name :: [MString](Model-CarInstanceParts.html#t:MString)  
 

parameter2\_is\_modifier :: [MBool](Model-CarInstanceParts.html#t:MBool)  
 

parameter3 :: [MInteger](Model-CarInstanceParts.html#t:MInteger)  
 

parameter3\_unit :: [MString](Model-CarInstanceParts.html#t:MString)  
 

parameter3\_name :: [MString](Model-CarInstanceParts.html#t:MString)  
 

parameter3\_is\_modifier :: [MBool](Model-CarInstanceParts.html#t:MBool)  
 

car\_id :: [Id](Model-General.html#t:Id)  
 

d3d\_model\_id :: Integer  
 

level :: Integer  
 

price :: Integer  
 

car\_model :: [MString](Model-CarInstanceParts.html#t:MString)  
 

manufacturer\_name :: [MString](Model-CarInstanceParts.html#t:MString)  
 

part\_modifier :: [MString](Model-CarInstanceParts.html#t:MString)  
 

unique :: Bool  
 

sort\_part\_type :: Integer  
 

new\_price :: Integer  
 

account\_id :: [MInteger](Model-CarInstanceParts.html#t:MInteger)  
 

required :: Bool  
 

fixed :: Bool  
 

hidden :: Bool  
 

Instances

||
|Eq [CarInstanceParts](Model-CarInstanceParts.html#t:CarInstanceParts)| |
|Show [CarInstanceParts](Model-CarInstanceParts.html#t:CarInstanceParts)| |
|ToJSON [CarInstanceParts](Model-CarInstanceParts.html#t:CarInstanceParts)| |
|FromJSON [CarInstanceParts](Model-CarInstanceParts.html#t:CarInstanceParts)| |
|Default [CarInstanceParts](Model-CarInstanceParts.html#t:CarInstanceParts)| |
|[FromInRule](Data-InRules.html#t:FromInRule) [CarInstanceParts](Model-CarInstanceParts.html#t:CarInstanceParts)| |
|[ToInRule](Data-InRules.html#t:ToInRule) [CarInstanceParts](Model-CarInstanceParts.html#t:CarInstanceParts)| |
|[Mapable](Model-General.html#t:Mapable) [CarInstanceParts](Model-CarInstanceParts.html#t:CarInstanceParts)| |
|[Database](Model-General.html#t:Database) [Connection](Data-SqlTransaction.html#t:Connection) [CarInstanceParts](Model-CarInstanceParts.html#t:CarInstanceParts)| |

relation :: [RelationM](Data-Relation.html#t:RelationM)

schema :: [[Char]]

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
