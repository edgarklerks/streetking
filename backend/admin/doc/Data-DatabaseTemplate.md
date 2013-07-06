-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Data.DatabaseTemplate

Documentation
=============

data DTD

Constructors

||
|Con [ConOp](Data-Database.html#t:ConOp) String [DTD](Data-DatabaseTemplate.html#t:DTD)| |
|And [DTD](Data-DatabaseTemplate.html#t:DTD) [DTD](Data-DatabaseTemplate.html#t:DTD)| |
|Or [DTD](Data-DatabaseTemplate.html#t:DTD) [DTD](Data-DatabaseTemplate.html#t:DTD)| |
|Lift String| |
|Fix [SqlValue](Data-SqlTransaction.html#t:SqlValue)| |
|If String (String -\> Bool) [DTD](Data-DatabaseTemplate.html#t:DTD) [DTD](Data-DatabaseTemplate.html#t:DTD)| |
|OrderedBy [DTD](Data-DatabaseTemplate.html#t:DTD) [String]| |
|Nop| |

orderedBy :: [DTD](Data-DatabaseTemplate.html#t:DTD) -\> [String] -\> [DTD](Data-DatabaseTemplate.html#t:DTD)

transformDTD :: ([DTD](Data-DatabaseTemplate.html#t:DTD) -\> [DTD](Data-DatabaseTemplate.html#t:DTD)) -\> [DTD](Data-DatabaseTemplate.html#t:DTD) -\> [DTD](Data-DatabaseTemplate.html#t:DTD)

filterDTD :: ([DTD](Data-DatabaseTemplate.html#t:DTD) -\> Bool) -\> [DTD](Data-DatabaseTemplate.html#t:DTD) -\> [DTD](Data-DatabaseTemplate.html#t:DTD)

(+&&) :: [DTD](Data-DatabaseTemplate.html#t:DTD) -\> [DTD](Data-DatabaseTemplate.html#t:DTD) -\> [DTD](Data-DatabaseTemplate.html#t:DTD)

(+||) :: [DTD](Data-DatabaseTemplate.html#t:DTD) -\> [DTD](Data-DatabaseTemplate.html#t:DTD) -\> [DTD](Data-DatabaseTemplate.html#t:DTD)

(+==) :: String -\> String -\> [DTD](Data-DatabaseTemplate.html#t:DTD)

(+\>=) :: String -\> String -\> [DTD](Data-DatabaseTemplate.html#t:DTD)

(+\>) :: String -\> String -\> [DTD](Data-DatabaseTemplate.html#t:DTD)

(+\<) :: String -\> String -\> [DTD](Data-DatabaseTemplate.html#t:DTD)

(+\<=) :: String -\> String -\> [DTD](Data-DatabaseTemplate.html#t:DTD)

(+%) :: String -\> String -\> [DTD](Data-DatabaseTemplate.html#t:DTD)

(+%%) :: String -\> String -\> [DTD](Data-DatabaseTemplate.html#t:DTD)

(+\<\>) :: String -\> String -\> [DTD](Data-DatabaseTemplate.html#t:DTD)

ifdtd :: String -\> (String -\> Bool) -\> [DTD](Data-DatabaseTemplate.html#t:DTD) -\> [DTD](Data-DatabaseTemplate.html#t:DTD) -\> [DTD](Data-DatabaseTemplate.html#t:DTD)

(+==|) :: String -\> [SqlValue](Data-SqlTransaction.html#t:SqlValue) -\> [DTD](Data-DatabaseTemplate.html#t:DTD)

(+\>=|) :: String -\> [SqlValue](Data-SqlTransaction.html#t:SqlValue) -\> [DTD](Data-DatabaseTemplate.html#t:DTD)

(+\>|) :: String -\> [SqlValue](Data-SqlTransaction.html#t:SqlValue) -\> [DTD](Data-DatabaseTemplate.html#t:DTD)

(+\<|) :: String -\> [SqlValue](Data-SqlTransaction.html#t:SqlValue) -\> [DTD](Data-DatabaseTemplate.html#t:DTD)

(+\<=|) :: String -\> [SqlValue](Data-SqlTransaction.html#t:SqlValue) -\> [DTD](Data-DatabaseTemplate.html#t:DTD)

(+%|) :: String -\> [SqlValue](Data-SqlTransaction.html#t:SqlValue) -\> [DTD](Data-DatabaseTemplate.html#t:DTD)

(+%%|) :: String -\> [SqlValue](Data-SqlTransaction.html#t:SqlValue) -\> [DTD](Data-DatabaseTemplate.html#t:DTD)

(+\<\>|) :: String -\> [SqlValue](Data-SqlTransaction.html#t:SqlValue) -\> [DTD](Data-DatabaseTemplate.html#t:DTD)

dtd :: [DTD](Data-DatabaseTemplate.html#t:DTD) -\> HashMap String [SqlValue](Data-SqlTransaction.html#t:SqlValue) -\> [Constraints](Data-Database.html#t:Constraints)

evalDTD :: [DTD](Data-DatabaseTemplate.html#t:DTD) -\> HashMap String [SqlValue](Data-SqlTransaction.html#t:SqlValue) -\> Maybe [Constraint](Data-Database.html#t:Constraint)

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
