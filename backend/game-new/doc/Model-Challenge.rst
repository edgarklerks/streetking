===============
Model.Challenge
===============

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Model.Challenge

Documentation
=============

type MInteger = Maybe Integer

data Challenge

Constructors

Challenge

 

Fields

id :: `Id <Model-General.html#t:Id>`__
     
account\_id :: Integer
     
track\_id :: Integer
     
participants :: Integer
     
type :: Integer
     
account\_min ::
`AccountProfileMin <Model-AccountProfileMin.html#t:AccountProfileMin>`__
     
car\_min :: `CarMinimal <Model-CarMinimal.html#t:CarMinimal>`__
     
challenger ::
`RaceParticipant <Data-RaceParticipant.html#t:RaceParticipant>`__
     
deleted :: Bool
     
amount :: Integer
     

Instances

+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Eq `Challenge <Model-Challenge.html#t:Challenge>`__                                                                                                    |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Show `Challenge <Model-Challenge.html#t:Challenge>`__                                                                                                  |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| ToJSON `Challenge <Model-Challenge.html#t:Challenge>`__                                                                                                |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| FromJSON `Challenge <Model-Challenge.html#t:Challenge>`__                                                                                              |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Default `Challenge <Model-Challenge.html#t:Challenge>`__                                                                                               |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-InRules.html#t:FromInRule>`__ `Challenge <Model-Challenge.html#t:Challenge>`__                                                       |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `ToInRule <Data-InRules.html#t:ToInRule>`__ `Challenge <Model-Challenge.html#t:Challenge>`__                                                           |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `Challenge <Model-Challenge.html#t:Challenge>`__                                                            |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `Challenge <Model-Challenge.html#t:Challenge>`__   |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+

relation :: `RelationM <Data-Relation.html#t:RelationM>`__

schema :: [[Char]]

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
