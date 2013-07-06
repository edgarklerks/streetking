==================
Model.TravelReport
==================

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Model.TravelReport

Documentation
=============

type MInteger = Maybe Integer

type MString = Maybe String

type MBool = Maybe Bool

data TravelReport

Constructors

TravelReport

 

Fields

id :: `Id <Model-General.html#t:Id>`__
     
account\_id :: Integer
     
time :: Integer
     
report\_type\_id :: Integer
     
report\_descriptor :: String
     
city\_to :: String
     
city\_from :: String
     
continent\_to :: `MString <Model-TravelReport.html#t:MString>`__
     
continent\_from :: `MString <Model-TravelReport.html#t:MString>`__
     

Instances

+-----------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Eq `TravelReport <Model-TravelReport.html#t:TravelReport>`__                                                                                                    |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Show `TravelReport <Model-TravelReport.html#t:TravelReport>`__                                                                                                  |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| ToJSON `TravelReport <Model-TravelReport.html#t:TravelReport>`__                                                                                                |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| FromJSON `TravelReport <Model-TravelReport.html#t:TravelReport>`__                                                                                              |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Default `TravelReport <Model-TravelReport.html#t:TravelReport>`__                                                                                               |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-InRules.html#t:FromInRule>`__ `TravelReport <Model-TravelReport.html#t:TravelReport>`__                                                       |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `ToInRule <Data-InRules.html#t:ToInRule>`__ `TravelReport <Model-TravelReport.html#t:TravelReport>`__                                                           |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `TravelReport <Model-TravelReport.html#t:TravelReport>`__                                                            |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `TravelReport <Model-TravelReport.html#t:TravelReport>`__   |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+

relation :: `RelationM <Data-Relation.html#t:RelationM>`__

schema :: [[Char]]

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
