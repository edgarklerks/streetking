-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Model.PersonnelInstanceDetails

Documentation
=============

type MInteger = Maybe Integer

data PersonnelInstanceDetails

Constructors

PersonnelInstanceDetails

 

Fields

personnel\_instance\_id :: [Id](Model-General.html#t:Id)  
 

personnel\_id :: [Id](Model-General.html#t:Id)  
 

garage\_id :: [Id](Model-General.html#t:Id)  
 

name :: String  
 

country\_name :: String  
 

country\_shortname :: String  
 

gender :: Bool  
 

picture :: String  
 

salary :: Integer  
 

skill\_repair :: Integer  
 

skill\_engineering :: Integer  
 

training\_cost\_repair :: Integer  
 

training\_cost\_engineering :: Integer  
 

task\_id :: Integer  
 

task\_name :: String  
 

task\_started :: Integer  
 

task\_end :: Integer  
 

task\_updated :: Integer  
 

task\_time\_left :: Integer  
 

task\_subject\_id :: Integer  
 

paid\_until :: Integer  
 

Instances

||
|Eq [PersonnelInstanceDetails](Model-PersonnelInstanceDetails.html#t:PersonnelInstanceDetails)| |
|Show [PersonnelInstanceDetails](Model-PersonnelInstanceDetails.html#t:PersonnelInstanceDetails)| |
|ToJSON [PersonnelInstanceDetails](Model-PersonnelInstanceDetails.html#t:PersonnelInstanceDetails)| |
|FromJSON [PersonnelInstanceDetails](Model-PersonnelInstanceDetails.html#t:PersonnelInstanceDetails)| |
|Default [PersonnelInstanceDetails](Model-PersonnelInstanceDetails.html#t:PersonnelInstanceDetails)| |
|[FromInRule](Data-InRules.html#t:FromInRule) [PersonnelInstanceDetails](Model-PersonnelInstanceDetails.html#t:PersonnelInstanceDetails)| |
|[ToInRule](Data-InRules.html#t:ToInRule) [PersonnelInstanceDetails](Model-PersonnelInstanceDetails.html#t:PersonnelInstanceDetails)| |
|[Mapable](Model-General.html#t:Mapable) [PersonnelInstanceDetails](Model-PersonnelInstanceDetails.html#t:PersonnelInstanceDetails)| |
|[Database](Model-General.html#t:Database) [Connection](Data-SqlTransaction.html#t:Connection) [PersonnelInstanceDetails](Model-PersonnelInstanceDetails.html#t:PersonnelInstanceDetails)| |

relation :: [RelationM](Data-Relation.html#t:RelationM)

schema :: [[Char]]

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
