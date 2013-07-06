% Model.MarketItem
% 
% 

-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Model.MarketItem

Documentation
=============

type MInteger = Maybe Integer

data MarketItem

Constructors

MarketItem

 

Fields

id :: [Id](Model-General.html#t:Id)
:    
car\_instance\_id :: [MInteger](Model-MarketItem.html#t:MInteger)
:    
part\_instance\_id :: [MInteger](Model-MarketItem.html#t:MInteger)
:    
price :: Integer
:    
account\_id :: Integer
:    

Instances

  ------------------------------------------------------------------------------------------------------------------------------------------------ ---
  Eq [MarketItem](Model-MarketItem.html#t:MarketItem)                                                                                               
  Show [MarketItem](Model-MarketItem.html#t:MarketItem)                                                                                             
  ToJSON [MarketItem](Model-MarketItem.html#t:MarketItem)                                                                                           
  FromJSON [MarketItem](Model-MarketItem.html#t:MarketItem)                                                                                         
  Default [MarketItem](Model-MarketItem.html#t:MarketItem)                                                                                          
  [FromInRule](Data-InRules.html#t:FromInRule) [MarketItem](Model-MarketItem.html#t:MarketItem)                                                     
  [ToInRule](Data-InRules.html#t:ToInRule) [MarketItem](Model-MarketItem.html#t:MarketItem)                                                         
  [Mapable](Model-General.html#t:Mapable) [MarketItem](Model-MarketItem.html#t:MarketItem)                                                          
  [Database](Model-General.html#t:Database) [Connection](Data-SqlTransaction.html#t:Connection) [MarketItem](Model-MarketItem.html#t:MarketItem)    
  ------------------------------------------------------------------------------------------------------------------------------------------------ ---

relation :: [RelationM](Data-Relation.html#t:RelationM)

schema :: [[Char]]

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
