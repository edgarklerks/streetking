-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Data.PriorityQueue

Description

This is a reasonable implementation of a priority queue. It has O(1) lookup and amortized delete min of O(log n) I am to lazy to calculate insert, but in practice it works quite well.

Synopsis

-   data [Prio](#t:Prio) q a
-   [view](#v:view) :: Ord q =\> [Prio](Data-PriorityQueue.html#t:Prio) q a -\> [ViewMin](Data-PriorityQueue.html#t:ViewMin) q a
-   data [ViewMin](#t:ViewMin) q a
    -   = a [:\>](#v::-62-) ([Prio](Data-PriorityQueue.html#t:Prio) q a)
    -   | [Nil](#v:Nil)

-   [fromList](#v:fromList) :: Ord q =\> [(q, a)] -\> [Prio](Data-PriorityQueue.html#t:Prio) q a
-   [extractMin](#v:extractMin) :: Ord q =\> [Prio](Data-PriorityQueue.html#t:Prio) q a -\> Maybe (a, [Prio](Data-PriorityQueue.html#t:Prio) q a)
-   [headMin](#v:headMin) :: Ord q =\> [Prio](Data-PriorityQueue.html#t:Prio) q a -\> Maybe a
-   [tailMin](#v:tailMin) :: Ord q =\> [Prio](Data-PriorityQueue.html#t:Prio) q a -\> Maybe ([Prio](Data-PriorityQueue.html#t:Prio) q a)
-   [insert](#v:insert) :: Ord q =\> q -\> a -\> [Prio](Data-PriorityQueue.html#t:Prio) q a -\> [Prio](Data-PriorityQueue.html#t:Prio) q a
-   [singleton](#v:singleton) :: q -\> a -\> [Prio](Data-PriorityQueue.html#t:Prio) q a
-   [extractTill](#v:extractTill) :: Ord q =\> q -\> [Prio](Data-PriorityQueue.html#t:Prio) q a -\> ([a], [Prio](Data-PriorityQueue.html#t:Prio) q a)
-   [extractTillWithKey](#v:extractTillWithKey) :: Ord q =\> q -\> [Prio](Data-PriorityQueue.html#t:Prio) q a -\> ([(q, a)], [Prio](Data-PriorityQueue.html#t:Prio) q a)

Documentation
=============

data Prio q a

Priority heap, the priority is a parameter to the type Prio q a can be ordered, is a functor, a foldable, a monoid and a traversable. There is also a monadic version. We should interpret this as a computation on the objects in the priority heap, rendering a tree of priority heaps and then merged into a consistent priority heap again.

The monad has a problem, because it has a constraint. In the current version of ghc, it is not possible to make it a monad yet.

A comonad like instance could be useful, but is not possible, because a comonad should always be safe to deconstruct. This thing is clearly not safe to deconstruct.

It could be empty

Instances

||
|Functor ([Prio](Data-PriorityQueue.html#t:Prio) q)| |
|Ord q =\> Foldable ([Prio](Data-PriorityQueue.html#t:Prio) q)| |
|Ord q =\> Traversable ([Prio](Data-PriorityQueue.html#t:Prio) q)| |
|(Show q, Show a) =\> Show ([Prio](Data-PriorityQueue.html#t:Prio) q a)| |
|Ord q =\> Monoid ([Prio](Data-PriorityQueue.html#t:Prio) q a)| |

view :: Ord q =\> [Prio](Data-PriorityQueue.html#t:Prio) q a -\> [ViewMin](Data-PriorityQueue.html#t:ViewMin) q a

View pattern for list like perspective

data ViewMin q a

List like view for the minimal element

Constructors

||
|a :\> ([Prio](Data-PriorityQueue.html#t:Prio) q a)| |
|Nil| |

fromList :: Ord q =\> [(q, a)] -\> [Prio](Data-PriorityQueue.html#t:Prio) q a

Build a prio heap from a list

extractMin :: Ord q =\> [Prio](Data-PriorityQueue.html#t:Prio) q a -\> Maybe (a, [Prio](Data-PriorityQueue.html#t:Prio) q a)

Get the minimal value O(1)

headMin :: Ord q =\> [Prio](Data-PriorityQueue.html#t:Prio) q a -\> Maybe a

Get the first element

tailMin :: Ord q =\> [Prio](Data-PriorityQueue.html#t:Prio) q a -\> Maybe ([Prio](Data-PriorityQueue.html#t:Prio) q a)

Get the tail

insert :: Ord q =\> q -\> a -\> [Prio](Data-PriorityQueue.html#t:Prio) q a -\> [Prio](Data-PriorityQueue.html#t:Prio) q a

Insert a new element with priority

singleton :: q -\> a -\> [Prio](Data-PriorityQueue.html#t:Prio) q a

Create an singleton prio queue

extractTill :: Ord q =\> q -\> [Prio](Data-PriorityQueue.html#t:Prio) q a -\> ([a], [Prio](Data-PriorityQueue.html#t:Prio) q a)

Get all till priority as value

extractTillWithKey :: Ord q =\> q -\> [Prio](Data-PriorityQueue.html#t:Prio) q a -\> ([(q, a)], [Prio](Data-PriorityQueue.html#t:Prio) q a)

Get all till priority as tuple

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
