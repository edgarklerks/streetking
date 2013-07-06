==================
Data.Notifications
==================

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Data.Notifications

Synopsis

-  type `Letters <#t:Letters>`__ =
   [`Letter <Data-Notifications.html#t:Letter>`__\ ]
-  type `Letter <#t:Letter>`__ =
   `PreLetter <Model-PreLetter.html#t:PreLetter>`__
-  type `Time <#t:Time>`__ = Integer
-  newtype `PrioService <#t:PrioService>`__ = `PQS <#v:PQS>`__ {

   -  `runPrioService <#v:runPrioService>`__ :: TVar
      (`Prio <Data-PriorityQueue.html#t:Prio>`__
      `Time <Data-Notifications.html#t:Time>`__ Int)

   }
-  newtype `PostSorter <#t:PostSorter>`__ = `PS <#v:PS>`__ {

   -  `runPostSorter <#v:runPostSorter>`__ :: TVar (IntMap
      `Letter <Data-Notifications.html#t:Letter>`__)

   }
-  newtype `UserBoxes <#t:UserBoxes>`__ = `UB <#v:UB>`__ {

   -  `runUserBoxes <#v:runUserBoxes>`__ :: TVar (IntMap (TVar
      (`LimitList <Data-LimitList.html#t:LimitList>`__ Int)))

   }
-  `readPostSorter <#v:readPostSorter>`__ ::
   `PostOffice <Data-Notifications.html#t:PostOffice>`__ -> STM (IntMap
   `Letter <Data-Notifications.html#t:Letter>`__)
-  `modifyPostSorter <#v:modifyPostSorter>`__ ::
   `PostOffice <Data-Notifications.html#t:PostOffice>`__ -> (IntMap
   `Letter <Data-Notifications.html#t:Letter>`__ -> IntMap
   `Letter <Data-Notifications.html#t:Letter>`__) -> STM ()
-  `writePostSorter <#v:writePostSorter>`__ ::
   `PostOffice <Data-Notifications.html#t:PostOffice>`__ -> IntMap
   `Letter <Data-Notifications.html#t:Letter>`__ -> STM ()
-  `readUserBoxes <#v:readUserBoxes>`__ ::
   `PostOffice <Data-Notifications.html#t:PostOffice>`__ -> STM (IntMap
   (TVar (`LimitList <Data-LimitList.html#t:LimitList>`__ Int)))
-  `modifyUserBoxes <#v:modifyUserBoxes>`__ ::
   `PostOffice <Data-Notifications.html#t:PostOffice>`__ -> (IntMap
   (TVar (`LimitList <Data-LimitList.html#t:LimitList>`__ Int)) ->
   IntMap (TVar (`LimitList <Data-LimitList.html#t:LimitList>`__ Int)))
   -> STM ()
-  `writeUserBoxes <#v:writeUserBoxes>`__ ::
   `PostOffice <Data-Notifications.html#t:PostOffice>`__ -> IntMap (TVar
   (`LimitList <Data-LimitList.html#t:LimitList>`__ Int)) -> STM ()
-  `readPrioService <#v:readPrioService>`__ ::
   `PostOffice <Data-Notifications.html#t:PostOffice>`__ -> STM
   (`Prio <Data-PriorityQueue.html#t:Prio>`__
   `Time <Data-Notifications.html#t:Time>`__ Int)
-  `modifyPrioService <#v:modifyPrioService>`__ ::
   `PostOffice <Data-Notifications.html#t:PostOffice>`__ ->
   (`Prio <Data-PriorityQueue.html#t:Prio>`__
   `Time <Data-Notifications.html#t:Time>`__ Int ->
   `Prio <Data-PriorityQueue.html#t:Prio>`__
   `Time <Data-Notifications.html#t:Time>`__ Int) -> STM ()
-  `writePrioService <#v:writePrioService>`__ ::
   `PostOffice <Data-Notifications.html#t:PostOffice>`__ ->
   `Prio <Data-PriorityQueue.html#t:Prio>`__
   `Time <Data-Notifications.html#t:Time>`__ Int -> STM ()
