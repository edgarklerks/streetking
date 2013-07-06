% Model.ParameterTable
% 
% 

-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Model.ParameterTable

Documentation
=============

data ParameterTable

Constructors

ParameterTable

 

Fields

id :: [Id](Model-General.html#t:Id)
:    
name :: String
:    
unit :: String
:    

Instances

  ------------------------------------------------------------------------------------------------------------------------------------------------------------ ---
  Eq [ParameterTable](Model-ParameterTable.html#t:ParameterTable)                                                                                               
  Show [ParameterTable](Model-ParameterTable.html#t:ParameterTable)                                                                                             
  Default [ParameterTable](Model-ParameterTable.html#t:ParameterTable)                                                                                          
  ToJSON [ParameterTable](Model-ParameterTable.html#t:ParameterTable)                                                                                           
  FromJSON [ParameterTable](Model-ParameterTable.html#t:ParameterTable)                                                                                         
  [FromInRule](Data-InRules.html#t:FromInRule) [ParameterTable](Model-ParameterTable.html#t:ParameterTable)                                                     
  [ToInRule](Data-InRules.html#t:ToInRule) [ParameterTable](Model-ParameterTable.html#t:ParameterTable)                                                         
  [Mapable](Model-General.html#t:Mapable) [ParameterTable](Model-ParameterTable.html#t:ParameterTable)                                                          
  [Database](Model-General.html#t:Database) [Connection](Data-SqlTransaction.html#t:Connection) [ParameterTable](Model-ParameterTable.html#t:ParameterTable)    
  ------------------------------------------------------------------------------------------------------------------------------------------------------------ ---

relation :: [RelationM](Data-Relation.html#t:RelationM)

schema :: [[Char]]

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
