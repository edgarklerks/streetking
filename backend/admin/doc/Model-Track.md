% Model.Track
% 
% 

-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Model.Track

Documentation
=============

type MInteger = Maybe Integer

type Data = Maybe String

data Track

Constructors

Track

 

Fields

id :: [Id](Model-General.html#t:Id)
:    
name :: String
:    
city\_id :: Integer
:    
level :: Integer
:    
data :: [Data](Model-Track.html#t:Data)
:    
loop :: Bool
:    
length :: Integer
:    
top\_time\_id :: [MInteger](Model-Track.html#t:MInteger)
:    
energy\_cost :: Integer
:    

Instances

  --------------------------------------------------------------------------------------------------------------------------------- ---
  Eq [Track](Model-Track.html#t:Track)                                                                                               
  Show [Track](Model-Track.html#t:Track)                                                                                             
  ToJSON [Track](Model-Track.html#t:Track)                                                                                           
  FromJSON [Track](Model-Track.html#t:Track)                                                                                         
  Default [Track](Model-Track.html#t:Track)                                                                                          
  [FromInRule](Data-InRules.html#t:FromInRule) [Track](Model-Track.html#t:Track)                                                     
  [ToInRule](Data-InRules.html#t:ToInRule) [Track](Model-Track.html#t:Track)                                                         
  [Mapable](Model-General.html#t:Mapable) [Track](Model-Track.html#t:Track)                                                          
  [Database](Model-General.html#t:Database) [Connection](Data-SqlTransaction.html#t:Connection) [Track](Model-Track.html#t:Track)    
  --------------------------------------------------------------------------------------------------------------------------------- ---

relation :: [RelationM](Data-Relation.html#t:RelationM)

schema :: [[Char]]

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
