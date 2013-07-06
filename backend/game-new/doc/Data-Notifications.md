-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Data.Notifications

Description

The notification system is modeled after a postal office we can sort the letters, then send letters in order of priority to the user boxes

Synopsis

-   type [Letters](#t:Letters) = [[Letter](Data-Notifications.html#t:Letter)]
-   type [Letter](#t:Letter) = [PreLetter](Model-PreLetter.html#t:PreLetter)
-   type [Time](#t:Time) = Integer
-   newtype [PrioService](#t:PrioService) = [PQS](#v:PQS) {
    -   [runPrioService](#v:runPrioService) :: TVar ([Prio](Data-PriorityQueue.html#t:Prio) [Time](Data-Notifications.html#t:Time) Int)

    }
-   newtype [PostSorter](#t:PostSorter) = [PS](#v:PS) {
    -   [runPostSorter](#v:runPostSorter) :: TVar (IntMap [Letter](Data-Notifications.html#t:Letter))

    }
-   newtype [UserBoxes](#t:UserBoxes) = [UB](#v:UB) {
    -   [runUserBoxes](#v:runUserBoxes) :: TVar (IntMap (TVar ([LimitList](Data-LimitList.html#t:LimitList) Int)))

    }
-   [readPostSorter](#v:readPostSorter) :: [PostOffice](Data-Notifications.html#t:PostOffice) -\> STM (IntMap [Letter](Data-Notifications.html#t:Letter))
-   [modifyPostSorter](#v:modifyPostSorter) :: [PostOffice](Data-Notifications.html#t:PostOffice) -\> (IntMap [Letter](Data-Notifications.html#t:Letter) -\> IntMap [Letter](Data-Notifications.html#t:Letter)) -\> STM ()
-   [writePostSorter](#v:writePostSorter) :: [PostOffice](Data-Notifications.html#t:PostOffice) -\> IntMap [Letter](Data-Notifications.html#t:Letter) -\> STM ()
-   [readUserBoxes](#v:readUserBoxes) :: [PostOffice](Data-Notifications.html#t:PostOffice) -\> STM (IntMap (TVar ([LimitList](Data-LimitList.html#t:LimitList) Int)))
-   [modifyUserBoxes](#v:modifyUserBoxes) :: [PostOffice](Data-Notifications.html#t:PostOffice) -\> (IntMap (TVar ([LimitList](Data-LimitList.html#t:LimitList) Int)) -\> IntMap (TVar ([LimitList](Data-LimitList.html#t:LimitList) Int))) -\> STM ()
-   [writeUserBoxes](#v:writeUserBoxes) :: [PostOffice](Data-Notifications.html#t:PostOffice) -\> IntMap (TVar ([LimitList](Data-LimitList.html#t:LimitList) Int)) -\> STM ()
-   [readPrioService](#v:readPrioService) :: [PostOffice](Data-Notifications.html#t:PostOffice) -\> STM ([Prio](Data-PriorityQueue.html#t:Prio) [Time](Data-Notifications.html#t:Time) Int)
-   [modifyPrioService](#v:modifyPrioService) :: [PostOffice](Data-Notifications.html#t:PostOffice) -\> ([Prio](Data-PriorityQueue.html#t:Prio) [Time](Data-Notifications.html#t:Time) Int -\> [Prio](Data-PriorityQueue.html#t:Prio) [Time](Data-Notifications.html#t:Time) Int) -\> STM ()
-   [writePrioService](#v:writePrioService) :: [PostOffice](Data-Notifications.html#t:PostOffice) -\> [Prio](Data-PriorityQueue.html#t:Prio) [Time](Data-Notifications.html#t:Time) Int -\> STM ()
-   [modifyLetter](#v:modifyLetter) :: [PostOffice](Data-Notifications.html#t:PostOffice) -\> Int -\> ([Letter](Data-Notifications.html#t:Letter) -\> [Letter](Data-Notifications.html#t:Letter)) -\> STM ()
-   [deleteLetter](#v:deleteLetter) :: [PostOffice](Data-Notifications.html#t:PostOffice) -\> Int -\> STM ()
-   type [UserId](#t:UserId) = Integer
-   [getId](#v:getId) :: [Letter](Data-Notifications.html#t:Letter) -\> Int
-   [withPriority](#v:withPriority) :: Monad m =\> [Letter](Data-Notifications.html#t:Letter) -\> ([Time](Data-Notifications.html#t:Time) -\> m ()) -\> m ()
-   [getPrio](#v:getPrio) :: [Letter](Data-Notifications.html#t:Letter) -\> Maybe [Time](Data-Notifications.html#t:Time)
-   newtype [PostOffice](#t:PostOffice) = [PO](#v:PO) {
    -   [closePostOffice](#v:closePostOffice) :: ([PrioService](Data-Notifications.html#t:PrioService), [PostSorter](Data-Notifications.html#t:PostSorter), [UserBoxes](Data-Notifications.html#t:UserBoxes))

    }
-   [sendLocal](#v:sendLocal) :: [PostOffice](Data-Notifications.html#t:PostOffice) -\> [UserId](Data-Notifications.html#t:UserId) -\> [Letter](Data-Notifications.html#t:Letter) -\> IO ()
-   [openPostOffice](#v:openPostOffice) :: IO [PostOffice](Data-Notifications.html#t:PostOffice)
-   [sendLetter](#v:sendLetter) :: [PostOffice](Data-Notifications.html#t:PostOffice) -\> [UserId](Data-Notifications.html#t:UserId) -\> [Letter](Data-Notifications.html#t:Letter) -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) [Letter](Data-Notifications.html#t:Letter)
-   [sendCentral](#v:sendCentral) :: [UserId](Data-Notifications.html#t:UserId) -\> [Letter](Data-Notifications.html#t:Letter) -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) [Letter](Data-Notifications.html#t:Letter)
-   [setRead](#v:setRead) :: [PostOffice](Data-Notifications.html#t:PostOffice) -\> [UserId](Data-Notifications.html#t:UserId) -\> Integer -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) ()
-   [setArchive](#v:setArchive) :: [PostOffice](Data-Notifications.html#t:PostOffice) -\> [UserId](Data-Notifications.html#t:UserId) -\> Integer -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) ()
-   [checkMailBox](#v:checkMailBox) :: [PostOffice](Data-Notifications.html#t:PostOffice) -\> [UserId](Data-Notifications.html#t:UserId) -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) [Letters](Data-Notifications.html#t:Letters)
-   [haulPost](#v:haulPost) :: [PostOffice](Data-Notifications.html#t:PostOffice) -\> [UserId](Data-Notifications.html#t:UserId) -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) ()
-   [extractSince](#v:extractSince) :: [Time](Data-Notifications.html#t:Time) -\> [PostOffice](Data-Notifications.html#t:PostOffice) -\> STM [Int]
-   [goin'Postal](#v:goin-39-Postal) :: [PostOffice](Data-Notifications.html#t:PostOffice) -\> IO ()
-   [sendBulkMail](#v:sendBulkMail) :: [PostOffice](Data-Notifications.html#t:PostOffice) -\> [Letter](Data-Notifications.html#t:Letter) -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) ()
-   [sendBulkLocal](#v:sendBulkLocal) :: [PostOffice](Data-Notifications.html#t:PostOffice) -\> [Letter](Data-Notifications.html#t:Letter) -\> IO ()
-   [sendBulkCentral](#v:sendBulkCentral) :: [PostOffice](Data-Notifications.html#t:PostOffice) -\> [Letter](Data-Notifications.html#t:Letter) -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) ()
-   [milliTime](#v:milliTime) :: [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) [Time](Data-Notifications.html#t:Time)

Documentation
=============

type Letters = [[Letter](Data-Notifications.html#t:Letter)]

type Letter = [PreLetter](Model-PreLetter.html#t:PreLetter)

type Time = Integer

newtype PrioService

Constructors

PQS

 

Fields

runPrioService :: TVar ([Prio](Data-PriorityQueue.html#t:Prio) [Time](Data-Notifications.html#t:Time) Int)  
 

newtype PostSorter

Constructors

PS

 

Fields

runPostSorter :: TVar (IntMap [Letter](Data-Notifications.html#t:Letter))  
 

newtype UserBoxes

Constructors

UB

 

Fields

runUserBoxes :: TVar (IntMap (TVar ([LimitList](Data-LimitList.html#t:LimitList) Int)))  
 

readPostSorter :: [PostOffice](Data-Notifications.html#t:PostOffice) -\> STM (IntMap [Letter](Data-Notifications.html#t:Letter))

Get all letters in the postoffice with an index

modifyPostSorter :: [PostOffice](Data-Notifications.html#t:PostOffice) -\> (IntMap [Letter](Data-Notifications.html#t:Letter) -\> IntMap [Letter](Data-Notifications.html#t:Letter)) -\> STM ()

Modify all the letters in the post office

writePostSorter :: [PostOffice](Data-Notifications.html#t:PostOffice) -\> IntMap [Letter](Data-Notifications.html#t:Letter) -\> STM ()

Replace all letters in the post office

readUserBoxes :: [PostOffice](Data-Notifications.html#t:PostOffice) -\> STM (IntMap (TVar ([LimitList](Data-LimitList.html#t:LimitList) Int)))

Read a specific user box

modifyUserBoxes :: [PostOffice](Data-Notifications.html#t:PostOffice) -\> (IntMap (TVar ([LimitList](Data-LimitList.html#t:LimitList) Int)) -\> IntMap (TVar ([LimitList](Data-LimitList.html#t:LimitList) Int))) -\> STM ()

Modify a user box

writeUserBoxes :: [PostOffice](Data-Notifications.html#t:PostOffice) -\> IntMap (TVar ([LimitList](Data-LimitList.html#t:LimitList) Int)) -\> STM ()

Replace a user box

readPrioService :: [PostOffice](Data-Notifications.html#t:PostOffice) -\> STM ([Prio](Data-PriorityQueue.html#t:Prio) [Time](Data-Notifications.html#t:Time) Int)

get the priority queue from the postoffice

modifyPrioService :: [PostOffice](Data-Notifications.html#t:PostOffice) -\> ([Prio](Data-PriorityQueue.html#t:Prio) [Time](Data-Notifications.html#t:Time) Int -\> [Prio](Data-PriorityQueue.html#t:Prio) [Time](Data-Notifications.html#t:Time) Int) -\> STM ()

modify the priority service of the postoffice

writePrioService :: [PostOffice](Data-Notifications.html#t:PostOffice) -\> [Prio](Data-PriorityQueue.html#t:Prio) [Time](Data-Notifications.html#t:Time) Int -\> STM ()

Replace the priority service in the postoffice

modifyLetter :: [PostOffice](Data-Notifications.html#t:PostOffice) -\> Int -\> ([Letter](Data-Notifications.html#t:Letter) -\> [Letter](Data-Notifications.html#t:Letter)) -\> STM ()

Modify a specific letter

deleteLetter :: [PostOffice](Data-Notifications.html#t:PostOffice) -\> Int -\> STM ()

Delete a letter from the postoffice

type UserId = Integer

getId :: [Letter](Data-Notifications.html#t:Letter) -\> Int

Get the id from a letter

withPriority :: Monad m =\> [Letter](Data-Notifications.html#t:Letter) -\> ([Time](Data-Notifications.html#t:Time) -\> m ()) -\> m ()

getPrio :: [Letter](Data-Notifications.html#t:Letter) -\> Maybe [Time](Data-Notifications.html#t:Time)

Get the priority of the letter

newtype PostOffice

A post office has a PrioService, PostSorter and UserBoxes

Constructors

PO

 

Fields

closePostOffice :: ([PrioService](Data-Notifications.html#t:PrioService), [PostSorter](Data-Notifications.html#t:PostSorter), [UserBoxes](Data-Notifications.html#t:UserBoxes))  
close the post office

sendLocal :: [PostOffice](Data-Notifications.html#t:PostOffice) -\> [UserId](Data-Notifications.html#t:UserId) -\> [Letter](Data-Notifications.html#t:Letter) -\> IO ()

Send a letter with postoffice to a user

openPostOffice :: IO [PostOffice](Data-Notifications.html#t:PostOffice)

open the post office

sendLetter :: [PostOffice](Data-Notifications.html#t:PostOffice) -\> [UserId](Data-Notifications.html#t:UserId) -\> [Letter](Data-Notifications.html#t:Letter) -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) [Letter](Data-Notifications.html#t:Letter)

send a message to that users locally and to the central post center (database)

sendCentral :: [UserId](Data-Notifications.html#t:UserId) -\> [Letter](Data-Notifications.html#t:Letter) -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) [Letter](Data-Notifications.html#t:Letter)

setRead :: [PostOffice](Data-Notifications.html#t:PostOffice) -\> [UserId](Data-Notifications.html#t:UserId) -\> Integer -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) ()

Flag letter read

setArchive :: [PostOffice](Data-Notifications.html#t:PostOffice) -\> [UserId](Data-Notifications.html#t:UserId) -\> Integer -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) ()

Flag letter archived

checkMailBox :: [PostOffice](Data-Notifications.html#t:PostOffice) -\> [UserId](Data-Notifications.html#t:UserId) -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) [Letters](Data-Notifications.html#t:Letters)

receive your messages

haulPost :: [PostOffice](Data-Notifications.html#t:PostOffice) -\> [UserId](Data-Notifications.html#t:UserId) -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) ()

Get post from the regional office (database)

extractSince :: [Time](Data-Notifications.html#t:Time) -\> [PostOffice](Data-Notifications.html#t:PostOffice) -\> STM [Int]

get all message letters since ..

goin'Postal :: [PostOffice](Data-Notifications.html#t:PostOffice) -\> IO ()

clean up that postoffice a bit

sendBulkMail :: [PostOffice](Data-Notifications.html#t:PostOffice) -\> [Letter](Data-Notifications.html#t:Letter) -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) ()

Sending bulk mail to everybody

sendBulkLocal :: [PostOffice](Data-Notifications.html#t:PostOffice) -\> [Letter](Data-Notifications.html#t:Letter) -\> IO ()

sendBulkCentral :: [PostOffice](Data-Notifications.html#t:PostOffice) -\> [Letter](Data-Notifications.html#t:Letter) -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) ()

milliTime :: [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) [Time](Data-Notifications.html#t:Time)

Some tools

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
