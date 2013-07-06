=======================
Model.ChallengeExtended
=======================

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Model.ChallengeExtended

Documentation
=============

data ChallengeExtended

Constructors

ChallengeExtended

 

Fields

challenge\_id :: Integer
     
account\_id :: Integer
     
track\_id :: Integer
     
participants :: Integer
     
type\_id :: Integer
     
type :: String
     
accepts :: Integer
     
user\_nickname :: String
     
user\_level :: Integer
     
track\_name :: String
     
track\_level :: Integer
     
city\_id :: Integer
     
city\_name :: String
     
continent\_id :: Integer
     
continent\_name :: String
     
track\_length :: Double
     
top\_time\_exists :: Bool
     
top\_time :: Double
     
top\_time\_id :: Integer
     
top\_time\_account\_id :: Integer
     
top\_time\_name :: String
     
top\_time\_picture\_small :: String
     
top\_time\_picture\_medium :: String
     
top\_time\_picture\_large :: String
     
amount :: Integer
     
profile ::
`AccountProfileMin <Model-AccountProfileMin.html#t:AccountProfileMin>`__
     
car :: `CarMinimal <Model-CarMinimal.html#t:CarMinimal>`__
     
deleted :: Bool
     

Instances

+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Eq `ChallengeExtended <Model-ChallengeExtended.html#t:ChallengeExtended>`__                                                                                                    |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Show `ChallengeExtended <Model-ChallengeExtended.html#t:ChallengeExtended>`__                                                                                                  |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| ToJSON `ChallengeExtended <Model-ChallengeExtended.html#t:ChallengeExtended>`__                                                                                                |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| FromJSON `ChallengeExtended <Model-ChallengeExtended.html#t:ChallengeExtended>`__                                                                                              |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Default `ChallengeExtended <Model-ChallengeExtended.html#t:ChallengeExtended>`__                                                                                               |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-InRules.html#t:FromInRule>`__ `ChallengeExtended <Model-ChallengeExtended.html#t:ChallengeExtended>`__                                                       |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `ToInRule <Data-InRules.html#t:ToInRule>`__ `ChallengeExtended <Model-ChallengeExtended.html#t:ChallengeExtended>`__                                                           |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `ChallengeExtended <Model-ChallengeExtended.html#t:ChallengeExtended>`__                                                            |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `ChallengeExtended <Model-ChallengeExtended.html#t:ChallengeExtended>`__   |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+

relation :: `RelationM <Data-Relation.html#t:RelationM>`__

schema :: [[Char]]

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
