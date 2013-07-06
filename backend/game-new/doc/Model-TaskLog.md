% Model.TaskLog
% 
% 

-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Model.TaskLog

Documentation
=============

type MInteger = Maybe Integer

data TaskLog

Constructors

TaskLog

 

Fields

id :: [Id](Model-General.html#t:Id)
:    
time :: Integer
:    
activity :: String
:    
task\_id :: [MInteger](Model-TaskLog.html#t:MInteger)
:    
entry :: [Data](Data-DataPack.html#t:Data)
:    

Instances

  --------------------------------------------------------------------------------------------------------------------------------------- ---
  Eq [TaskLog](Model-TaskLog.html#t:TaskLog)                                                                                               
  Show [TaskLog](Model-TaskLog.html#t:TaskLog)                                                                                             
  ToJSON [TaskLog](Model-TaskLog.html#t:TaskLog)                                                                                           
  FromJSON [TaskLog](Model-TaskLog.html#t:TaskLog)                                                                                         
  Default [TaskLog](Model-TaskLog.html#t:TaskLog)                                                                                          
  [FromInRule](Data-InRules.html#t:FromInRule) [TaskLog](Model-TaskLog.html#t:TaskLog)                                                     
  [ToInRule](Data-InRules.html#t:ToInRule) [TaskLog](Model-TaskLog.html#t:TaskLog)                                                         
  [Mapable](Model-General.html#t:Mapable) [TaskLog](Model-TaskLog.html#t:TaskLog)                                                          
  [Database](Model-General.html#t:Database) [Connection](Data-SqlTransaction.html#t:Connection) [TaskLog](Model-TaskLog.html#t:TaskLog)    
  --------------------------------------------------------------------------------------------------------------------------------------- ---

relation :: [RelationM](Data-Relation.html#t:RelationM)

schema :: [[Char]]

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
