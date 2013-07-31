===============
Model.TrackTime
===============

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Model.TrackTime

Documentation
=============

data TrackTime

Constructors

TrackTime

 

Fields

id :: `Id <Model-General.html#t:Id>`__
     
account\_id :: Integer
     
track\_id :: Integer
     
time :: Double
     

Instances

+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Eq `TrackTime <Model-TrackTime.html#t:TrackTime>`__                                                                                                    |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Show `TrackTime <Model-TrackTime.html#t:TrackTime>`__                                                                                                  |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| ToJSON `TrackTime <Model-TrackTime.html#t:TrackTime>`__                                                                                                |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| FromJSON `TrackTime <Model-TrackTime.html#t:TrackTime>`__                                                                                              |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Default `TrackTime <Model-TrackTime.html#t:TrackTime>`__                                                                                               |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-InRules.html#t:FromInRule>`__ `TrackTime <Model-TrackTime.html#t:TrackTime>`__                                                       |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `ToInRule <Data-InRules.html#t:ToInRule>`__ `TrackTime <Model-TrackTime.html#t:TrackTime>`__                                                           |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `TrackTime <Model-TrackTime.html#t:TrackTime>`__                                                            |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `TrackTime <Model-TrackTime.html#t:TrackTime>`__   |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+

relation :: `RelationM <Data-Relation.html#t:RelationM>`__

schema :: [[Char]]

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
