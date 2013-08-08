===========
Data.Reward
===========

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Data.Reward

Documentation
=============

newtype Rewards

Constructors

Rewards

 

Fields

unRewards :: [`Reward <Data-Reward.html#t:Reward>`__\ ]
     

Instances

+----------------------------------------------------------------------------------------+-----+
| Show `Rewards <Data-Reward.html#t:Rewards>`__                                          |     |
+----------------------------------------------------------------------------------------+-----+
| `ToInRule <Data-InRules.html#t:ToInRule>`__ `Rewards <Data-Reward.html#t:Rewards>`__   |     |
+----------------------------------------------------------------------------------------+-----+

data Reward

Constructors

Reward

 

Fields

rule :: String
     
name :: String
     
prizes :: [`Prize <Data-Reward.html#t:Prize>`__\ ]
     

Instances

+--------------------------------------------------------------------------------------+-----+
| Show `Reward <Data-Reward.html#t:Reward>`__                                          |     |
+--------------------------------------------------------------------------------------+-----+
| `ToInRule <Data-InRules.html#t:ToInRule>`__ `Reward <Data-Reward.html#t:Reward>`__   |     |
+--------------------------------------------------------------------------------------+-----+

data Prize

Constructors

+----------------------+-----+
| Money Integer        |     |
+----------------------+-----+
| Experience Integer   |     |
+----------------------+-----+

Instances

+------------------------------------------------------------------------------------+-----+
| Show `Prize <Data-Reward.html#t:Prize>`__                                          |     |
+------------------------------------------------------------------------------------+-----+
| `ToInRule <Data-InRules.html#t:ToInRule>`__ `Prize <Data-Reward.html#t:Prize>`__   |     |
+------------------------------------------------------------------------------------+-----+

transform :: `RewardLog <Model-RewardLog.html#t:RewardLog>`__ ->
`Reward <Data-Reward.html#t:Reward>`__

testRewards :: `Rewards <Data-Reward.html#t:Rewards>`__

transformRewards :: [`RewardLog <Model-RewardLog.html#t:RewardLog>`__\ ]
-> `Rewards <Data-Reward.html#t:Rewards>`__

concatRewards :: `Rewards <Data-Reward.html#t:Rewards>`__ ->
`Rewards <Data-Reward.html#t:Rewards>`__

checkRewardLog :: Integer ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ ()

activateRewards :: Integer ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ ()

saveRewardLogEvent :: [Integer] -> [Integer] -> [Integer] -> Integer ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ ()

extractEvent :: [`Event <Data-Event.html#t:Event>`__\ ] -> ([Integer],
[Integer], [Integer])

loadRule :: Integer ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ (String,
`Expr <Data-Decider.html#t:Expr>`__ g
`Symbol <Data-Event.html#t:Symbol>`__, Bool)

runEventStream :: Integer ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ [(String,
Integer, [`Event <Data-Event.html#t:Event>`__\ ])]

testParseRule :: IO ()

optimize :: `Expr <Data-Decider.html#t:Expr>`__ t t1 ->
`Expr <Data-Decider.html#t:Expr>`__ t t1

joinSame :: [`Expr <Data-Decider.html#t:Expr>`__ t t1] ->
[`Expr <Data-Decider.html#t:Expr>`__ t t1]

parseRule :: Parser (`Expr <Data-Decider.html#t:Expr>`__ g
`Symbol <Data-Event.html#t:Symbol>`__)

manyRules :: Parser [`Expr <Data-Decider.html#t:Expr>`__ g
`Symbol <Data-Event.html#t:Symbol>`__]

testMatchRule :: IO ()

matchRule :: Parser (`Expr <Data-Decider.html#t:Expr>`__ g
`Symbol <Data-Event.html#t:Symbol>`__)

fromtoE :: Parser (`Expr <Data-Decider.html#t:Expr>`__ g
`Symbol <Data-Event.html#t:Symbol>`__)

fromE :: Parser (`Expr <Data-Decider.html#t:Expr>`__ g
`Symbol <Data-Event.html#t:Symbol>`__)

toE :: Parser (`Expr <Data-Decider.html#t:Expr>`__ g
`Symbol <Data-Event.html#t:Symbol>`__)

allE :: Parser (`Expr <Data-Decider.html#t:Expr>`__ g
`Symbol <Data-Event.html#t:Symbol>`__)

anyE :: Parser (`Expr <Data-Decider.html#t:Expr>`__ g
`Symbol <Data-Event.html#t:Symbol>`__)

oneE :: Parser (`Expr <Data-Decider.html#t:Expr>`__ g
`Symbol <Data-Event.html#t:Symbol>`__)

matchSymbol :: Parser `Symbol <Data-Event.html#t:Symbol>`__

tournamentI :: Parser `Symbol <Data-Event.html#t:Symbol>`__

tournamentS :: Parser `Symbol <Data-Event.html#t:Symbol>`__

levelI :: Parser `Symbol <Data-Event.html#t:Symbol>`__

raceI :: Parser `Symbol <Data-Event.html#t:Symbol>`__

raceS :: Parser `Symbol <Data-Event.html#t:Symbol>`__

practiceI :: Parser `Symbol <Data-Event.html#t:Symbol>`__

practiceS :: Parser `Symbol <Data-Event.html#t:Symbol>`__

uncurry3 :: (a -> b -> c -> d) -> (a, b, c) -> d

parseTriple :: Parser (Maybe Integer, Maybe Integer, Maybe Integer)

parsePair :: Parser (Maybe Integer, Maybe Integer)

parseArg :: Parser (Maybe Integer)

integer :: Parser Integer

num :: Parser Char

testTournament :: IO ()

eitherToMaybe :: Either a b -> Maybe b

rewardAction :: `Event <Data-Event.html#t:Event>`__ ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__
[`RuleReward <Model-RuleReward.html#t:RuleReward>`__\ ]

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
