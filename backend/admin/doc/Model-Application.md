% Model.Application
% 
% 

-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Model.Application

Documentation
=============

data Application

Constructors

Application

 

Fields

id :: [Id](Model-General.html#t:Id)
:    
platform :: String
:    
token :: String
:    

Instances

  --------------------------------------------------------------------------------------------------------------------------------------------------- ---
  Eq [Application](Model-Application.html#t:Application)                                                                                               
  Show [Application](Model-Application.html#t:Application)                                                                                             
  ToJSON [Application](Model-Application.html#t:Application)                                                                                           
  FromJSON [Application](Model-Application.html#t:Application)                                                                                         
  Default [Application](Model-Application.html#t:Application)                                                                                          
  [FromInRule](Data-InRules.html#t:FromInRule) [Application](Model-Application.html#t:Application)                                                     
  [ToInRule](Data-InRules.html#t:ToInRule) [Application](Model-Application.html#t:Application)                                                         
  [Mapable](Model-General.html#t:Mapable) [Application](Model-Application.html#t:Application)                                                          
  [Database](Model-General.html#t:Database) [Connection](Data-SqlTransaction.html#t:Connection) [Application](Model-Application.html#t:Application)    
  --------------------------------------------------------------------------------------------------------------------------------------------------- ---

relation :: [RelationM](Data-Relation.html#t:RelationM)

schema :: [[Char]]

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
