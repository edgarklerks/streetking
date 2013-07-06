-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Model.PartMarket

Documentation
=============

type MString = Maybe String

type MInteger = Maybe Integer

data PartMarket

Constructors

PartMarket

 

Fields

id :: [Id](Model-General.html#t:Id)  
 

part\_type\_id :: Integer  
 

weight :: Integer  
 

parameter1 :: [MInteger](Model-PartMarket.html#t:MInteger)  
 

parameter1\_unit :: [MString](Model-PartMarket.html#t:MString)  
 

parameter1\_name :: [MString](Model-PartMarket.html#t:MString)  
 

parameter2 :: [MInteger](Model-PartMarket.html#t:MInteger)  
 

parameter2\_unit :: [MString](Model-PartMarket.html#t:MString)  
 

parameter2\_name :: [MString](Model-PartMarket.html#t:MString)  
 

parameter3 :: [MInteger](Model-PartMarket.html#t:MInteger)  
 

parameter3\_unit :: [MString](Model-PartMarket.html#t:MString)  
 

parameter3\_name :: [MString](Model-PartMarket.html#t:MString)  
 

car\_id :: [Id](Model-General.html#t:Id)  
 

d3d\_model\_id :: Integer  
 

level :: Integer  
 

name :: String  
 

price :: Integer  
 

car\_model :: [MString](Model-PartMarket.html#t:MString)  
 

manufacturer\_name :: [MString](Model-PartMarket.html#t:MString)  
 

part\_modifier :: [MString](Model-PartMarket.html#t:MString)  
 

unique :: Bool  
 

required :: Bool  
 

fixed :: Bool  
 

hidden :: Bool  
 

Instances

||
|Eq [PartMarket](Model-PartMarket.html#t:PartMarket)| |
|Show [PartMarket](Model-PartMarket.html#t:PartMarket)| |
|ToJSON [PartMarket](Model-PartMarket.html#t:PartMarket)| |
|FromJSON [PartMarket](Model-PartMarket.html#t:PartMarket)| |
|Default [PartMarket](Model-PartMarket.html#t:PartMarket)| |
|[FromInRule](Data-InRules.html#t:FromInRule) [PartMarket](Model-PartMarket.html#t:PartMarket)| |
|[ToInRule](Data-InRules.html#t:ToInRule) [PartMarket](Model-PartMarket.html#t:PartMarket)| |
|[Mapable](Model-General.html#t:Mapable) [PartMarket](Model-PartMarket.html#t:PartMarket)| |
|[Database](Model-General.html#t:Database) [Connection](Data-SqlTransaction.html#t:Connection) [PartMarket](Model-PartMarket.html#t:PartMarket)| |

relation :: [RelationM](Data-Relation.html#t:RelationM)

schema :: [[Char]]

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
