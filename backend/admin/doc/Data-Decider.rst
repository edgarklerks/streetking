============
Data.Decider
============

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

Safe-Infered

Data.Decider

Synopsis

-  data `Expr <#t:Expr>`__ g a where

   -  `Any <#v:Any>`__ :: [`Expr <Data-Decider.html#t:Expr>`__ g a] ->
      `Expr <Data-Decider.html#t:Expr>`__ g a
   -  `All <#v:All>`__ :: [`Expr <Data-Decider.html#t:Expr>`__ g a] ->
      `Expr <Data-Decider.html#t:Expr>`__ g a
   -  `FromTo <#v:FromTo>`__ :: Integer -> Integer ->
      `Expr <Data-Decider.html#t:Expr>`__ g a ->
      `Expr <Data-Decider.html#t:Expr>`__ g a
   -  `One <#v:One>`__ :: a -> `Expr <Data-Decider.html#t:Expr>`__ g a
   -  `From <#v:From>`__ :: Integer ->
      `Expr <Data-Decider.html#t:Expr>`__ g a ->
      `Expr <Data-Decider.html#t:Expr>`__ g a
   -  `To <#v:To>`__ :: Integer -> `Expr <Data-Decider.html#t:Expr>`__ g
      a -> `Expr <Data-Decider.html#t:Expr>`__ g a

-  data a `:+: <#t::-43-:>`__ b
-  data `M <#t:M>`__
-  data `D <#t:D>`__
-  data `O <#t:O>`__
-  class `Evaluate <#t:Evaluate>`__ a b where

   -  `match <#v:match>`__ :: a -> b -> Bool

-  `simpleRule <#v:simpleRule>`__ :: Num a =>
   `Expr <Data-Decider.html#t:Expr>`__ g a
-  `simpleRule2 <#v:simpleRule2>`__ :: Num a =>
   `Expr <Data-Decider.html#t:Expr>`__ g a
-  `toOne <#v:toOne>`__ :: `Expr <Data-Decider.html#t:Expr>`__ g a ->
   Maybe a
-  `equalDecider <#v:equalDecider>`__ :: Eq b =>
   `Expr <Data-Decider.html#t:Expr>`__ g b ->
   `Decider <Data-Decider.html#t:Decider>`__ b
-  newtype `Decider <#t:Decider>`__ a = `Decider <#v:Decider>`__ {

   -  `runDecider <#v:runDecider>`__ :: [a] -> ([a], Bool)

   }
-  `buildDecider <#v:buildDecider>`__ :: (a -> b -> Bool) ->
   `Expr <Data-Decider.html#t:Expr>`__ g b ->
   `Decider <Data-Decider.html#t:Decider>`__ a
-  `member <#v:member>`__ :: (a -> b -> Bool) -> b -> [a] -> ([a], Bool)
-  `accept <#v:accept>`__ :: (a -> b -> Bool) -> b -> [a] -> Bool
-  newtype `Machine <#t:Machine>`__ a b = `Machine <#v:Machine>`__ {

   -  `runMachine <#v:runMachine>`__ :: [a] -> ([b], Bool)

   }
-  `(.-) <#v:.-45->`__ :: `Machine <Data-Decider.html#t:Machine>`__ a a1
   -> `Machine <Data-Decider.html#t:Machine>`__ a1 b ->
   `Machine <Data-Decider.html#t:Machine>`__ a b

Documentation
=============

data Expr g a where

Constructors

+----------------------------------------------------------------------------------------------------------------------+-----+
| Any :: [`Expr <Data-Decider.html#t:Expr>`__ g a] -> `Expr <Data-Decider.html#t:Expr>`__ g a                          |     |
+----------------------------------------------------------------------------------------------------------------------+-----+
| All :: [`Expr <Data-Decider.html#t:Expr>`__ g a] -> `Expr <Data-Decider.html#t:Expr>`__ g a                          |     |
+----------------------------------------------------------------------------------------------------------------------+-----+
| FromTo :: Integer -> Integer -> `Expr <Data-Decider.html#t:Expr>`__ g a -> `Expr <Data-Decider.html#t:Expr>`__ g a   |     |
+----------------------------------------------------------------------------------------------------------------------+-----+
| One :: a -> `Expr <Data-Decider.html#t:Expr>`__ g a                                                                  |     |
+----------------------------------------------------------------------------------------------------------------------+-----+
| From :: Integer -> `Expr <Data-Decider.html#t:Expr>`__ g a -> `Expr <Data-Decider.html#t:Expr>`__ g a                |     |
+----------------------------------------------------------------------------------------------------------------------+-----+
| To :: Integer -> `Expr <Data-Decider.html#t:Expr>`__ g a -> `Expr <Data-Decider.html#t:Expr>`__ g a                  |     |
+----------------------------------------------------------------------------------------------------------------------+-----+

Instances

+------------------------------------------------------------+-----+
| Show a => Show (`Expr <Data-Decider.html#t:Expr>`__ g a)   |     |
+------------------------------------------------------------+-----+

data a :+: b

data M

data D

data O

class Evaluate a b where

Methods

match :: a -> b -> Bool

Instances

+-------------------------------------------------------------------------------------------------------------------------+-----+
| `Evaluate <Data-Decider.html#t:Evaluate>`__ `Event <Data-Event.html#t:Event>`__ `Symbol <Data-Event.html#t:Symbol>`__   |     |
+-------------------------------------------------------------------------------------------------------------------------+-----+

simpleRule :: Num a => `Expr <Data-Decider.html#t:Expr>`__ g a

simpleRule2 :: Num a => `Expr <Data-Decider.html#t:Expr>`__ g a

toOne :: `Expr <Data-Decider.html#t:Expr>`__ g a -> Maybe a

equalDecider :: Eq b => `Expr <Data-Decider.html#t:Expr>`__ g b ->
`Decider <Data-Decider.html#t:Decider>`__ b

Every expression gives rise to function

newtype Decider a

Constructors

Decider

 

Fields

runDecider :: [a] -> ([a], Bool)
     

Instances

+--------------------------------------------------------+-----+
| Monoid (`Decider <Data-Decider.html#t:Decider>`__ a)   |     |
+--------------------------------------------------------+-----+

buildDecider :: (a -> b -> Bool) -> `Expr <Data-Decider.html#t:Expr>`__
g b -> `Decider <Data-Decider.html#t:Decider>`__ a

member :: (a -> b -> Bool) -> b -> [a] -> ([a], Bool)

accept :: (a -> b -> Bool) -> b -> [a] -> Bool

newtype Machine a b

Constructors

Machine

 

Fields

runMachine :: [a] -> ([b], Bool)
     

Instances

+------------------------------------------------------+-----+
| Category `Machine <Data-Decider.html#t:Machine>`__   |     |
+------------------------------------------------------+-----+

(.-) :: `Machine <Data-Decider.html#t:Machine>`__ a a1 ->
`Machine <Data-Decider.html#t:Machine>`__ a1 b ->
`Machine <Data-Decider.html#t:Machine>`__ a b

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
