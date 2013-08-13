==============================
Model.PersonnelInstanceDetails
==============================

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

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

personnel\_instance\_id :: `Id <Model-General.html#t:Id>`__
     
personnel\_id :: `Id <Model-General.html#t:Id>`__
     
garage\_id :: `Id <Model-General.html#t:Id>`__
     
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

+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Eq `PersonnelInstanceDetails <Model-PersonnelInstanceDetails.html#t:PersonnelInstanceDetails>`__                                                                                                    |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Show `PersonnelInstanceDetails <Model-PersonnelInstanceDetails.html#t:PersonnelInstanceDetails>`__                                                                                                  |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| ToJSON `PersonnelInstanceDetails <Model-PersonnelInstanceDetails.html#t:PersonnelInstanceDetails>`__                                                                                                |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| FromJSON `PersonnelInstanceDetails <Model-PersonnelInstanceDetails.html#t:PersonnelInstanceDetails>`__                                                                                              |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Default `PersonnelInstanceDetails <Model-PersonnelInstanceDetails.html#t:PersonnelInstanceDetails>`__                                                                                               |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-InRules.html#t:FromInRule>`__ `PersonnelInstanceDetails <Model-PersonnelInstanceDetails.html#t:PersonnelInstanceDetails>`__                                                       |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `ToInRule <Data-InRules.html#t:ToInRule>`__ `PersonnelInstanceDetails <Model-PersonnelInstanceDetails.html#t:PersonnelInstanceDetails>`__                                                           |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `PersonnelInstanceDetails <Model-PersonnelInstanceDetails.html#t:PersonnelInstanceDetails>`__                                                            |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `PersonnelInstanceDetails <Model-PersonnelInstanceDetails.html#t:PersonnelInstanceDetails>`__   |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+

relation :: `RelationM <Data-Relation.html#t:RelationM>`__

schema :: [[Char]]

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
