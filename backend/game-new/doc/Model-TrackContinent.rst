====================
Model.TrackContinent
====================

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Model.TrackContinent

Documentation
=============

data TrackContinent

Constructors

TrackContinent

 

Fields

continent\_id :: Integer
     
continent\_name :: String
     
continent\_data :: String
     
continent\_level :: Integer
     
continent\_tracks :: Integer
     

Instances

+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Eq `TrackContinent <Model-TrackContinent.html#t:TrackContinent>`__                                                                                                    |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Show `TrackContinent <Model-TrackContinent.html#t:TrackContinent>`__                                                                                                  |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| ToJSON `TrackContinent <Model-TrackContinent.html#t:TrackContinent>`__                                                                                                |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| FromJSON `TrackContinent <Model-TrackContinent.html#t:TrackContinent>`__                                                                                              |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Default `TrackContinent <Model-TrackContinent.html#t:TrackContinent>`__                                                                                               |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-InRules.html#t:FromInRule>`__ `TrackContinent <Model-TrackContinent.html#t:TrackContinent>`__                                                       |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `ToInRule <Data-InRules.html#t:ToInRule>`__ `TrackContinent <Model-TrackContinent.html#t:TrackContinent>`__                                                           |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `TrackContinent <Model-TrackContinent.html#t:TrackContinent>`__                                                            |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `TrackContinent <Model-TrackContinent.html#t:TrackContinent>`__   |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+

relation :: `RelationM <Data-Relation.html#t:RelationM>`__

schema :: [[Char]]

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
