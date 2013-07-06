% Model.TrackContinent
% 
% 

-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Model.TrackContinent

Documentation
=============

data TrackContinent

Constructors

TrackContinent

 

Fields

continent\_id :: Integer
:    
continent\_name :: String
:    
continent\_data :: String
:    
continent\_level :: Integer
:    
continent\_tracks :: Integer
:    

Instances

  ------------------------------------------------------------------------------------------------------------------------------------------------------------ ---
  Eq [TrackContinent](Model-TrackContinent.html#t:TrackContinent)                                                                                               
  Show [TrackContinent](Model-TrackContinent.html#t:TrackContinent)                                                                                             
  ToJSON [TrackContinent](Model-TrackContinent.html#t:TrackContinent)                                                                                           
  FromJSON [TrackContinent](Model-TrackContinent.html#t:TrackContinent)                                                                                         
  Default [TrackContinent](Model-TrackContinent.html#t:TrackContinent)                                                                                          
  [FromInRule](Data-InRules.html#t:FromInRule) [TrackContinent](Model-TrackContinent.html#t:TrackContinent)                                                     
  [ToInRule](Data-InRules.html#t:ToInRule) [TrackContinent](Model-TrackContinent.html#t:TrackContinent)                                                         
  [Mapable](Model-General.html#t:Mapable) [TrackContinent](Model-TrackContinent.html#t:TrackContinent)                                                          
  [Database](Model-General.html#t:Database) [Connection](Data-SqlTransaction.html#t:Connection) [TrackContinent](Model-TrackContinent.html#t:TrackContinent)    
  ------------------------------------------------------------------------------------------------------------------------------------------------------------ ---

relation :: [RelationM](Data-Relation.html#t:RelationM)

schema :: [[Char]]

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
