% Model.Report
% 
% 

-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Model.Report

Documentation
=============

data Type

Constructors

  ----------- ---
  Race         
  Shopper      
  Personnel    
  Garage       
  ----------- ---

Instances

  ------------------------------------------------------------------------------- ---
  Enum [Type](Model-Report.html#t:Type)                                            
  Eq [Type](Model-Report.html#t:Type)                                              
  Show [Type](Model-Report.html#t:Type)                                            
  IsString [Type](Model-Report.html#t:Type)                                        
  ToJSON [Type](Model-Report.html#t:Type)                                          
  FromJSON [Type](Model-Report.html#t:Type)                                        
  Default [Type](Model-Report.html#t:Type)                                         
  [FromInRule](Data-InRules.html#t:FromInRule) [Type](Model-Report.html#t:Type)    
  [ToInRule](Data-InRules.html#t:ToInRule) [Type](Model-Report.html#t:Type)        
  ------------------------------------------------------------------------------- ---

data Report

Constructors

Report

 

Fields

id :: [Id](Model-General.html#t:Id)
:    
account\_id :: Integer
:    
time :: Integer
:    
type :: [Type](Model-Report.html#t:Type)
:    
data :: [Data](Data-DataPack.html#t:Data)
:    

Instances

  ------------------------------------------------------------------------------------------------------------------------------------ ---
  Eq [Report](Model-Report.html#t:Report)                                                                                               
  Show [Report](Model-Report.html#t:Report)                                                                                             
  ToJSON [Report](Model-Report.html#t:Report)                                                                                           
  FromJSON [Report](Model-Report.html#t:Report)                                                                                         
  Default [Report](Model-Report.html#t:Report)                                                                                          
  [FromInRule](Data-InRules.html#t:FromInRule) [Report](Model-Report.html#t:Report)                                                     
  [ToInRule](Data-InRules.html#t:ToInRule) [Report](Model-Report.html#t:Report)                                                         
  [Mapable](Model-General.html#t:Mapable) [Report](Model-Report.html#t:Report)                                                          
  [Database](Model-General.html#t:Database) [Connection](Data-SqlTransaction.html#t:Connection) [Report](Model-Report.html#t:Report)    
  ------------------------------------------------------------------------------------------------------------------------------------ ---

relation :: [RelationM](Data-Relation.html#t:RelationM)

schema :: [[Char]]

report :: [Type](Model-Report.html#t:Type) -\> Integer -\> Integer -\>
[Data](Data-DataPack.html#t:Data) -\>
[SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction)
[Connection](Data-SqlTransaction.html#t:Connection) Integer

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
