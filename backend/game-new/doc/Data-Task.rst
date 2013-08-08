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

init :: IO ()

registerHandler :: (`Task <Model-Task.html#t:Task>`__ -> Bool) ->
(`Task <Model-Task.html#t:Task>`__ ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ Bool) -> IO ()

run :: `Trigger <Data-Task.html#t:Trigger>`__ -> Integer ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ ()

runAll :: `Trigger <Data-Task.html#t:Trigger>`__ ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ ()

executeTask :: `Task <Model-Task.html#t:Task>`__ ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ Bool

task :: ToJSON a => a -> Integer -> `Data <Data-DataPack.html#t:Data>`__
-> `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ Integer

trigger :: `Trigger <Data-Task.html#t:Trigger>`__ -> Integer -> Integer
-> `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ Integer

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
| MutabilizeCar   |     |
+-----------------+-----+

Instances

+-------------------------------------------------+-----+
| Enum `Action <Data-Task.html#t:Action>`__       |     |
+-------------------------------------------------+-----+
| Eq `Action <Data-Task.html#t:Action>`__         |     |
+-------------------------------------------------+-----+
| Show `Action <Data-Task.html#t:Action>`__       |     |
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
| Test    |     |
+---------+-----+

Instances

+---------------------------------------------------+-----+
| Enum `Trigger <Data-Task.html#t:Trigger>`__       |     |
+---------------------------------------------------+-----+
| Eq `Trigger <Data-Task.html#t:Trigger>`__         |     |
+---------------------------------------------------+-----+
| Show `Trigger <Data-Task.html#t:Trigger>`__       |     |
+---------------------------------------------------+-----+
| ToJSON `Trigger <Data-Task.html#t:Trigger>`__     |     |
+---------------------------------------------------+-----+
| FromJSON `Trigger <Data-Task.html#t:Trigger>`__   |     |
+---------------------------------------------------+-----+

trackTime :: Integer -> Integer -> Integer -> Double ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ ()

emitEvent :: Integer -> `Event <Data-Event.html#t:Event>`__ -> Integer
-> `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ ()

giveMoney :: Integer -> Integer -> Integer -> String -> Integer ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ ()

transferMoney :: Integer -> Integer -> Integer -> Integer -> String ->
Integer ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ ()

giveCar :: Integer -> Integer -> Integer ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ ()

transferCar :: Integer -> Integer -> Integer -> Integer ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ ()

givePart :: Integer -> Integer -> Integer ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ ()

giveRespect :: Integer -> Integer -> Integer ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ ()

escrowCancel :: Integer -> Integer ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ ()

escrowRelease :: Integer -> Integer -> Integer ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ ()

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
