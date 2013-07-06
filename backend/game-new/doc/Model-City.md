% Model.City
% 
% 

-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Model.City

Documentation
=============

data City

Constructors

City

 

Fields

id :: [Id](Model-General.html#t:Id)
:    
continent\_id :: Integer
:    
level :: Integer
:    
name :: String
:    
data :: String
:    
default :: Bool
:    

Instances

  ------------------------------------------------------------------------------------------------------------------------------ ---
  Eq [City](Model-City.html#t:City)                                                                                               
  Show [City](Model-City.html#t:City)                                                                                             
  ToJSON [City](Model-City.html#t:City)                                                                                           
  FromJSON [City](Model-City.html#t:City)                                                                                         
  Default [City](Model-City.html#t:City)                                                                                          
  [FromInRule](Data-InRules.html#t:FromInRule) [City](Model-City.html#t:City)                                                     
  [ToInRule](Data-InRules.html#t:ToInRule) [City](Model-City.html#t:City)                                                         
  [Mapable](Model-General.html#t:Mapable) [City](Model-City.html#t:City)                                                          
  [Database](Model-General.html#t:Database) [Connection](Data-SqlTransaction.html#t:Connection) [City](Model-City.html#t:City)    
  ------------------------------------------------------------------------------------------------------------------------------ ---

relation :: [RelationM](Data-Relation.html#t:RelationM)

schema :: [[Char]]

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
