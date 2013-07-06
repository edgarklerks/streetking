% Model.TrackMaster
% 
% 

-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Model.TrackMaster

Documentation
=============

data TrackMaster

Constructors

TrackMaster

 

Fields

track\_id :: Integer
:    
track\_name :: String
:    
track\_data :: String
:    
track\_level :: Integer
:    
city\_id :: Integer
:    
city\_name :: String
:    
city\_data :: String
:    
continent\_id :: Integer
:    
continent\_name :: String
:    
continent\_data :: String
:    
length :: Double
:    
energy\_cost :: Integer
:    
top\_time\_exists :: Bool
:    
top\_time :: Double
:    
top\_time\_id :: Integer
:    
top\_time\_account\_id :: Integer
:    
top\_time\_name :: String
:    
top\_time\_picture\_small :: String
:    
top\_time\_picture\_medium :: String
:    
top\_time\_picture\_large :: String
:    

Instances

  --------------------------------------------------------------------------------------------------------------------------------------------------- ---
  Eq [TrackMaster](Model-TrackMaster.html#t:TrackMaster)                                                                                               
  Show [TrackMaster](Model-TrackMaster.html#t:TrackMaster)                                                                                             
  ToJSON [TrackMaster](Model-TrackMaster.html#t:TrackMaster)                                                                                           
  FromJSON [TrackMaster](Model-TrackMaster.html#t:TrackMaster)                                                                                         
  Default [TrackMaster](Model-TrackMaster.html#t:TrackMaster)                                                                                          
  [FromInRule](Data-InRules.html#t:FromInRule) [TrackMaster](Model-TrackMaster.html#t:TrackMaster)                                                     
  [ToInRule](Data-InRules.html#t:ToInRule) [TrackMaster](Model-TrackMaster.html#t:TrackMaster)                                                         
  [Mapable](Model-General.html#t:Mapable) [TrackMaster](Model-TrackMaster.html#t:TrackMaster)                                                          
  [Database](Model-General.html#t:Database) [Connection](Data-SqlTransaction.html#t:Connection) [TrackMaster](Model-TrackMaster.html#t:TrackMaster)    
  --------------------------------------------------------------------------------------------------------------------------------------------------- ---

relation :: [RelationM](Data-Relation.html#t:RelationM)

schema :: [[Char]]

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
