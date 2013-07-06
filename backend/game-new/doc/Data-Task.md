-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Data.Task

Documentation
=============

init :: IO ()

registerHandler :: ([Task](Model-Task.html#t:Task) -\> Bool) -\> ([Task](Model-Task.html#t:Task) -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) Bool) -\> IO ()

run :: [Trigger](Data-Task.html#t:Trigger) -\> Integer -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) ()

runAll :: [Trigger](Data-Task.html#t:Trigger) -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) ()

executeTask :: [Task](Model-Task.html#t:Task) -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) Bool

task :: ToJSON a =\> a -\> Integer -\> [Data](Data-DataPack.html#t:Data) -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) Integer

trigger :: [Trigger](Data-Task.html#t:Trigger) -\> Integer -\> Integer -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) Integer

data Action

Constructors

||
|TrackTime| |
|GiveRespect| |
|GiveMoney| |
|GiveCar| |
|GivePart| |
|TransferMoney| |
|TransferCar| |
|EscrowCancel| |
|EscrowRelease| |
|EmitEvent| |
|MutabilizeCar| |

Instances

||
|Enum [Action](Data-Task.html#t:Action)| |
|Eq [Action](Data-Task.html#t:Action)| |
|Show [Action](Data-Task.html#t:Action)| |
|ToJSON [Action](Data-Task.html#t:Action)| |
|FromJSON [Action](Data-Task.html#t:Action)| |

data Trigger

Constructors

||
|Track| |
|User| |
|Car| |
|Part| |
|Cron| |
|Test| |

Instances

||
|Enum [Trigger](Data-Task.html#t:Trigger)| |
|Eq [Trigger](Data-Task.html#t:Trigger)| |
|Show [Trigger](Data-Task.html#t:Trigger)| |
|ToJSON [Trigger](Data-Task.html#t:Trigger)| |
|FromJSON [Trigger](Data-Task.html#t:Trigger)| |

trackTime :: Integer -\> Integer -\> Integer -\> Double -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) ()

emitEvent :: Integer -\> [Event](Data-Event.html#t:Event) -\> Integer -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) ()

giveMoney :: Integer -\> Integer -\> Integer -\> String -\> Integer -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) ()

transferMoney :: Integer -\> Integer -\> Integer -\> Integer -\> String -\> Integer -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) ()

giveCar :: Integer -\> Integer -\> Integer -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) ()

transferCar :: Integer -\> Integer -\> Integer -\> Integer -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) ()

givePart :: Integer -\> Integer -\> Integer -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) ()

giveRespect :: Integer -\> Integer -\> Integer -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) ()

escrowCancel :: Integer -\> Integer -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) ()

escrowRelease :: Integer -\> Integer -\> Integer -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) ()

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
