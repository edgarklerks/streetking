% Data.ExternalLog
% 
% 

-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Data.ExternalLog

Description

Small module for logging to an external party

Documentation
=============

type Address = String

type Name = String

data Cycle

Constructors

Cycle

 

Fields

cycleChannel :: TQueue (String, String)
:    
threadId :: ThreadId
:    

reportCycle :: [Cycle](Data-ExternalLog.html#t:Cycle) -\> String -\>
String -\> IO ()

initCycle :: [Address](Data-ExternalLog.html#t:Address) -\> IO
[Cycle](Data-ExternalLog.html#t:Cycle)

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
