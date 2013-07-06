-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Data.PriorityQueue

Documentation
=============

data Prio q a

Instances

||
|Functor ([Prio](Data-PriorityQueue.html#t:Prio) q)| |
|Ord q =\> Foldable ([Prio](Data-PriorityQueue.html#t:Prio) q)| |
|Ord q =\> Traversable ([Prio](Data-PriorityQueue.html#t:Prio) q)| |
|(Show q, Show a) =\> Show ([Prio](Data-PriorityQueue.html#t:Prio) q a)| |
|Ord q =\> Monoid ([Prio](Data-PriorityQueue.html#t:Prio) q a)| |

view :: Ord q =\> [Prio](Data-PriorityQueue.html#t:Prio) q a -\> [ViewMin](Data-PriorityQueue.html#t:ViewMin) q a

data ViewMin q a

Constructors

||
|a :\> ([Prio](Data-PriorityQueue.html#t:Prio) q a)| |
|Nil| |

fromList :: Ord q =\> [(q, a)] -\> [Prio](Data-PriorityQueue.html#t:Prio) q a

extractMin :: Ord q =\> [Prio](Data-PriorityQueue.html#t:Prio) q a -\> Maybe (a, [Prio](Data-PriorityQueue.html#t:Prio) q a)

headMin :: Ord q =\> [Prio](Data-PriorityQueue.html#t:Prio) q a -\> Maybe a

tailMin :: Ord q =\> [Prio](Data-PriorityQueue.html#t:Prio) q a -\> Maybe ([Prio](Data-PriorityQueue.html#t:Prio) q a)

insert :: Ord q =\> q -\> a -\> [Prio](Data-PriorityQueue.html#t:Prio) q a -\> [Prio](Data-PriorityQueue.html#t:Prio) q a

singleton :: q -\> a -\> [Prio](Data-PriorityQueue.html#t:Prio) q a

extractTill :: Ord q =\> q -\> [Prio](Data-PriorityQueue.html#t:Prio) q a -\> ([a], [Prio](Data-PriorityQueue.html#t:Prio) q a)

extractTillWithKey :: Ord q =\> q -\> [Prio](Data-PriorityQueue.html#t:Prio) q a -\> ([(q, a)], [Prio](Data-PriorityQueue.html#t:Prio) q a)

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
