% Model.RaceDetails
% 
% 

-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Model.RaceDetails

Documentation
=============

data RaceDetails

Constructors

RaceDetails

 

Fields

race\_id :: Integer
:    
track\_id :: Integer
:    
start\_time :: Integer
:    
end\_time :: Integer
:    
time\_left :: Integer
:    
type :: String
:    
data :: [RaceDataList](Data-RacingNew.html#t:RaceDataList)
:    

Instances

  --------------------------------------------------------------------------------------------------------------------------------------------------- ---
  Eq [RaceDetails](Model-RaceDetails.html#t:RaceDetails)                                                                                               
  Show [RaceDetails](Model-RaceDetails.html#t:RaceDetails)                                                                                             
  ToJSON [RaceDetails](Model-RaceDetails.html#t:RaceDetails)                                                                                           
  FromJSON [RaceDetails](Model-RaceDetails.html#t:RaceDetails)                                                                                         
  Default [RaceDetails](Model-RaceDetails.html#t:RaceDetails)                                                                                          
  [FromInRule](Data-InRules.html#t:FromInRule) [RaceDetails](Model-RaceDetails.html#t:RaceDetails)                                                     
  [ToInRule](Data-InRules.html#t:ToInRule) [RaceDetails](Model-RaceDetails.html#t:RaceDetails)                                                         
  [Mapable](Model-General.html#t:Mapable) [RaceDetails](Model-RaceDetails.html#t:RaceDetails)                                                          
  [Database](Model-General.html#t:Database) [Connection](Data-SqlTransaction.html#t:Connection) [RaceDetails](Model-RaceDetails.html#t:RaceDetails)    
  --------------------------------------------------------------------------------------------------------------------------------------------------- ---

relation :: [RelationM](Data-Relation.html#t:RelationM)

schema :: [[Char]]

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
