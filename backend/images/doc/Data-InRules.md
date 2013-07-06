-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Data.InRules

Contents

-   [Data types and classes](#g:1)
-   [Pretty print](#g:2)

Description

This module implements a dynamic type system

Synopsis

-   [hmapKeys](#v:hmapKeys) :: (Eq k, Hashable k) =\> (k1 -\> k) -\> HashMap k1 v -\> HashMap k v
-   [hmapWithKey](#v:hmapWithKey) :: (Eq k, Hashable k) =\> (k -\> v1 -\> v) -\> HashMap k v1 -\> HashMap k v
-   data [InRule](#t:InRule)
    -   = [InString](#v:InString) !String
    -   | [InByteString](#v:InByteString) !ByteString
    -   | [InInteger](#v:InInteger) !Integer
    -   | [InDouble](#v:InDouble) !Double
    -   | [InNumber](#v:InNumber) !Rational
    -   | [InBool](#v:InBool) !Bool
    -   | [InNull](#v:InNull)
    -   | [InArray](#v:InArray) [[InRule](Data-InRules.html#t:InRule)]
    -   | [InObject](#v:InObject) (HashMap String [InRule](Data-InRules.html#t:InRule))

-   newtype [Readable](#t:Readable) = [Readable](#v:Readable) {
    -   [unReadable](#v:unReadable) :: String

    }
-   data [InKey](#t:InKey)
    -   = [Index](#v:Index) Int
    -   | [None](#v:None)
    -   | [Assoc](#v:Assoc) String

-   newtype [IdentityMonoid](#t:IdentityMonoid) a = [IM](#v:IM) {
    -   [unIM](#v:unIM) :: a

    }
-   data [PathState](#t:PathState)
    -   = [Accept](#v:Accept)
    -   | [Reject](#v:Reject)

-   data [PathStep](#t:PathStep) a
    -   = [Next](#v:Next) ([PathAcceptor](Data-InRules.html#t:PathAcceptor) a)
    -   | [Final](#v:Final) [PathState](Data-InRules.html#t:PathState)

-   newtype [PathAcceptor](#t:PathAcceptor) a = [PM](#v:PM) {
    -   [unPM](#v:unPM) :: a -\> [PathStep](Data-InRules.html#t:PathStep) a

    }
-   [accept](#v:accept) :: [PathStep](Data-InRules.html#t:PathStep) a
-   [reject](#v:reject) :: [PathStep](Data-InRules.html#t:PathStep) a
-   [acceptor](#v:acceptor) :: [PathAcceptor](Data-InRules.html#t:PathAcceptor) a
-   [rejector](#v:rejector) :: [PathAcceptor](Data-InRules.html#t:PathAcceptor) a
-   [continue](#v:continue) :: [PathAcceptor](Data-InRules.html#t:PathAcceptor) a
-   [alter](#v:alter) :: [PathAcceptor](Data-InRules.html#t:PathAcceptor) a -\> [PathAcceptor](Data-InRules.html#t:PathAcceptor) a -\> [PathAcceptor](Data-InRules.html#t:PathAcceptor) a
-   [apoint](#v:apoint) :: Eq a =\> a -\> [PathAcceptor](Data-InRules.html#t:PathAcceptor) a
-   [runPath](#v:runPath) :: Eq a =\> [PathAcceptor](Data-InRules.html#t:PathAcceptor) a -\> [a] -\> Bool
-   data [KindView](#t:KindView)
    -   = [TScalar](#v:TScalar)
    -   | [TArray](#v:TArray)
    -   | [TObject](#v:TObject)
    -   | [TNone](#v:TNone)

-   [viewKind](#v:viewKind) :: [InRule](Data-InRules.html#t:InRule) -\> [KindView](Data-InRules.html#t:KindView)
-   [kmap](#v:kmap) :: ([InKey](Data-InRules.html#t:InKey) -\> [InRule](Data-InRules.html#t:InRule) -\> [InRule](Data-InRules.html#t:InRule)) -\> [InRule](Data-InRules.html#t:InRule) -\> [InRule](Data-InRules.html#t:InRule)
-   [pmap](#v:pmap) :: (Monoid (f [InKey](Data-InRules.html#t:InKey)), Pointed f) =\> (f [InKey](Data-InRules.html#t:InKey) -\> [InRule](Data-InRules.html#t:InRule) -\> [InRule](Data-InRules.html#t:InRule)) -\> [InRule](Data-InRules.html#t:InRule) -\> [InRule](Data-InRules.html#t:InRule)
-   [pfold](#v:pfold) :: (Monoid (f [InKey](Data-InRules.html#t:InKey)), Pointed f) =\> (f [InKey](Data-InRules.html#t:InKey) -\> [InRule](Data-InRules.html#t:InRule) -\> b -\> b) -\> [InRule](Data-InRules.html#t:InRule) -\> b -\> b
-   [longest\_path](#v:longest_path) :: [InRule](Data-InRules.html#t:InRule) -\> Int
-   [ckey](#v:ckey) :: Num a =\> [[InKey](Data-InRules.html#t:InKey)] -\> a
-   [kfold](#v:kfold) :: ([InKey](Data-InRules.html#t:InKey) -\> [InRule](Data-InRules.html#t:InRule) -\> b -\> b) -\> [InRule](Data-InRules.html#t:InRule) -\> b -\> b
-   [(.\>)](#v:.-62-) :: [InRule](Data-InRules.html#t:InRule) -\> String -\> Maybe [InRule](Data-InRules.html#t:InRule)
-   [(..\>)](#v:..-62-) :: [FromInRule](Data-InRules.html#t:FromInRule) a =\> [InRule](Data-InRules.html#t:InRule) -\> String -\> Maybe a
-   [(.\>\>)](#v:.-62--62-) :: [InRule](Data-InRules.html#t:InRule) -\> String -\> [[InRule](Data-InRules.html#t:InRule)]
-   [readable](#v:readable) :: String -\> [Readable](Data-InRules.html#t:Readable)
-   [viaReadable](#v:viaReadable) :: Read a =\> [InRule](Data-InRules.html#t:InRule) -\> a
-   [asReadable](#v:asReadable) :: [InRule](Data-InRules.html#t:InRule) -\> [Readable](Data-InRules.html#t:Readable)
-   type [InRules](#t:InRules) = [[InRule](Data-InRules.html#t:InRule)]
-   class [ToInRule](#t:ToInRule) a where
    -   [toInRule](#v:toInRule) :: a -\> [InRule](Data-InRules.html#t:InRule)

-   class [FromInRule](#t:FromInRule) a where
    -   [fromInRule](#v:fromInRule) :: [InRule](Data-InRules.html#t:InRule) -\> a

-   [toCompatible](#v:toCompatible) :: [InRule](Data-InRules.html#t:InRule) -\> [InRule](Data-InRules.html#t:InRule)
-   [validObject](#v:validObject) :: [InRule](Data-InRules.html#t:InRule) -\> Bool
-   [emptyObj](#v:emptyObj) :: [InRule](Data-InRules.html#t:InRule)
-   [object](#v:object) :: [(String, [InRule](Data-InRules.html#t:InRule))] -\> [InRule](Data-InRules.html#t:InRule)
-   [list](#v:list) :: [[InRule](Data-InRules.html#t:InRule)] -\> [InRule](Data-InRules.html#t:InRule)
-   [project](#v:project) :: [InRule](Data-InRules.html#t:InRule) -\> [InRule](Data-InRules.html#t:InRule) -\> [InRule](Data-InRules.html#t:InRule)
-   [mapWithKey](#v:mapWithKey) :: (k -\> a -\> b) -\> HashMap k a -\> HashMap k b
-   [arrayToObj](#v:arrayToObj) :: [InRule](Data-InRules.html#t:InRule) -\> [InRule](Data-InRules.html#t:InRule)
-   [shp](#v:shp) :: [InRule](Data-InRules.html#t:InRule) -\> [InRule](Data-InRules.html#t:InRule) -\> Bool
-   [shpTestAB](#v:shpTestAB) :: Bool
-   [shpTestArr](#v:shpTestArr) :: Bool
-   [singleObj](#v:singleObj) :: [ToInRule](Data-InRules.html#t:ToInRule) a =\> String -\> a -\> [InRule](Data-InRules.html#t:InRule)
-   [(==\>)](#v:-61--61--62-) :: [ToInRule](Data-InRules.html#t:ToInRule) a =\> String -\> a -\> [InRule](Data-InRules.html#t:InRule)
-   [orM](#v:orM) :: Maybe a -\> a -\> Maybe a
-   [withDefault](#v:withDefault) :: a -\> Maybe a -\> Maybe a
-   [fromList](#v:fromList) :: [ToInRule](Data-InRules.html#t:ToInRule) a =\> [(String, a)] -\> [InRule](Data-InRules.html#t:InRule)
-   [toList](#v:toList) :: [FromInRule](Data-InRules.html#t:FromInRule) a =\> [InRule](Data-InRules.html#t:InRule) -\> [(String, a)]
-   [toListString](#v:toListString) :: [InRule](Data-InRules.html#t:InRule) -\> [(String, String)]
-   [unionObj](#v:unionObj) :: [InRule](Data-InRules.html#t:InRule) -\> [InRule](Data-InRules.html#t:InRule) -\> [InRule](Data-InRules.html#t:InRule)
-   [unionsObj](#v:unionsObj) :: [[InRule](Data-InRules.html#t:InRule)] -\> [InRule](Data-InRules.html#t:InRule)
-   [unionRecObj](#v:unionRecObj) :: [InRule](Data-InRules.html#t:InRule) -\> [InRule](Data-InRules.html#t:InRule) -\> [InRule](Data-InRules.html#t:InRule)
-   [toString](#v:toString) :: [InRule](Data-InRules.html#t:InRule) -\> String
-   [pprint](#v:pprint) :: [InRule](Data-InRules.html#t:InRule) -\> IO ()
-   [pprint'](#v:pprint-39-) :: String -\> Integer -\> [InRule](Data-InRules.html#t:InRule) -\> String
-   [pprints](#v:pprints) :: [[InRule](Data-InRules.html#t:InRule)] -\> IO ()
-   [escInStr](#v:escInStr) :: String -\> String
-   [escInChar](#v:escInChar) :: Char -\> String

Documentation
=============

hmapKeys :: (Eq k, Hashable k) =\> (k1 -\> k) -\> HashMap k1 v -\> HashMap k v

Map all the hash map keys

hmapWithKey :: (Eq k, Hashable k) =\> (k -\> v1 -\> v) -\> HashMap k v1 -\> HashMap k v

Map over all the hash map values with a key

Data types and classes
======================

data InRule

Primitive type, a subset of this type is isomorph to json and yaml

Constructors

||
|InString !String| |
|InByteString !ByteString| |
|InInteger !Integer| |
|InDouble !Double| |
|InNumber !Rational| |
|InBool !Bool| |
|InNull| |
|InArray [[InRule](Data-InRules.html#t:InRule)]| |
|InObject (HashMap String [InRule](Data-InRules.html#t:InRule))| |

Instances

||
|Eq [InRule](Data-InRules.html#t:InRule)| |
|Show [InRule](Data-InRules.html#t:InRule)| |
|IsString [InRule](Data-InRules.html#t:InRule)| |
|Monoid [InRule](Data-InRules.html#t:InRule)| |
|Serialize [InRule](Data-InRules.html#t:InRule)| |
|Arbitrary [InRule](Data-InRules.html#t:InRule)| |
|[FromInRule](Data-InRules.html#t:FromInRule) [InRule](Data-InRules.html#t:InRule)| |
|[ToInRule](Data-InRules.html#t:ToInRule) [InRule](Data-InRules.html#t:InRule)| |
|Binary [InRule](Data-InRules.html#t:InRule)| |
|[StringLike](Data-Tools.html#t:StringLike) [InRule](Data-InRules.html#t:InRule)| |
|[ToInRule](Data-InRules.html#t:ToInRule) b =\> Convertible b [InRule](Data-InRules.html#t:InRule)| |
|[FromInRule](Data-InRules.html#t:FromInRule) b =\> Convertible [InRule](Data-InRules.html#t:InRule) b| |

newtype Readable

Constructors

Readable

 

Fields

unReadable :: String  
 

Instances

Show [Readable](Data-InRules.html#t:Readable)

 

[FromInRule](Data-InRules.html#t:FromInRule) [Readable](Data-InRules.html#t:Readable)

Dirty fallback strategy

Read a =\> Convertible [Readable](Data-InRules.html#t:Readable) a

 

data InKey

Data type used for viewing the type of a index

Constructors

||
|Index Int| |
|None| |
|Assoc String| |

Instances

||
|Show [InKey](Data-InRules.html#t:InKey)| |
|Monoid [InKey](Data-InRules.html#t:InKey)| |

newtype IdentityMonoid a

Identity monoid, doesn't exist in prelude or anywhere else

Constructors

IM

 

Fields

unIM :: a  
 

Instances

||
|Functor [IdentityMonoid](Data-InRules.html#t:IdentityMonoid)| |
|Pointed [IdentityMonoid](Data-InRules.html#t:IdentityMonoid)| |
|Copointed [IdentityMonoid](Data-InRules.html#t:IdentityMonoid)| |
|Monoid a =\> Monoid ([IdentityMonoid](Data-InRules.html#t:IdentityMonoid) a)| |

data PathState

Simple automaton for rejecting or accepting paths

Constructors

||
|Accept| |
|Reject| |

Instances

||
|Show [PathState](Data-InRules.html#t:PathState)| |

data PathStep a

One step of the automata. Automata can be in two states: | next step or final path

Constructors

||
|Next ([PathAcceptor](Data-InRules.html#t:PathAcceptor) a)| |
|Final [PathState](Data-InRules.html#t:PathState)| |

newtype PathAcceptor a

One machine step

Constructors

PM

 

Fields

unPM :: a -\> [PathStep](Data-InRules.html#t:PathStep) a  
 

Instances

Semigroup ([PathAcceptor](Data-InRules.html#t:PathAcceptor) a)

Path acceptor is a semigroup and acts semantically like a and operator

accept :: [PathStep](Data-InRules.html#t:PathStep) a

The always acceptor

reject :: [PathStep](Data-InRules.html#t:PathStep) a

The always rejector

acceptor :: [PathAcceptor](Data-InRules.html#t:PathAcceptor) a

Always accept the input

rejector :: [PathAcceptor](Data-InRules.html#t:PathAcceptor) a

Always reject the input

continue :: [PathAcceptor](Data-InRules.html#t:PathAcceptor) a

Always accept the complete input stream (will always be false for finite streams and true for infinite ones)

alter :: [PathAcceptor](Data-InRules.html#t:PathAcceptor) a -\> [PathAcceptor](Data-InRules.html#t:PathAcceptor) a -\> [PathAcceptor](Data-InRules.html#t:PathAcceptor) a

Alternate two acceptors. If the first rejects try the next. Behaves like an or | operator

apoint :: Eq a =\> a -\> [PathAcceptor](Data-InRules.html#t:PathAcceptor) a

Creates a pointed acceptor

runPath :: Eq a =\> [PathAcceptor](Data-InRules.html#t:PathAcceptor) a -\> [a] -\> Bool

data KindView

View the kind of a InRule

Constructors

||
|TScalar| |
|TArray| |
|TObject| |
|TNone| |

Instances

||
|Eq [KindView](Data-InRules.html#t:KindView)| |
|Show [KindView](Data-InRules.html#t:KindView)| |

viewKind :: [InRule](Data-InRules.html#t:InRule) -\> [KindView](Data-InRules.html#t:KindView)

kmap :: ([InKey](Data-InRules.html#t:InKey) -\> [InRule](Data-InRules.html#t:InRule) -\> [InRule](Data-InRules.html#t:InRule)) -\> [InRule](Data-InRules.html#t:InRule) -\> [InRule](Data-InRules.html#t:InRule)

Maps through the structure

pmap :: (Monoid (f [InKey](Data-InRules.html#t:InKey)), Pointed f) =\> (f [InKey](Data-InRules.html#t:InKey) -\> [InRule](Data-InRules.html#t:InRule) -\> [InRule](Data-InRules.html#t:InRule)) -\> [InRule](Data-InRules.html#t:InRule) -\> [InRule](Data-InRules.html#t:InRule)

Maps trough the structure with a history of the path kept in a monoid

pfold :: (Monoid (f [InKey](Data-InRules.html#t:InKey)), Pointed f) =\> (f [InKey](Data-InRules.html#t:InKey) -\> [InRule](Data-InRules.html#t:InRule) -\> b -\> b) -\> [InRule](Data-InRules.html#t:InRule) -\> b -\> b

Fold trough a structure with a history of the path kept in a monoid

longest\_path :: [InRule](Data-InRules.html#t:InRule) -\> Int

Example of the longest path in the inrule structure

ckey :: Num a =\> [[InKey](Data-InRules.html#t:InKey)] -\> a

kfold :: ([InKey](Data-InRules.html#t:InKey) -\> [InRule](Data-InRules.html#t:InRule) -\> b -\> b) -\> [InRule](Data-InRules.html#t:InRule) -\> b -\> b

Fold through the structure

(.\>) :: [InRule](Data-InRules.html#t:InRule) -\> String -\> Maybe [InRule](Data-InRules.html#t:InRule)

Find top level matching keyword

(..\>) :: [FromInRule](Data-InRules.html#t:FromInRule) a =\> [InRule](Data-InRules.html#t:InRule) -\> String -\> Maybe a

Find top level value and convert to normal value

(.\>\>) :: [InRule](Data-InRules.html#t:InRule) -\> String -\> [[InRule](Data-InRules.html#t:InRule)]

Search all occuring keywords recursively

readable :: String -\> [Readable](Data-InRules.html#t:Readable)

Transform a string into a readable

viaReadable :: Read a =\> [InRule](Data-InRules.html#t:InRule) -\> a

asReadable :: [InRule](Data-InRules.html#t:InRule) -\> [Readable](Data-InRules.html#t:Readable)

type InRules = [[InRule](Data-InRules.html#t:InRule)]

class ToInRule a where

Methods

toInRule :: a -\> [InRule](Data-InRules.html#t:InRule)

Instances

[ToInRule](Data-InRules.html#t:ToInRule) Bool

 

[ToInRule](Data-InRules.html#t:ToInRule) Char

 

[ToInRule](Data-InRules.html#t:ToInRule) Double

 

[ToInRule](Data-InRules.html#t:ToInRule) Float

 

[ToInRule](Data-InRules.html#t:ToInRule) Int

 

[ToInRule](Data-InRules.html#t:ToInRule) Int32

 

[ToInRule](Data-InRules.html#t:ToInRule) Int64

 

[ToInRule](Data-InRules.html#t:ToInRule) Integer

 

[ToInRule](Data-InRules.html#t:ToInRule) Rational

 

[ToInRule](Data-InRules.html#t:ToInRule) Word32

 

[ToInRule](Data-InRules.html#t:ToInRule) Word64

 

[ToInRule](Data-InRules.html#t:ToInRule) String

 

[ToInRule](Data-InRules.html#t:ToInRule) ()

 

[ToInRule](Data-InRules.html#t:ToInRule) [SqlValue](Data-SqlTransaction.html#t:SqlValue)

Renders InRule to String.

[ToInRule](Data-InRules.html#t:ToInRule) ByteString

 

[ToInRule](Data-InRules.html#t:ToInRule) Value

 

[ToInRule](Data-InRules.html#t:ToInRule) ByteString

 

[ToInRule](Data-InRules.html#t:ToInRule) UTCTime

 

[ToInRule](Data-InRules.html#t:ToInRule) LocalTime

 

[ToInRule](Data-InRules.html#t:ToInRule) Day

 

[ToInRule](Data-InRules.html#t:ToInRule) TimeOfDay

 

[ToInRule](Data-InRules.html#t:ToInRule) [InRule](Data-InRules.html#t:InRule)

 

[ToInRule](Data-InRules.html#t:ToInRule) [Application](Model-Application.html#t:Application)

 

[ToInRule](Data-InRules.html#t:ToInRule) [CarInstance](Model-CarInstance.html#t:CarInstance)

 

[ToInRule](Data-InRules.html#t:ToInRule) [ParameterTable](Model-ParameterTable.html#t:ParameterTable)

 

[ToInRule](Data-InRules.html#t:ToInRule) a =\> [ToInRule](Data-InRules.html#t:ToInRule) [a]

 

[ToInRule](Data-InRules.html#t:ToInRule) a =\> [ToInRule](Data-InRules.html#t:ToInRule) (Maybe a)

 

([ToInRule](Data-InRules.html#t:ToInRule) t1, [ToInRule](Data-InRules.html#t:ToInRule) t2) =\> [ToInRule](Data-InRules.html#t:ToInRule) (t1, t2)

 

[ToInRule](Data-InRules.html#t:ToInRule) a =\> [ToInRule](Data-InRules.html#t:ToInRule) (HashMap String a)

 

([ToInRule](Data-InRules.html#t:ToInRule) k, [ToInRule](Data-InRules.html#t:ToInRule) v) =\> [ToInRule](Data-InRules.html#t:ToInRule) (HashMap k v)

 

([ToInRule](Data-InRules.html#t:ToInRule) t1, [ToInRule](Data-InRules.html#t:ToInRule) t2, [ToInRule](Data-InRules.html#t:ToInRule) t3) =\> [ToInRule](Data-InRules.html#t:ToInRule) (t1, t2, t3)

 

([ToInRule](Data-InRules.html#t:ToInRule) t1, [ToInRule](Data-InRules.html#t:ToInRule) t2, [ToInRule](Data-InRules.html#t:ToInRule) t3, [ToInRule](Data-InRules.html#t:ToInRule) t4) =\> [ToInRule](Data-InRules.html#t:ToInRule) (t1, t2, t3, t4)

 

([ToInRule](Data-InRules.html#t:ToInRule) t1, [ToInRule](Data-InRules.html#t:ToInRule) t2, [ToInRule](Data-InRules.html#t:ToInRule) t3, [ToInRule](Data-InRules.html#t:ToInRule) t4, [ToInRule](Data-InRules.html#t:ToInRule) t5) =\> [ToInRule](Data-InRules.html#t:ToInRule) (t1, t2, t3, t4, t5)

 

class FromInRule a where

Methods

fromInRule :: [InRule](Data-InRules.html#t:InRule) -\> a

Instances

[FromInRule](Data-InRules.html#t:FromInRule) Bool

 

[FromInRule](Data-InRules.html#t:FromInRule) Double

 

[FromInRule](Data-InRules.html#t:FromInRule) Float

 

[FromInRule](Data-InRules.html#t:FromInRule) Int

 

[FromInRule](Data-InRules.html#t:FromInRule) Int32

 

[FromInRule](Data-InRules.html#t:FromInRule) Int64

 

[FromInRule](Data-InRules.html#t:FromInRule) Integer

 

[FromInRule](Data-InRules.html#t:FromInRule) Rational

 

[FromInRule](Data-InRules.html#t:FromInRule) Word32

 

[FromInRule](Data-InRules.html#t:FromInRule) Word64

 

[FromInRule](Data-InRules.html#t:FromInRule) String

 

[FromInRule](Data-InRules.html#t:FromInRule) [SqlValue](Data-SqlTransaction.html#t:SqlValue)

 

[FromInRule](Data-InRules.html#t:FromInRule) ByteString

 

[FromInRule](Data-InRules.html#t:FromInRule) Value

 

[FromInRule](Data-InRules.html#t:FromInRule) ByteString

 

[FromInRule](Data-InRules.html#t:FromInRule) UTCTime

 

[FromInRule](Data-InRules.html#t:FromInRule) LocalTime

 

[FromInRule](Data-InRules.html#t:FromInRule) Day

 

[FromInRule](Data-InRules.html#t:FromInRule) TimeOfDay

 

[FromInRule](Data-InRules.html#t:FromInRule) [Readable](Data-InRules.html#t:Readable)

Dirty fallback strategy

[FromInRule](Data-InRules.html#t:FromInRule) [InRule](Data-InRules.html#t:InRule)

 

[FromInRule](Data-InRules.html#t:FromInRule) [Application](Model-Application.html#t:Application)

 

[FromInRule](Data-InRules.html#t:FromInRule) [CarInstance](Model-CarInstance.html#t:CarInstance)

 

[FromInRule](Data-InRules.html#t:FromInRule) [ParameterTable](Model-ParameterTable.html#t:ParameterTable)

 

[FromInRule](Data-InRules.html#t:FromInRule) a =\> [FromInRule](Data-InRules.html#t:FromInRule) [a]

 

[FromInRule](Data-InRules.html#t:FromInRule) a =\> [FromInRule](Data-InRules.html#t:FromInRule) (Maybe a)

 

([FromInRule](Data-InRules.html#t:FromInRule) t1, [FromInRule](Data-InRules.html#t:FromInRule) t2) =\> [FromInRule](Data-InRules.html#t:FromInRule) (t1, t2)

 

[FromInRule](Data-InRules.html#t:FromInRule) a =\> [FromInRule](Data-InRules.html#t:FromInRule) (HashMap String a)

 

(Eq k, Hashable k, [FromInRule](Data-InRules.html#t:FromInRule) k, [FromInRule](Data-InRules.html#t:FromInRule) v) =\> [FromInRule](Data-InRules.html#t:FromInRule) (HashMap k v)

 

([FromInRule](Data-InRules.html#t:FromInRule) t1, [FromInRule](Data-InRules.html#t:FromInRule) t2, [FromInRule](Data-InRules.html#t:FromInRule) t3) =\> [FromInRule](Data-InRules.html#t:FromInRule) (t1, t2, t3)

 

([FromInRule](Data-InRules.html#t:FromInRule) t1, [FromInRule](Data-InRules.html#t:FromInRule) t2, [FromInRule](Data-InRules.html#t:FromInRule) t3, [FromInRule](Data-InRules.html#t:FromInRule) t4) =\> [FromInRule](Data-InRules.html#t:FromInRule) (t1, t2, t3, t4)

 

([FromInRule](Data-InRules.html#t:FromInRule) t1, [FromInRule](Data-InRules.html#t:FromInRule) t2, [FromInRule](Data-InRules.html#t:FromInRule) t3, [FromInRule](Data-InRules.html#t:FromInRule) t4, [FromInRule](Data-InRules.html#t:FromInRule) t5) =\> [FromInRule](Data-InRules.html#t:FromInRule) (t1, t2, t3, t4, t5)

 

toCompatible :: [InRule](Data-InRules.html#t:InRule) -\> [InRule](Data-InRules.html#t:InRule)

validObject :: [InRule](Data-InRules.html#t:InRule) -\> Bool

emptyObj :: [InRule](Data-InRules.html#t:InRule)

object :: [(String, [InRule](Data-InRules.html#t:InRule))] -\> [InRule](Data-InRules.html#t:InRule)

list :: [[InRule](Data-InRules.html#t:InRule)] -\> [InRule](Data-InRules.html#t:InRule)

project :: [InRule](Data-InRules.html#t:InRule) -\> [InRule](Data-InRules.html#t:InRule) -\> [InRule](Data-InRules.html#t:InRule)

mapWithKey :: (k -\> a -\> b) -\> HashMap k a -\> HashMap k b

arrayToObj :: [InRule](Data-InRules.html#t:InRule) -\> [InRule](Data-InRules.html#t:InRule)

shp :: [InRule](Data-InRules.html#t:InRule) -\> [InRule](Data-InRules.html#t:InRule) -\> Bool

shpTestAB :: Bool

shpTestArr :: Bool

singleObj :: [ToInRule](Data-InRules.html#t:ToInRule) a =\> String -\> a -\> [InRule](Data-InRules.html#t:InRule)

Create single InRule object.

(==\>) :: [ToInRule](Data-InRules.html#t:ToInRule) a =\> String -\> a -\> [InRule](Data-InRules.html#t:InRule)

`(==>`) Eq `singleObj` .

orM :: Maybe a -\> a -\> Maybe a

withDefault :: a -\> Maybe a -\> Maybe a

fromList :: [ToInRule](Data-InRules.html#t:ToInRule) a =\> [(String, a)] -\> [InRule](Data-InRules.html#t:InRule)

Create InRule object from list.

toList :: [FromInRule](Data-InRules.html#t:FromInRule) a =\> [InRule](Data-InRules.html#t:InRule) -\> [(String, a)]

Create InRule object from list.

toListString :: [InRule](Data-InRules.html#t:InRule) -\> [(String, String)]

unionObj :: [InRule](Data-InRules.html#t:InRule) -\> [InRule](Data-InRules.html#t:InRule) -\> [InRule](Data-InRules.html#t:InRule)

unionsObj :: [[InRule](Data-InRules.html#t:InRule)] -\> [InRule](Data-InRules.html#t:InRule)

Merge InRule objects from list.

unionRecObj :: [InRule](Data-InRules.html#t:InRule) -\> [InRule](Data-InRules.html#t:InRule) -\> [InRule](Data-InRules.html#t:InRule)

toString :: [InRule](Data-InRules.html#t:InRule) -\> String

Renders InRule to String.

Pretty print
============

pprint :: [InRule](Data-InRules.html#t:InRule) -\> IO ()

Pretty-prints InRule.

pprint' :: String -\> Integer -\> [InRule](Data-InRules.html#t:InRule) -\> String

pprints :: [[InRule](Data-InRules.html#t:InRule)] -\> IO ()

Pretty-prints InRules.

escInStr :: String -\> String

escInChar :: Char -\> String

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
