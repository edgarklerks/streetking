-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Model.MarketPlace

Documentation
=============

type MString = Maybe String

type MInteger = Maybe Integer

data MarketPlace

Constructors

MarketPlace

 

Fields

id :: [Id](Model-General.html#t:Id)  
 

part\_type\_id :: Integer  
 

weight :: Integer  
 

parameter1 :: [MInteger](Model-MarketPlace.html#t:MInteger)  
 

parameter1\_unit :: [MString](Model-MarketPlace.html#t:MString)  
 

parameter1\_name :: [MString](Model-MarketPlace.html#t:MString)  
 

parameter2 :: [MInteger](Model-MarketPlace.html#t:MInteger)  
 

parameter2\_unit :: [MString](Model-MarketPlace.html#t:MString)  
 

parameter2\_name :: [MString](Model-MarketPlace.html#t:MString)  
 

parameter3 :: [MInteger](Model-MarketPlace.html#t:MInteger)  
 

parameter3\_unit :: [MString](Model-MarketPlace.html#t:MString)  
 

parameter3\_name :: [MString](Model-MarketPlace.html#t:MString)  
 

car\_id :: [Id](Model-General.html#t:Id)  
 

d3d\_model\_id :: Integer  
 

level :: Integer  
 

name :: String  
 

price :: Integer  
 

car\_model :: [MString](Model-MarketPlace.html#t:MString)  
 

manufacturer\_name :: [MString](Model-MarketPlace.html#t:MString)  
 

part\_modifier :: [MString](Model-MarketPlace.html#t:MString)  
 

unique :: Bool  
 

improvement :: Integer  
 

wear :: Integer  
 

account\_id :: Integer  
 

part\_id :: Integer  
 

Instances

||
|Eq [MarketPlace](Model-MarketPlace.html#t:MarketPlace)| |
|Show [MarketPlace](Model-MarketPlace.html#t:MarketPlace)| |
|ToJSON [MarketPlace](Model-MarketPlace.html#t:MarketPlace)| |
|FromJSON [MarketPlace](Model-MarketPlace.html#t:MarketPlace)| |
|Default [MarketPlace](Model-MarketPlace.html#t:MarketPlace)| |
|[FromInRule](Data-InRules.html#t:FromInRule) [MarketPlace](Model-MarketPlace.html#t:MarketPlace)| |
|[ToInRule](Data-InRules.html#t:ToInRule) [MarketPlace](Model-MarketPlace.html#t:MarketPlace)| |
|[Mapable](Model-General.html#t:Mapable) [MarketPlace](Model-MarketPlace.html#t:MarketPlace)| |
|[Database](Model-General.html#t:Database) [Connection](Data-SqlTransaction.html#t:Connection) [MarketPlace](Model-MarketPlace.html#t:MarketPlace)| |

relation :: [RelationM](Data-Relation.html#t:RelationM)

schema :: [[Char]]

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
