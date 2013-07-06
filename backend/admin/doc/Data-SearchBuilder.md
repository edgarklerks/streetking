% Data.SearchBuilder
% 
% 

-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Data.SearchBuilder

Documentation
=============

type Sortable = Bool

type Exceptions = [String -\> [Type](Data-SearchBuilder.html#t:Type) -\>
Maybe [DTD](Data-DatabaseTemplate.html#t:DTD)]

type Behaviours = [([Type](Data-SearchBuilder.html#t:Type),
[Behaviour](Data-SearchBuilder.html#t:Behaviour))]

type Type = String

data Behaviour where

Constructors

  ------------------------------------------------------------ ---
  Max :: [Behaviour](Data-SearchBuilder.html#t:Behaviour)       
  Min :: [Behaviour](Data-SearchBuilder.html#t:Behaviour)       
  MinMax :: [Behaviour](Data-SearchBuilder.html#t:Behaviour)    
  Equal :: [Behaviour](Data-SearchBuilder.html#t:Behaviour)     
  Like :: [Behaviour](Data-SearchBuilder.html#t:Behaviour)      
  Ignore :: [Behaviour](Data-SearchBuilder.html#t:Behaviour)    
  ------------------------------------------------------------ ---

Instances

  ----------------------------------------------------- ---
  Eq [Behaviour](Data-SearchBuilder.html#t:Behaviour)    
  ----------------------------------------------------- ---

type MString = Maybe String

type MInteger = Maybe Integer

type MInt = Maybe Int

type MBool = Maybe Bool

type MChar = Maybe Char

type MDouble = Maybe Double

defaultBehaviours :: [Behaviours](Data-SearchBuilder.html#t:Behaviours)

defaultExceptions :: [Exceptions](Data-SearchBuilder.html#t:Exceptions)

findException :: String -\> [Type](Data-SearchBuilder.html#t:Type) -\>
[Exceptions](Data-SearchBuilder.html#t:Exceptions) -\> Maybe
[DTD](Data-DatabaseTemplate.html#t:DTD)

build :: [Database](Model-General.html#t:Database) c a =\>
[Behaviours](Data-SearchBuilder.html#t:Behaviours) -\> a -\>
[Exceptions](Data-SearchBuilder.html#t:Exceptions) -\>
([DTD](Data-DatabaseTemplate.html#t:DTD), [String])

lookupMany :: Eq a =\> a -\> [(a, b)] -\> [b]

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
