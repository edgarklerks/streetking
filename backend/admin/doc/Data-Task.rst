=========
Data.Task
=========

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Data.Task

Documentation
=============

data Action

Constructors

+-----------------+-----+
| TrackTime       |     |
+-----------------+-----+
| GiveRespect     |     |
+-----------------+-----+
| GiveMoney       |     |
+-----------------+-----+
| GiveCar         |     |
+-----------------+-----+
| GivePart        |     |
+-----------------+-----+
| TransferMoney   |     |
+-----------------+-----+
| TransferCar     |     |
+-----------------+-----+
| EscrowCancel    |     |
+-----------------+-----+
| EscrowRelease   |     |
+-----------------+-----+
| EmitEvent       |     |
+-----------------+-----+

Instances

+-------------------------------------------------+-----+
| Enum `Action <Data-Task.html#t:Action>`__       |     |
+-------------------------------------------------+-----+
| Eq `Action <Data-Task.html#t:Action>`__         |     |
+-------------------------------------------------+-----+
| ToJSON `Action <Data-Task.html#t:Action>`__     |     |
+-------------------------------------------------+-----+
| FromJSON `Action <Data-Task.html#t:Action>`__   |     |
+-------------------------------------------------+-----+

data Trigger

Constructors

+---------+-----+
| Track   |     |
+---------+-----+
| User    |     |
+---------+-----+
| Car     |     |
+---------+-----+
| Part    |     |
+---------+-----+
| Cron    |     |
+---------+-----+

Instances

+-----------------------------------------------+-----+
| Enum `Trigger <Data-Task.html#t:Trigger>`__   |     |
+-----------------------------------------------+-----+
| Eq `Trigger <Data-Task.html#t:Trigger>`__     |     |
+-----------------------------------------------+-----+

task :: ToJSON a => a -> Integer -> `Data <Data-DataPack.html#t:Data>`__
-> `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ Integer

trigger :: `Trigger <Data-Task.html#t:Trigger>`__ -> Integer -> Integer
-> `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ Integer

trackTime :: Integer -> Integer -> Integer -> Double ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ ()

emitEvent :: Integer -> `Event <Data-Event.html#t:Event>`__ -> Integer
-> `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ ()

giveMoney :: Integer -> Integer -> Integer -> String -> Integer ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ ()

giveRespect :: Integer -> Integer -> Integer ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ ()

giveCar :: Integer -> Integer -> Integer ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ ()

givePart :: Integer -> Integer -> Integer ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ ()

transferMoney :: Integer -> Integer -> Integer -> Integer -> String ->
Integer ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ ()

transferCar :: Integer -> Integer -> Integer -> Integer ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ ()

escrowCancel :: Integer -> Integer ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ ()

escrowRelease :: Integer -> Integer -> Integer ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ ()

runAll :: `Trigger <Data-Task.html#t:Trigger>`__ ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ ()

run :: `Trigger <Data-Task.html#t:Trigger>`__ -> Integer ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ ()

claim :: Integer -> `Trigger <Data-Task.html#t:Trigger>`__ -> Integer ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__
[`Task <Model-Task.html#t:Task>`__\ ]

release :: `Task <Model-Task.html#t:Task>`__ ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ ()

remove :: `Task <Model-Task.html#t:Task>`__ ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ ()

cleanup :: Integer ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ ()

wait :: Integer -> `Trigger <Data-Task.html#t:Trigger>`__ -> Integer ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ ()

initTask :: IO ()

executeTask :: `Task <Model-Task.html#t:Task>`__ ->
`SqlTransactionUser <Data-SqlTransaction.html#t:SqlTransactionUser>`__
`Lock <LockSnaplet.html#t:Lock>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ Bool

process :: `Task <Model-Task.html#t:Task>`__ ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ Bool

processFail :: `Task <Model-Task.html#t:Task>`__ -> String ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ Bool

runFail :: `Trigger <Data-Task.html#t:Trigger>`__ -> Integer -> String
-> `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ ()

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
