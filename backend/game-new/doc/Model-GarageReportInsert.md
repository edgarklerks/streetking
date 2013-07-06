% Model.GarageReportInsert
% 
% 

-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Model.GarageReportInsert

Documentation
=============

type MInteger = Maybe Integer

type MString = Maybe String

type MBool = Maybe Bool

data GarageReportInsert

Constructors

GarageReportInsert

 

Fields

id :: [Id](Model-General.html#t:Id)
:    
account\_id :: Integer
:    
time :: Integer
:    
report\_type\_id :: Integer
:    
report\_descriptor :: String
:    
personnel\_instance\_id :: Integer
:    
part\_instance\_id :: Integer
:    
ready :: Bool
:    
data :: String
:    
task :: String
:    

Instances

  ------------------------------------------------------------------------------------------------------------------------------------------------------------------------ ---
  Eq [GarageReportInsert](Model-GarageReportInsert.html#t:GarageReportInsert)                                                                                               
  Show [GarageReportInsert](Model-GarageReportInsert.html#t:GarageReportInsert)                                                                                             
  ToJSON [GarageReportInsert](Model-GarageReportInsert.html#t:GarageReportInsert)                                                                                           
  FromJSON [GarageReportInsert](Model-GarageReportInsert.html#t:GarageReportInsert)                                                                                         
  Default [GarageReportInsert](Model-GarageReportInsert.html#t:GarageReportInsert)                                                                                          
  [FromInRule](Data-InRules.html#t:FromInRule) [GarageReportInsert](Model-GarageReportInsert.html#t:GarageReportInsert)                                                     
  [ToInRule](Data-InRules.html#t:ToInRule) [GarageReportInsert](Model-GarageReportInsert.html#t:GarageReportInsert)                                                         
  [Mapable](Model-General.html#t:Mapable) [GarageReportInsert](Model-GarageReportInsert.html#t:GarageReportInsert)                                                          
  [Database](Model-General.html#t:Database) [Connection](Data-SqlTransaction.html#t:Connection) [GarageReportInsert](Model-GarageReportInsert.html#t:GarageReportInsert)    
  ------------------------------------------------------------------------------------------------------------------------------------------------------------------------ ---

relation :: [RelationM](Data-Relation.html#t:RelationM)

schema :: [[Char]]

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
