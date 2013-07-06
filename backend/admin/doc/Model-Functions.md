% Model.Functions
% 
% 

-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Model.Functions

Documentation
=============

unix\_timestamp ::
[SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction)
[Connection](Data-SqlTransaction.html#t:Connection) Integer

tasks\_in\_progress :: Integer -\> Integer -\> Integer -\>
[SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction)
[Connection](Data-SqlTransaction.html#t:Connection) Bool

claim\_tasks :: [IConnection](Data-SqlTransaction.html#t:IConnection) c
=\> Integer -\> Integer -\> Integer -\>
[SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c [HashMap
String [SqlValue](Data-SqlTransaction.html#t:SqlValue)]

garage\_unset\_active\_car :: Integer -\> Integer -\>
[SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction)
[Connection](Data-SqlTransaction.html#t:Connection) Bool

garage\_set\_active\_car :: Integer -\> Integer -\>
[SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction)
[Connection](Data-SqlTransaction.html#t:Connection) Bool

car\_get\_missing\_parts ::
[IConnection](Data-SqlTransaction.html#t:IConnection) c =\> Integer -\>
[SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c [HashMap
String [SqlValue](Data-SqlTransaction.html#t:SqlValue)]

car\_get\_worn\_parts ::
[IConnection](Data-SqlTransaction.html#t:IConnection) c =\> Integer -\>
[SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) c [HashMap
String [SqlValue](Data-SqlTransaction.html#t:SqlValue)]

garage\_actions\_account :: Integer -\>
[SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction)
[Connection](Data-SqlTransaction.html#t:Connection) Bool

personnel\_cancel\_task :: Integer -\>
[SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction)
[Connection](Data-SqlTransaction.html#t:Connection) Bool

personnel\_start\_task :: Integer -\> String -\> Integer -\>
[SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction)
[Connection](Data-SqlTransaction.html#t:Connection) Bool

personnel\_train :: Integer -\> String -\> String -\>
[SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction)
[Connection](Data-SqlTransaction.html#t:Connection) Bool

account\_update\_energy :: Integer -\>
[SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction)
[Connection](Data-SqlTransaction.html#t:Connection) Bool

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
