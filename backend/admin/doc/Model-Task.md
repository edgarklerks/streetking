% Model.Task
% 
% 

-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Model.Task

Documentation
=============

data Task

Constructors

Task

 

Fields

id :: [Id](Model-General.html#t:Id)
:    
time :: Integer
:    
data :: [Data](Data-DataPack.html#t:Data)
:    
deleted :: Bool
:    

Instances

  ------------------------------------------------------------------------------------------------------------------------------ ---
  Eq [Task](Model-Task.html#t:Task)                                                                                               
  Show [Task](Model-Task.html#t:Task)                                                                                             
  ToJSON [Task](Model-Task.html#t:Task)                                                                                           
  FromJSON [Task](Model-Task.html#t:Task)                                                                                         
  Default [Task](Model-Task.html#t:Task)                                                                                          
  [FromInRule](Data-InRules.html#t:FromInRule) [Task](Model-Task.html#t:Task)                                                     
  [ToInRule](Data-InRules.html#t:ToInRule) [Task](Model-Task.html#t:Task)                                                         
  [Mapable](Model-General.html#t:Mapable) [Task](Model-Task.html#t:Task)                                                          
  [Database](Model-General.html#t:Database) [Connection](Data-SqlTransaction.html#t:Connection) [Task](Model-Task.html#t:Task)    
  ------------------------------------------------------------------------------------------------------------------------------ ---

relation :: [RelationM](Data-Relation.html#t:RelationM)

schema :: [[Char]]

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
