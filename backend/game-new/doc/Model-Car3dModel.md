% Model.Car3dModel
% 
% 

-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Model.Car3dModel

Documentation
=============

data Car3dModel

Constructors

Car3dModel

 

Fields

id :: [Id](Model-General.html#t:Id)
:    
name :: String
:    
use\_3d :: String
:    
part\_instance\_id :: String
:    
part\_type\_id :: Integer
:    

Instances

  ------------------------------------------------------------------------------------------------------------------------------------------------ ---
  Eq [Car3dModel](Model-Car3dModel.html#t:Car3dModel)                                                                                               
  Show [Car3dModel](Model-Car3dModel.html#t:Car3dModel)                                                                                             
  ToJSON [Car3dModel](Model-Car3dModel.html#t:Car3dModel)                                                                                           
  FromJSON [Car3dModel](Model-Car3dModel.html#t:Car3dModel)                                                                                         
  Default [Car3dModel](Model-Car3dModel.html#t:Car3dModel)                                                                                          
  [FromInRule](Data-InRules.html#t:FromInRule) [Car3dModel](Model-Car3dModel.html#t:Car3dModel)                                                     
  [ToInRule](Data-InRules.html#t:ToInRule) [Car3dModel](Model-Car3dModel.html#t:Car3dModel)                                                         
  [Mapable](Model-General.html#t:Mapable) [Car3dModel](Model-Car3dModel.html#t:Car3dModel)                                                          
  [Database](Model-General.html#t:Database) [Connection](Data-SqlTransaction.html#t:Connection) [Car3dModel](Model-Car3dModel.html#t:Car3dModel)    
  ------------------------------------------------------------------------------------------------------------------------------------------------ ---

relation :: [RelationM](Data-Relation.html#t:RelationM)

schema :: [[Char]]

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
