% Model.CarOptionsExtended
% 
% 

-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Model.CarOptionsExtended

Documentation
=============

type MString = Maybe String

data CarOptionsExtended

Constructors

CarOptionsExtended

 

Fields

car\_instance\_id :: Integer
:    
account\_id :: Integer
:    
key :: String
:    
value :: [MString](Model-CarOptionsExtended.html#t:MString)
:    

Instances

  ------------------------------------------------------------------------------------------------------------------------------------------------------------------------ ---
  Eq [CarOptionsExtended](Model-CarOptionsExtended.html#t:CarOptionsExtended)                                                                                               
  Show [CarOptionsExtended](Model-CarOptionsExtended.html#t:CarOptionsExtended)                                                                                             
  ToJSON [CarOptionsExtended](Model-CarOptionsExtended.html#t:CarOptionsExtended)                                                                                           
  FromJSON [CarOptionsExtended](Model-CarOptionsExtended.html#t:CarOptionsExtended)                                                                                         
  Default [CarOptionsExtended](Model-CarOptionsExtended.html#t:CarOptionsExtended)                                                                                          
  [FromInRule](Data-InRules.html#t:FromInRule) [CarOptionsExtended](Model-CarOptionsExtended.html#t:CarOptionsExtended)                                                     
  [ToInRule](Data-InRules.html#t:ToInRule) [CarOptionsExtended](Model-CarOptionsExtended.html#t:CarOptionsExtended)                                                         
  [Mapable](Model-General.html#t:Mapable) [CarOptionsExtended](Model-CarOptionsExtended.html#t:CarOptionsExtended)                                                          
  [Database](Model-General.html#t:Database) [Connection](Data-SqlTransaction.html#t:Connection) [CarOptionsExtended](Model-CarOptionsExtended.html#t:CarOptionsExtended)    
  ------------------------------------------------------------------------------------------------------------------------------------------------------------------------ ---

relation :: [RelationM](Data-Relation.html#t:RelationM)

schema :: [[Char]]

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
