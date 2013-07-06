% Model.Personnel
% 
% 

-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Model.Personnel

Documentation
=============

type MInteger = Maybe Integer

data Personnel

Constructors

Personnel

 

Fields

id :: [Id](Model-General.html#t:Id)
:    
name :: String
:    
country\_id :: Integer
:    
gender :: Bool
:    
picture :: String
:    
salary :: Integer
:    
price :: Integer
:    
skill\_repair :: Integer
:    
skill\_engineering :: Integer
:    
sort :: Integer
:    

Instances

  --------------------------------------------------------------------------------------------------------------------------------------------- ---
  Eq [Personnel](Model-Personnel.html#t:Personnel)                                                                                               
  Show [Personnel](Model-Personnel.html#t:Personnel)                                                                                             
  ToJSON [Personnel](Model-Personnel.html#t:Personnel)                                                                                           
  FromJSON [Personnel](Model-Personnel.html#t:Personnel)                                                                                         
  Default [Personnel](Model-Personnel.html#t:Personnel)                                                                                          
  [FromInRule](Data-InRules.html#t:FromInRule) [Personnel](Model-Personnel.html#t:Personnel)                                                     
  [ToInRule](Data-InRules.html#t:ToInRule) [Personnel](Model-Personnel.html#t:Personnel)                                                         
  [Mapable](Model-General.html#t:Mapable) [Personnel](Model-Personnel.html#t:Personnel)                                                          
  [Database](Model-General.html#t:Database) [Connection](Data-SqlTransaction.html#t:Connection) [Personnel](Model-Personnel.html#t:Personnel)    
  --------------------------------------------------------------------------------------------------------------------------------------------- ---

relation :: [RelationM](Data-Relation.html#t:RelationM)

schema :: [[Char]]

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
