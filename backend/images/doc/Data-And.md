-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

Safe-Infered

Data.And

Documentation
=============

data And a

Constructors

||
|Nil| |
|One a| |
|List (Seq a)| |

Instances

||
|Functor [And](Data-And.html#t:And)| |
|Applicative [And](Data-And.html#t:And)| |
|Foldable [And](Data-And.html#t:And)| |
|Traversable [And](Data-And.html#t:And)| |
|Eq a =\> Eq ([And](Data-And.html#t:And) a)| |
|Read a =\> Read ([And](Data-And.html#t:And) a)| |
|Show a =\> Show ([And](Data-And.html#t:And) a)| |
|Monoid ([And](Data-And.html#t:And) a)| |

isNil :: [And](Data-And.html#t:And) a -\> Bool

singleton :: a -\> [And](Data-And.html#t:And) a

(|\>) :: a -\> [And](Data-And.html#t:And) a -\> [And](Data-And.html#t:And) a

(\<|) :: [And](Data-And.html#t:And) a -\> a -\> [And](Data-And.html#t:And) a

fromList :: [a] -\> [And](Data-And.html#t:And) a

testMonad :: [And](Data-And.html#t:And) Int

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
