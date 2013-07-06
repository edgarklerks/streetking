-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Model.PersonnelReport

Documentation
=============

type MInteger = Maybe Integer

type MString = Maybe String

type MBool = Maybe Bool

data PersonnelReport

Constructors

PersonnelReport

 

Fields

id :: [Id](Model-General.html#t:Id)  
 

account\_id :: Integer  
 

time :: Integer  
 

report\_type\_id :: Integer  
 

report\_type :: String  
 

report\_descriptor :: String  
 

personnel\_instance\_id :: [MInteger](Model-PersonnelReport.html#t:MInteger)  
 

part\_instance\_id :: [MInteger](Model-PersonnelReport.html#t:MInteger)  
 

cost :: [MInteger](Model-PersonnelReport.html#t:MInteger)  
 

result :: String  
 

data :: [MString](Model-PersonnelReport.html#t:MString)  
 

personnel\_id :: [Id](Model-General.html#t:Id)  
 

name :: [MString](Model-PersonnelReport.html#t:MString)  
 

country\_name :: [MString](Model-PersonnelReport.html#t:MString)  
 

country\_shortname :: [MString](Model-PersonnelReport.html#t:MString)  
 

gender :: [MBool](Model-PersonnelReport.html#t:MBool)  
 

picture :: [MString](Model-PersonnelReport.html#t:MString)  
 

salary :: [MInteger](Model-PersonnelReport.html#t:MInteger)  
 

price :: [MInteger](Model-PersonnelReport.html#t:MInteger)  
 

skill\_repair :: [MInteger](Model-PersonnelReport.html#t:MInteger)  
 

skill\_engineering :: [MInteger](Model-PersonnelReport.html#t:MInteger)  
 

sort :: [MInteger](Model-PersonnelReport.html#t:MInteger)  
 

type :: [MString](Model-PersonnelReport.html#t:MString)  
 

Instances

||
|Eq [PersonnelReport](Model-PersonnelReport.html#t:PersonnelReport)| |
|Show [PersonnelReport](Model-PersonnelReport.html#t:PersonnelReport)| |
|ToJSON [PersonnelReport](Model-PersonnelReport.html#t:PersonnelReport)| |
|FromJSON [PersonnelReport](Model-PersonnelReport.html#t:PersonnelReport)| |
|Default [PersonnelReport](Model-PersonnelReport.html#t:PersonnelReport)| |
|[FromInRule](Data-InRules.html#t:FromInRule) [PersonnelReport](Model-PersonnelReport.html#t:PersonnelReport)| |
|[ToInRule](Data-InRules.html#t:ToInRule) [PersonnelReport](Model-PersonnelReport.html#t:PersonnelReport)| |
|[Mapable](Model-General.html#t:Mapable) [PersonnelReport](Model-PersonnelReport.html#t:PersonnelReport)| |
|[Database](Model-General.html#t:Database) [Connection](Data-SqlTransaction.html#t:Connection) [PersonnelReport](Model-PersonnelReport.html#t:PersonnelReport)| |

relation :: [RelationM](Data-Relation.html#t:RelationM)

schema :: [[Char]]

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
