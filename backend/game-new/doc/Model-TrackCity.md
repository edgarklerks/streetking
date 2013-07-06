% Model.TrackCity
% 
% 

-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Model.TrackCity

Documentation
=============

data TrackCity

Constructors

TrackCity

 

Fields

city\_id :: Integer
:    
city\_name :: String
:    
city\_data :: String
:    
city\_level :: Integer
:    
city\_tracks :: Integer
:    
continent\_id :: Integer
:    
continent\_name :: String
:    
continent\_data :: String
:    

Instances

  --------------------------------------------------------------------------------------------------------------------------------------------- ---
  Eq [TrackCity](Model-TrackCity.html#t:TrackCity)                                                                                               
  Show [TrackCity](Model-TrackCity.html#t:TrackCity)                                                                                             
  ToJSON [TrackCity](Model-TrackCity.html#t:TrackCity)                                                                                           
  FromJSON [TrackCity](Model-TrackCity.html#t:TrackCity)                                                                                         
  Default [TrackCity](Model-TrackCity.html#t:TrackCity)                                                                                          
  [FromInRule](Data-InRules.html#t:FromInRule) [TrackCity](Model-TrackCity.html#t:TrackCity)                                                     
  [ToInRule](Data-InRules.html#t:ToInRule) [TrackCity](Model-TrackCity.html#t:TrackCity)                                                         
  [Mapable](Model-General.html#t:Mapable) [TrackCity](Model-TrackCity.html#t:TrackCity)                                                          
  [Database](Model-General.html#t:Database) [Connection](Data-SqlTransaction.html#t:Connection) [TrackCity](Model-TrackCity.html#t:TrackCity)    
  --------------------------------------------------------------------------------------------------------------------------------------------- ---

relation :: [RelationM](Data-Relation.html#t:RelationM)

schema :: [[Char]]

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
