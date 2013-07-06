% Data.RaceParticipant
% 
% 

-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Data.RaceParticipant

Documentation
=============

data RaceParticipant

Constructors

RaceParticipant

 

Fields

rp\_account :: [Account](Model-Account.html#t:Account)
:    
rp\_account\_min :: [AccountProfileMin](Model-AccountProfileMin.html#t:AccountProfileMin)
:    
rp\_car :: [CarInGarage](Model-CarInGarage.html#t:CarInGarage)
:    
rp\_car\_min :: [CarMinimal](Model-CarMinimal.html#t:CarMinimal)
:    
rp\_escrow\_id :: MInteger
:    

Instances

  ------------------------------------------------------------------------------------------------------------- ---
  Eq [RaceParticipant](Data-RaceParticipant.html#t:RaceParticipant)                                              
  Show [RaceParticipant](Data-RaceParticipant.html#t:RaceParticipant)                                            
  ToJSON [RaceParticipant](Data-RaceParticipant.html#t:RaceParticipant)                                          
  FromJSON [RaceParticipant](Data-RaceParticipant.html#t:RaceParticipant)                                        
  Default [RaceParticipant](Data-RaceParticipant.html#t:RaceParticipant)                                         
  [FromInRule](Data-InRules.html#t:FromInRule) [RaceParticipant](Data-RaceParticipant.html#t:RaceParticipant)    
  [ToInRule](Data-InRules.html#t:ToInRule) [RaceParticipant](Data-RaceParticipant.html#t:RaceParticipant)        
  [Mapable](Model-General.html#t:Mapable) [RaceParticipant](Data-RaceParticipant.html#t:RaceParticipant)         
  ------------------------------------------------------------------------------------------------------------- ---

mkRaceParticipant :: Integer -\> Integer -\> Maybe Integer -\>
[SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction)
[Connection](Data-SqlTransaction.html#t:Connection)
[RaceParticipant](Data-RaceParticipant.html#t:RaceParticipant)

rp\_account\_id ::
[RaceParticipant](Data-RaceParticipant.html#t:RaceParticipant) -\>
Integer

rp\_car\_id ::
[RaceParticipant](Data-RaceParticipant.html#t:RaceParticipant) -\>
Integer

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
