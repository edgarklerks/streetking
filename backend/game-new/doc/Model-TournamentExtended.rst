========================
Model.TournamentExtended
========================

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Model.TournamentExtended

Documentation
=============

type MRaceReward = Maybe
`RaceRewards <Data-RaceReward.html#t:RaceRewards>`__

type MInteger = Maybe Integer

data TournamentExtended

Constructors

TournamentExtended

 

Fields

id :: `Id <Model-General.html#t:Id>`__
     
car\_id :: `Id <Model-General.html#t:Id>`__
     
start\_time :: `MInteger <Model-TournamentExtended.html#t:MInteger>`__
     
costs :: Integer
     
minlevel :: Integer
     
maxlevel :: Integer
     
rewards :: `MRaceReward <Model-TournamentExtended.html#t:MRaceReward>`__
     
track\_id :: Integer
     
players :: Integer
     
name :: String
     
current\_players :: Integer
     
done :: Bool
     
running :: Bool
     
tournament\_type\_id :: Integer
     
tournament\_type :: String
     

Instances

+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Eq `TournamentExtended <Model-TournamentExtended.html#t:TournamentExtended>`__                                                                                                    |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Show `TournamentExtended <Model-TournamentExtended.html#t:TournamentExtended>`__                                                                                                  |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| ToJSON `TournamentExtended <Model-TournamentExtended.html#t:TournamentExtended>`__                                                                                                |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| FromJSON `TournamentExtended <Model-TournamentExtended.html#t:TournamentExtended>`__                                                                                              |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Default `TournamentExtended <Model-TournamentExtended.html#t:TournamentExtended>`__                                                                                               |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-InRules.html#t:FromInRule>`__ `TournamentExtended <Model-TournamentExtended.html#t:TournamentExtended>`__                                                       |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `ToInRule <Data-InRules.html#t:ToInRule>`__ `TournamentExtended <Model-TournamentExtended.html#t:TournamentExtended>`__                                                           |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `TournamentExtended <Model-TournamentExtended.html#t:TournamentExtended>`__                                                            |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `TournamentExtended <Model-TournamentExtended.html#t:TournamentExtended>`__   |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+

relation :: `RelationM <Data-Relation.html#t:RelationM>`__

schema :: [[Char]]

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
