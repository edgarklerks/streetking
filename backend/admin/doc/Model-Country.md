% Model.Country
% 
% 

-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Model.Country

Documentation
=============

data Country

Constructors

Country

 

Fields

id :: [Id](Model-General.html#t:Id)
:    
name :: String
:    
shortname :: String
:    

Instances

  --------------------------------------------------------------------------------------------------------------------------------------- ---
  Eq [Country](Model-Country.html#t:Country)                                                                                               
  Show [Country](Model-Country.html#t:Country)                                                                                             
  ToJSON [Country](Model-Country.html#t:Country)                                                                                           
  FromJSON [Country](Model-Country.html#t:Country)                                                                                         
  Default [Country](Model-Country.html#t:Country)                                                                                          
  [FromInRule](Data-InRules.html#t:FromInRule) [Country](Model-Country.html#t:Country)                                                     
  [ToInRule](Data-InRules.html#t:ToInRule) [Country](Model-Country.html#t:Country)                                                         
  [Mapable](Model-General.html#t:Mapable) [Country](Model-Country.html#t:Country)                                                          
  [Database](Model-General.html#t:Database) [Connection](Data-SqlTransaction.html#t:Connection) [Country](Model-Country.html#t:Country)    
  --------------------------------------------------------------------------------------------------------------------------------------- ---

relation :: [RelationM](Data-Relation.html#t:RelationM)

schema :: [[Char]]

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
