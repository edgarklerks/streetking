% Model.GarageReport
% 
% 

-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Model.GarageReport

Documentation
=============

type MInteger = Maybe Integer

type MString = Maybe String

type MBool = Maybe Bool

data GarageReport

Constructors

GarageReport

 

Fields

id :: [Id](Model-General.html#t:Id)
:    
account\_id :: [MInteger](Model-GarageReport.html#t:MInteger)
:    
time :: [MInteger](Model-GarageReport.html#t:MInteger)
:    
report\_type\_id :: [MInteger](Model-GarageReport.html#t:MInteger)
:    
report\_descriptor :: [MString](Model-GarageReport.html#t:MString)
:    
personnel\_instance\_id :: [MInteger](Model-GarageReport.html#t:MInteger)
:    
part\_instance\_id :: [MInteger](Model-GarageReport.html#t:MInteger)
:    
personnel\_id :: [Id](Model-General.html#t:Id)
:    
name :: [MString](Model-GarageReport.html#t:MString)
:    
country\_name :: [MString](Model-GarageReport.html#t:MString)
:    
country\_shortname :: [MString](Model-GarageReport.html#t:MString)
:    
gender :: [MBool](Model-GarageReport.html#t:MBool)
:    
picture :: [MString](Model-GarageReport.html#t:MString)
:    
salary :: [MInteger](Model-GarageReport.html#t:MInteger)
:    
skill\_repair :: [MInteger](Model-GarageReport.html#t:MInteger)
:    
skill\_engineering :: [MInteger](Model-GarageReport.html#t:MInteger)
:    
training\_cost\_repair :: [MInteger](Model-GarageReport.html#t:MInteger)
:    
training\_cost\_engineering :: [MInteger](Model-GarageReport.html#t:MInteger)
:    
paid\_until :: [MInteger](Model-GarageReport.html#t:MInteger)
:    
part\_type :: [MString](Model-GarageReport.html#t:MString)
:    
weight :: [MInteger](Model-GarageReport.html#t:MInteger)
:    
parameter1 :: [MInteger](Model-GarageReport.html#t:MInteger)
:    
parameter1\_unit :: [MString](Model-GarageReport.html#t:MString)
:    
parameter1\_name :: [MString](Model-GarageReport.html#t:MString)
:    
parameter2 :: [MInteger](Model-GarageReport.html#t:MInteger)
:    
parameter2\_unit :: [MString](Model-GarageReport.html#t:MString)
:    
parameter2\_name :: [MString](Model-GarageReport.html#t:MString)
:    
parameter3 :: [MInteger](Model-GarageReport.html#t:MInteger)
:    
parameter3\_unit :: [MString](Model-GarageReport.html#t:MString)
:    
parameter3\_name :: [MString](Model-GarageReport.html#t:MString)
:    
level :: [MInteger](Model-GarageReport.html#t:MInteger)
:    
price :: [MInteger](Model-GarageReport.html#t:MInteger)
:    
car\_model :: [MString](Model-GarageReport.html#t:MString)
:    
manufacturer\_name :: [MString](Model-GarageReport.html#t:MString)
:    
part\_modifier :: [MString](Model-GarageReport.html#t:MString)
:    
unique :: [MBool](Model-GarageReport.html#t:MBool)
:    
improvement :: [MInteger](Model-GarageReport.html#t:MInteger)
:    
improvement\_change :: [MInteger](Model-GarageReport.html#t:MInteger)
:    
wear :: [MInteger](Model-GarageReport.html#t:MInteger)
:    
wear\_change :: [MInteger](Model-GarageReport.html#t:MInteger)
:    
task :: [MString](Model-GarageReport.html#t:MString)
:    
part\_id :: [MInteger](Model-GarageReport.html#t:MInteger)
:    

Instances

  ------------------------------------------------------------------------------------------------------------------------------------------------------ ---
  Eq [GarageReport](Model-GarageReport.html#t:GarageReport)                                                                                               
  Show [GarageReport](Model-GarageReport.html#t:GarageReport)                                                                                             
  ToJSON [GarageReport](Model-GarageReport.html#t:GarageReport)                                                                                           
  FromJSON [GarageReport](Model-GarageReport.html#t:GarageReport)                                                                                         
  Default [GarageReport](Model-GarageReport.html#t:GarageReport)                                                                                          
  [FromInRule](Data-InRules.html#t:FromInRule) [GarageReport](Model-GarageReport.html#t:GarageReport)                                                     
  [ToInRule](Data-InRules.html#t:ToInRule) [GarageReport](Model-GarageReport.html#t:GarageReport)                                                         
  [Mapable](Model-General.html#t:Mapable) [GarageReport](Model-GarageReport.html#t:GarageReport)                                                          
  [Database](Model-General.html#t:Database) [Connection](Data-SqlTransaction.html#t:Connection) [GarageReport](Model-GarageReport.html#t:GarageReport)    
  ------------------------------------------------------------------------------------------------------------------------------------------------------ ---

relation :: [RelationM](Data-Relation.html#t:RelationM)

schema :: [[Char]]

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
