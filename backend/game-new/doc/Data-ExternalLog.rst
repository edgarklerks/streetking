================
Data.ExternalLog
================

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

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
     
threadId :: ThreadId
     

reportCycle :: `Cycle <Data-ExternalLog.html#t:Cycle>`__ -> String ->
String -> IO ()

initCycle :: `Address <Data-ExternalLog.html#t:Address>`__ -> IO
`Cycle <Data-ExternalLog.html#t:Cycle>`__

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
