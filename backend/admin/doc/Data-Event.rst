==========
Data.Event
==========

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Data.Event

Documentation
=============

data Symbol where

Constructors

+-----------------------------------------------------------------------------------------------------------+-----+
| TournamentI :: Maybe Integer -> Maybe Integer -> Maybe Integer -> `Symbol <Data-Event.html#t:Symbol>`__   |     |
+-----------------------------------------------------------------------------------------------------------+-----+
| LevelI :: Integer -> `Symbol <Data-Event.html#t:Symbol>`__                                                |     |
+-----------------------------------------------------------------------------------------------------------+-----+
| RaceI :: Maybe Integer -> Maybe Integer -> `Symbol <Data-Event.html#t:Symbol>`__                          |     |
+-----------------------------------------------------------------------------------------------------------+-----+
| PracticeI :: Maybe Integer -> `Symbol <Data-Event.html#t:Symbol>`__                                       |     |
+-----------------------------------------------------------------------------------------------------------+-----+

Instances

+-------------------------------------------------------------------------------------------------------------------------+-----+
| Show `Symbol <Data-Event.html#t:Symbol>`__                                                                              |     |
+-------------------------------------------------------------------------------------------------------------------------+-----+
| `Evaluate <Data-Decider.html#t:Evaluate>`__ `Event <Data-Event.html#t:Event>`__ `Symbol <Data-Event.html#t:Symbol>`__   |     |
+-------------------------------------------------------------------------------------------------------------------------+-----+

matchEvent :: `Expr <Data-Decider.html#t:Expr>`__ g
`Symbol <Data-Event.html#t:Symbol>`__ ->
[`Event <Data-Event.html#t:Event>`__\ ] ->
([`Event <Data-Event.html#t:Event>`__\ ], Bool)

eventDecider :: `Expr <Data-Decider.html#t:Expr>`__ g
`Symbol <Data-Event.html#t:Symbol>`__ ->
`Decider <Data-Decider.html#t:Decider>`__
`Event <Data-Event.html#t:Event>`__

data Event where

Constructors

+--------------------------------------------------------------------------------------+-----+
| Tournament :: Integer -> Integer -> Integer -> `Event <Data-Event.html#t:Event>`__   |     |
+--------------------------------------------------------------------------------------+-----+
| PracticeRace :: Integer -> `Event <Data-Event.html#t:Event>`__                       |     |
+--------------------------------------------------------------------------------------+-----+
| ChallengeRace :: Integer -> Integer -> `Event <Data-Event.html#t:Event>`__           |     |
+--------------------------------------------------------------------------------------+-----+
| Level :: Integer -> `Event <Data-Event.html#t:Event>`__                              |     |
+--------------------------------------------------------------------------------------+-----+

Instances

+-------------------------------------------------------------------------------------------------------------------------+-----+
| Eq `Event <Data-Event.html#t:Event>`__                                                                                  |     |
+-------------------------------------------------------------------------------------------------------------------------+-----+
| Show `Event <Data-Event.html#t:Event>`__                                                                                |     |
+-------------------------------------------------------------------------------------------------------------------------+-----+
| ToJSON `Event <Data-Event.html#t:Event>`__                                                                              |     |
+-------------------------------------------------------------------------------------------------------------------------+-----+
| FromJSON `Event <Data-Event.html#t:Event>`__                                                                            |     |
+-------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-InRules.html#t:FromInRule>`__ `Event <Data-Event.html#t:Event>`__                                     |     |
+-------------------------------------------------------------------------------------------------------------------------+-----+
| `ToInRule <Data-InRules.html#t:ToInRule>`__ `Event <Data-Event.html#t:Event>`__                                         |     |
+-------------------------------------------------------------------------------------------------------------------------+-----+
| `Evaluate <Data-Decider.html#t:Evaluate>`__ `Event <Data-Event.html#t:Event>`__ `Symbol <Data-Event.html#t:Symbol>`__   |     |
+-------------------------------------------------------------------------------------------------------------------------+-----+

toInt :: Value -> Integer

cmp :: Eq a => Maybe a -> a -> Bool

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
