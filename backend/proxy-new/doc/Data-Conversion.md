% Data.Conversion
% 
% 

-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Data.Conversion

Description

Tests for some guarantees we want to make about the code.

-   There should be a mapping between the number types
-   A subset of InRule must be isomorphic to Value and Json2, that
    means, we do not lose type information.
-   Different strings types must isomorph

The bijective map of a subset of InRule with Value is:


    InInteger Integer            -      Number (I Integer)

    InDouble  Double             -      Number (D Double)

    InByteString B.ByteString    -      String (Text) 

    InArray  [InRule]            -      Array (Vector Value)  

    InObject M.Map String InRule -      Object M.Map Text Value  

    InBool Bool                  -      Bool Bool

    InNull                       -      Null

By the way, this is the file you want to import to get the whole
interface

Synopsis

-   [(.\>)](#v:.-62-) :: [InRule](Data-Conversion.html#t:InRule) -\>
    String -\> Maybe [InRule](Data-Conversion.html#t:InRule)
-   [(.\>\>)](#v:.-62--62-) :: [InRule](Data-Conversion.html#t:InRule)
    -\> String -\> [[InRule](Data-Conversion.html#t:InRule)]
-   [(==\>)](#v:-61--61--62-) ::
    [ToInRule](Data-Conversion.html#t:ToInRule) a =\> String -\> a -\>
    [InRule](Data-Conversion.html#t:InRule)
-   [(..\>)](#v:..-62-) ::
    [FromInRule](Data-Conversion.html#t:FromInRule) a =\>
    [InRule](Data-Conversion.html#t:InRule) -\> String -\> Maybe a
-   [hmapKeys](#v:hmapKeys) :: (Eq k, Hashable k) =\> (k1 -\> k) -\>
    HashMap k1 v -\> HashMap k v
-   [hmapWithKey](#v:hmapWithKey) :: (Eq k, Hashable k) =\> (k -\> v1
    -\> v) -\> HashMap k v1 -\> HashMap k v
-   data [InRule](#t:InRule)
    -   = [InString](#v:InString) !String
    -   | [InByteString](#v:InByteString) !ByteString
    -   | [InInteger](#v:InInteger) !Integer
    -   | [InDouble](#v:InDouble) !Double
    -   | [InNumber](#v:InNumber) !Rational
    -   | [InBool](#v:InBool) !Bool
    -   | [InNull](#v:InNull)
    -   | [InArray](#v:InArray)
        [[InRule](Data-Conversion.html#t:InRule)]
    -   | [InObject](#v:InObject) (HashMap String
        [InRule](Data-Conversion.html#t:InRule))

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
    -   = [Next](#v:Next)
        ([PathAcceptor](Data-Conversion.html#t:PathAcceptor) a)
    -   | [Final](#v:Final)
        [PathState](Data-Conversion.html#t:PathState)

-   newtype [PathAcceptor](#t:PathAcceptor) a = [PM](#v:PM) {
    -   [unPM](#v:unPM) :: a -\>
        [PathStep](Data-Conversion.html#t:PathStep) a

    }
-   [accept](#v:accept) :: [PathStep](Data-Conversion.html#t:PathStep) a
-   [reject](#v:reject) :: [PathStep](Data-Conversion.html#t:PathStep) a
-   [acceptor](#v:acceptor) ::
    [PathAcceptor](Data-Conversion.html#t:PathAcceptor) a
-   [continue](#v:continue) ::
    [PathAcceptor](Data-Conversion.html#t:PathAcceptor) a
-   [alter](#v:alter) ::
    [PathAcceptor](Data-Conversion.html#t:PathAcceptor) a -\>
    [PathAcceptor](Data-Conversion.html#t:PathAcceptor) a -\>
    [PathAcceptor](Data-Conversion.html#t:PathAcceptor) a
-   [apoint](#v:apoint) :: Eq a =\> a -\>
    [PathAcceptor](Data-Conversion.html#t:PathAcceptor) a
-   [runPath](#v:runPath) :: Eq a =\>
    [PathAcceptor](Data-Conversion.html#t:PathAcceptor) a -\> [a] -\>
    Bool
-   data [KindView](#t:KindView)
    -   = [TScalar](#v:TScalar)
    -   | [TArray](#v:TArray)
    -   | [TObject](#v:TObject)
    -   | [TNone](#v:TNone)

-   [viewKind](#v:viewKind) :: [InRule](Data-Conversion.html#t:InRule)
    -\> [KindView](Data-Conversion.html#t:KindView)
-   [kmap](#v:kmap) :: ([InKey](Data-Conversion.html#t:InKey) -\>
    [InRule](Data-Conversion.html#t:InRule) -\>
    [InRule](Data-Conversion.html#t:InRule)) -\>
    [InRule](Data-Conversion.html#t:InRule) -\>
    [InRule](Data-Conversion.html#t:InRule)
-   [pmap](#v:pmap) :: (Monoid (f
    [InKey](Data-Conversion.html#t:InKey)), Pointed f) =\> (f
    [InKey](Data-Conversion.html#t:InKey) -\>
    [InRule](Data-Conversion.html#t:InRule) -\>
    [InRule](Data-Conversion.html#t:InRule)) -\>
    [InRule](Data-Conversion.html#t:InRule) -\>
    [InRule](Data-Conversion.html#t:InRule)
-   [pfold](#v:pfold) :: (Monoid (f
    [InKey](Data-Conversion.html#t:InKey)), Pointed f) =\> (f
    [InKey](Data-Conversion.html#t:InKey) -\>
    [InRule](Data-Conversion.html#t:InRule) -\> b -\> b) -\>
    [InRule](Data-Conversion.html#t:InRule) -\> b -\> b
-   [kfold](#v:kfold) :: ([InKey](Data-Conversion.html#t:InKey) -\>
    [InRule](Data-Conversion.html#t:InRule) -\> b -\> b) -\>
    [InRule](Data-Conversion.html#t:InRule) -\> b -\> b
-   [readable](#v:readable) :: String -\>
    [Readable](Data-Conversion.html#t:Readable)
-   [viaReadable](#v:viaReadable) :: Read a =\>
    [InRule](Data-Conversion.html#t:InRule) -\> a
-   [asReadable](#v:asReadable) ::
    [InRule](Data-Conversion.html#t:InRule) -\>
    [Readable](Data-Conversion.html#t:Readable)
-   class [ToInRule](#t:ToInRule) a where
    -   [toInRule](#v:toInRule) :: a -\>
        [InRule](Data-Conversion.html#t:InRule)

-   class [FromInRule](#t:FromInRule) a where
    -   [fromInRule](#v:fromInRule) ::
        [InRule](Data-Conversion.html#t:InRule) -\> a

-   [validObject](#v:validObject) ::
    [InRule](Data-Conversion.html#t:InRule) -\> Bool
-   [emptyObj](#v:emptyObj) :: [InRule](Data-Conversion.html#t:InRule)
-   [singleObj](#v:singleObj) ::
    [ToInRule](Data-Conversion.html#t:ToInRule) a =\> String -\> a -\>
    [InRule](Data-Conversion.html#t:InRule)
-   [fromList](#v:fromList) ::
    [ToInRule](Data-Conversion.html#t:ToInRule) a =\> [(String, a)] -\>
    [InRule](Data-Conversion.html#t:InRule)
-   [toList](#v:toList) ::
    [FromInRule](Data-Conversion.html#t:FromInRule) a =\>
    [InRule](Data-Conversion.html#t:InRule) -\> [(String, a)]
-   [toListString](#v:toListString) ::
    [InRule](Data-Conversion.html#t:InRule) -\> [(String, String)]
-   [unionObj](#v:unionObj) :: [InRule](Data-Conversion.html#t:InRule)
    -\> [InRule](Data-Conversion.html#t:InRule) -\>
    [InRule](Data-Conversion.html#t:InRule)
-   [unionsObj](#v:unionsObj) ::
    [[InRule](Data-Conversion.html#t:InRule)] -\>
    [InRule](Data-Conversion.html#t:InRule)
-   [toString](#v:toString) :: [InRule](Data-Conversion.html#t:InRule)
    -\> String
-   [pprint](#v:pprint) :: [InRule](Data-Conversion.html#t:InRule) -\>
    IO ()
-   [pprints](#v:pprints) :: [[InRule](Data-Conversion.html#t:InRule)]
    -\> IO ()
-   [object](#v:object) :: [(String,
    [InRule](Data-Conversion.html#t:InRule))] -\>
    [InRule](Data-Conversion.html#t:InRule)
-   [list](#v:list) :: [[InRule](Data-Conversion.html#t:InRule)] -\>
    [InRule](Data-Conversion.html#t:InRule)
-   [project](#v:project) :: [InRule](Data-Conversion.html#t:InRule) -\>
    [InRule](Data-Conversion.html#t:InRule) -\>
    [InRule](Data-Conversion.html#t:InRule)
-   [keyFilter](#v:keyFilter) :: (String -\> Bool) -\>
    [InRule](Data-Conversion.html#t:InRule) -\>
    [InRule](Data-Conversion.html#t:InRule)

Documentation
=============

(.\>) :: [InRule](Data-Conversion.html#t:InRule) -\> String -\> Maybe
[InRule](Data-Conversion.html#t:InRule)

Find top level matching keyword

(.\>\>) :: [InRule](Data-Conversion.html#t:InRule) -\> String -\>
[[InRule](Data-Conversion.html#t:InRule)]

Search all occuring keywords recursively

(==\>) :: [ToInRule](Data-Conversion.html#t:ToInRule) a =\> String -\> a
-\> [InRule](Data-Conversion.html#t:InRule)

`(==>`) Eq `singleObj` .

(..\>) :: [FromInRule](Data-Conversion.html#t:FromInRule) a =\>
[InRule](Data-Conversion.html#t:InRule) -\> String -\> Maybe a

Find top level value and convert to normal value

hmapKeys :: (Eq k, Hashable k) =\> (k1 -\> k) -\> HashMap k1 v -\>
HashMap k v

Map all the hash map keys

hmapWithKey :: (Eq k, Hashable k) =\> (k -\> v1 -\> v) -\> HashMap k v1
-\> HashMap k v

Map over all the hash map values with a key

data InRule

Primitive type, a subset of this type is isomorph to json and yaml

Constructors

  ------------------------------------------------------------------- ---
  InString !String                                                     
  InByteString !ByteString                                             
  InInteger !Integer                                                   
  InDouble !Double                                                     
  InNumber !Rational                                                   
  InBool !Bool                                                         
  InNull                                                               
  InArray [[InRule](Data-Conversion.html#t:InRule)]                    
  InObject (HashMap String [InRule](Data-Conversion.html#t:InRule))    
  ------------------------------------------------------------------- ---

Instances

  ------------------------------------------------------------------------------------------------------------- ---
  Eq [InRule](Data-Conversion.html#t:InRule)                                                                     
  Show [InRule](Data-Conversion.html#t:InRule)                                                                   
  IsString [InRule](Data-Conversion.html#t:InRule)                                                               
  Monoid [InRule](Data-Conversion.html#t:InRule)                                                                 
  Serialize [InRule](Data-Conversion.html#t:InRule)                                                              
  Arbitrary [InRule](Data-Conversion.html#t:InRule)                                                              
  [FromInRule](Data-Conversion.html#t:FromInRule) [InRule](Data-Conversion.html#t:InRule)                        
  [ToInRule](Data-Conversion.html#t:ToInRule) [InRule](Data-Conversion.html#t:InRule)                            
  Binary [InRule](Data-Conversion.html#t:InRule)                                                                 
  [StringLike](Data-Tools.html#t:StringLike) [InRule](Data-Conversion.html#t:InRule)                             
  [ToInRule](Data-Conversion.html#t:ToInRule) b =\> Convertible b [InRule](Data-Conversion.html#t:InRule)        
  [FromInRule](Data-Conversion.html#t:FromInRule) b =\> Convertible [InRule](Data-Conversion.html#t:InRule) b    
  ------------------------------------------------------------------------------------------------------------- ---

newtype Readable

Constructors

Readable

 

Fields

unReadable :: String
:    

Instances

Show [Readable](Data-Conversion.html#t:Readable)

 

[FromInRule](Data-Conversion.html#t:FromInRule)
[Readable](Data-Conversion.html#t:Readable)

Dirty fallback strategy

Read a =\> Convertible [Readable](Data-Conversion.html#t:Readable) a

 

data InKey

Data type used for viewing the type of a index

Constructors

  -------------- ---
  Index Int       
  None            
  Assoc String    
  -------------- ---

Instances

  ---------------------------------------------- ---
  Show [InKey](Data-Conversion.html#t:InKey)      
  Monoid [InKey](Data-Conversion.html#t:InKey)    
  ---------------------------------------------- ---

newtype IdentityMonoid a

Identity monoid, doesn't exist in prelude or anywhere else

Constructors

IM

 

Fields

unIM :: a
:    

Instances

  --------------------------------------------------------------------------------- ---
  Functor [IdentityMonoid](Data-Conversion.html#t:IdentityMonoid)                    
  Pointed [IdentityMonoid](Data-Conversion.html#t:IdentityMonoid)                    
  Copointed [IdentityMonoid](Data-Conversion.html#t:IdentityMonoid)                  
  Monoid a =\> Monoid ([IdentityMonoid](Data-Conversion.html#t:IdentityMonoid) a)    
  --------------------------------------------------------------------------------- ---

data PathState

Simple automaton for rejecting or accepting paths

Constructors

  -------- ---
  Accept    
  Reject    
  -------- ---

Instances

  ---------------------------------------------------- ---
  Show [PathState](Data-Conversion.html#t:PathState)    
  ---------------------------------------------------- ---

data PathStep a

One step of the automata. Automata can be in two states: | next step or
final path

Constructors

  -------------------------------------------------------------- ---
  Next ([PathAcceptor](Data-Conversion.html#t:PathAcceptor) a)    
  Final [PathState](Data-Conversion.html#t:PathState)             
  -------------------------------------------------------------- ---

newtype PathAcceptor a

One machine step

Constructors

PM

 

Fields

unPM :: a -\> [PathStep](Data-Conversion.html#t:PathStep) a
:    

Instances

Semigroup ([PathAcceptor](Data-Conversion.html#t:PathAcceptor) a)

Path acceptor is a semigroup and acts semantically like a and operator

accept :: [PathStep](Data-Conversion.html#t:PathStep) a

The always acceptor

reject :: [PathStep](Data-Conversion.html#t:PathStep) a

The always rejector

acceptor :: [PathAcceptor](Data-Conversion.html#t:PathAcceptor) a

Always accept the input

continue :: [PathAcceptor](Data-Conversion.html#t:PathAcceptor) a

Always accept the complete input stream (will always be false for finite
streams and true for infinite ones)

alter :: [PathAcceptor](Data-Conversion.html#t:PathAcceptor) a -\>
[PathAcceptor](Data-Conversion.html#t:PathAcceptor) a -\>
[PathAcceptor](Data-Conversion.html#t:PathAcceptor) a

Alternate two acceptors. If the first rejects try the next. Behaves like
an or | operator

apoint :: Eq a =\> a -\>
[PathAcceptor](Data-Conversion.html#t:PathAcceptor) a

Creates a pointed acceptor

runPath :: Eq a =\> [PathAcceptor](Data-Conversion.html#t:PathAcceptor)
a -\> [a] -\> Bool

data KindView

View the kind of a InRule

Constructors

  --------- ---
  TScalar    
  TArray     
  TObject    
  TNone      
  --------- ---

Instances

  -------------------------------------------------- ---
  Eq [KindView](Data-Conversion.html#t:KindView)      
  Show [KindView](Data-Conversion.html#t:KindView)    
  -------------------------------------------------- ---

viewKind :: [InRule](Data-Conversion.html#t:InRule) -\>
[KindView](Data-Conversion.html#t:KindView)

kmap :: ([InKey](Data-Conversion.html#t:InKey) -\>
[InRule](Data-Conversion.html#t:InRule) -\>
[InRule](Data-Conversion.html#t:InRule)) -\>
[InRule](Data-Conversion.html#t:InRule) -\>
[InRule](Data-Conversion.html#t:InRule)

Maps through the structure

pmap :: (Monoid (f [InKey](Data-Conversion.html#t:InKey)), Pointed f)
=\> (f [InKey](Data-Conversion.html#t:InKey) -\>
[InRule](Data-Conversion.html#t:InRule) -\>
[InRule](Data-Conversion.html#t:InRule)) -\>
[InRule](Data-Conversion.html#t:InRule) -\>
[InRule](Data-Conversion.html#t:InRule)

Maps trough the structure with a history of the path kept in a monoid

pfold :: (Monoid (f [InKey](Data-Conversion.html#t:InKey)), Pointed f)
=\> (f [InKey](Data-Conversion.html#t:InKey) -\>
[InRule](Data-Conversion.html#t:InRule) -\> b -\> b) -\>
[InRule](Data-Conversion.html#t:InRule) -\> b -\> b

Fold trough a structure with a history of the path kept in a monoid

kfold :: ([InKey](Data-Conversion.html#t:InKey) -\>
[InRule](Data-Conversion.html#t:InRule) -\> b -\> b) -\>
[InRule](Data-Conversion.html#t:InRule) -\> b -\> b

Fold through the structure

readable :: String -\> [Readable](Data-Conversion.html#t:Readable)

Transform a string into a readable

viaReadable :: Read a =\> [InRule](Data-Conversion.html#t:InRule) -\> a

asReadable :: [InRule](Data-Conversion.html#t:InRule) -\>
[Readable](Data-Conversion.html#t:Readable)

class ToInRule a where

Methods

toInRule :: a -\> [InRule](Data-Conversion.html#t:InRule)

Instances

[ToInRule](Data-Conversion.html#t:ToInRule) Bool

 

[ToInRule](Data-Conversion.html#t:ToInRule) Char

 

[ToInRule](Data-Conversion.html#t:ToInRule) Double

 

[ToInRule](Data-Conversion.html#t:ToInRule) Float

 

[ToInRule](Data-Conversion.html#t:ToInRule) Int

 

[ToInRule](Data-Conversion.html#t:ToInRule) Int32

 

[ToInRule](Data-Conversion.html#t:ToInRule) Int64

 

[ToInRule](Data-Conversion.html#t:ToInRule) Integer

 

[ToInRule](Data-Conversion.html#t:ToInRule) Rational

 

[ToInRule](Data-Conversion.html#t:ToInRule) Word32

 

[ToInRule](Data-Conversion.html#t:ToInRule) Word64

 

[ToInRule](Data-Conversion.html#t:ToInRule) String

 

[ToInRule](Data-Conversion.html#t:ToInRule) ()

 

[ToInRule](Data-Conversion.html#t:ToInRule)
[SqlValue](Data-SqlTransaction.html#t:SqlValue)

Renders InRule to String.

[ToInRule](Data-Conversion.html#t:ToInRule) ByteString

 

[ToInRule](Data-Conversion.html#t:ToInRule) Value

 

[ToInRule](Data-Conversion.html#t:ToInRule) ByteString

 

[ToInRule](Data-Conversion.html#t:ToInRule) UTCTime

 

[ToInRule](Data-Conversion.html#t:ToInRule) LocalTime

 

[ToInRule](Data-Conversion.html#t:ToInRule) Day

 

[ToInRule](Data-Conversion.html#t:ToInRule) TimeOfDay

 

[ToInRule](Data-Conversion.html#t:ToInRule)
[InRule](Data-Conversion.html#t:InRule)

 

[ToInRule](Data-Conversion.html#t:ToInRule)
[Application](Model-Application.html#t:Application)

 

[ToInRule](Data-Conversion.html#t:ToInRule) a =\>
[ToInRule](Data-Conversion.html#t:ToInRule) [a]

 

[ToInRule](Data-Conversion.html#t:ToInRule) a =\>
[ToInRule](Data-Conversion.html#t:ToInRule) (Maybe a)

 

([ToInRule](Data-Conversion.html#t:ToInRule) t1,
[ToInRule](Data-Conversion.html#t:ToInRule) t2) =\>
[ToInRule](Data-Conversion.html#t:ToInRule) (t1, t2)

 

[ToInRule](Data-Conversion.html#t:ToInRule) a =\>
[ToInRule](Data-Conversion.html#t:ToInRule) (HashMap String a)

 

([ToInRule](Data-Conversion.html#t:ToInRule) k,
[ToInRule](Data-Conversion.html#t:ToInRule) v) =\>
[ToInRule](Data-Conversion.html#t:ToInRule) (HashMap k v)

 

([ToInRule](Data-Conversion.html#t:ToInRule) t1,
[ToInRule](Data-Conversion.html#t:ToInRule) t2,
[ToInRule](Data-Conversion.html#t:ToInRule) t3) =\>
[ToInRule](Data-Conversion.html#t:ToInRule) (t1, t2, t3)

 

([ToInRule](Data-Conversion.html#t:ToInRule) t1,
[ToInRule](Data-Conversion.html#t:ToInRule) t2,
[ToInRule](Data-Conversion.html#t:ToInRule) t3,
[ToInRule](Data-Conversion.html#t:ToInRule) t4) =\>
[ToInRule](Data-Conversion.html#t:ToInRule) (t1, t2, t3, t4)

 

([ToInRule](Data-Conversion.html#t:ToInRule) t1,
[ToInRule](Data-Conversion.html#t:ToInRule) t2,
[ToInRule](Data-Conversion.html#t:ToInRule) t3,
[ToInRule](Data-Conversion.html#t:ToInRule) t4,
[ToInRule](Data-Conversion.html#t:ToInRule) t5) =\>
[ToInRule](Data-Conversion.html#t:ToInRule) (t1, t2, t3, t4, t5)

 

class FromInRule a where

Methods

fromInRule :: [InRule](Data-Conversion.html#t:InRule) -\> a

Instances

[FromInRule](Data-Conversion.html#t:FromInRule) Bool

 

[FromInRule](Data-Conversion.html#t:FromInRule) Double

 

[FromInRule](Data-Conversion.html#t:FromInRule) Float

 

[FromInRule](Data-Conversion.html#t:FromInRule) Int

 

[FromInRule](Data-Conversion.html#t:FromInRule) Int32

 

[FromInRule](Data-Conversion.html#t:FromInRule) Int64

 

[FromInRule](Data-Conversion.html#t:FromInRule) Integer

 

[FromInRule](Data-Conversion.html#t:FromInRule) Rational

 

[FromInRule](Data-Conversion.html#t:FromInRule) Word32

 

[FromInRule](Data-Conversion.html#t:FromInRule) Word64

 

[FromInRule](Data-Conversion.html#t:FromInRule) String

 

[FromInRule](Data-Conversion.html#t:FromInRule)
[SqlValue](Data-SqlTransaction.html#t:SqlValue)

 

[FromInRule](Data-Conversion.html#t:FromInRule) ByteString

 

[FromInRule](Data-Conversion.html#t:FromInRule) Value

 

[FromInRule](Data-Conversion.html#t:FromInRule) ByteString

 

[FromInRule](Data-Conversion.html#t:FromInRule) UTCTime

 

[FromInRule](Data-Conversion.html#t:FromInRule) LocalTime

 

[FromInRule](Data-Conversion.html#t:FromInRule) Day

 

[FromInRule](Data-Conversion.html#t:FromInRule) TimeOfDay

 

[FromInRule](Data-Conversion.html#t:FromInRule)
[Readable](Data-Conversion.html#t:Readable)

Dirty fallback strategy

[FromInRule](Data-Conversion.html#t:FromInRule)
[InRule](Data-Conversion.html#t:InRule)

 

[FromInRule](Data-Conversion.html#t:FromInRule)
[Application](Model-Application.html#t:Application)

 

[FromInRule](Data-Conversion.html#t:FromInRule) a =\>
[FromInRule](Data-Conversion.html#t:FromInRule) [a]

 

[FromInRule](Data-Conversion.html#t:FromInRule) a =\>
[FromInRule](Data-Conversion.html#t:FromInRule) (Maybe a)

 

([FromInRule](Data-Conversion.html#t:FromInRule) t1,
[FromInRule](Data-Conversion.html#t:FromInRule) t2) =\>
[FromInRule](Data-Conversion.html#t:FromInRule) (t1, t2)

 

[FromInRule](Data-Conversion.html#t:FromInRule) a =\>
[FromInRule](Data-Conversion.html#t:FromInRule) (HashMap String a)

 

(Eq k, Hashable k, [FromInRule](Data-Conversion.html#t:FromInRule) k,
[FromInRule](Data-Conversion.html#t:FromInRule) v) =\>
[FromInRule](Data-Conversion.html#t:FromInRule) (HashMap k v)

 

([FromInRule](Data-Conversion.html#t:FromInRule) t1,
[FromInRule](Data-Conversion.html#t:FromInRule) t2,
[FromInRule](Data-Conversion.html#t:FromInRule) t3) =\>
[FromInRule](Data-Conversion.html#t:FromInRule) (t1, t2, t3)

 

([FromInRule](Data-Conversion.html#t:FromInRule) t1,
[FromInRule](Data-Conversion.html#t:FromInRule) t2,
[FromInRule](Data-Conversion.html#t:FromInRule) t3,
[FromInRule](Data-Conversion.html#t:FromInRule) t4) =\>
[FromInRule](Data-Conversion.html#t:FromInRule) (t1, t2, t3, t4)

 

([FromInRule](Data-Conversion.html#t:FromInRule) t1,
[FromInRule](Data-Conversion.html#t:FromInRule) t2,
[FromInRule](Data-Conversion.html#t:FromInRule) t3,
[FromInRule](Data-Conversion.html#t:FromInRule) t4,
[FromInRule](Data-Conversion.html#t:FromInRule) t5) =\>
[FromInRule](Data-Conversion.html#t:FromInRule) (t1, t2, t3, t4, t5)

 

validObject :: [InRule](Data-Conversion.html#t:InRule) -\> Bool

emptyObj :: [InRule](Data-Conversion.html#t:InRule)

singleObj :: [ToInRule](Data-Conversion.html#t:ToInRule) a =\> String
-\> a -\> [InRule](Data-Conversion.html#t:InRule)

Create single InRule object.

fromList :: [ToInRule](Data-Conversion.html#t:ToInRule) a =\> [(String,
a)] -\> [InRule](Data-Conversion.html#t:InRule)

Create InRule object from list.

toList :: [FromInRule](Data-Conversion.html#t:FromInRule) a =\>
[InRule](Data-Conversion.html#t:InRule) -\> [(String, a)]

Create InRule object from list.

toListString :: [InRule](Data-Conversion.html#t:InRule) -\> [(String,
String)]

unionObj :: [InRule](Data-Conversion.html#t:InRule) -\>
[InRule](Data-Conversion.html#t:InRule) -\>
[InRule](Data-Conversion.html#t:InRule)

unionsObj :: [[InRule](Data-Conversion.html#t:InRule)] -\>
[InRule](Data-Conversion.html#t:InRule)

Merge InRule objects from list.

toString :: [InRule](Data-Conversion.html#t:InRule) -\> String

Renders InRule to String.

pprint :: [InRule](Data-Conversion.html#t:InRule) -\> IO ()

Pretty-prints InRule.

pprints :: [[InRule](Data-Conversion.html#t:InRule)] -\> IO ()

Pretty-prints InRules.

object :: [(String, [InRule](Data-Conversion.html#t:InRule))] -\>
[InRule](Data-Conversion.html#t:InRule)

list :: [[InRule](Data-Conversion.html#t:InRule)] -\>
[InRule](Data-Conversion.html#t:InRule)

project :: [InRule](Data-Conversion.html#t:InRule) -\>
[InRule](Data-Conversion.html#t:InRule) -\>
[InRule](Data-Conversion.html#t:InRule)

keyFilter :: (String -\> Bool) -\>
[InRule](Data-Conversion.html#t:InRule) -\>
[InRule](Data-Conversion.html#t:InRule)

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
