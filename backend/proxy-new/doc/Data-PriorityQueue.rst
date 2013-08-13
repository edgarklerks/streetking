==================
Data.PriorityQueue
==================

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Data.PriorityQueue

Documentation
=============

data Prio q a

Instances

+----------------------------------------------------------------------------+-----+
| Functor (`Prio <Data-PriorityQueue.html#t:Prio>`__ q)                      |     |
+----------------------------------------------------------------------------+-----+
| Ord q => Foldable (`Prio <Data-PriorityQueue.html#t:Prio>`__ q)            |     |
+----------------------------------------------------------------------------+-----+
| Ord q => Traversable (`Prio <Data-PriorityQueue.html#t:Prio>`__ q)         |     |
+----------------------------------------------------------------------------+-----+
| (Show q, Show a) => Show (`Prio <Data-PriorityQueue.html#t:Prio>`__ q a)   |     |
+----------------------------------------------------------------------------+-----+
| Ord q => Monoid (`Prio <Data-PriorityQueue.html#t:Prio>`__ q a)            |     |
+----------------------------------------------------------------------------+-----+

view :: Ord q => `Prio <Data-PriorityQueue.html#t:Prio>`__ q a ->
`ViewMin <Data-PriorityQueue.html#t:ViewMin>`__ q a

data ViewMin q a

Constructors

+--------------------------------------------------------+-----+
| a :> (`Prio <Data-PriorityQueue.html#t:Prio>`__ q a)   |     |
+--------------------------------------------------------+-----+
| Nil                                                    |     |
+--------------------------------------------------------+-----+

fromList :: Ord q => [(q, a)] ->
`Prio <Data-PriorityQueue.html#t:Prio>`__ q a

extractMin :: Ord q => `Prio <Data-PriorityQueue.html#t:Prio>`__ q a ->
Maybe (a, `Prio <Data-PriorityQueue.html#t:Prio>`__ q a)

headMin :: Ord q => `Prio <Data-PriorityQueue.html#t:Prio>`__ q a ->
Maybe a

tailMin :: Ord q => `Prio <Data-PriorityQueue.html#t:Prio>`__ q a ->
Maybe (`Prio <Data-PriorityQueue.html#t:Prio>`__ q a)

insert :: Ord q => q -> a -> `Prio <Data-PriorityQueue.html#t:Prio>`__ q
a -> `Prio <Data-PriorityQueue.html#t:Prio>`__ q a

singleton :: q -> a -> `Prio <Data-PriorityQueue.html#t:Prio>`__ q a

extractTill :: Ord q => q -> `Prio <Data-PriorityQueue.html#t:Prio>`__ q
a -> ([a], `Prio <Data-PriorityQueue.html#t:Prio>`__ q a)

extractTillWithKey :: Ord q => q ->
`Prio <Data-PriorityQueue.html#t:Prio>`__ q a -> ([(q, a)],
`Prio <Data-PriorityQueue.html#t:Prio>`__ q a)

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
