=============
Data.Relation
=============

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Data.Relation

Documentation
=============

data Relation

Instances

+---------------------------------------------------------+-----+
| Show `Relation <Data-Relation.html#t:Relation>`__       |     |
+---------------------------------------------------------+-----+
| ToValues `Relation <Data-Relation.html#t:Relation>`__   |     |
+---------------------------------------------------------+-----+
| ToSql `Relation <Data-Relation.html#t:Relation>`__      |     |
+---------------------------------------------------------+-----+

type RelationM = State `Relation <Data-Relation.html#t:Relation>`__ ()

getResult :: `RelationM <Data-Relation.html#t:RelationM>`__ ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ Result

getAssoc :: `RelationM <Data-Relation.html#t:RelationM>`__ ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ ResultAssoc

toAssoc :: Result -> ResultAssoc

fromAssoc :: Schema -> ResultAssoc -> Result

raw :: Sql -> [`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__\ ] ->
Schema -> `RelationM <Data-Relation.html#t:RelationM>`__

table :: String -> Schema ->
`RelationM <Data-Relation.html#t:RelationM>`__

view :: String -> Schema ->
`RelationM <Data-Relation.html#t:RelationM>`__

identity :: `RelationM <Data-Relation.html#t:RelationM>`__

project :: Schema -> `RelationM <Data-Relation.html#t:RelationM>`__

projectAs :: [(Key, Key)] ->
`RelationM <Data-Relation.html#t:RelationM>`__

select :: Condition -> `RelationM <Data-Relation.html#t:RelationM>`__

unite :: `RelationM <Data-Relation.html#t:RelationM>`__ ->
`RelationM <Data-Relation.html#t:RelationM>`__

intersect :: `RelationM <Data-Relation.html#t:RelationM>`__ ->
`RelationM <Data-Relation.html#t:RelationM>`__

diff :: `RelationM <Data-Relation.html#t:RelationM>`__ ->
`RelationM <Data-Relation.html#t:RelationM>`__

cross :: `RelationM <Data-Relation.html#t:RelationM>`__ ->
`RelationM <Data-Relation.html#t:RelationM>`__

rename :: [(Key, Key)] -> `RelationM <Data-Relation.html#t:RelationM>`__

join :: Condition -> `RelationM <Data-Relation.html#t:RelationM>`__ ->
`RelationM <Data-Relation.html#t:RelationM>`__

take :: Integer -> `RelationM <Data-Relation.html#t:RelationM>`__

drop :: Integer -> `RelationM <Data-Relation.html#t:RelationM>`__

sort :: Orderings -> `RelationM <Data-Relation.html#t:RelationM>`__

data Direction

Constructors

+--------+-----+
| Asc    |     |
+--------+-----+
| Desc   |     |
+--------+-----+

Instances

+-----------------------------------------------------------+-----+
| Show `Direction <Data-Relation.html#t:Direction>`__       |     |
+-----------------------------------------------------------+-----+
| ToValues `Direction <Data-Relation.html#t:Direction>`__   |     |
+-----------------------------------------------------------+-----+
| ToValues Orderings                                        |     |
+-----------------------------------------------------------+-----+
| ToValues Ordering                                         |     |
+-----------------------------------------------------------+-----+
| ToSql `Direction <Data-Relation.html#t:Direction>`__      |     |
+-----------------------------------------------------------+-----+
| ToSql Orderings                                           |     |
+-----------------------------------------------------------+-----+
| ToSql Ordering                                            |     |
+-----------------------------------------------------------+-----+

(<&&>) :: Condition -> Condition -> Condition

(<\|\|>) :: Condition -> Condition -> Condition

(\|==\|) :: String -> String -> Condition

(\|>\|) :: String -> String -> Condition

(\|>=\|) :: String -> String -> Condition

(\|<>\|) :: String -> String -> Condition

(\|<\|) :: String -> String -> Condition

(\|<=\|) :: String -> String -> Condition

(\|%\|) :: String -> String -> Condition

(\|%%\|) :: String -> String -> Condition

(\*==\|) :: `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__ -> String
-> Condition

(\*>\|) :: `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__ -> String
-> Condition

(\*>=\|) :: `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__ -> String
-> Condition

(\*<>\|) :: `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__ -> String
-> Condition

(\*<\|) :: `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__ -> String
-> Condition

(\*<=\|) :: `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__ -> String
-> Condition

(\*%\|) :: `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__ -> String
-> Condition

(\*%%\|) :: `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__ -> String
-> Condition

(\|==\*) :: String -> `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__
-> Condition

(\|>\*) :: String -> `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__
-> Condition

(\|>=\*) :: String -> `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__
-> Condition

(\|<>\*) :: String -> `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__
-> Condition

(\|<\*) :: String -> `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__
-> Condition

(\|<=\*) :: String -> `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__
-> Condition

(\|%\*) :: String -> `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__
-> Condition

(\|%%\*) :: String -> `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__
-> Condition

(\*==\*) :: `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__ ->
`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__ -> Condition

(\*>\*) :: `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__ ->
`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__ -> Condition

(\*>=\*) :: `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__ ->
`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__ -> Condition

(\*<>\*) :: `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__ ->
`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__ -> Condition

(\*<\*) :: `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__ ->
`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__ -> Condition

(\*<=\*) :: `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__ ->
`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__ -> Condition

(\*%\*) :: `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__ ->
`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__ -> Condition

(\*%%\*) :: `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__ ->
`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__ -> Condition

and :: [Condition] -> Condition

or :: [Condition] -> Condition

as :: Sql -> [`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__\ ] ->
Condition

not :: Bool -> Bool

isnull :: String -> Condition

notnull :: String -> Condition

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
