% Data.DatabaseTemplate
% 
% 

-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Data.DatabaseTemplate

Description

DSL for expression queries, which can extract data from a map and build
a database contstraint from the DSL. We have two operators a lifted one,
which pulls the right side from the map and the left side is the field
in the database.

     "id" +== "user-id"

This generates id = 1 (if user\_id contains 1) We also have fixed
operators, which don't pull up a value from the hash map, but have a
fixed value

     "id" +==| (toSql 12)

There also is an if statement:

     ifdtd ("account" +==| (toSql 1)) ("account_id" +== "account_id") ("account_id" +==| (toSql 2)

Synopsis

-   data [DTD](#t:DTD)
    -   = [Con](#v:Con) [ConOp](Data-Database.html#t:ConOp) String
        [DTD](Data-DatabaseTemplate.html#t:DTD)
    -   | [And](#v:And) [DTD](Data-DatabaseTemplate.html#t:DTD)
        [DTD](Data-DatabaseTemplate.html#t:DTD)
    -   | [Or](#v:Or) [DTD](Data-DatabaseTemplate.html#t:DTD)
        [DTD](Data-DatabaseTemplate.html#t:DTD)
    -   | [Lift](#v:Lift) String
    -   | [Fix](#v:Fix) [SqlValue](Data-SqlTransaction.html#t:SqlValue)
    -   | [If](#v:If) String (String -\> Bool)
        [DTD](Data-DatabaseTemplate.html#t:DTD)
        [DTD](Data-DatabaseTemplate.html#t:DTD)
    -   | [OrderedBy](#v:OrderedBy)
        [DTD](Data-DatabaseTemplate.html#t:DTD) [String]
    -   | [Nop](#v:Nop)

-   [orderedBy](#v:orderedBy) :: [DTD](Data-DatabaseTemplate.html#t:DTD)
    -\> [String] -\> [DTD](Data-DatabaseTemplate.html#t:DTD)
-   [transformDTD](#v:transformDTD) ::
    ([DTD](Data-DatabaseTemplate.html#t:DTD) -\>
    [DTD](Data-DatabaseTemplate.html#t:DTD)) -\>
    [DTD](Data-DatabaseTemplate.html#t:DTD) -\>
    [DTD](Data-DatabaseTemplate.html#t:DTD)
-   [filterDTD](#v:filterDTD) ::
    ([DTD](Data-DatabaseTemplate.html#t:DTD) -\> Bool) -\>
    [DTD](Data-DatabaseTemplate.html#t:DTD) -\>
    [DTD](Data-DatabaseTemplate.html#t:DTD)
-   [(+&&)](#v:-43--38--38-) :: [DTD](Data-DatabaseTemplate.html#t:DTD)
    -\> [DTD](Data-DatabaseTemplate.html#t:DTD) -\>
    [DTD](Data-DatabaseTemplate.html#t:DTD)
-   [(+||)](#v:-43--124--124-) ::
    [DTD](Data-DatabaseTemplate.html#t:DTD) -\>
    [DTD](Data-DatabaseTemplate.html#t:DTD) -\>
    [DTD](Data-DatabaseTemplate.html#t:DTD)
-   [(+==)](#v:-43--61--61-) :: String -\> String -\>
    [DTD](Data-DatabaseTemplate.html#t:DTD)
-   [(+\>=)](#v:-43--62--61-) :: String -\> String -\>
    [DTD](Data-DatabaseTemplate.html#t:DTD)
-   [(+\>)](#v:-43--62-) :: String -\> String -\>
    [DTD](Data-DatabaseTemplate.html#t:DTD)
-   [(+\<)](#v:-43--60-) :: String -\> String -\>
    [DTD](Data-DatabaseTemplate.html#t:DTD)
-   [(+\<=)](#v:-43--60--61-) :: String -\> String -\>
    [DTD](Data-DatabaseTemplate.html#t:DTD)
-   [(+%)](#v:-43--37-) :: String -\> String -\>
    [DTD](Data-DatabaseTemplate.html#t:DTD)
-   [(+%%)](#v:-43--37--37-) :: String -\> String -\>
    [DTD](Data-DatabaseTemplate.html#t:DTD)
-   [(+\<\>)](#v:-43--60--62-) :: String -\> String -\>
    [DTD](Data-DatabaseTemplate.html#t:DTD)
-   [ifdtd](#v:ifdtd) :: String -\> (String -\> Bool) -\>
    [DTD](Data-DatabaseTemplate.html#t:DTD) -\>
    [DTD](Data-DatabaseTemplate.html#t:DTD) -\>
    [DTD](Data-DatabaseTemplate.html#t:DTD)
-   [(+==|)](#v:-43--61--61--124-) :: String -\>
    [SqlValue](Data-SqlTransaction.html#t:SqlValue) -\>
    [DTD](Data-DatabaseTemplate.html#t:DTD)
-   [(+\>=|)](#v:-43--62--61--124-) :: String -\>
    [SqlValue](Data-SqlTransaction.html#t:SqlValue) -\>
    [DTD](Data-DatabaseTemplate.html#t:DTD)
-   [(+\>|)](#v:-43--62--124-) :: String -\>
    [SqlValue](Data-SqlTransaction.html#t:SqlValue) -\>
    [DTD](Data-DatabaseTemplate.html#t:DTD)
-   [(+\<|)](#v:-43--60--124-) :: String -\>
    [SqlValue](Data-SqlTransaction.html#t:SqlValue) -\>
    [DTD](Data-DatabaseTemplate.html#t:DTD)
-   [(+\<=|)](#v:-43--60--61--124-) :: String -\>
    [SqlValue](Data-SqlTransaction.html#t:SqlValue) -\>
    [DTD](Data-DatabaseTemplate.html#t:DTD)
-   [(+%|)](#v:-43--37--124-) :: String -\>
    [SqlValue](Data-SqlTransaction.html#t:SqlValue) -\>
    [DTD](Data-DatabaseTemplate.html#t:DTD)
-   [(+%%|)](#v:-43--37--37--124-) :: String -\>
    [SqlValue](Data-SqlTransaction.html#t:SqlValue) -\>
    [DTD](Data-DatabaseTemplate.html#t:DTD)
-   [(+\<\>|)](#v:-43--60--62--124-) :: String -\>
    [SqlValue](Data-SqlTransaction.html#t:SqlValue) -\>
    [DTD](Data-DatabaseTemplate.html#t:DTD)
-   [dtd](#v:dtd) :: [DTD](Data-DatabaseTemplate.html#t:DTD) -\> HashMap
    String [SqlValue](Data-SqlTransaction.html#t:SqlValue) -\>
    [Constraints](Data-Database.html#t:Constraints)
-   [evalDTD](#v:evalDTD) :: [DTD](Data-DatabaseTemplate.html#t:DTD) -\>
    HashMap String [SqlValue](Data-SqlTransaction.html#t:SqlValue) -\>
    Maybe [Constraint](Data-Database.html#t:Constraint)

Documentation
=============

data DTD

Constructors

  ------------------------------------------------------------------------------------------------------------- ---
  Con [ConOp](Data-Database.html#t:ConOp) String [DTD](Data-DatabaseTemplate.html#t:DTD)                         
  And [DTD](Data-DatabaseTemplate.html#t:DTD) [DTD](Data-DatabaseTemplate.html#t:DTD)                            
  Or [DTD](Data-DatabaseTemplate.html#t:DTD) [DTD](Data-DatabaseTemplate.html#t:DTD)                             
  Lift String                                                                                                    
  Fix [SqlValue](Data-SqlTransaction.html#t:SqlValue)                                                            
  If String (String -\> Bool) [DTD](Data-DatabaseTemplate.html#t:DTD) [DTD](Data-DatabaseTemplate.html#t:DTD)    
  OrderedBy [DTD](Data-DatabaseTemplate.html#t:DTD) [String]                                                     
  Nop                                                                                                            
  ------------------------------------------------------------------------------------------------------------- ---

orderedBy :: [DTD](Data-DatabaseTemplate.html#t:DTD) -\> [String] -\>
[DTD](Data-DatabaseTemplate.html#t:DTD)

transformDTD :: ([DTD](Data-DatabaseTemplate.html#t:DTD) -\>
[DTD](Data-DatabaseTemplate.html#t:DTD)) -\>
[DTD](Data-DatabaseTemplate.html#t:DTD) -\>
[DTD](Data-DatabaseTemplate.html#t:DTD)

Transform a DTD bottom up

filterDTD :: ([DTD](Data-DatabaseTemplate.html#t:DTD) -\> Bool) -\>
[DTD](Data-DatabaseTemplate.html#t:DTD) -\>
[DTD](Data-DatabaseTemplate.html#t:DTD)

Filter certain DTD out

(+&&) :: [DTD](Data-DatabaseTemplate.html#t:DTD) -\>
[DTD](Data-DatabaseTemplate.html#t:DTD) -\>
[DTD](Data-DatabaseTemplate.html#t:DTD)

(+||) :: [DTD](Data-DatabaseTemplate.html#t:DTD) -\>
[DTD](Data-DatabaseTemplate.html#t:DTD) -\>
[DTD](Data-DatabaseTemplate.html#t:DTD)

(+==) :: String -\> String -\> [DTD](Data-DatabaseTemplate.html#t:DTD)

Equal operator lifted

(+\>=) :: String -\> String -\> [DTD](Data-DatabaseTemplate.html#t:DTD)

Greater or equal lifted

(+\>) :: String -\> String -\> [DTD](Data-DatabaseTemplate.html#t:DTD)

Greater lifted

(+\<) :: String -\> String -\> [DTD](Data-DatabaseTemplate.html#t:DTD)

Smaller lifted

(+\<=) :: String -\> String -\> [DTD](Data-DatabaseTemplate.html#t:DTD)

Smaller or equal lifted

(+%) :: String -\> String -\> [DTD](Data-DatabaseTemplate.html#t:DTD)

Like lifted

(+%%) :: String -\> String -\> [DTD](Data-DatabaseTemplate.html#t:DTD)

ILike lifted

(+\<\>) :: String -\> String -\> [DTD](Data-DatabaseTemplate.html#t:DTD)

Not equal lifted

ifdtd :: String -\> (String -\> Bool) -\>
[DTD](Data-DatabaseTemplate.html#t:DTD) -\>
[DTD](Data-DatabaseTemplate.html#t:DTD) -\>
[DTD](Data-DatabaseTemplate.html#t:DTD)

If statement, see above for usage example

(+==|) :: String -\> [SqlValue](Data-SqlTransaction.html#t:SqlValue) -\>
[DTD](Data-DatabaseTemplate.html#t:DTD)

Equal fixed

(+\>=|) :: String -\> [SqlValue](Data-SqlTransaction.html#t:SqlValue)
-\> [DTD](Data-DatabaseTemplate.html#t:DTD)

Greater or eqal fixed

(+\>|) :: String -\> [SqlValue](Data-SqlTransaction.html#t:SqlValue) -\>
[DTD](Data-DatabaseTemplate.html#t:DTD)

Greater fixed

(+\<|) :: String -\> [SqlValue](Data-SqlTransaction.html#t:SqlValue) -\>
[DTD](Data-DatabaseTemplate.html#t:DTD)

smaller fixed

(+\<=|) :: String -\> [SqlValue](Data-SqlTransaction.html#t:SqlValue)
-\> [DTD](Data-DatabaseTemplate.html#t:DTD)

smaller or equal fixed

(+%|) :: String -\> [SqlValue](Data-SqlTransaction.html#t:SqlValue) -\>
[DTD](Data-DatabaseTemplate.html#t:DTD)

like fixed

(+%%|) :: String -\> [SqlValue](Data-SqlTransaction.html#t:SqlValue) -\>
[DTD](Data-DatabaseTemplate.html#t:DTD)

ilike fixed

(+\<\>|) :: String -\> [SqlValue](Data-SqlTransaction.html#t:SqlValue)
-\> [DTD](Data-DatabaseTemplate.html#t:DTD)

dtd :: [DTD](Data-DatabaseTemplate.html#t:DTD) -\> HashMap String
[SqlValue](Data-SqlTransaction.html#t:SqlValue) -\>
[Constraints](Data-Database.html#t:Constraints)

evalDTD

Arguments

:: [DTD](Data-DatabaseTemplate.html#t:DTD)

The database template

-\> HashMap String [SqlValue](Data-SqlTransaction.html#t:SqlValue)

Hashmap which provides the values

-\> Maybe [Constraint](Data-Database.html#t:Constraint)

Constraint usable form computation

Evaluate transforms the DTD into a constraint

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
