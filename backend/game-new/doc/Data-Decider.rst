============
Data.Decider
============

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

Safe-Infered

Data.Decider

Description

This let the user build a regular expression engine, which also works
with permutations of the expression.

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

Expression language for a decider

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

Not used at the moment. These should change the \| behavior of the
matcher

data M

data D

data O

class Evaluate a b where

Methods

match :: a -> b -> Bool

Instances

`Evaluate <Data-Decider.html#t:Evaluate>`__
`Event <Data-Event.html#t:Event>`__
`Symbol <Data-Event.html#t:Symbol>`__

Matcher for tournament types

simpleRule :: Num a => `Expr <Data-Decider.html#t:Expr>`__ g a

simpleRule2 :: Num a => `Expr <Data-Decider.html#t:Expr>`__ g a

toOne :: `Expr <Data-Decider.html#t:Expr>`__ g a -> Maybe a

equalDecider :: Eq b => `Expr <Data-Decider.html#t:Expr>`__ g b ->
`Decider <Data-Decider.html#t:Decider>`__ b

Every expression gives rise to function

newtype Decider a

The underlying arrow is Machine a b = [a] -> ([b], Bool) deltaStream =
xs - ys

Constructors

Decider

 

Fields

runDecider :: [a] -> ([a], Bool)
     

Instances

Monoid (`Decider <Data-Decider.html#t:Decider>`__ a)

A decider is a monoid, we can add several machines together

buildDecider :: (a -> b -> Bool) -> `Expr <Data-Decider.html#t:Expr>`__
g b -> `Decider <Data-Decider.html#t:Decider>`__ a

Builds a decider from an expression

member :: (a -> b -> Bool) -> b -> [a] -> ([a], Bool)

The most primitive building block. This is satisfy, when you build \| a
parser. We use member, because we need to allow all permutations

accept :: (a -> b -> Bool) -> b -> [a] -> Bool

newtype Machine a b

underline machine is actually very boring.

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
