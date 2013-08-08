================
Model.Tournament
================

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Model.Tournament

Documentation
=============

type MRaceReward = Maybe
`RaceRewards <Data-RaceReward.html#t:RaceRewards>`__

type MInteger = Maybe Integer

type MString = Maybe String

data Tournament

Constructors

Tournament

 

Fields

id :: `Id <Model-General.html#t:Id>`__
     
car\_id :: `Id <Model-General.html#t:Id>`__
     
start\_time :: `MInteger <Model-Tournament.html#t:MInteger>`__
     
costs :: Integer
     
minlevel :: Integer
     
maxlevel :: Integer
     
rewards :: `MRaceReward <Model-Tournament.html#t:MRaceReward>`__
     
track\_id :: Integer
     
players :: Integer
     
name :: String
     
done :: Bool
     
running :: Bool
     
image :: String
     
tournament\_type\_id :: Integer
     
tournament\_prices :: `MString <Model-Tournament.html#t:MString>`__
     

Instances

+-----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Eq `Tournament <Model-Tournament.html#t:Tournament>`__                                                                                                    |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Show `Tournament <Model-Tournament.html#t:Tournament>`__                                                                                                  |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| ToJSON `Tournament <Model-Tournament.html#t:Tournament>`__                                                                                                |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| FromJSON `Tournament <Model-Tournament.html#t:Tournament>`__                                                                                              |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Default `Tournament <Model-Tournament.html#t:Tournament>`__                                                                                               |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-InRules.html#t:FromInRule>`__ `Tournament <Model-Tournament.html#t:Tournament>`__                                                       |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `ToInRule <Data-InRules.html#t:ToInRule>`__ `Tournament <Model-Tournament.html#t:Tournament>`__                                                           |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `Tournament <Model-Tournament.html#t:Tournament>`__                                                            |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `Tournament <Model-Tournament.html#t:Tournament>`__   |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+

relation :: `RelationM <Data-Relation.html#t:RelationM>`__

schema :: [[Char]]

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
