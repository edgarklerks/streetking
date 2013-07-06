% Data.Account
% 
% 

-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Data.Account

Synopsis

-   [addRespect](#v:addRespect) :: Integer -\> Integer -\>
    [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction)
    [Connection](Data-SqlTransaction.html#t:Connection) ()

Documentation
=============

addRespect

Arguments

:: Integer

user id

-\> Integer

respect amount

-\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction)
[Connection](Data-SqlTransaction.html#t:Connection) ()

 

Add respect to an user account, runs in the SqlTransaction monad.

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
