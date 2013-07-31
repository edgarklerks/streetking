==================
Model.TrackDetails
==================

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Model.TrackDetails

Documentation
=============

data TrackDetails

Constructors

TrackDetails

 

Fields

id :: `Id <Model-General.html#t:Id>`__
     
track\_id :: Integer
     
radius :: Double
     
length :: Double
     
segment :: String
     

Instances

+-----------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Eq `TrackDetails <Model-TrackDetails.html#t:TrackDetails>`__                                                                                                    |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Show `TrackDetails <Model-TrackDetails.html#t:TrackDetails>`__                                                                                                  |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| ToJSON `TrackDetails <Model-TrackDetails.html#t:TrackDetails>`__                                                                                                |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| FromJSON `TrackDetails <Model-TrackDetails.html#t:TrackDetails>`__                                                                                              |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Default `TrackDetails <Model-TrackDetails.html#t:TrackDetails>`__                                                                                               |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-InRules.html#t:FromInRule>`__ `TrackDetails <Model-TrackDetails.html#t:TrackDetails>`__                                                       |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `ToInRule <Data-InRules.html#t:ToInRule>`__ `TrackDetails <Model-TrackDetails.html#t:TrackDetails>`__                                                           |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `TrackDetails <Model-TrackDetails.html#t:TrackDetails>`__                                                            |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `TrackDetails <Model-TrackDetails.html#t:TrackDetails>`__   |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+

relation :: `RelationM <Data-Relation.html#t:RelationM>`__

schema :: [[Char]]

type TrackDetailss =
[`TrackDetails <Model-TrackDetails.html#t:TrackDetails>`__\ ]

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
