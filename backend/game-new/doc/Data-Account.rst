============
Data.Account
============

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Data.Account

Synopsis

-  `addRespect <#v:addRespect>`__ :: Integer -> Integer ->
   `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
   `Connection <Data-SqlTransaction.html#t:Connection>`__ ()

Documentation
=============

addRespect

Arguments

:: Integer

user id

-> Integer

respect amount

-> `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ ()

 

Add respect to an user account, runs in the SqlTransaction monad.

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
