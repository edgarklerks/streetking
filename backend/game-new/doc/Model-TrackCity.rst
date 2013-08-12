===============
Model.TrackCity
===============

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Model.TrackCity

Documentation
=============

data TrackCity

Constructors

TrackCity

 

Fields

city\_id :: Integer
     
city\_name :: String
     
city\_data :: String
     
city\_level :: Integer
     
city\_tracks :: Integer
     
continent\_id :: Integer
     
continent\_name :: String
     
continent\_data :: String
     

Instances

+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Eq `TrackCity <Model-TrackCity.html#t:TrackCity>`__                                                                                                    |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Show `TrackCity <Model-TrackCity.html#t:TrackCity>`__                                                                                                  |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| ToJSON `TrackCity <Model-TrackCity.html#t:TrackCity>`__                                                                                                |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| FromJSON `TrackCity <Model-TrackCity.html#t:TrackCity>`__                                                                                              |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Default `TrackCity <Model-TrackCity.html#t:TrackCity>`__                                                                                               |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-InRules.html#t:FromInRule>`__ `TrackCity <Model-TrackCity.html#t:TrackCity>`__                                                       |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `ToInRule <Data-InRules.html#t:ToInRule>`__ `TrackCity <Model-TrackCity.html#t:TrackCity>`__                                                           |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `TrackCity <Model-TrackCity.html#t:TrackCity>`__                                                            |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `TrackCity <Model-TrackCity.html#t:TrackCity>`__   |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+

relation :: `RelationM <Data-Relation.html#t:RelationM>`__

schema :: [[Char]]

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
