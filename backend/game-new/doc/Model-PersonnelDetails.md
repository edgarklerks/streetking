% Model.PersonnelDetails
% 
% 

-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Model.PersonnelDetails

Documentation
=============

type MInteger = Maybe Integer

data PersonnelDetails

Constructors

PersonnelDetails

 

Fields

personnel\_id :: [Id](Model-General.html#t:Id)
:    
name :: String
:    
country\_name :: String
:    
country\_shortname :: String
:    
gender :: Bool
:    
picture :: String
:    
salary :: Integer
:    
price :: Integer
:    
skill\_repair :: Integer
:    
skill\_engineering :: Integer
:    
sort :: Integer
:    

Instances

  ------------------------------------------------------------------------------------------------------------------------------------------------------------------ ---
  Eq [PersonnelDetails](Model-PersonnelDetails.html#t:PersonnelDetails)                                                                                               
  Show [PersonnelDetails](Model-PersonnelDetails.html#t:PersonnelDetails)                                                                                             
  ToJSON [PersonnelDetails](Model-PersonnelDetails.html#t:PersonnelDetails)                                                                                           
  FromJSON [PersonnelDetails](Model-PersonnelDetails.html#t:PersonnelDetails)                                                                                         
  Default [PersonnelDetails](Model-PersonnelDetails.html#t:PersonnelDetails)                                                                                          
  [FromInRule](Data-InRules.html#t:FromInRule) [PersonnelDetails](Model-PersonnelDetails.html#t:PersonnelDetails)                                                     
  [ToInRule](Data-InRules.html#t:ToInRule) [PersonnelDetails](Model-PersonnelDetails.html#t:PersonnelDetails)                                                         
  [Mapable](Model-General.html#t:Mapable) [PersonnelDetails](Model-PersonnelDetails.html#t:PersonnelDetails)                                                          
  [Database](Model-General.html#t:Database) [Connection](Data-SqlTransaction.html#t:Connection) [PersonnelDetails](Model-PersonnelDetails.html#t:PersonnelDetails)    
  ------------------------------------------------------------------------------------------------------------------------------------------------------------------ ---

relation :: [RelationM](Data-Relation.html#t:RelationM)

schema :: [[Char]]

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
