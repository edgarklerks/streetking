% Model.PersonnelInstance
% 
% 

-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Model.PersonnelInstance

Documentation
=============

type MInteger = Maybe Integer

data PersonnelInstance

Constructors

PersonnelInstance

 

Fields

id :: [Id](Model-General.html#t:Id)
:    
personnel\_id :: [MInteger](Model-PersonnelInstance.html#t:MInteger)
:    
garage\_id :: Integer
:    
skill\_repair :: Integer
:    
skill\_engineering :: Integer
:    
training\_cost\_repair :: Integer
:    
training\_cost\_engineering :: Integer
:    
salary :: Integer
:    
paid\_until :: Integer
:    
task\_id :: Integer
:    
task\_started :: Integer
:    
task\_end :: Integer
:    
task\_updated :: Integer
:    
task\_subject\_id :: Integer
:    
deleted :: Bool
:    

Instances

  --------------------------------------------------------------------------------------------------------------------------------------------------------------------- ---
  Eq [PersonnelInstance](Model-PersonnelInstance.html#t:PersonnelInstance)                                                                                               
  Show [PersonnelInstance](Model-PersonnelInstance.html#t:PersonnelInstance)                                                                                             
  ToJSON [PersonnelInstance](Model-PersonnelInstance.html#t:PersonnelInstance)                                                                                           
  FromJSON [PersonnelInstance](Model-PersonnelInstance.html#t:PersonnelInstance)                                                                                         
  Default [PersonnelInstance](Model-PersonnelInstance.html#t:PersonnelInstance)                                                                                          
  [FromInRule](Data-InRules.html#t:FromInRule) [PersonnelInstance](Model-PersonnelInstance.html#t:PersonnelInstance)                                                     
  [ToInRule](Data-InRules.html#t:ToInRule) [PersonnelInstance](Model-PersonnelInstance.html#t:PersonnelInstance)                                                         
  [Mapable](Model-General.html#t:Mapable) [PersonnelInstance](Model-PersonnelInstance.html#t:PersonnelInstance)                                                          
  [Database](Model-General.html#t:Database) [Connection](Data-SqlTransaction.html#t:Connection) [PersonnelInstance](Model-PersonnelInstance.html#t:PersonnelInstance)    
  --------------------------------------------------------------------------------------------------------------------------------------------------------------------- ---

relation :: [RelationM](Data-Relation.html#t:RelationM)

schema :: [[Char]]

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
