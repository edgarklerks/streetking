=================
Model.RaceDetails
=================

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Model.RaceDetails

Documentation
=============

data RaceDetails

Constructors

RaceDetails

 

Fields

race\_id :: Integer
     
track\_id :: Integer
     
start\_time :: Integer
     
end\_time :: Integer
     
time\_left :: Integer
     
type :: String
     
data :: `RaceDataList <Data-RacingNew.html#t:RaceDataList>`__
     

Instances

+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Eq `RaceDetails <Model-RaceDetails.html#t:RaceDetails>`__                                                                                                    |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Show `RaceDetails <Model-RaceDetails.html#t:RaceDetails>`__                                                                                                  |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| ToJSON `RaceDetails <Model-RaceDetails.html#t:RaceDetails>`__                                                                                                |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| FromJSON `RaceDetails <Model-RaceDetails.html#t:RaceDetails>`__                                                                                              |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Default `RaceDetails <Model-RaceDetails.html#t:RaceDetails>`__                                                                                               |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-InRules.html#t:FromInRule>`__ `RaceDetails <Model-RaceDetails.html#t:RaceDetails>`__                                                       |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `ToInRule <Data-InRules.html#t:ToInRule>`__ `RaceDetails <Model-RaceDetails.html#t:RaceDetails>`__                                                           |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `RaceDetails <Model-RaceDetails.html#t:RaceDetails>`__                                                            |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `RaceDetails <Model-RaceDetails.html#t:RaceDetails>`__   |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+

relation :: `RelationM <Data-Relation.html#t:RelationM>`__

schema :: [[Char]]

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
