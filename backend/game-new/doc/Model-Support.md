% Model.Support
% 
% 

-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Model.Support

Documentation
=============

type AAS = Value

data Support

Constructors

Support

 

Fields

id :: [Id](Model-General.html#t:Id)
:    
account\_id :: Integer
:    
message :: String
:    
data :: String
:    
processed :: Bool
:    
created :: Integer
:    

Instances

  --------------------------------------------------------------------------------------------------------------------------------------- ---
  Eq [Support](Model-Support.html#t:Support)                                                                                               
  Show [Support](Model-Support.html#t:Support)                                                                                             
  ToJSON [Support](Model-Support.html#t:Support)                                                                                           
  FromJSON [Support](Model-Support.html#t:Support)                                                                                         
  Default [Support](Model-Support.html#t:Support)                                                                                          
  [FromInRule](Data-InRules.html#t:FromInRule) [Support](Model-Support.html#t:Support)                                                     
  [ToInRule](Data-InRules.html#t:ToInRule) [Support](Model-Support.html#t:Support)                                                         
  [Mapable](Model-General.html#t:Mapable) [Support](Model-Support.html#t:Support)                                                          
  [Database](Model-General.html#t:Database) [Connection](Data-SqlTransaction.html#t:Connection) [Support](Model-Support.html#t:Support)    
  --------------------------------------------------------------------------------------------------------------------------------------- ---

relation :: [RelationM](Data-Relation.html#t:RelationM)

schema :: [[Char]]

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