-  `modifyLetter <#v:modifyLetter>`__ ::
   `PostOffice <Data-Notifications.html#t:PostOffice>`__ -> Int ->
   (`Letter <Data-Notifications.html#t:Letter>`__ ->
   `Letter <Data-Notifications.html#t:Letter>`__) -> STM ()
-  `deleteLetter <#v:deleteLetter>`__ ::
   `PostOffice <Data-Notifications.html#t:PostOffice>`__ -> Int -> STM
   ()
-  type `UserId <#t:UserId>`__ = Integer
-  `getId <#v:getId>`__ :: `Letter <Data-Notifications.html#t:Letter>`__
   -> Int
-  `withPriority <#v:withPriority>`__ :: Monad m =>
   `Letter <Data-Notifications.html#t:Letter>`__ ->
   (`Time <Data-Notifications.html#t:Time>`__ -> m ()) -> m ()
-  `getPrio <#v:getPrio>`__ ::
   `Letter <Data-Notifications.html#t:Letter>`__ -> Maybe
   `Time <Data-Notifications.html#t:Time>`__
-  newtype `PostOffice <#t:PostOffice>`__ = `PO <#v:PO>`__ {

   -  `closePostOffice <#v:closePostOffice>`__ ::
      (`PrioService <Data-Notifications.html#t:PrioService>`__,
      `PostSorter <Data-Notifications.html#t:PostSorter>`__,
      `UserBoxes <Data-Notifications.html#t:UserBoxes>`__)

   }
-  `sendLocal <#v:sendLocal>`__ ::
   `PostOffice <Data-Notifications.html#t:PostOffice>`__ ->
   `UserId <Data-Notifications.html#t:UserId>`__ ->
   `Letter <Data-Notifications.html#t:Letter>`__ -> IO ()
-  `openPostOffice <#v:openPostOffice>`__ :: IO
   `PostOffice <Data-Notifications.html#t:PostOffice>`__
-  `sendLetter <#v:sendLetter>`__ ::
   `PostOffice <Data-Notifications.html#t:PostOffice>`__ ->
   `UserId <Data-Notifications.html#t:UserId>`__ ->
   `Letter <Data-Notifications.html#t:Letter>`__ ->
   `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
   `Connection <Data-SqlTransaction.html#t:Connection>`__
   `Letter <Data-Notifications.html#t:Letter>`__
-  `sendCentral <#v:sendCentral>`__ ::
   `UserId <Data-Notifications.html#t:UserId>`__ ->
   `Letter <Data-Notifications.html#t:Letter>`__ ->
   `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
   `Connection <Data-SqlTransaction.html#t:Connection>`__
   `Letter <Data-Notifications.html#t:Letter>`__
-  `setRead <#v:setRead>`__ ::
   `PostOffice <Data-Notifications.html#t:PostOffice>`__ ->
   `UserId <Data-Notifications.html#t:UserId>`__ -> Integer ->
   `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
   `Connection <Data-SqlTransaction.html#t:Connection>`__ ()
-  `setArchive <#v:setArchive>`__ ::
   `PostOffice <Data-Notifications.html#t:PostOffice>`__ ->
   `UserId <Data-Notifications.html#t:UserId>`__ -> Integer ->
   `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
   `Connection <Data-SqlTransaction.html#t:Connection>`__ ()
-  `checkMailBox <#v:checkMailBox>`__ ::
   `PostOffice <Data-Notifications.html#t:PostOffice>`__ ->
   `UserId <Data-Notifications.html#t:UserId>`__ ->
   `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
   `Connection <Data-SqlTransaction.html#t:Connection>`__
   `Letters <Data-Notifications.html#t:Letters>`__
-  `haulPost <#v:haulPost>`__ ::
   `PostOffice <Data-Notifications.html#t:PostOffice>`__ ->
   `UserId <Data-Notifications.html#t:UserId>`__ ->
   `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
   `Connection <Data-SqlTransaction.html#t:Connection>`__ ()
-  `extractSince <#v:extractSince>`__ ::
   `Time <Data-Notifications.html#t:Time>`__ ->
   `PostOffice <Data-Notifications.html#t:PostOffice>`__ -> STM [Int]
