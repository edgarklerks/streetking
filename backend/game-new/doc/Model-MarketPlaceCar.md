-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Model.MarketPlaceCar

Documentation
=============

type MInteger = Maybe Integer

data MarketPlaceCar

Constructors

MarketPlaceCar

 

Fields

car\_instance\_id :: [Id](Model-General.html#t:Id)  
 

price :: Integer  
 

top\_speed :: Integer  
 

acceleration :: Integer  
 

cornering :: Integer  
 

stopping :: Integer  
 

nitrous :: Integer  
 

weight :: Integer  
 

manufacturer\_name :: String  
 

level :: Integer  
 

year :: Integer  
 

wear :: Integer  
 

improvement :: Integer  
 

account\_id :: Integer  
 

model :: String  
 

Instances

||
|Eq [MarketPlaceCar](Model-MarketPlaceCar.html#t:MarketPlaceCar)| |
|Show [MarketPlaceCar](Model-MarketPlaceCar.html#t:MarketPlaceCar)| |
|ToJSON [MarketPlaceCar](Model-MarketPlaceCar.html#t:MarketPlaceCar)| |
|FromJSON [MarketPlaceCar](Model-MarketPlaceCar.html#t:MarketPlaceCar)| |
|Default [MarketPlaceCar](Model-MarketPlaceCar.html#t:MarketPlaceCar)| |
|[FromInRule](Data-InRules.html#t:FromInRule) [MarketPlaceCar](Model-MarketPlaceCar.html#t:MarketPlaceCar)| |
|[ToInRule](Data-InRules.html#t:ToInRule) [MarketPlaceCar](Model-MarketPlaceCar.html#t:MarketPlaceCar)| |
|[Mapable](Model-General.html#t:Mapable) [MarketPlaceCar](Model-MarketPlaceCar.html#t:MarketPlaceCar)| |
|[Database](Model-General.html#t:Database) [Connection](Data-SqlTransaction.html#t:Connection) [MarketPlaceCar](Model-MarketPlaceCar.html#t:MarketPlaceCar)| |

relation :: [RelationM](Data-Relation.html#t:RelationM)

schema :: [[Char]]

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
