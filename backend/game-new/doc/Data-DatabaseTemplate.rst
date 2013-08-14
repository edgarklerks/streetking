=====================
Data.DatabaseTemplate
=====================

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Data.DatabaseTemplate

Description

DSL for expression queries, which can extract data from a map and build
a database contstraint from the DSL. We have two operators a lifted one,
which pulls the right side from the map and the left side is the field
in the database.

::

     "id" +== "user-id"

This generates id = 1 (if user\_id contains 1) We also have fixed
operators, which don't pull up a value from the hash map, but have a
fixed value

::

     "id" +==| (toSql 12)

There also is an if statement:

::

     ifdtd ("account" +==| (toSql 1)) ("account_id" +== "account_id") ("account_id" +==| (toSql 2)

Synopsis

-  data `DTD <#t:DTD>`__

   -  = `Con <#v:Con>`__ `ConOp <Data-Database.html#t:ConOp>`__ String
      `DTD <Data-DatabaseTemplate.html#t:DTD>`__
   -  \| `And <#v:And>`__ `DTD <Data-DatabaseTemplate.html#t:DTD>`__
      `DTD <Data-DatabaseTemplate.html#t:DTD>`__
   -  \| `Or <#v:Or>`__ `DTD <Data-DatabaseTemplate.html#t:DTD>`__
      `DTD <Data-DatabaseTemplate.html#t:DTD>`__
   -  \| `Lift <#v:Lift>`__ String
   -  \| `Fix <#v:Fix>`__
      `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__
   -  \| `If <#v:If>`__ String (String -> Bool)
      `DTD <Data-DatabaseTemplate.html#t:DTD>`__
      `DTD <Data-DatabaseTemplate.html#t:DTD>`__
   -  \| `OrderedBy <#v:OrderedBy>`__
      `DTD <Data-DatabaseTemplate.html#t:DTD>`__ [String]
   -  \| `Nop <#v:Nop>`__

-  `orderedBy <#v:orderedBy>`__ ::
   `DTD <Data-DatabaseTemplate.html#t:DTD>`__ -> [String] ->
   `DTD <Data-DatabaseTemplate.html#t:DTD>`__
-  `transformDTD <#v:transformDTD>`__ ::
   (`DTD <Data-DatabaseTemplate.html#t:DTD>`__ ->
   `DTD <Data-DatabaseTemplate.html#t:DTD>`__) ->
   `DTD <Data-DatabaseTemplate.html#t:DTD>`__ ->
   `DTD <Data-DatabaseTemplate.html#t:DTD>`__
-  `filterDTD <#v:filterDTD>`__ ::
   (`DTD <Data-DatabaseTemplate.html#t:DTD>`__ -> Bool) ->
   `DTD <Data-DatabaseTemplate.html#t:DTD>`__ ->
   `DTD <Data-DatabaseTemplate.html#t:DTD>`__
-  `(+&&) <#v:-43--38--38->`__ ::
   `DTD <Data-DatabaseTemplate.html#t:DTD>`__ ->
   `DTD <Data-DatabaseTemplate.html#t:DTD>`__ ->
   `DTD <Data-DatabaseTemplate.html#t:DTD>`__
-  `(+\|\|) <#v:-43--124--124->`__ ::
   `DTD <Data-DatabaseTemplate.html#t:DTD>`__ ->
   `DTD <Data-DatabaseTemplate.html#t:DTD>`__ ->
   `DTD <Data-DatabaseTemplate.html#t:DTD>`__
-  `(+==) <#v:-43--61--61->`__ :: String -> String ->
   `DTD <Data-DatabaseTemplate.html#t:DTD>`__
-  `(+>=) <#v:-43--62--61->`__ :: String -> String ->
   `DTD <Data-DatabaseTemplate.html#t:DTD>`__
-  `(+>) <#v:-43--62->`__ :: String -> String ->
   `DTD <Data-DatabaseTemplate.html#t:DTD>`__
-  `(+<) <#v:-43--60->`__ :: String -> String ->
   `DTD <Data-DatabaseTemplate.html#t:DTD>`__
-  `(+<=) <#v:-43--60--61->`__ :: String -> String ->
   `DTD <Data-DatabaseTemplate.html#t:DTD>`__
-  `(+%) <#v:-43--37->`__ :: String -> String ->
   `DTD <Data-DatabaseTemplate.html#t:DTD>`__
-  `(+%%) <#v:-43--37--37->`__ :: String -> String ->
   `DTD <Data-DatabaseTemplate.html#t:DTD>`__
-  `(+<>) <#v:-43--60--62->`__ :: String -> String ->
   `DTD <Data-DatabaseTemplate.html#t:DTD>`__
-  `ifdtd <#v:ifdtd>`__ :: String -> (String -> Bool) ->
   `DTD <Data-DatabaseTemplate.html#t:DTD>`__ ->
   `DTD <Data-DatabaseTemplate.html#t:DTD>`__ ->
   `DTD <Data-DatabaseTemplate.html#t:DTD>`__
-  `(+==\|) <#v:-43--61--61--124->`__ :: String ->
   `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__ ->
   `DTD <Data-DatabaseTemplate.html#t:DTD>`__
-  `(+>=\|) <#v:-43--62--61--124->`__ :: String ->
   `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__ ->
   `DTD <Data-DatabaseTemplate.html#t:DTD>`__
-  `(+>\|) <#v:-43--62--124->`__ :: String ->
   `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__ ->
   `DTD <Data-DatabaseTemplate.html#t:DTD>`__
-  `(+<\|) <#v:-43--60--124->`__ :: String ->
   `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__ ->
   `DTD <Data-DatabaseTemplate.html#t:DTD>`__
-  `(+<=\|) <#v:-43--60--61--124->`__ :: String ->
   `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__ ->
   `DTD <Data-DatabaseTemplate.html#t:DTD>`__
-  `(+%\|) <#v:-43--37--124->`__ :: String ->
   `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__ ->
   `DTD <Data-DatabaseTemplate.html#t:DTD>`__
-  `(+%%\|) <#v:-43--37--37--124->`__ :: String ->
   `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__ ->
   `DTD <Data-DatabaseTemplate.html#t:DTD>`__
-  `(+<>\|) <#v:-43--60--62--124->`__ :: String ->
   `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__ ->
   `DTD <Data-DatabaseTemplate.html#t:DTD>`__
-  `dtd <#v:dtd>`__ :: `DTD <Data-DatabaseTemplate.html#t:DTD>`__ ->
   HashMap String `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__ ->
   `Constraints <Data-Database.html#t:Constraints>`__
-  `evalDTD <#v:evalDTD>`__ ::
   `DTD <Data-DatabaseTemplate.html#t:DTD>`__ -> HashMap String
   `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__ -> Maybe
   `Constraint <Data-Database.html#t:Constraint>`__

Documentation
=============

data DTD

Constructors

+--------------------------------------------------------------------------------------------------------------------+-----+
| Con `ConOp <Data-Database.html#t:ConOp>`__ String `DTD <Data-DatabaseTemplate.html#t:DTD>`__                       |     |
+--------------------------------------------------------------------------------------------------------------------+-----+
| And `DTD <Data-DatabaseTemplate.html#t:DTD>`__ `DTD <Data-DatabaseTemplate.html#t:DTD>`__                          |     |
+--------------------------------------------------------------------------------------------------------------------+-----+
| Or `DTD <Data-DatabaseTemplate.html#t:DTD>`__ `DTD <Data-DatabaseTemplate.html#t:DTD>`__                           |     |
+--------------------------------------------------------------------------------------------------------------------+-----+
| Lift String                                                                                                        |     |
+--------------------------------------------------------------------------------------------------------------------+-----+
| Fix `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__                                                             |     |
+--------------------------------------------------------------------------------------------------------------------+-----+
| If String (String -> Bool) `DTD <Data-DatabaseTemplate.html#t:DTD>`__ `DTD <Data-DatabaseTemplate.html#t:DTD>`__   |     |
+--------------------------------------------------------------------------------------------------------------------+-----+
| OrderedBy `DTD <Data-DatabaseTemplate.html#t:DTD>`__ [String]                                                      |     |
+--------------------------------------------------------------------------------------------------------------------+-----+
| Nop                                                                                                                |     |
+--------------------------------------------------------------------------------------------------------------------+-----+

orderedBy :: `DTD <Data-DatabaseTemplate.html#t:DTD>`__ -> [String] ->
`DTD <Data-DatabaseTemplate.html#t:DTD>`__

transformDTD :: (`DTD <Data-DatabaseTemplate.html#t:DTD>`__ ->
`DTD <Data-DatabaseTemplate.html#t:DTD>`__) ->
`DTD <Data-DatabaseTemplate.html#t:DTD>`__ ->
`DTD <Data-DatabaseTemplate.html#t:DTD>`__

Transform a DTD bottom up

filterDTD :: (`DTD <Data-DatabaseTemplate.html#t:DTD>`__ -> Bool) ->
`DTD <Data-DatabaseTemplate.html#t:DTD>`__ ->
`DTD <Data-DatabaseTemplate.html#t:DTD>`__

Filter certain DTD out

(+&&) :: `DTD <Data-DatabaseTemplate.html#t:DTD>`__ ->
`DTD <Data-DatabaseTemplate.html#t:DTD>`__ ->
`DTD <Data-DatabaseTemplate.html#t:DTD>`__

(+\|\|) :: `DTD <Data-DatabaseTemplate.html#t:DTD>`__ ->
`DTD <Data-DatabaseTemplate.html#t:DTD>`__ ->
`DTD <Data-DatabaseTemplate.html#t:DTD>`__

(+==) :: String -> String -> `DTD <Data-DatabaseTemplate.html#t:DTD>`__

Equal operator lifted

(+>=) :: String -> String -> `DTD <Data-DatabaseTemplate.html#t:DTD>`__

Greater or equal lifted

(+>) :: String -> String -> `DTD <Data-DatabaseTemplate.html#t:DTD>`__

Greater lifted

(+<) :: String -> String -> `DTD <Data-DatabaseTemplate.html#t:DTD>`__

Smaller lifted

(+<=) :: String -> String -> `DTD <Data-DatabaseTemplate.html#t:DTD>`__

Smaller or equal lifted

(+%) :: String -> String -> `DTD <Data-DatabaseTemplate.html#t:DTD>`__

Like lifted

(+%%) :: String -> String -> `DTD <Data-DatabaseTemplate.html#t:DTD>`__

ILike lifted

(+<>) :: String -> String -> `DTD <Data-DatabaseTemplate.html#t:DTD>`__

Not equal lifted

ifdtd :: String -> (String -> Bool) ->
`DTD <Data-DatabaseTemplate.html#t:DTD>`__ ->
`DTD <Data-DatabaseTemplate.html#t:DTD>`__ ->
`DTD <Data-DatabaseTemplate.html#t:DTD>`__

If statement, see above for usage example

(+==\|) :: String -> `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__
-> `DTD <Data-DatabaseTemplate.html#t:DTD>`__

Equal fixed

(+>=\|) :: String -> `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__
-> `DTD <Data-DatabaseTemplate.html#t:DTD>`__

Greater or eqal fixed

(+>\|) :: String -> `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__
-> `DTD <Data-DatabaseTemplate.html#t:DTD>`__

Greater fixed

(+<\|) :: String -> `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__
-> `DTD <Data-DatabaseTemplate.html#t:DTD>`__

smaller fixed

(+<=\|) :: String -> `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__
-> `DTD <Data-DatabaseTemplate.html#t:DTD>`__

smaller or equal fixed

(+%\|) :: String -> `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__
-> `DTD <Data-DatabaseTemplate.html#t:DTD>`__

like fixed

(+%%\|) :: String -> `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__
-> `DTD <Data-DatabaseTemplate.html#t:DTD>`__

ilike fixed

(+<>\|) :: String -> `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__
-> `DTD <Data-DatabaseTemplate.html#t:DTD>`__

dtd :: `DTD <Data-DatabaseTemplate.html#t:DTD>`__ -> HashMap String
`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__ ->
`Constraints <Data-Database.html#t:Constraints>`__

evalDTD

Arguments

:: `DTD <Data-DatabaseTemplate.html#t:DTD>`__

The database template

-> HashMap String `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__

Hashmap which provides the values

-> Maybe `Constraint <Data-Database.html#t:Constraint>`__

Constraint usable form computation

Evaluate transforms the DTD into a constraint

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
