-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Data.Task

Documentation
=============

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

Instances

||
|Enum [Action](Data-Task.html#t:Action)| |
|Eq [Action](Data-Task.html#t:Action)| |
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

Instances

||
|Enum [Trigger](Data-Task.html#t:Trigger)| |
|Eq [Trigger](Data-Task.html#t:Trigger)| |

task :: ToJSON a =\> a -\> Integer -\> [Data](Data-DataPack.html#t:Data) -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) Integer

trigger :: [Trigger](Data-Task.html#t:Trigger) -\> Integer -\> Integer -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) Integer

trackTime :: Integer -\> Integer -\> Integer -\> Double -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) ()

emitEvent :: Integer -\> [Event](Data-Event.html#t:Event) -\> Integer -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) ()

giveMoney :: Integer -\> Integer -\> Integer -\> String -\> Integer -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) ()

giveRespect :: Integer -\> Integer -\> Integer -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) ()

giveCar :: Integer -\> Integer -\> Integer -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) ()

givePart :: Integer -\> Integer -\> Integer -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) ()

transferMoney :: Integer -\> Integer -\> Integer -\> Integer -\> String -\> Integer -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) ()

transferCar :: Integer -\> Integer -\> Integer -\> Integer -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) ()

escrowCancel :: Integer -\> Integer -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) ()

escrowRelease :: Integer -\> Integer -\> Integer -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) ()

runAll :: [Trigger](Data-Task.html#t:Trigger) -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) ()

run :: [Trigger](Data-Task.html#t:Trigger) -\> Integer -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) ()

claim :: Integer -\> [Trigger](Data-Task.html#t:Trigger) -\> Integer -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) [[Task](Model-Task.html#t:Task)]

release :: [Task](Model-Task.html#t:Task) -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) ()

remove :: [Task](Model-Task.html#t:Task) -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) ()

cleanup :: Integer -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) ()

wait :: Integer -\> [Trigger](Data-Task.html#t:Trigger) -\> Integer -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) ()

initTask :: IO ()

executeTask :: [Task](Model-Task.html#t:Task) -\> [SqlTransactionUser](Data-SqlTransaction.html#t:SqlTransactionUser) [Lock](LockSnaplet.html#t:Lock) [Connection](Data-SqlTransaction.html#t:Connection) Bool

process :: [Task](Model-Task.html#t:Task) -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) Bool

processFail :: [Task](Model-Task.html#t:Task) -\> String -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) Bool

runFail :: [Trigger](Data-Task.html#t:Trigger) -\> Integer -\> String -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) ()

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
