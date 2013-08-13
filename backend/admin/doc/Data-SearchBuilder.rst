==================
Data.SearchBuilder
==================

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Data.SearchBuilder

Documentation
=============

type Sortable = Bool

type Exceptions = [String -> `Type <Data-SearchBuilder.html#t:Type>`__
-> Maybe `DTD <Data-DatabaseTemplate.html#t:DTD>`__]

type Behaviours = [(`Type <Data-SearchBuilder.html#t:Type>`__,
`Behaviour <Data-SearchBuilder.html#t:Behaviour>`__)]

type Type = String

data Behaviour where

Constructors

+-----------------------------------------------------------------+-----+
| Max :: `Behaviour <Data-SearchBuilder.html#t:Behaviour>`__      |     |
+-----------------------------------------------------------------+-----+
| Min :: `Behaviour <Data-SearchBuilder.html#t:Behaviour>`__      |     |
+-----------------------------------------------------------------+-----+
| MinMax :: `Behaviour <Data-SearchBuilder.html#t:Behaviour>`__   |     |
+-----------------------------------------------------------------+-----+
| Equal :: `Behaviour <Data-SearchBuilder.html#t:Behaviour>`__    |     |
+-----------------------------------------------------------------+-----+
| Like :: `Behaviour <Data-SearchBuilder.html#t:Behaviour>`__     |     |
+-----------------------------------------------------------------+-----+
| Ignore :: `Behaviour <Data-SearchBuilder.html#t:Behaviour>`__   |     |
+-----------------------------------------------------------------+-----+

Instances

+----------------------------------------------------------+-----+
| Eq `Behaviour <Data-SearchBuilder.html#t:Behaviour>`__   |     |
+----------------------------------------------------------+-----+

type MString = Maybe String

type MInteger = Maybe Integer

type MInt = Maybe Int

type MBool = Maybe Bool

type MChar = Maybe Char

type MDouble = Maybe Double

defaultBehaviours ::
`Behaviours <Data-SearchBuilder.html#t:Behaviours>`__

defaultExceptions ::
`Exceptions <Data-SearchBuilder.html#t:Exceptions>`__

findException :: String -> `Type <Data-SearchBuilder.html#t:Type>`__ ->
`Exceptions <Data-SearchBuilder.html#t:Exceptions>`__ -> Maybe
`DTD <Data-DatabaseTemplate.html#t:DTD>`__

build :: `Database <Model-General.html#t:Database>`__ c a =>
`Behaviours <Data-SearchBuilder.html#t:Behaviours>`__ -> a ->
`Exceptions <Data-SearchBuilder.html#t:Exceptions>`__ ->
(`DTD <Data-DatabaseTemplate.html#t:DTD>`__, [String])

lookupMany :: Eq a => a -> [(a, b)] -> [b]

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
