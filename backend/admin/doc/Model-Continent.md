% Model.Continent
% 
% 

-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Model.Continent

Documentation
=============

data Continent

Constructors

Continent

 

Fields

id :: [Id](Model-General.html#t:Id)
:    
name :: String
:    
data :: String
:    

Instances

  --------------------------------------------------------------------------------------------------------------------------------------------- ---
  Eq [Continent](Model-Continent.html#t:Continent)                                                                                               
  Show [Continent](Model-Continent.html#t:Continent)                                                                                             
  ToJSON [Continent](Model-Continent.html#t:Continent)                                                                                           
  FromJSON [Continent](Model-Continent.html#t:Continent)                                                                                         
  Default [Continent](Model-Continent.html#t:Continent)                                                                                          
  [FromInRule](Data-InRules.html#t:FromInRule) [Continent](Model-Continent.html#t:Continent)                                                     
  [ToInRule](Data-InRules.html#t:ToInRule) [Continent](Model-Continent.html#t:Continent)                                                         
  [Mapable](Model-General.html#t:Mapable) [Continent](Model-Continent.html#t:Continent)                                                          
  [Database](Model-General.html#t:Database) [Connection](Data-SqlTransaction.html#t:Connection) [Continent](Model-Continent.html#t:Continent)    
  --------------------------------------------------------------------------------------------------------------------------------------------- ---

relation :: [RelationM](Data-Relation.html#t:RelationM)

schema :: [[Char]]

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
