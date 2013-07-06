% Model.CarMarket
% 
% 

-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Model.CarMarket

Documentation
=============

data CarMarket

Constructors

CarMarket

 

Fields

id :: [Id](Model-General.html#t:Id)
:    
manufacturer\_id :: Integer
:    
top\_speed :: Integer
:    
acceleration :: Integer
:    
braking :: Integer
:    
nos :: Integer
:    
handling :: Integer
:    
name :: String
:    
use\_3d :: String
:    
year :: Integer
:    
level :: Integer
:    
manufacturer\_name :: String
:    
label :: String
:    
car\_label :: String
:    
models\_available :: Integer
:    
price :: Integer
:    

Instances

  --------------------------------------------------------------------------------------------------------------------------------------------- ---
  Eq [CarMarket](Model-CarMarket.html#t:CarMarket)                                                                                               
  Show [CarMarket](Model-CarMarket.html#t:CarMarket)                                                                                             
  ToJSON [CarMarket](Model-CarMarket.html#t:CarMarket)                                                                                           
  FromJSON [CarMarket](Model-CarMarket.html#t:CarMarket)                                                                                         
  Default [CarMarket](Model-CarMarket.html#t:CarMarket)                                                                                          
  [FromInRule](Data-InRules.html#t:FromInRule) [CarMarket](Model-CarMarket.html#t:CarMarket)                                                     
  [ToInRule](Data-InRules.html#t:ToInRule) [CarMarket](Model-CarMarket.html#t:CarMarket)                                                         
  [Mapable](Model-General.html#t:Mapable) [CarMarket](Model-CarMarket.html#t:CarMarket)                                                          
  [Database](Model-General.html#t:Database) [Connection](Data-SqlTransaction.html#t:Connection) [CarMarket](Model-CarMarket.html#t:CarMarket)    
  --------------------------------------------------------------------------------------------------------------------------------------------- ---

relation :: [RelationM](Data-Relation.html#t:RelationM)

schema :: [[Char]]

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
