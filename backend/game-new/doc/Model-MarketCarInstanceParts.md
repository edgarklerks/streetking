% Model.MarketCarInstanceParts
% 
% 

-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Model.MarketCarInstanceParts

Documentation
=============

type MString = Maybe String

type MInteger = Maybe Integer

data MarketCarInstanceParts

Constructors

MarketCarInstanceParts

 

Fields

part\_instance\_id :: Integer
:    
car\_instance\_id :: Integer
:    
part\_id :: Integer
:    
name :: String
:    
part\_type\_id :: Integer
:    
weight :: Integer
:    
improvement :: Integer
:    
wear :: Integer
:    
parameter1 :: [MInteger](Model-MarketCarInstanceParts.html#t:MInteger)
:    
parameter1\_unit :: [MString](Model-MarketCarInstanceParts.html#t:MString)
:    
parameter1\_name :: [MString](Model-MarketCarInstanceParts.html#t:MString)
:    
parameter2 :: [MInteger](Model-MarketCarInstanceParts.html#t:MInteger)
:    
parameter2\_unit :: [MString](Model-MarketCarInstanceParts.html#t:MString)
:    
parameter2\_name :: [MString](Model-MarketCarInstanceParts.html#t:MString)
:    
parameter3 :: [MInteger](Model-MarketCarInstanceParts.html#t:MInteger)
:    
parameter3\_unit :: [MString](Model-MarketCarInstanceParts.html#t:MString)
:    
parameter3\_name :: [MString](Model-MarketCarInstanceParts.html#t:MString)
:    
car\_id :: [Id](Model-General.html#t:Id)
:    
d3d\_model\_id :: Integer
:    
level :: Integer
:    
price :: Integer
:    
car\_model :: [MString](Model-MarketCarInstanceParts.html#t:MString)
:    
manufacturer\_name :: [MString](Model-MarketCarInstanceParts.html#t:MString)
:    
part\_modifier :: [MString](Model-MarketCarInstanceParts.html#t:MString)
:    
unique :: Bool
:    
sort\_part\_type :: Integer
:    
new\_price :: Integer
:    
account\_id :: [MInteger](Model-MarketCarInstanceParts.html#t:MInteger)
:    
required :: Bool
:    
fixed :: Bool
:    
hidden :: Bool
:    

Instances

  ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ ---
  Eq [MarketCarInstanceParts](Model-MarketCarInstanceParts.html#t:MarketCarInstanceParts)                                                                                               
  Show [MarketCarInstanceParts](Model-MarketCarInstanceParts.html#t:MarketCarInstanceParts)                                                                                             
  ToJSON [MarketCarInstanceParts](Model-MarketCarInstanceParts.html#t:MarketCarInstanceParts)                                                                                           
  FromJSON [MarketCarInstanceParts](Model-MarketCarInstanceParts.html#t:MarketCarInstanceParts)                                                                                         
  Default [MarketCarInstanceParts](Model-MarketCarInstanceParts.html#t:MarketCarInstanceParts)                                                                                          
  [FromInRule](Data-InRules.html#t:FromInRule) [MarketCarInstanceParts](Model-MarketCarInstanceParts.html#t:MarketCarInstanceParts)                                                     
  [ToInRule](Data-InRules.html#t:ToInRule) [MarketCarInstanceParts](Model-MarketCarInstanceParts.html#t:MarketCarInstanceParts)                                                         
  [Mapable](Model-General.html#t:Mapable) [MarketCarInstanceParts](Model-MarketCarInstanceParts.html#t:MarketCarInstanceParts)                                                          
  [Database](Model-General.html#t:Database) [Connection](Data-SqlTransaction.html#t:Connection) [MarketCarInstanceParts](Model-MarketCarInstanceParts.html#t:MarketCarInstanceParts)    
  ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ ---

relation :: [RelationM](Data-Relation.html#t:RelationM)

schema :: [[Char]]

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
