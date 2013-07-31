=============
Data.Database
=============

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Data.Database

Documentation
=============

dbconn :: IO `Connection <Data-SqlTransaction.html#t:Connection>`__

doSql :: `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ a -> IO a

type Sql = String

type Value = `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__

type Values = [`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__\ ]

class Expression a where

Methods

sql :: a -> `Sql <Data-Database.html#t:Sql>`__

values :: a -> `Values <Data-Database.html#t:Values>`__

Instances

+-------------------------------------------------------------------------------------------------------+-----+
| `Expression <Data-Database.html#t:Expression>`__ `Update <Data-Database.html#t:Update>`__             |     |
+-------------------------------------------------------------------------------------------------------+-----+
| `Expression <Data-Database.html#t:Expression>`__ `Insert <Data-Database.html#t:Insert>`__             |     |
+-------------------------------------------------------------------------------------------------------+-----+
| `Expression <Data-Database.html#t:Expression>`__ `Delete <Data-Database.html#t:Delete>`__             |     |
+-------------------------------------------------------------------------------------------------------+-----+
| `Expression <Data-Database.html#t:Expression>`__ `Select <Data-Database.html#t:Select>`__             |     |
+-------------------------------------------------------------------------------------------------------+-----+
| `Expression <Data-Database.html#t:Expression>`__ `Offset <Data-Database.html#t:Offset>`__             |     |
+-------------------------------------------------------------------------------------------------------+-----+
| `Expression <Data-Database.html#t:Expression>`__ `Limit <Data-Database.html#t:Limit>`__               |     |
+-------------------------------------------------------------------------------------------------------+-----+
| `Expression <Data-Database.html#t:Expression>`__ `Direction <Data-Database.html#t:Direction>`__       |     |
+-------------------------------------------------------------------------------------------------------+-----+
| `Expression <Data-Database.html#t:Expression>`__ `Order <Data-Database.html#t:Order>`__               |     |
+-------------------------------------------------------------------------------------------------------+-----+
| `Expression <Data-Database.html#t:Expression>`__ `Orders <Data-Database.html#t:Orders>`__             |     |
+-------------------------------------------------------------------------------------------------------+-----+
| `Expression <Data-Database.html#t:Expression>`__ `ConOp <Data-Database.html#t:ConOp>`__               |     |
+-------------------------------------------------------------------------------------------------------+-----+
| `Expression <Data-Database.html#t:Expression>`__ `Constraint <Data-Database.html#t:Constraint>`__     |     |
+-------------------------------------------------------------------------------------------------------+-----+
| `Expression <Data-Database.html#t:Expression>`__ `Constraints <Data-Database.html#t:Constraints>`__   |     |
+-------------------------------------------------------------------------------------------------------+-----+
| `Expression <Data-Database.html#t:Expression>`__ `Assignment <Data-Database.html#t:Assignment>`__     |     |
+-------------------------------------------------------------------------------------------------------+-----+
| `Expression <Data-Database.html#t:Expression>`__ `Assignments <Data-Database.html#t:Assignments>`__   |     |
+-------------------------------------------------------------------------------------------------------+-----+
| `Expression <Data-Database.html#t:Expression>`__ `Selections <Data-Database.html#t:Selections>`__     |     |
+-------------------------------------------------------------------------------------------------------+-----+
| `Expression <Data-Database.html#t:Expression>`__ `Pair <Data-Database.html#t:Pair>`__                 |     |
+-------------------------------------------------------------------------------------------------------+-----+

type Pair = (`Sql <Data-Database.html#t:Sql>`__,
`Values <Data-Database.html#t:Values>`__)

(.\*) :: `Sql <Data-Database.html#t:Sql>`__ ->
`Values <Data-Database.html#t:Values>`__ ->
`Pair <Data-Database.html#t:Pair>`__

pair :: `Expression <Data-Database.html#t:Expression>`__ a => a ->
`Pair <Data-Database.html#t:Pair>`__

class Expressable a where

Methods

express :: a -> `Pair <Data-Database.html#t:Pair>`__

Instances

+-----------------------------------------------------------------------------------------------+-----+
| `Expressable <Data-Database.html#t:Expressable>`__ `Values <Data-Database.html#t:Values>`__   |     |
+-----------------------------------------------------------------------------------------------+-----+
| `Expressable <Data-Database.html#t:Expressable>`__ `Value <Data-Database.html#t:Value>`__     |     |
+-----------------------------------------------------------------------------------------------+-----+
| `Expressable <Data-Database.html#t:Expressable>`__ `Sql <Data-Database.html#t:Sql>`__         |     |
+-----------------------------------------------------------------------------------------------+-----+

type Table = `Pair <Data-Database.html#t:Pair>`__

table :: `Sql <Data-Database.html#t:Sql>`__ ->
`Table <Data-Database.html#t:Table>`__

type Selections = [`Selection <Data-Database.html#t:Selection>`__\ ]

type Selection = `Pair <Data-Database.html#t:Pair>`__

column :: `Sql <Data-Database.html#t:Sql>`__ ->
`Selection <Data-Database.html#t:Selection>`__

selectAll :: `Selection <Data-Database.html#t:Selection>`__

data Assignments

Constructors

+----------------------------------------------------------------+-----+
| Inserts [`Assignment <Data-Database.html#t:Assignment>`__\ ]   |     |
+----------------------------------------------------------------+-----+
| Updates [`Assignment <Data-Database.html#t:Assignment>`__\ ]   |     |
+----------------------------------------------------------------+-----+

Instances

+-------------------------------------------------------------------------------------------------------+-----+
| Show `Assignments <Data-Database.html#t:Assignments>`__                                               |     |
+-------------------------------------------------------------------------------------------------------+-----+
| `Expression <Data-Database.html#t:Expression>`__ `Assignments <Data-Database.html#t:Assignments>`__   |     |
+-------------------------------------------------------------------------------------------------------+-----+

data Assignment

Constructors

+------------------------------------------------------------------------------------+-----+
| Assign `Sql <Data-Database.html#t:Sql>`__ `Value <Data-Database.html#t:Value>`__   |     |
+------------------------------------------------------------------------------------+-----+
| Default `Sql <Data-Database.html#t:Sql>`__ `Sql <Data-Database.html#t:Sql>`__      |     |
+------------------------------------------------------------------------------------+-----+

Instances

+-----------------------------------------------------------------------------------------------------+-----+
| Show `Assignment <Data-Database.html#t:Assignment>`__                                               |     |
+-----------------------------------------------------------------------------------------------------+-----+
| `Expression <Data-Database.html#t:Expression>`__ `Assignment <Data-Database.html#t:Assignment>`__   |     |
+-----------------------------------------------------------------------------------------------------+-----+

(.->) :: `Sql <Data-Database.html#t:Sql>`__ ->
`Value <Data-Database.html#t:Value>`__ ->
`Assignment <Data-Database.html#t:Assignment>`__

(.#>) :: `Sql <Data-Database.html#t:Sql>`__ ->
`Sql <Data-Database.html#t:Sql>`__ ->
`Assignment <Data-Database.html#t:Assignment>`__

devault :: `Assignment <Data-Database.html#t:Assignment>`__ ->
`Sql <Data-Database.html#t:Sql>`__

type Constraints = [`Constraint <Data-Database.html#t:Constraint>`__\ ]

data Constraint

Constructors

+-------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Constraint `ConOp <Data-Database.html#t:ConOp>`__ `Selection <Data-Database.html#t:Selection>`__ `Value <Data-Database.html#t:Value>`__   |     |
+-------------------------------------------------------------------------------------------------------------------------------------------+-----+
| And `Constraint <Data-Database.html#t:Constraint>`__ `Constraint <Data-Database.html#t:Constraint>`__                                     |     |
+-------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Or `Constraint <Data-Database.html#t:Constraint>`__ `Constraint <Data-Database.html#t:Constraint>`__                                      |     |
+-------------------------------------------------------------------------------------------------------------------------------------------+-----+

Instances

+-------------------------------------------------------------------------------------------------------+-----+
| Show `Constraint <Data-Database.html#t:Constraint>`__                                                 |     |
+-------------------------------------------------------------------------------------------------------+-----+
| `Expression <Data-Database.html#t:Expression>`__ `Constraint <Data-Database.html#t:Constraint>`__     |     |
+-------------------------------------------------------------------------------------------------------+-----+
| `Expression <Data-Database.html#t:Expression>`__ `Constraints <Data-Database.html#t:Constraints>`__   |     |
+-------------------------------------------------------------------------------------------------------+-----+

(.&&) :: `Constraint <Data-Database.html#t:Constraint>`__ ->
`Constraint <Data-Database.html#t:Constraint>`__ ->
`Constraint <Data-Database.html#t:Constraint>`__

(.\|\|) :: `Constraint <Data-Database.html#t:Constraint>`__ ->
`Constraint <Data-Database.html#t:Constraint>`__ ->
`Constraint <Data-Database.html#t:Constraint>`__

data ConOp

Constructors

+---------------+-----+
| OpLT          |     |
+---------------+-----+
| OpLTE         |     |
+---------------+-----+
| OpGT          |     |
+---------------+-----+
| OpGTE         |     |
+---------------+-----+
| OpEQ          |     |
+---------------+-----+
| OpNEQ         |     |
+---------------+-----+
| OpContains    |     |
+---------------+-----+
| OpIContains   |     |
+---------------+-----+

Instances

+-------------------------------------------------------------------------------------------+-----+
| Show `ConOp <Data-Database.html#t:ConOp>`__                                               |     |
+-------------------------------------------------------------------------------------------+-----+
| `Expression <Data-Database.html#t:Expression>`__ `ConOp <Data-Database.html#t:ConOp>`__   |     |
+-------------------------------------------------------------------------------------------+-----+

cLT :: `Selection <Data-Database.html#t:Selection>`__ ->
`Value <Data-Database.html#t:Value>`__ ->
`Constraint <Data-Database.html#t:Constraint>`__

cLTE :: `Selection <Data-Database.html#t:Selection>`__ ->
`Value <Data-Database.html#t:Value>`__ ->
`Constraint <Data-Database.html#t:Constraint>`__

cGT :: `Selection <Data-Database.html#t:Selection>`__ ->
`Value <Data-Database.html#t:Value>`__ ->
`Constraint <Data-Database.html#t:Constraint>`__

cGTE :: `Selection <Data-Database.html#t:Selection>`__ ->
`Value <Data-Database.html#t:Value>`__ ->
`Constraint <Data-Database.html#t:Constraint>`__

cEQ :: `Selection <Data-Database.html#t:Selection>`__ ->
`Value <Data-Database.html#t:Value>`__ ->
`Constraint <Data-Database.html#t:Constraint>`__

cNEQ :: `Selection <Data-Database.html#t:Selection>`__ ->
`Value <Data-Database.html#t:Value>`__ ->
`Constraint <Data-Database.html#t:Constraint>`__

cIn :: `Selection <Data-Database.html#t:Selection>`__ ->
`Value <Data-Database.html#t:Value>`__ ->
`Constraint <Data-Database.html#t:Constraint>`__

cIni :: `Selection <Data-Database.html#t:Selection>`__ ->
`Value <Data-Database.html#t:Value>`__ ->
`Constraint <Data-Database.html#t:Constraint>`__

(\|<) :: `Sql <Data-Database.html#t:Sql>`__ ->
`Value <Data-Database.html#t:Value>`__ ->
`Constraint <Data-Database.html#t:Constraint>`__

(\|<=) :: `Sql <Data-Database.html#t:Sql>`__ ->
`Value <Data-Database.html#t:Value>`__ ->
`Constraint <Data-Database.html#t:Constraint>`__

(\|>) :: `Sql <Data-Database.html#t:Sql>`__ ->
`Value <Data-Database.html#t:Value>`__ ->
`Constraint <Data-Database.html#t:Constraint>`__

(\|>=) :: `Sql <Data-Database.html#t:Sql>`__ ->
`Value <Data-Database.html#t:Value>`__ ->
`Constraint <Data-Database.html#t:Constraint>`__

(\|==) :: `Sql <Data-Database.html#t:Sql>`__ ->
`Value <Data-Database.html#t:Value>`__ ->
`Constraint <Data-Database.html#t:Constraint>`__

(\|<>) :: `Sql <Data-Database.html#t:Sql>`__ ->
`Value <Data-Database.html#t:Value>`__ ->
`Constraint <Data-Database.html#t:Constraint>`__

(\|%) :: `Sql <Data-Database.html#t:Sql>`__ ->
`Value <Data-Database.html#t:Value>`__ ->
`Constraint <Data-Database.html#t:Constraint>`__

(\|%%) :: `Sql <Data-Database.html#t:Sql>`__ ->
`Value <Data-Database.html#t:Value>`__ ->
`Constraint <Data-Database.html#t:Constraint>`__

type Orders = [`Order <Data-Database.html#t:Order>`__\ ]

data Order

Constructors

+-------------------------------------------------------------------------------------------------------+-----+
| Order `Selection <Data-Database.html#t:Selection>`__ `Direction <Data-Database.html#t:Direction>`__   |     |
+-------------------------------------------------------------------------------------------------------+-----+

Instances

+---------------------------------------------------------------------------------------------+-----+
| Show `Order <Data-Database.html#t:Order>`__                                                 |     |
+---------------------------------------------------------------------------------------------+-----+
| `Expression <Data-Database.html#t:Expression>`__ `Order <Data-Database.html#t:Order>`__     |     |
+---------------------------------------------------------------------------------------------+-----+
| `Expression <Data-Database.html#t:Expression>`__ `Orders <Data-Database.html#t:Orders>`__   |     |
+---------------------------------------------------------------------------------------------+-----+

order :: `Sql <Data-Database.html#t:Sql>`__ ->
`Direction <Data-Database.html#t:Direction>`__ ->
`Order <Data-Database.html#t:Order>`__

asc :: `Direction <Data-Database.html#t:Direction>`__

desc :: `Direction <Data-Database.html#t:Direction>`__

type Direction = Bool

data Limit

Constructors

+------------------------------------------------+-----+
| Limit `Value <Data-Database.html#t:Value>`__   |     |
+------------------------------------------------+-----+
| NullLimit                                      |     |
+------------------------------------------------+-----+

Instances

+-------------------------------------------------------------------------------------------+-----+
| Show `Limit <Data-Database.html#t:Limit>`__                                               |     |
+-------------------------------------------------------------------------------------------+-----+
| `Expression <Data-Database.html#t:Expression>`__ `Limit <Data-Database.html#t:Limit>`__   |     |
+-------------------------------------------------------------------------------------------+-----+

data Offset

Constructors

+-------------------------------------------------+-----+
| Offset `Value <Data-Database.html#t:Value>`__   |     |
+-------------------------------------------------+-----+
| NullOffset                                      |     |
+-------------------------------------------------+-----+

Instances

+---------------------------------------------------------------------------------------------+-----+
| Show `Offset <Data-Database.html#t:Offset>`__                                               |     |
+---------------------------------------------------------------------------------------------+-----+
| `Expression <Data-Database.html#t:Expression>`__ `Offset <Data-Database.html#t:Offset>`__   |     |
+---------------------------------------------------------------------------------------------+-----+

data Select

Constructors

+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Select `Table <Data-Database.html#t:Table>`__ `Selections <Data-Database.html#t:Selections>`__ `Constraints <Data-Database.html#t:Constraints>`__ `Orders <Data-Database.html#t:Orders>`__ `Limit <Data-Database.html#t:Limit>`__ `Offset <Data-Database.html#t:Offset>`__   |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+

Instances

+---------------------------------------------------------------------------------------------+-----+
| `Expression <Data-Database.html#t:Expression>`__ `Select <Data-Database.html#t:Select>`__   |     |
+---------------------------------------------------------------------------------------------+-----+

data Delete

Constructors

+----------------------------------------------------------------------------------------------------+-----+
| Delete `Table <Data-Database.html#t:Table>`__ `Constraints <Data-Database.html#t:Constraints>`__   |     |
+----------------------------------------------------------------------------------------------------+-----+

Instances

+---------------------------------------------------------------------------------------------+-----+
| `Expression <Data-Database.html#t:Expression>`__ `Delete <Data-Database.html#t:Delete>`__   |     |
+---------------------------------------------------------------------------------------------+-----+

data Insert

Constructors

+----------------------------------------------------------------------------------------------------+-----+
| Insert `Table <Data-Database.html#t:Table>`__ `Assignments <Data-Database.html#t:Assignments>`__   |     |
+----------------------------------------------------------------------------------------------------+-----+

Instances

+---------------------------------------------------------------------------------------------+-----+
| `Expression <Data-Database.html#t:Expression>`__ `Insert <Data-Database.html#t:Insert>`__   |     |
+---------------------------------------------------------------------------------------------+-----+

data Update

Constructors

+-------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Update `Table <Data-Database.html#t:Table>`__ `Assignments <Data-Database.html#t:Assignments>`__ `Constraints <Data-Database.html#t:Constraints>`__   |     |
+-------------------------------------------------------------------------------------------------------------------------------------------------------+-----+

Instances

+---------------------------------------------------------------------------------------------+-----+
| `Expression <Data-Database.html#t:Expression>`__ `Update <Data-Database.html#t:Update>`__   |     |
+---------------------------------------------------------------------------------------------+-----+

constraints :: [(`Sql <Data-Database.html#t:Sql>`__,
`Selection <Data-Database.html#t:Selection>`__ ->
`Value <Data-Database.html#t:Value>`__ ->
`Constraint <Data-Database.html#t:Constraint>`__)] ->
[(`Sql <Data-Database.html#t:Sql>`__,
`Value <Data-Database.html#t:Value>`__)] ->
`Constraints <Data-Database.html#t:Constraints>`__

assigns :: [(`Sql <Data-Database.html#t:Sql>`__,
`Sql <Data-Database.html#t:Sql>`__)] ->
[(`Sql <Data-Database.html#t:Sql>`__,
`Value <Data-Database.html#t:Value>`__)] ->
[`Assignment <Data-Database.html#t:Assignment>`__\ ]

inserts :: [(`Sql <Data-Database.html#t:Sql>`__,
`Sql <Data-Database.html#t:Sql>`__)] ->
[(`Sql <Data-Database.html#t:Sql>`__,
`Value <Data-Database.html#t:Value>`__)] ->
`Assignments <Data-Database.html#t:Assignments>`__

updates :: [(`Sql <Data-Database.html#t:Sql>`__,
`Sql <Data-Database.html#t:Sql>`__)] ->
[(`Sql <Data-Database.html#t:Sql>`__,
`Value <Data-Database.html#t:Value>`__)] ->
`Assignments <Data-Database.html#t:Assignments>`__

orders :: [(`Sql <Data-Database.html#t:Sql>`__,
`Value <Data-Database.html#t:Value>`__)] ->
`Orders <Data-Database.html#t:Orders>`__

limit :: [(`Sql <Data-Database.html#t:Sql>`__,
`Value <Data-Database.html#t:Value>`__)] ->
`Limit <Data-Database.html#t:Limit>`__

offset :: [(`Sql <Data-Database.html#t:Sql>`__,
`Value <Data-Database.html#t:Value>`__)] ->
`Offset <Data-Database.html#t:Offset>`__

transaction :: `Expression <Data-Database.html#t:Expression>`__ x =>
(`Sql <Data-Database.html#t:Sql>`__ ->
`Values <Data-Database.html#t:Values>`__ ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ t) -> x ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ t

select :: `Sql <Data-Database.html#t:Sql>`__ ->
[(`Sql <Data-Database.html#t:Sql>`__,
`Selection <Data-Database.html#t:Selection>`__ ->
`Value <Data-Database.html#t:Value>`__ ->
`Constraint <Data-Database.html#t:Constraint>`__)] ->
[(`Sql <Data-Database.html#t:Sql>`__,
`Value <Data-Database.html#t:Value>`__)] ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ [HashMap
`Sql <Data-Database.html#t:Sql>`__
`Value <Data-Database.html#t:Value>`__]

insert :: `Sql <Data-Database.html#t:Sql>`__ ->
[(`Sql <Data-Database.html#t:Sql>`__,
`Sql <Data-Database.html#t:Sql>`__)] ->
[(`Sql <Data-Database.html#t:Sql>`__,
`Value <Data-Database.html#t:Value>`__)] ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__
`Value <Data-Database.html#t:Value>`__

update :: `Sql <Data-Database.html#t:Sql>`__ ->
`Constraints <Data-Database.html#t:Constraints>`__ ->
[(`Sql <Data-Database.html#t:Sql>`__,
`Sql <Data-Database.html#t:Sql>`__)] ->
[(`Sql <Data-Database.html#t:Sql>`__,
`Value <Data-Database.html#t:Value>`__)] ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ ()

upsert :: `Sql <Data-Database.html#t:Sql>`__ -> HashMap
`Sql <Data-Database.html#t:Sql>`__
`Value <Data-Database.html#t:Value>`__ ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__
`Value <Data-Database.html#t:Value>`__

geometry :: `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__ ->
`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__ ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__
`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