-  `goin'Postal <#v:goin-39-Postal>`__ ::
   `PostOffice <Data-Notifications.html#t:PostOffice>`__ -> IO ()
-  `sendBulkMail <#v:sendBulkMail>`__ ::
   `PostOffice <Data-Notifications.html#t:PostOffice>`__ ->
   `Letter <Data-Notifications.html#t:Letter>`__ ->
   `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
   `Connection <Data-SqlTransaction.html#t:Connection>`__ ()
-  `sendBulkLocal <#v:sendBulkLocal>`__ ::
   `PostOffice <Data-Notifications.html#t:PostOffice>`__ ->
   `Letter <Data-Notifications.html#t:Letter>`__ -> IO ()
-  `sendBulkCentral <#v:sendBulkCentral>`__ ::
   `PostOffice <Data-Notifications.html#t:PostOffice>`__ ->
   `Letter <Data-Notifications.html#t:Letter>`__ ->
   `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
   `Connection <Data-SqlTransaction.html#t:Connection>`__ ()
-  `milliTime <#v:milliTime>`__ ::
   `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
   `Connection <Data-SqlTransaction.html#t:Connection>`__
   `Time <Data-Notifications.html#t:Time>`__

Documentation
=============

type Letters = [`Letter <Data-Notifications.html#t:Letter>`__\ ]

type Letter = `PreLetter <Model-PreLetter.html#t:PreLetter>`__

type Time = Integer

newtype PrioService

Constructors

PQS

 

Fields

runPrioService :: TVar (`Prio <Data-PriorityQueue.html#t:Prio>`__
`Time <Data-Notifications.html#t:Time>`__ Int)
     

newtype PostSorter

Constructors

PS

 

Fields

runPostSorter :: TVar (IntMap
`Letter <Data-Notifications.html#t:Letter>`__)
     

newtype UserBoxes

Constructors

UB

 

Fields

runUserBoxes :: TVar (IntMap (TVar
(`LimitList <Data-LimitList.html#t:LimitList>`__ Int)))
     

readPostSorter :: `PostOffice <Data-Notifications.html#t:PostOffice>`__
-> STM (IntMap `Letter <Data-Notifications.html#t:Letter>`__)

modifyPostSorter ::
`PostOffice <Data-Notifications.html#t:PostOffice>`__ -> (IntMap
`Letter <Data-Notifications.html#t:Letter>`__ -> IntMap
`Letter <Data-Notifications.html#t:Letter>`__) -> STM ()

writePostSorter :: `PostOffice <Data-Notifications.html#t:PostOffice>`__
-> IntMap `Letter <Data-Notifications.html#t:Letter>`__ -> STM ()

readUserBoxes :: `PostOffice <Data-Notifications.html#t:PostOffice>`__
-> STM (IntMap (TVar (`LimitList <Data-LimitList.html#t:LimitList>`__
Int)))

modifyUserBoxes :: `PostOffice <Data-Notifications.html#t:PostOffice>`__
-> (IntMap (TVar (`LimitList <Data-LimitList.html#t:LimitList>`__ Int))
-> IntMap (TVar (`LimitList <Data-LimitList.html#t:LimitList>`__ Int)))
-> STM ()

writeUserBoxes :: `PostOffice <Data-Notifications.html#t:PostOffice>`__
-> IntMap (TVar (`LimitList <Data-LimitList.html#t:LimitList>`__ Int))
-> STM ()

readPrioService :: `PostOffice <Data-Notifications.html#t:PostOffice>`__
-> STM (`Prio <Data-PriorityQueue.html#t:Prio>`__
`Time <Data-Notifications.html#t:Time>`__ Int)

modifyPrioService ::
`PostOffice <Data-Notifications.html#t:PostOffice>`__ ->
(`Prio <Data-PriorityQueue.html#t:Prio>`__
`Time <Data-Notifications.html#t:Time>`__ Int ->
`Prio <Data-PriorityQueue.html#t:Prio>`__
`Time <Data-Notifications.html#t:Time>`__ Int) -> STM ()

