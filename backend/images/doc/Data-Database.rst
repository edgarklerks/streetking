=============
Data.Database
=============

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Data.Database

Description

Primitive database data types for expression simple queries \| Internal
use only

Synopsis

-  `dbconn <#v:dbconn>`__ :: IO
   `Connection <Data-SqlTransaction.html#t:Connection>`__
-  `doSql <#v:doSql>`__ ::
   `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
   `Connection <Data-SqlTransaction.html#t:Connection>`__ a -> IO a
-  type `Sql <#t:Sql>`__ = String
-  type `Value <#t:Value>`__ =
   `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__
-  type `Values <#t:Values>`__ =
   [`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__\ ]
-  class `Expression <#t:Expression>`__ a where

   -  `sql <#v:sql>`__ :: a -> `Sql <Data-Database.html#t:Sql>`__
   -  `values <#v:values>`__ :: a ->
      `Values <Data-Database.html#t:Values>`__

-  type `Pair <#t:Pair>`__ = (`Sql <Data-Database.html#t:Sql>`__,
   `Values <Data-Database.html#t:Values>`__)
-  `(.\*) <#v:.-42->`__ :: `Sql <Data-Database.html#t:Sql>`__ ->
   `Values <Data-Database.html#t:Values>`__ ->
   `Pair <Data-Database.html#t:Pair>`__
-  `pair <#v:pair>`__ ::
   `Expression <Data-Database.html#t:Expression>`__ a => a ->
   `Pair <Data-Database.html#t:Pair>`__
-  class `Expressable <#t:Expressable>`__ a where

   -  `express <#v:express>`__ :: a ->
      `Pair <Data-Database.html#t:Pair>`__

-  type `Table <#t:Table>`__ = `Pair <Data-Database.html#t:Pair>`__
-  `table <#v:table>`__ :: `Sql <Data-Database.html#t:Sql>`__ ->
   `Table <Data-Database.html#t:Table>`__
-  type `Selections <#t:Selections>`__ =
   [`Selection <Data-Database.html#t:Selection>`__\ ]
-  type `Selection <#t:Selection>`__ =
   `Pair <Data-Database.html#t:Pair>`__
-  `column <#v:column>`__ :: `Sql <Data-Database.html#t:Sql>`__ ->
   `Selection <Data-Database.html#t:Selection>`__
-  `selectAll <#v:selectAll>`__ ::
   `Selection <Data-Database.html#t:Selection>`__
-  data `Assignments <#t:Assignments>`__

   -  = `Inserts <#v:Inserts>`__
      [`Assignment <Data-Database.html#t:Assignment>`__\ ]
   -  \| `Updates <#v:Updates>`__
      [`Assignment <Data-Database.html#t:Assignment>`__\ ]

-  data `Assignment <#t:Assignment>`__

   -  = `Assign <#v:Assign>`__ `Sql <Data-Database.html#t:Sql>`__
      `Value <Data-Database.html#t:Value>`__
   -  \| `Default <#v:Default>`__ `Sql <Data-Database.html#t:Sql>`__
      `Sql <Data-Database.html#t:Sql>`__

-  `(.->) <#v:.-45--62->`__ :: `Sql <Data-Database.html#t:Sql>`__ ->
   `Value <Data-Database.html#t:Value>`__ ->
   `Assignment <Data-Database.html#t:Assignment>`__
-  `(.#>) <#v:.-35--62->`__ :: `Sql <Data-Database.html#t:Sql>`__ ->
   `Sql <Data-Database.html#t:Sql>`__ ->
   `Assignment <Data-Database.html#t:Assignment>`__
-  `devault <#v:devault>`__ ::
   `Assignment <Data-Database.html#t:Assignment>`__ ->
   `Sql <Data-Database.html#t:Sql>`__
-  type `Constraints <#t:Constraints>`__ =
   [`Constraint <Data-Database.html#t:Constraint>`__\ ]
-  data `Constraint <#t:Constraint>`__

   -  = `Constraint <#v:Constraint>`__
      `ConOp <Data-Database.html#t:ConOp>`__
      `Selection <Data-Database.html#t:Selection>`__
      `Value <Data-Database.html#t:Value>`__
   -  \| `And <#v:And>`__
      `Constraint <Data-Database.html#t:Constraint>`__
      `Constraint <Data-Database.html#t:Constraint>`__
   -  \| `Or <#v:Or>`__ `Constraint <Data-Database.html#t:Constraint>`__
      `Constraint <Data-Database.html#t:Constraint>`__

-  `(.&&) <#v:.-38--38->`__ ::
   `Constraint <Data-Database.html#t:Constraint>`__ ->
   `Constraint <Data-Database.html#t:Constraint>`__ ->
   `Constraint <Data-Database.html#t:Constraint>`__
-  `(.\|\|) <#v:.-124--124->`__ ::
   `Constraint <Data-Database.html#t:Constraint>`__ ->
   `Constraint <Data-Database.html#t:Constraint>`__ ->
   `Constraint <Data-Database.html#t:Constraint>`__
-  data `ConOp <#t:ConOp>`__

   -  = `OpLT <#v:OpLT>`__
   -  \| `OpLTE <#v:OpLTE>`__
   -  \| `OpGT <#v:OpGT>`__
   -  \| `OpGTE <#v:OpGTE>`__
   -  \| `OpEQ <#v:OpEQ>`__
   -  \| `OpNEQ <#v:OpNEQ>`__
   -  \| `OpContains <#v:OpContains>`__
   -  \| `OpIContains <#v:OpIContains>`__
   -  \| `OpInList <#v:OpInList>`__

-  `cLT <#v:cLT>`__ :: `Selection <Data-Database.html#t:Selection>`__ ->
   `Value <Data-Database.html#t:Value>`__ ->
   `Constraint <Data-Database.html#t:Constraint>`__
-  `cLTE <#v:cLTE>`__ :: `Selection <Data-Database.html#t:Selection>`__
   -> `Value <Data-Database.html#t:Value>`__ ->
   `Constraint <Data-Database.html#t:Constraint>`__
-  `cGT <#v:cGT>`__ :: `Selection <Data-Database.html#t:Selection>`__ ->
   `Value <Data-Database.html#t:Value>`__ ->
   `Constraint <Data-Database.html#t:Constraint>`__
-  `cGTE <#v:cGTE>`__ :: `Selection <Data-Database.html#t:Selection>`__
   -> `Value <Data-Database.html#t:Value>`__ ->
   `Constraint <Data-Database.html#t:Constraint>`__
-  `cEQ <#v:cEQ>`__ :: `Selection <Data-Database.html#t:Selection>`__ ->
   `Value <Data-Database.html#t:Value>`__ ->
   `Constraint <Data-Database.html#t:Constraint>`__
-  `cNEQ <#v:cNEQ>`__ :: `Selection <Data-Database.html#t:Selection>`__
   -> `Value <Data-Database.html#t:Value>`__ ->
   `Constraint <Data-Database.html#t:Constraint>`__
-  `cIn <#v:cIn>`__ :: `Selection <Data-Database.html#t:Selection>`__ ->
   `Value <Data-Database.html#t:Value>`__ ->
   `Constraint <Data-Database.html#t:Constraint>`__
-  `cIni <#v:cIni>`__ :: `Selection <Data-Database.html#t:Selection>`__
   -> `Value <Data-Database.html#t:Value>`__ ->
   `Constraint <Data-Database.html#t:Constraint>`__
-  `cInList <#v:cInList>`__ ::
   `Selection <Data-Database.html#t:Selection>`__ ->
   `Value <Data-Database.html#t:Value>`__ ->
   `Constraint <Data-Database.html#t:Constraint>`__
-  `(\|<) <#v:-124--60->`__ :: `Sql <Data-Database.html#t:Sql>`__ ->
   `Value <Data-Database.html#t:Value>`__ ->
   `Constraint <Data-Database.html#t:Constraint>`__
-  `(\|<=) <#v:-124--60--61->`__ :: `Sql <Data-Database.html#t:Sql>`__
   -> `Value <Data-Database.html#t:Value>`__ ->
   `Constraint <Data-Database.html#t:Constraint>`__
-  `(\|>) <#v:-124--62->`__ :: `Sql <Data-Database.html#t:Sql>`__ ->
   `Value <Data-Database.html#t:Value>`__ ->
   `Constraint <Data-Database.html#t:Constraint>`__
-  `(\|>=) <#v:-124--62--61->`__ :: `Sql <Data-Database.html#t:Sql>`__
   -> `Value <Data-Database.html#t:Value>`__ ->
   `Constraint <Data-Database.html#t:Constraint>`__
-  `(\|==) <#v:-124--61--61->`__ :: `Sql <Data-Database.html#t:Sql>`__
   -> `Value <Data-Database.html#t:Value>`__ ->
   `Constraint <Data-Database.html#t:Constraint>`__
-  `(\|<>) <#v:-124--60--62->`__ :: `Sql <Data-Database.html#t:Sql>`__
   -> `Value <Data-Database.html#t:Value>`__ ->
   `Constraint <Data-Database.html#t:Constraint>`__
-  `(\|%) <#v:-124--37->`__ :: `Sql <Data-Database.html#t:Sql>`__ ->
   `Value <Data-Database.html#t:Value>`__ ->
   `Constraint <Data-Database.html#t:Constraint>`__
-  `(\|%%) <#v:-124--37--37->`__ :: `Sql <Data-Database.html#t:Sql>`__
   -> `Value <Data-Database.html#t:Value>`__ ->
   `Constraint <Data-Database.html#t:Constraint>`__
-  `(\|~) <#v:-124--126->`__ :: `Sql <Data-Database.html#t:Sql>`__ ->
   `Value <Data-Database.html#t:Value>`__ ->
   `Constraint <Data-Database.html#t:Constraint>`__
-  type `Orders <#t:Orders>`__ =
   [`Order <Data-Database.html#t:Order>`__\ ]
-  data `Order <#t:Order>`__ = `Order <#v:Order>`__
   `Selection <Data-Database.html#t:Selection>`__
   `Direction <Data-Database.html#t:Direction>`__
-  `order <#v:order>`__ :: `Sql <Data-Database.html#t:Sql>`__ ->
   `Direction <Data-Database.html#t:Direction>`__ ->
   `Order <Data-Database.html#t:Order>`__
-  `asc <#v:asc>`__ :: `Direction <Data-Database.html#t:Direction>`__
-  `desc <#v:desc>`__ :: `Direction <Data-Database.html#t:Direction>`__
-  type `Direction <#t:Direction>`__ = Bool
-  data `Limit <#t:Limit>`__

   -  = `Limit <#v:Limit>`__ `Value <Data-Database.html#t:Value>`__
   -  \| `NullLimit <#v:NullLimit>`__

-  data `Offset <#t:Offset>`__

   -  = `Offset <#v:Offset>`__ `Value <Data-Database.html#t:Value>`__
   -  \| `NullOffset <#v:NullOffset>`__

-  data `Select <#t:Select>`__ = `Select <#v:Select>`__
   `Table <Data-Database.html#t:Table>`__
   `Selections <Data-Database.html#t:Selections>`__
   `Constraints <Data-Database.html#t:Constraints>`__
   `Orders <Data-Database.html#t:Orders>`__
   `Limit <Data-Database.html#t:Limit>`__
   `Offset <Data-Database.html#t:Offset>`__
-  data `Delete <#t:Delete>`__ = `Delete <#v:Delete>`__
   `Table <Data-Database.html#t:Table>`__
   `Constraints <Data-Database.html#t:Constraints>`__
-  data `Insert <#t:Insert>`__ = `Insert <#v:Insert>`__
   `Table <Data-Database.html#t:Table>`__
   `Assignments <Data-Database.html#t:Assignments>`__
-  data `Update <#t:Update>`__ = `Update <#v:Update>`__
   `Table <Data-Database.html#t:Table>`__
   `Assignments <Data-Database.html#t:Assignments>`__
   `Constraints <Data-Database.html#t:Constraints>`__
-  `constraints <#v:constraints>`__ ::
   [(`Sql <Data-Database.html#t:Sql>`__,
   `Selection <Data-Database.html#t:Selection>`__ ->
   `Value <Data-Database.html#t:Value>`__ ->
   `Constraint <Data-Database.html#t:Constraint>`__)] ->
   [(`Sql <Data-Database.html#t:Sql>`__,
   `Value <Data-Database.html#t:Value>`__)] ->
   `Constraints <Data-Database.html#t:Constraints>`__
-  `assigns <#v:assigns>`__ :: [(`Sql <Data-Database.html#t:Sql>`__,
   `Sql <Data-Database.html#t:Sql>`__)] ->
   [(`Sql <Data-Database.html#t:Sql>`__,
   `Value <Data-Database.html#t:Value>`__)] ->
   [`Assignment <Data-Database.html#t:Assignment>`__\ ]
-  `inserts <#v:inserts>`__ :: [(`Sql <Data-Database.html#t:Sql>`__,
   `Sql <Data-Database.html#t:Sql>`__)] ->
   [(`Sql <Data-Database.html#t:Sql>`__,
   `Value <Data-Database.html#t:Value>`__)] ->
   `Assignments <Data-Database.html#t:Assignments>`__
-  `updates <#v:updates>`__ :: [(`Sql <Data-Database.html#t:Sql>`__,
   `Sql <Data-Database.html#t:Sql>`__)] ->
   [(`Sql <Data-Database.html#t:Sql>`__,
   `Value <Data-Database.html#t:Value>`__)] ->
   `Assignments <Data-Database.html#t:Assignments>`__
-  `orders <#v:orders>`__ :: [(`Sql <Data-Database.html#t:Sql>`__,
   `Value <Data-Database.html#t:Value>`__)] ->
   `Orders <Data-Database.html#t:Orders>`__
-  `limit <#v:limit>`__ :: [(`Sql <Data-Database.html#t:Sql>`__,
   `Value <Data-Database.html#t:Value>`__)] ->
   `Limit <Data-Database.html#t:Limit>`__
-  `offset <#v:offset>`__ :: [(`Sql <Data-Database.html#t:Sql>`__,
   `Value <Data-Database.html#t:Value>`__)] ->
   `Offset <Data-Database.html#t:Offset>`__
-  `transaction <#v:transaction>`__ ::
   `Expression <Data-Database.html#t:Expression>`__ x =>
   (`Sql <Data-Database.html#t:Sql>`__ ->
   `Values <Data-Database.html#t:Values>`__ ->
   `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
   `Connection <Data-SqlTransaction.html#t:Connection>`__ t) -> x ->
   `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
   `Connection <Data-SqlTransaction.html#t:Connection>`__ t
-  `select <#v:select>`__ :: `Sql <Data-Database.html#t:Sql>`__ ->
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
-  `insert <#v:insert>`__ :: `Sql <Data-Database.html#t:Sql>`__ ->
   [(`Sql <Data-Database.html#t:Sql>`__,
   `Sql <Data-Database.html#t:Sql>`__)] ->
   [(`Sql <Data-Database.html#t:Sql>`__,
   `Value <Data-Database.html#t:Value>`__)] ->
   `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
   `Connection <Data-SqlTransaction.html#t:Connection>`__
   `Value <Data-Database.html#t:Value>`__
-  `update <#v:update>`__ :: `Sql <Data-Database.html#t:Sql>`__ ->
   `Constraints <Data-Database.html#t:Constraints>`__ ->
   [(`Sql <Data-Database.html#t:Sql>`__,
   `Sql <Data-Database.html#t:Sql>`__)] ->
   [(`Sql <Data-Database.html#t:Sql>`__,
   `Value <Data-Database.html#t:Value>`__)] ->
   `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
   `Connection <Data-SqlTransaction.html#t:Connection>`__ ()
-  `upsert <#v:upsert>`__ :: `Sql <Data-Database.html#t:Sql>`__ ->
   HashMap `Sql <Data-Database.html#t:Sql>`__
   `Value <Data-Database.html#t:Value>`__ ->
   `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
   `Connection <Data-SqlTransaction.html#t:Connection>`__
   `Value <Data-Database.html#t:Value>`__
-  `geometry <#v:geometry>`__ ::
   `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__ ->
   `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__ ->
   `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
   `Connection <Data-SqlTransaction.html#t:Connection>`__
   `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__

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
| OpInList      |     |
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

cInList :: `Selection <Data-Database.html#t:Selection>`__ ->
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

(\|~) :: `Sql <Data-Database.html#t:Sql>`__ ->
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

constraints: provide map of optional arguments and a dictionary of
operators to use for each one

assigns :: [(`Sql <Data-Database.html#t:Sql>`__,
`Sql <Data-Database.html#t:Sql>`__)] ->
[(`Sql <Data-Database.html#t:Sql>`__,
`Value <Data-Database.html#t:Value>`__)] ->
[`Assignment <Data-Database.html#t:Assignment>`__\ ]

assigns: provide list of allowed fields, default values, and a list of
optional arguments

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

orders: provide map of optional arguments. if found, sort\_field and
sort\_invert is used to generate orderings

limit :: [(`Sql <Data-Database.html#t:Sql>`__,
`Value <Data-Database.html#t:Value>`__)] ->
`Limit <Data-Database.html#t:Limit>`__

limit: provide map of optional arguments. if found, limit is used to
generate limit

offset :: [(`Sql <Data-Database.html#t:Sql>`__,
`Value <Data-Database.html#t:Value>`__)] ->
`Offset <Data-Database.html#t:Offset>`__

offset: provide map of optional arguments. if found, offset is used to
generate offset

transaction :: `Expression <Data-Database.html#t:Expression>`__ x =>
(`Sql <Data-Database.html#t:Sql>`__ ->
`Values <Data-Database.html#t:Values>`__ ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ t) -> x ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ t

transaction: provide query function and an expression, generates
transaction

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

select: quick select. table name; [(field name, constraint
constructor)]; map of optional arguments

insert :: `Sql <Data-Database.html#t:Sql>`__ ->
[(`Sql <Data-Database.html#t:Sql>`__,
`Sql <Data-Database.html#t:Sql>`__)] ->
[(`Sql <Data-Database.html#t:Sql>`__,
`Value <Data-Database.html#t:Value>`__)] ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__
`Value <Data-Database.html#t:Value>`__

insert: quick insert. table name; defaults; fields names; map of
optional arguments

update :: `Sql <Data-Database.html#t:Sql>`__ ->
`Constraints <Data-Database.html#t:Constraints>`__ ->
[(`Sql <Data-Database.html#t:Sql>`__,
`Sql <Data-Database.html#t:Sql>`__)] ->
[(`Sql <Data-Database.html#t:Sql>`__,
`Value <Data-Database.html#t:Value>`__)] ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ ()

update: quick update. table name; [(Sql, Selection -> Value ->
Constraint)]; constraint arguments; default assigns; assignment
arguments

upsert :: `Sql <Data-Database.html#t:Sql>`__ -> HashMap
`Sql <Data-Database.html#t:Sql>`__
`Value <Data-Database.html#t:Value>`__ ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__
`Value <Data-Database.html#t:Value>`__

upsert: take table name and a record in HashMap format. check if a
record already exists with the id from the Map. if exists, update the
record; if not, insert. return the id of the record.

geometry :: `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__ ->
`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__ ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__
`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__

geometry: convert geo coordinates to a geometry. this requires a query.

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
