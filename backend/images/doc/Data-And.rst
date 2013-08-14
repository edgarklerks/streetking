========
Data.And
========

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

Safe-Infered

Data.And

Documentation
=============

data And a

Constructors

+----------------+-----+
| Nil            |     |
+----------------+-----+
| One a          |     |
+----------------+-----+
| List (Seq a)   |     |
+----------------+-----+

Instances

+----------------------------------------------------+-----+
| Functor `And <Data-And.html#t:And>`__              |     |
+----------------------------------------------------+-----+
| Applicative `And <Data-And.html#t:And>`__          |     |
+----------------------------------------------------+-----+
| Foldable `And <Data-And.html#t:And>`__             |     |
+----------------------------------------------------+-----+
| Traversable `And <Data-And.html#t:And>`__          |     |
+----------------------------------------------------+-----+
| Eq a => Eq (`And <Data-And.html#t:And>`__ a)       |     |
+----------------------------------------------------+-----+
| Read a => Read (`And <Data-And.html#t:And>`__ a)   |     |
+----------------------------------------------------+-----+
| Show a => Show (`And <Data-And.html#t:And>`__ a)   |     |
+----------------------------------------------------+-----+
| Monoid (`And <Data-And.html#t:And>`__ a)           |     |
+----------------------------------------------------+-----+

isNil :: `And <Data-And.html#t:And>`__ a -> Bool

singleton :: a -> `And <Data-And.html#t:And>`__ a

(\|>) :: a -> `And <Data-And.html#t:And>`__ a ->
`And <Data-And.html#t:And>`__ a

(<\|) :: `And <Data-And.html#t:And>`__ a -> a ->
`And <Data-And.html#t:And>`__ a

fromList :: [a] -> `And <Data-And.html#t:And>`__ a

testMonad :: `And <Data-And.html#t:And>`__ Int

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
