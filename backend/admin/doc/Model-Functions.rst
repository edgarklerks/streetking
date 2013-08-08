===============
Model.Functions
===============

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Model.Functions

Documentation
=============

unix\_timestamp ::
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ Integer

tasks\_in\_progress :: Integer -> Integer -> Integer ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ Bool

claim\_tasks :: `IConnection <Data-SqlTransaction.html#t:IConnection>`__
c => Integer -> Integer -> Integer ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c
[HashMap String `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__]

garage\_unset\_active\_car :: Integer -> Integer ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ Bool

garage\_set\_active\_car :: Integer -> Integer ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ Bool

car\_get\_missing\_parts ::
`IConnection <Data-SqlTransaction.html#t:IConnection>`__ c => Integer ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c
[HashMap String `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__]

car\_get\_worn\_parts ::
`IConnection <Data-SqlTransaction.html#t:IConnection>`__ c => Integer ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__ c
[HashMap String `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__]

garage\_actions\_account :: Integer ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ Bool

personnel\_cancel\_task :: Integer ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ Bool

personnel\_start\_task :: Integer -> String -> Integer ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ Bool

personnel\_train :: Integer -> String -> String ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ Bool

account\_update\_energy :: Integer ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ Bool

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
