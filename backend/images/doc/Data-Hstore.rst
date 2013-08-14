===========
Data.Hstore
===========

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Data.Hstore

Description

Creates some conversion instances for getting and retrieving hstores

Documentation
=============

parseHStore :: `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__ ->
`HStore <Data-Hstore.html#t:HStore>`__

newtype HStore

Constructors

HS

 

Fields

unHS :: HashMap String String
     

Instances

+---------------------------------------------------------------------------------------------------------+-----+
| Eq `HStore <Data-Hstore.html#t:HStore>`__                                                               |     |
+---------------------------------------------------------------------------------------------------------+-----+
| Show `HStore <Data-Hstore.html#t:HStore>`__                                                             |     |
+---------------------------------------------------------------------------------------------------------+-----+
| Default `HStore <Data-Hstore.html#t:HStore>`__                                                          |     |
+---------------------------------------------------------------------------------------------------------+-----+
| Convertible `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__ `HStore <Data-Hstore.html#t:HStore>`__   |     |
+---------------------------------------------------------------------------------------------------------+-----+
| Convertible `HStore <Data-Hstore.html#t:HStore>`__ `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__   |     |
+---------------------------------------------------------------------------------------------------------+-----+

ppHStore :: `HStore <Data-Hstore.html#t:HStore>`__ -> String

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
