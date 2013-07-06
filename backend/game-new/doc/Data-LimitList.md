% Data.LimitList
% 
% 

-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

Safe-Infered

Data.LimitList

Documentation
=============

data LimitList a

Constructors

  ---------------------- ---
  LL !Int !Int (Seq a)    
  ---------------------- ---

Instances

  ------------------------------------------------------------------ ---
  Functor [LimitList](Data-LimitList.html#t:LimitList)                
  Foldable [LimitList](Data-LimitList.html#t:LimitList)               
  Traversable [LimitList](Data-LimitList.html#t:LimitList)            
  Show a =\> Show ([LimitList](Data-LimitList.html#t:LimitList) a)    
  Monoid ([LimitList](Data-LimitList.html#t:LimitList) a)             
  ------------------------------------------------------------------ ---

new :: Int -\> [LimitList](Data-LimitList.html#t:LimitList) a

size :: [LimitList](Data-LimitList.html#t:LimitList) a -\> Int

maxsize :: [LimitList](Data-LimitList.html#t:LimitList) a -\> Int

insert :: a -\> [LimitList](Data-LimitList.html#t:LimitList) a -\>
[LimitList](Data-LimitList.html#t:LimitList) a

singleton :: a -\> [LimitList](Data-LimitList.html#t:LimitList) a

remove :: [LimitList](Data-LimitList.html#t:LimitList) a -\>
[LimitList](Data-LimitList.html#t:LimitList) a

test :: [LimitList](Data-LimitList.html#t:LimitList) Integer

test2 :: [LimitList](Data-LimitList.html#t:LimitList) Integer

head :: [LimitList](Data-LimitList.html#t:LimitList) a -\> Maybe a

tail :: [LimitList](Data-LimitList.html#t:LimitList) a -\> Maybe
([LimitList](Data-LimitList.html#t:LimitList) a)

(|\>) :: a -\> [LimitList](Data-LimitList.html#t:LimitList) a -\>
[LimitList](Data-LimitList.html#t:LimitList) a

catMaybes :: [LimitList](Data-LimitList.html#t:LimitList) (Maybe a) -\>
[LimitList](Data-LimitList.html#t:LimitList) a

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
