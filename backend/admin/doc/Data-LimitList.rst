==============
Data.LimitList
==============

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

Safe-Infered

Data.LimitList

Documentation
=============

data LimitList a

Constructors

+------------------------+-----+
| LL !Int !Int (Seq a)   |     |
+------------------------+-----+

Instances

+----------------------------------------------------------------------+-----+
| Functor `LimitList <Data-LimitList.html#t:LimitList>`__              |     |
+----------------------------------------------------------------------+-----+
| Foldable `LimitList <Data-LimitList.html#t:LimitList>`__             |     |
+----------------------------------------------------------------------+-----+
| Traversable `LimitList <Data-LimitList.html#t:LimitList>`__          |     |
+----------------------------------------------------------------------+-----+
| Show a => Show (`LimitList <Data-LimitList.html#t:LimitList>`__ a)   |     |
+----------------------------------------------------------------------+-----+
| Monoid (`LimitList <Data-LimitList.html#t:LimitList>`__ a)           |     |
+----------------------------------------------------------------------+-----+

new :: Int -> `LimitList <Data-LimitList.html#t:LimitList>`__ a

size :: `LimitList <Data-LimitList.html#t:LimitList>`__ a -> Int

maxsize :: `LimitList <Data-LimitList.html#t:LimitList>`__ a -> Int

insert :: a -> `LimitList <Data-LimitList.html#t:LimitList>`__ a ->
`LimitList <Data-LimitList.html#t:LimitList>`__ a

singleton :: a -> `LimitList <Data-LimitList.html#t:LimitList>`__ a

remove :: `LimitList <Data-LimitList.html#t:LimitList>`__ a ->
`LimitList <Data-LimitList.html#t:LimitList>`__ a

test :: `LimitList <Data-LimitList.html#t:LimitList>`__ Integer

test2 :: `LimitList <Data-LimitList.html#t:LimitList>`__ Integer

head :: `LimitList <Data-LimitList.html#t:LimitList>`__ a -> Maybe a

tail :: `LimitList <Data-LimitList.html#t:LimitList>`__ a -> Maybe
(`LimitList <Data-LimitList.html#t:LimitList>`__ a)

(\|>) :: a -> `LimitList <Data-LimitList.html#t:LimitList>`__ a ->
`LimitList <Data-LimitList.html#t:LimitList>`__ a

catMaybes :: `LimitList <Data-LimitList.html#t:LimitList>`__ (Maybe a)
-> `LimitList <Data-LimitList.html#t:LimitList>`__ a

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
