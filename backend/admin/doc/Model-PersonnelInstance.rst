=======================
Model.PersonnelInstance
=======================

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

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

id :: `Id <Model-General.html#t:Id>`__
     
personnel\_id :: `MInteger <Model-PersonnelInstance.html#t:MInteger>`__
     
garage\_id :: Integer
     
skill\_repair :: Integer
     
skill\_engineering :: Integer
     
training\_cost\_repair :: Integer
     
training\_cost\_engineering :: Integer
     
salary :: Integer
     
paid\_until :: Integer
     
task\_id :: Integer
     
task\_started :: Integer
     
task\_end :: Integer
     
task\_updated :: Integer
     
task\_subject\_id :: Integer
     
deleted :: Bool
     

Instances

+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Eq `PersonnelInstance <Model-PersonnelInstance.html#t:PersonnelInstance>`__                                                                                                    |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Show `PersonnelInstance <Model-PersonnelInstance.html#t:PersonnelInstance>`__                                                                                                  |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| ToJSON `PersonnelInstance <Model-PersonnelInstance.html#t:PersonnelInstance>`__                                                                                                |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| FromJSON `PersonnelInstance <Model-PersonnelInstance.html#t:PersonnelInstance>`__                                                                                              |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Default `PersonnelInstance <Model-PersonnelInstance.html#t:PersonnelInstance>`__                                                                                               |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-InRules.html#t:FromInRule>`__ `PersonnelInstance <Model-PersonnelInstance.html#t:PersonnelInstance>`__                                                       |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `ToInRule <Data-InRules.html#t:ToInRule>`__ `PersonnelInstance <Model-PersonnelInstance.html#t:PersonnelInstance>`__                                                           |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `PersonnelInstance <Model-PersonnelInstance.html#t:PersonnelInstance>`__                                                            |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `PersonnelInstance <Model-PersonnelInstance.html#t:PersonnelInstance>`__   |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+

relation :: `RelationM <Data-Relation.html#t:RelationM>`__

schema :: [[Char]]

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
