% Data.CarReady
% 
% 

-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Data.CarReady

Documentation
=============

type Car = HashMap Integer Part

data CarReadyState

Constructors

CarReadyState

 

Fields

ready :: Bool
:    
missing :: Types
:    
worn :: Parts
:    

Instances

  -------------------------------------------------------------------------------------------------- ---
  Eq [CarReadyState](Data-CarReady.html#t:CarReadyState)                                              
  Show [CarReadyState](Data-CarReady.html#t:CarReadyState)                                            
  ToJSON [CarReadyState](Data-CarReady.html#t:CarReadyState)                                          
  FromJSON [CarReadyState](Data-CarReady.html#t:CarReadyState)                                        
  Default [CarReadyState](Data-CarReady.html#t:CarReadyState)                                         
  [FromInRule](Data-InRules.html#t:FromInRule) [CarReadyState](Data-CarReady.html#t:CarReadyState)    
  [ToInRule](Data-InRules.html#t:ToInRule) [CarReadyState](Data-CarReady.html#t:CarReadyState)        
  [Mapable](Model-General.html#t:Mapable) [CarReadyState](Data-CarReady.html#t:CarReadyState)         
  -------------------------------------------------------------------------------------------------- ---

carReadyState :: [Car](Data-CarReady.html#t:Car) -\>
[SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction)
[Connection](Data-SqlTransaction.html#t:Connection)
[CarReadyState](Data-CarReady.html#t:CarReadyState)

carReady :: Integer -\>
[SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction)
[Connection](Data-SqlTransaction.html#t:Connection)
[CarReadyState](Data-CarReady.html#t:CarReadyState)

carFromParts :: Parts -\>
[SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction)
[Connection](Data-SqlTransaction.html#t:Connection)
[Car](Data-CarReady.html#t:Car)

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
