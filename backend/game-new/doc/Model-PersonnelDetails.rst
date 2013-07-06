======================
Model.PersonnelDetails
======================

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

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

personnel\_id :: `Id <Model-General.html#t:Id>`__
     
name :: String
     
country\_name :: String
     
country\_shortname :: String
     
gender :: Bool
     
picture :: String
     
salary :: Integer
     
price :: Integer
     
skill\_repair :: Integer
     
skill\_engineering :: Integer
     
sort :: Integer
     

Instances

+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Eq `PersonnelDetails <Model-PersonnelDetails.html#t:PersonnelDetails>`__                                                                                                    |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Show `PersonnelDetails <Model-PersonnelDetails.html#t:PersonnelDetails>`__                                                                                                  |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| ToJSON `PersonnelDetails <Model-PersonnelDetails.html#t:PersonnelDetails>`__                                                                                                |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| FromJSON `PersonnelDetails <Model-PersonnelDetails.html#t:PersonnelDetails>`__                                                                                              |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Default `PersonnelDetails <Model-PersonnelDetails.html#t:PersonnelDetails>`__                                                                                               |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-InRules.html#t:FromInRule>`__ `PersonnelDetails <Model-PersonnelDetails.html#t:PersonnelDetails>`__                                                       |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `ToInRule <Data-InRules.html#t:ToInRule>`__ `PersonnelDetails <Model-PersonnelDetails.html#t:PersonnelDetails>`__                                                           |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `PersonnelDetails <Model-PersonnelDetails.html#t:PersonnelDetails>`__                                                            |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `PersonnelDetails <Model-PersonnelDetails.html#t:PersonnelDetails>`__   |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+

relation :: `RelationM <Data-Relation.html#t:RelationM>`__

schema :: [[Char]]

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
