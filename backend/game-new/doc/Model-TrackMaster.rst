=================
Model.TrackMaster
=================

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Model.TrackMaster

Documentation
=============

data TrackMaster

Constructors

TrackMaster

 

Fields

track\_id :: Integer
     
track\_name :: String
     
track\_data :: String
     
track\_level :: Integer
     
city\_id :: Integer
     
city\_name :: String
     
city\_data :: String
     
continent\_id :: Integer
     
continent\_name :: String
     
continent\_data :: String
     
length :: Double
     
energy\_cost :: Integer
     
top\_time\_exists :: Bool
     
top\_time :: Double
     
top\_time\_id :: Integer
     
top\_time\_account\_id :: Integer
     
top\_time\_name :: String
     
top\_time\_picture\_small :: String
     
top\_time\_picture\_medium :: String
     
top\_time\_picture\_large :: String
     

Instances

+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Eq `TrackMaster <Model-TrackMaster.html#t:TrackMaster>`__                                                                                                    |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Show `TrackMaster <Model-TrackMaster.html#t:TrackMaster>`__                                                                                                  |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| ToJSON `TrackMaster <Model-TrackMaster.html#t:TrackMaster>`__                                                                                                |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| FromJSON `TrackMaster <Model-TrackMaster.html#t:TrackMaster>`__                                                                                              |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Default `TrackMaster <Model-TrackMaster.html#t:TrackMaster>`__                                                                                               |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-InRules.html#t:FromInRule>`__ `TrackMaster <Model-TrackMaster.html#t:TrackMaster>`__                                                       |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `ToInRule <Data-InRules.html#t:ToInRule>`__ `TrackMaster <Model-TrackMaster.html#t:TrackMaster>`__                                                           |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `TrackMaster <Model-TrackMaster.html#t:TrackMaster>`__                                                            |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `TrackMaster <Model-TrackMaster.html#t:TrackMaster>`__   |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+

relation :: `RelationM <Data-Relation.html#t:RelationM>`__

schema :: [[Char]]

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