writePrioService ::
`PostOffice <Data-Notifications.html#t:PostOffice>`__ ->
`Prio <Data-PriorityQueue.html#t:Prio>`__
`Time <Data-Notifications.html#t:Time>`__ Int -> STM ()

modifyLetter :: `PostOffice <Data-Notifications.html#t:PostOffice>`__ ->
Int -> (`Letter <Data-Notifications.html#t:Letter>`__ ->
`Letter <Data-Notifications.html#t:Letter>`__) -> STM ()

deleteLetter :: `PostOffice <Data-Notifications.html#t:PostOffice>`__ ->
Int -> STM ()

type UserId = Integer

getId :: `Letter <Data-Notifications.html#t:Letter>`__ -> Int

withPriority :: Monad m => `Letter <Data-Notifications.html#t:Letter>`__
-> (`Time <Data-Notifications.html#t:Time>`__ -> m ()) -> m ()

getPrio :: `Letter <Data-Notifications.html#t:Letter>`__ -> Maybe
`Time <Data-Notifications.html#t:Time>`__

newtype PostOffice

Constructors

PO

 

Fields

closePostOffice ::
(`PrioService <Data-Notifications.html#t:PrioService>`__,
`PostSorter <Data-Notifications.html#t:PostSorter>`__,
`UserBoxes <Data-Notifications.html#t:UserBoxes>`__)
    close the post office

sendLocal :: `PostOffice <Data-Notifications.html#t:PostOffice>`__ ->
`UserId <Data-Notifications.html#t:UserId>`__ ->
`Letter <Data-Notifications.html#t:Letter>`__ -> IO ()

openPostOffice :: IO
`PostOffice <Data-Notifications.html#t:PostOffice>`__

open the post office

sendLetter :: `PostOffice <Data-Notifications.html#t:PostOffice>`__ ->
`UserId <Data-Notifications.html#t:UserId>`__ ->
`Letter <Data-Notifications.html#t:Letter>`__ ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__
`Letter <Data-Notifications.html#t:Letter>`__

send a message to that users

sendCentral :: `UserId <Data-Notifications.html#t:UserId>`__ ->
`Letter <Data-Notifications.html#t:Letter>`__ ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__
`Letter <Data-Notifications.html#t:Letter>`__

setRead :: `PostOffice <Data-Notifications.html#t:PostOffice>`__ ->
`UserId <Data-Notifications.html#t:UserId>`__ -> Integer ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ ()

setArchive :: `PostOffice <Data-Notifications.html#t:PostOffice>`__ ->
`UserId <Data-Notifications.html#t:UserId>`__ -> Integer ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ ()

checkMailBox :: `PostOffice <Data-Notifications.html#t:PostOffice>`__ ->
`UserId <Data-Notifications.html#t:UserId>`__ ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__
`Letters <Data-Notifications.html#t:Letters>`__

receive your messages

haulPost :: `PostOffice <Data-Notifications.html#t:PostOffice>`__ ->
`UserId <Data-Notifications.html#t:UserId>`__ ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ ()

Get post from the regional office (database)

extractSince :: `Time <Data-Notifications.html#t:Time>`__ ->
`PostOffice <Data-Notifications.html#t:PostOffice>`__ -> STM [Int]

goin'Postal :: `PostOffice <Data-Notifications.html#t:PostOffice>`__ ->
IO ()

clean up that postoffice a bit

sendBulkMail :: `PostOffice <Data-Notifications.html#t:PostOffice>`__ ->
`Letter <Data-Notifications.html#t:Letter>`__ ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ ()

Sending bulk mail to everybody

sendBulkLocal :: `PostOffice <Data-Notifications.html#t:PostOffice>`__
-> `Letter <Data-Notifications.html#t:Letter>`__ -> IO ()

sendBulkCentral :: `PostOffice <Data-Notifications.html#t:PostOffice>`__
-> `Letter <Data-Notifications.html#t:Letter>`__ ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ ()

milliTime ::
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__
`Time <Data-Notifications.html#t:Time>`__

Some tools

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
