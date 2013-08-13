=================
Model.DBFunctions
=================

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Model.DBFunctions

Documentation
=============

type Arg = Name

type Args = [`Arg <Model-DBFunctions.html#t:Arg>`__\ ]

type Ret = Name

type FName = String

type Definition = String

type Arity = Int

data FType

Constructors

+----------+-----+
| Row      |     |
+----------+-----+
| Scalar   |     |
+----------+-----+

Instances

+---------------------------------------------------+-----+
| Show `FType <Model-DBFunctions.html#t:FType>`__   |     |
+---------------------------------------------------+-----+

data Function

Constructors

+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| F `FType <Model-DBFunctions.html#t:FType>`__ `FName <Model-DBFunctions.html#t:FName>`__ `Args <Model-DBFunctions.html#t:Args>`__ `Ret <Model-DBFunctions.html#t:Ret>`__   |     |
+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+

Instances

+---------------------------------------------------------+-----+
| Show `Function <Model-DBFunctions.html#t:Function>`__   |     |
+---------------------------------------------------------+-----+

data SqlFunction

Constructors

+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| SF `FName <Model-DBFunctions.html#t:FName>`__ `FType <Model-DBFunctions.html#t:FType>`__ `Arity <Model-DBFunctions.html#t:Arity>`__ `Args <Model-DBFunctions.html#t:Args>`__ `Definition <Model-DBFunctions.html#t:Definition>`__ `Ret <Model-DBFunctions.html#t:Ret>`__   |     |
+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+

Instances

+---------------------------------------------------------------+-----+
| Show `SqlFunction <Model-DBFunctions.html#t:SqlFunction>`__   |     |
+---------------------------------------------------------------+-----+

mkFunctions :: [(String, [Name], Name,
`FType <Model-DBFunctions.html#t:FType>`__)] -> Q [Dec]

ftosql :: `Function <Model-DBFunctions.html#t:Function>`__ ->
`SqlFunction <Model-DBFunctions.html#t:SqlFunction>`__

sqlFunctionToSql ::
`SqlFunction <Model-DBFunctions.html#t:SqlFunction>`__ -> DecQ

ft :: String -> [`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__\ ]
-> `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__
`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
