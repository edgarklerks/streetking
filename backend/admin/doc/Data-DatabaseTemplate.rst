=====================
Data.DatabaseTemplate
=====================

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Data.DatabaseTemplate

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

filterDTD :: (`DTD <Data-DatabaseTemplate.html#t:DTD>`__ -> Bool) ->
`DTD <Data-DatabaseTemplate.html#t:DTD>`__ ->
`DTD <Data-DatabaseTemplate.html#t:DTD>`__

(+&&) :: `DTD <Data-DatabaseTemplate.html#t:DTD>`__ ->
`DTD <Data-DatabaseTemplate.html#t:DTD>`__ ->
`DTD <Data-DatabaseTemplate.html#t:DTD>`__

(+\|\|) :: `DTD <Data-DatabaseTemplate.html#t:DTD>`__ ->
`DTD <Data-DatabaseTemplate.html#t:DTD>`__ ->
`DTD <Data-DatabaseTemplate.html#t:DTD>`__

(+==) :: String -> String -> `DTD <Data-DatabaseTemplate.html#t:DTD>`__

(+>=) :: String -> String -> `DTD <Data-DatabaseTemplate.html#t:DTD>`__

(+>) :: String -> String -> `DTD <Data-DatabaseTemplate.html#t:DTD>`__

(+<) :: String -> String -> `DTD <Data-DatabaseTemplate.html#t:DTD>`__

(+<=) :: String -> String -> `DTD <Data-DatabaseTemplate.html#t:DTD>`__

(+%) :: String -> String -> `DTD <Data-DatabaseTemplate.html#t:DTD>`__

(+%%) :: String -> String -> `DTD <Data-DatabaseTemplate.html#t:DTD>`__

(+<>) :: String -> String -> `DTD <Data-DatabaseTemplate.html#t:DTD>`__

ifdtd :: String -> (String -> Bool) ->
`DTD <Data-DatabaseTemplate.html#t:DTD>`__ ->
`DTD <Data-DatabaseTemplate.html#t:DTD>`__ ->
`DTD <Data-DatabaseTemplate.html#t:DTD>`__

(+==\|) :: String -> `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__
-> `DTD <Data-DatabaseTemplate.html#t:DTD>`__

(+>=\|) :: String -> `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__
-> `DTD <Data-DatabaseTemplate.html#t:DTD>`__

(+>\|) :: String -> `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__
-> `DTD <Data-DatabaseTemplate.html#t:DTD>`__

(+<\|) :: String -> `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__
-> `DTD <Data-DatabaseTemplate.html#t:DTD>`__

(+<=\|) :: String -> `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__
-> `DTD <Data-DatabaseTemplate.html#t:DTD>`__

(+%\|) :: String -> `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__
-> `DTD <Data-DatabaseTemplate.html#t:DTD>`__

(+%%\|) :: String -> `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__
-> `DTD <Data-DatabaseTemplate.html#t:DTD>`__

(+<>\|) :: String -> `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__
-> `DTD <Data-DatabaseTemplate.html#t:DTD>`__

dtd :: `DTD <Data-DatabaseTemplate.html#t:DTD>`__ -> HashMap String
`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__ ->
`Constraints <Data-Database.html#t:Constraints>`__

evalDTD :: `DTD <Data-DatabaseTemplate.html#t:DTD>`__ -> HashMap String
`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__ -> Maybe
`Constraint <Data-Database.html#t:Constraint>`__

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
