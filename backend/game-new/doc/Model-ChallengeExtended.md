% Model.ChallengeExtended
% 
% 

-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Model.ChallengeExtended

Documentation
=============

data ChallengeExtended

Constructors

ChallengeExtended

 

Fields

challenge\_id :: Integer
:    
account\_id :: Integer
:    
track\_id :: Integer
:    
participants :: Integer
:    
type\_id :: Integer
:    
type :: String
:    
accepts :: Integer
:    
user\_nickname :: String
:    
user\_level :: Integer
:    
track\_name :: String
:    
track\_level :: Integer
:    
city\_id :: Integer
:    
city\_name :: String
:    
continent\_id :: Integer
:    
continent\_name :: String
:    
track\_length :: Double
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
amount :: Integer
:    
profile :: [AccountProfileMin](Model-AccountProfileMin.html#t:AccountProfileMin)
:    
car :: [CarMinimal](Model-CarMinimal.html#t:CarMinimal)
:    
deleted :: Bool
:    

Instances

  --------------------------------------------------------------------------------------------------------------------------------------------------------------------- ---
  Eq [ChallengeExtended](Model-ChallengeExtended.html#t:ChallengeExtended)                                                                                               
  Show [ChallengeExtended](Model-ChallengeExtended.html#t:ChallengeExtended)                                                                                             
  ToJSON [ChallengeExtended](Model-ChallengeExtended.html#t:ChallengeExtended)                                                                                           
  FromJSON [ChallengeExtended](Model-ChallengeExtended.html#t:ChallengeExtended)                                                                                         
  Default [ChallengeExtended](Model-ChallengeExtended.html#t:ChallengeExtended)                                                                                          
  [FromInRule](Data-InRules.html#t:FromInRule) [ChallengeExtended](Model-ChallengeExtended.html#t:ChallengeExtended)                                                     
  [ToInRule](Data-InRules.html#t:ToInRule) [ChallengeExtended](Model-ChallengeExtended.html#t:ChallengeExtended)                                                         
  [Mapable](Model-General.html#t:Mapable) [ChallengeExtended](Model-ChallengeExtended.html#t:ChallengeExtended)                                                          
  [Database](Model-General.html#t:Database) [Connection](Data-SqlTransaction.html#t:Connection) [ChallengeExtended](Model-ChallengeExtended.html#t:ChallengeExtended)    
  --------------------------------------------------------------------------------------------------------------------------------------------------------------------- ---

relation :: [RelationM](Data-Relation.html#t:RelationM)

schema :: [[Char]]

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
