% Model.TrackTime
% 
% 

-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Model.TrackTime

Documentation
=============

data TrackTime

Constructors

TrackTime

 

Fields

id :: [Id](Model-General.html#t:Id)
:    
account\_id :: Integer
:    
track\_id :: Integer
:    
time :: Double
:    

Instances

  --------------------------------------------------------------------------------------------------------------------------------------------- ---
  Eq [TrackTime](Model-TrackTime.html#t:TrackTime)                                                                                               
  Show [TrackTime](Model-TrackTime.html#t:TrackTime)                                                                                             
  ToJSON [TrackTime](Model-TrackTime.html#t:TrackTime)                                                                                           
  FromJSON [TrackTime](Model-TrackTime.html#t:TrackTime)                                                                                         
  Default [TrackTime](Model-TrackTime.html#t:TrackTime)                                                                                          
  [FromInRule](Data-InRules.html#t:FromInRule) [TrackTime](Model-TrackTime.html#t:TrackTime)                                                     
  [ToInRule](Data-InRules.html#t:ToInRule) [TrackTime](Model-TrackTime.html#t:TrackTime)                                                         
  [Mapable](Model-General.html#t:Mapable) [TrackTime](Model-TrackTime.html#t:TrackTime)                                                          
  [Database](Model-General.html#t:Database) [Connection](Data-SqlTransaction.html#t:Connection) [TrackTime](Model-TrackTime.html#t:TrackTime)    
  --------------------------------------------------------------------------------------------------------------------------------------------- ---

relation :: [RelationM](Data-Relation.html#t:RelationM)

schema :: [[Char]]

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
