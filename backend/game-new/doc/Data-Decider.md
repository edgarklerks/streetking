% Data.Decider
% 
% 

-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

Safe-Infered

Data.Decider

Description

This let the user build a regular expression engine, which also works
with permutations of the expression.

Synopsis

-   data [Expr](#t:Expr) g a where
    -   [Any](#v:Any) :: [[Expr](Data-Decider.html#t:Expr) g a] -\>
        [Expr](Data-Decider.html#t:Expr) g a
    -   [All](#v:All) :: [[Expr](Data-Decider.html#t:Expr) g a] -\>
        [Expr](Data-Decider.html#t:Expr) g a
    -   [FromTo](#v:FromTo) :: Integer -\> Integer -\>
        [Expr](Data-Decider.html#t:Expr) g a -\>
        [Expr](Data-Decider.html#t:Expr) g a
    -   [One](#v:One) :: a -\> [Expr](Data-Decider.html#t:Expr) g a
    -   [From](#v:From) :: Integer -\> [Expr](Data-Decider.html#t:Expr)
        g a -\> [Expr](Data-Decider.html#t:Expr) g a
    -   [To](#v:To) :: Integer -\> [Expr](Data-Decider.html#t:Expr) g a
        -\> [Expr](Data-Decider.html#t:Expr) g a

-   data a [:+:](#t::-43-:) b
-   data [M](#t:M)
-   data [D](#t:D)
-   data [O](#t:O)
-   class [Evaluate](#t:Evaluate) a b where
    -   [match](#v:match) :: a -\> b -\> Bool

-   [simpleRule](#v:simpleRule) :: Num a =\>
    [Expr](Data-Decider.html#t:Expr) g a
-   [simpleRule2](#v:simpleRule2) :: Num a =\>
    [Expr](Data-Decider.html#t:Expr) g a
-   [toOne](#v:toOne) :: [Expr](Data-Decider.html#t:Expr) g a -\> Maybe
    a
-   [equalDecider](#v:equalDecider) :: Eq b =\>
    [Expr](Data-Decider.html#t:Expr) g b -\>
    [Decider](Data-Decider.html#t:Decider) b
-   newtype [Decider](#t:Decider) a = [Decider](#v:Decider) {
    -   [runDecider](#v:runDecider) :: [a] -\> ([a], Bool)

    }
-   [buildDecider](#v:buildDecider) :: (a -\> b -\> Bool) -\>
    [Expr](Data-Decider.html#t:Expr) g b -\>
    [Decider](Data-Decider.html#t:Decider) a
-   [member](#v:member) :: (a -\> b -\> Bool) -\> b -\> [a] -\> ([a],
    Bool)
-   [accept](#v:accept) :: (a -\> b -\> Bool) -\> b -\> [a] -\> Bool
-   newtype [Machine](#t:Machine) a b = [Machine](#v:Machine) {
    -   [runMachine](#v:runMachine) :: [a] -\> ([b], Bool)

    }
-   [(.-)](#v:.-45-) :: [Machine](Data-Decider.html#t:Machine) a a1 -\>
    [Machine](Data-Decider.html#t:Machine) a1 b -\>
    [Machine](Data-Decider.html#t:Machine) a b

Documentation
=============

data Expr g a where

Expression language for a decider

Constructors

  ----------------------------------------------------------------------------------------------------------------- ---
  Any :: [[Expr](Data-Decider.html#t:Expr) g a] -\> [Expr](Data-Decider.html#t:Expr) g a                             
  All :: [[Expr](Data-Decider.html#t:Expr) g a] -\> [Expr](Data-Decider.html#t:Expr) g a                             
  FromTo :: Integer -\> Integer -\> [Expr](Data-Decider.html#t:Expr) g a -\> [Expr](Data-Decider.html#t:Expr) g a    
  One :: a -\> [Expr](Data-Decider.html#t:Expr) g a                                                                  
  From :: Integer -\> [Expr](Data-Decider.html#t:Expr) g a -\> [Expr](Data-Decider.html#t:Expr) g a                  
  To :: Integer -\> [Expr](Data-Decider.html#t:Expr) g a -\> [Expr](Data-Decider.html#t:Expr) g a                    
  ----------------------------------------------------------------------------------------------------------------- ---

Instances

  -------------------------------------------------------- ---
  Show a =\> Show ([Expr](Data-Decider.html#t:Expr) g a)    
  -------------------------------------------------------- ---

data a :+: b

Not used at the moment. These should change the | behavior of the
matcher

data M

data D

data O

class Evaluate a b where

Methods

match :: a -\> b -\> Bool

Instances

[Evaluate](Data-Decider.html#t:Evaluate)
[Event](Data-Event.html#t:Event) [Symbol](Data-Event.html#t:Symbol)

Matcher for tournament types

simpleRule :: Num a =\> [Expr](Data-Decider.html#t:Expr) g a

simpleRule2 :: Num a =\> [Expr](Data-Decider.html#t:Expr) g a

toOne :: [Expr](Data-Decider.html#t:Expr) g a -\> Maybe a

equalDecider :: Eq b =\> [Expr](Data-Decider.html#t:Expr) g b -\>
[Decider](Data-Decider.html#t:Decider) b

Every expression gives rise to function

newtype Decider a

The underlying arrow is Machine a b = [a] -\> ([b], Bool) deltaStream =
xs - ys

Constructors

Decider

 

Fields

runDecider :: [a] -\> ([a], Bool)
:    

Instances

Monoid ([Decider](Data-Decider.html#t:Decider) a)

A decider is a monoid, we can add several machines together

buildDecider :: (a -\> b -\> Bool) -\> [Expr](Data-Decider.html#t:Expr)
g b -\> [Decider](Data-Decider.html#t:Decider) a

Builds a decider from an expression

member :: (a -\> b -\> Bool) -\> b -\> [a] -\> ([a], Bool)

The most primitive building block. This is satisfy, when you build | a
parser. We use member, because we need to allow all permutations

accept :: (a -\> b -\> Bool) -\> b -\> [a] -\> Bool

newtype Machine a b

underline machine is actually very boring.

Constructors

Machine

 

Fields

runMachine :: [a] -\> ([b], Bool)
:    

Instances

  ------------------------------------------------- ---
  Category [Machine](Data-Decider.html#t:Machine)    
  ------------------------------------------------- ---

(.-) :: [Machine](Data-Decider.html#t:Machine) a a1 -\>
[Machine](Data-Decider.html#t:Machine) a1 b -\>
[Machine](Data-Decider.html#t:Machine) a b

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
