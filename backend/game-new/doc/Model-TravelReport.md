% Model.TravelReport
% 
% 

-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Model.TravelReport

Documentation
=============

type MInteger = Maybe Integer

type MString = Maybe String

type MBool = Maybe Bool

data TravelReport

Constructors

TravelReport

 

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
city\_to :: String
:    
city\_from :: String
:    
continent\_to :: [MString](Model-TravelReport.html#t:MString)
:    
continent\_from :: [MString](Model-TravelReport.html#t:MString)
:    

Instances

  ------------------------------------------------------------------------------------------------------------------------------------------------------ ---
  Eq [TravelReport](Model-TravelReport.html#t:TravelReport)                                                                                               
  Show [TravelReport](Model-TravelReport.html#t:TravelReport)                                                                                             
  ToJSON [TravelReport](Model-TravelReport.html#t:TravelReport)                                                                                           
  FromJSON [TravelReport](Model-TravelReport.html#t:TravelReport)                                                                                         
  Default [TravelReport](Model-TravelReport.html#t:TravelReport)                                                                                          
  [FromInRule](Data-InRules.html#t:FromInRule) [TravelReport](Model-TravelReport.html#t:TravelReport)                                                     
  [ToInRule](Data-InRules.html#t:ToInRule) [TravelReport](Model-TravelReport.html#t:TravelReport)                                                         
  [Mapable](Model-General.html#t:Mapable) [TravelReport](Model-TravelReport.html#t:TravelReport)                                                          
  [Database](Model-General.html#t:Database) [Connection](Data-SqlTransaction.html#t:Connection) [TravelReport](Model-TravelReport.html#t:TravelReport)    
  ------------------------------------------------------------------------------------------------------------------------------------------------------ ---

relation :: [RelationM](Data-Relation.html#t:RelationM)

schema :: [[Char]]

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
