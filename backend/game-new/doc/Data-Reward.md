-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Data.Reward

Documentation
=============

newtype Rewards

Constructors

Rewards

 

Fields

unRewards :: [[Reward](Data-Reward.html#t:Reward)]  
 

Instances

||
|Show [Rewards](Data-Reward.html#t:Rewards)| |
|[ToInRule](Data-InRules.html#t:ToInRule) [Rewards](Data-Reward.html#t:Rewards)| |

data Reward

Constructors

Reward

 

Fields

rule :: String  
 

name :: String  
 

prizes :: [[Prize](Data-Reward.html#t:Prize)]  
 

Instances

||
|Show [Reward](Data-Reward.html#t:Reward)| |
|[ToInRule](Data-InRules.html#t:ToInRule) [Reward](Data-Reward.html#t:Reward)| |

data Prize

Constructors

||
|Money Integer| |
|Experience Integer| |

Instances

||
|Show [Prize](Data-Reward.html#t:Prize)| |
|[ToInRule](Data-InRules.html#t:ToInRule) [Prize](Data-Reward.html#t:Prize)| |

transform :: [RewardLog](Model-RewardLog.html#t:RewardLog) -\> [Reward](Data-Reward.html#t:Reward)

testRewards :: [Rewards](Data-Reward.html#t:Rewards)

transformRewards :: [[RewardLog](Model-RewardLog.html#t:RewardLog)] -\> [Rewards](Data-Reward.html#t:Rewards)

concatRewards :: [Rewards](Data-Reward.html#t:Rewards) -\> [Rewards](Data-Reward.html#t:Rewards)

checkRewardLog :: Integer -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) ()

activateRewards :: Integer -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) ()

saveRewardLogEvent :: [Integer] -\> [Integer] -\> [Integer] -\> Integer -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) ()

extractEvent :: [[Event](Data-Event.html#t:Event)] -\> ([Integer], [Integer], [Integer])

loadRule :: Integer -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) (String, [Expr](Data-Decider.html#t:Expr) g [Symbol](Data-Event.html#t:Symbol), Bool)

runEventStream :: Integer -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) [(String, Integer, [[Event](Data-Event.html#t:Event)])]

testParseRule :: IO ()

optimize :: [Expr](Data-Decider.html#t:Expr) t t1 -\> [Expr](Data-Decider.html#t:Expr) t t1

joinSame :: [[Expr](Data-Decider.html#t:Expr) t t1] -\> [[Expr](Data-Decider.html#t:Expr) t t1]

parseRule :: Parser ([Expr](Data-Decider.html#t:Expr) g [Symbol](Data-Event.html#t:Symbol))

manyRules :: Parser [[Expr](Data-Decider.html#t:Expr) g [Symbol](Data-Event.html#t:Symbol)]

testMatchRule :: IO ()

matchRule :: Parser ([Expr](Data-Decider.html#t:Expr) g [Symbol](Data-Event.html#t:Symbol))

fromtoE :: Parser ([Expr](Data-Decider.html#t:Expr) g [Symbol](Data-Event.html#t:Symbol))

fromE :: Parser ([Expr](Data-Decider.html#t:Expr) g [Symbol](Data-Event.html#t:Symbol))

toE :: Parser ([Expr](Data-Decider.html#t:Expr) g [Symbol](Data-Event.html#t:Symbol))

allE :: Parser ([Expr](Data-Decider.html#t:Expr) g [Symbol](Data-Event.html#t:Symbol))

anyE :: Parser ([Expr](Data-Decider.html#t:Expr) g [Symbol](Data-Event.html#t:Symbol))

oneE :: Parser ([Expr](Data-Decider.html#t:Expr) g [Symbol](Data-Event.html#t:Symbol))

matchSymbol :: Parser [Symbol](Data-Event.html#t:Symbol)

tournamentI :: Parser [Symbol](Data-Event.html#t:Symbol)

tournamentS :: Parser [Symbol](Data-Event.html#t:Symbol)

levelI :: Parser [Symbol](Data-Event.html#t:Symbol)

raceI :: Parser [Symbol](Data-Event.html#t:Symbol)

raceS :: Parser [Symbol](Data-Event.html#t:Symbol)

practiceI :: Parser [Symbol](Data-Event.html#t:Symbol)

practiceS :: Parser [Symbol](Data-Event.html#t:Symbol)

uncurry3 :: (a -\> b -\> c -\> d) -\> (a, b, c) -\> d

parseTriple :: Parser (Maybe Integer, Maybe Integer, Maybe Integer)

parsePair :: Parser (Maybe Integer, Maybe Integer)

parseArg :: Parser (Maybe Integer)

integer :: Parser Integer

num :: Parser Char

testTournament :: IO ()

eitherToMaybe :: Either a b -\> Maybe b

rewardAction :: [Event](Data-Event.html#t:Event) -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) [[RuleReward](Model-RuleReward.html#t:RuleReward)]

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
