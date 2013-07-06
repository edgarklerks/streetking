% Model.CarStockParts
% 
% 

-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Model.CarStockParts

Documentation
=============

type MInteger = Maybe Integer

data CarStockPart

Constructors

CarStockPart

 

Fields

id :: [Id](Model-General.html#t:Id)
:    
part\_type\_id :: Integer
:    
weight :: Integer
:    
parameter1 :: [MInteger](Model-CarStockParts.html#t:MInteger)
:    
parameter2 :: [MInteger](Model-CarStockParts.html#t:MInteger)
:    
parameter3 :: [MInteger](Model-CarStockParts.html#t:MInteger)
:    
parameter1\_type\_id :: [MInteger](Model-CarStockParts.html#t:MInteger)
:    
parameter2\_type\_id :: [MInteger](Model-CarStockParts.html#t:MInteger)
:    
parameter3\_type\_id :: [MInteger](Model-CarStockParts.html#t:MInteger)
:    
car\_id :: [Id](Model-General.html#t:Id)
:    
d3d\_model\_id :: Integer
:    
level :: Integer
:    
price :: Integer
:    
part\_modifier\_id :: [MInteger](Model-CarStockParts.html#t:MInteger)
:    
unique :: Bool
:    

Instances

  ------------------------------------------------------------------------------------------------------------------------------------------------------- ---
  Eq [CarStockPart](Model-CarStockParts.html#t:CarStockPart)                                                                                               
  Show [CarStockPart](Model-CarStockParts.html#t:CarStockPart)                                                                                             
  ToJSON [CarStockPart](Model-CarStockParts.html#t:CarStockPart)                                                                                           
  FromJSON [CarStockPart](Model-CarStockParts.html#t:CarStockPart)                                                                                         
  Default [CarStockPart](Model-CarStockParts.html#t:CarStockPart)                                                                                          
  [FromInRule](Data-InRules.html#t:FromInRule) [CarStockPart](Model-CarStockParts.html#t:CarStockPart)                                                     
  [ToInRule](Data-InRules.html#t:ToInRule) [CarStockPart](Model-CarStockParts.html#t:CarStockPart)                                                         
  [Mapable](Model-General.html#t:Mapable) [CarStockPart](Model-CarStockParts.html#t:CarStockPart)                                                          
  [Database](Model-General.html#t:Database) [Connection](Data-SqlTransaction.html#t:Connection) [CarStockPart](Model-CarStockParts.html#t:CarStockPart)    
  ------------------------------------------------------------------------------------------------------------------------------------------------------- ---

relation :: [RelationM](Data-Relation.html#t:RelationM)

schema :: [[Char]]

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
