===============
Data.Conversion
===============

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Data.Conversion

Description

Tests for some guarantees we want to make about the code.

-  There should be a mapping between the number types
-  A subset of InRule must be isomorphic to Value and Json2, that means,
   we do not lose type information.
-  Different strings types must isomorph

The bijective map of a subset of InRule with Value is:

::


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

-  `(.>) <#v:.-62->`__ :: `InRule <Data-Conversion.html#t:InRule>`__ ->
   String -> Maybe `InRule <Data-Conversion.html#t:InRule>`__
-  `(.>>) <#v:.-62--62->`__ ::
   `InRule <Data-Conversion.html#t:InRule>`__ -> String ->
   [`InRule <Data-Conversion.html#t:InRule>`__\ ]
-  `(==>) <#v:-61--61--62->`__ ::
   `ToInRule <Data-Conversion.html#t:ToInRule>`__ a => String -> a ->
   `InRule <Data-Conversion.html#t:InRule>`__
-  `(..>) <#v:..-62->`__ ::
   `FromInRule <Data-Conversion.html#t:FromInRule>`__ a =>
   `InRule <Data-Conversion.html#t:InRule>`__ -> String -> Maybe a
-  `hmapKeys <#v:hmapKeys>`__ :: (Eq k, Hashable k) => (k1 -> k) ->
   HashMap k1 v -> HashMap k v
-  `hmapWithKey <#v:hmapWithKey>`__ :: (Eq k, Hashable k) => (k -> v1 ->
   v) -> HashMap k v1 -> HashMap k v
-  data `InRule <#t:InRule>`__

   -  = `InString <#v:InString>`__ !String
   -  \| `InByteString <#v:InByteString>`__ !ByteString
   -  \| `InInteger <#v:InInteger>`__ !Integer
   -  \| `InDouble <#v:InDouble>`__ !Double
   -  \| `InNumber <#v:InNumber>`__ !Rational
   -  \| `InBool <#v:InBool>`__ !Bool
   -  \| `InNull <#v:InNull>`__
   -  \| `InArray <#v:InArray>`__
      [`InRule <Data-Conversion.html#t:InRule>`__\ ]
   -  \| `InObject <#v:InObject>`__ (HashMap String
      `InRule <Data-Conversion.html#t:InRule>`__)

-  newtype `Readable <#t:Readable>`__ = `Readable <#v:Readable>`__ {

   -  `unReadable <#v:unReadable>`__ :: String

   }
-  data `InKey <#t:InKey>`__

   -  = `Index <#v:Index>`__ Int
   -  \| `None <#v:None>`__
   -  \| `Assoc <#v:Assoc>`__ String

-  newtype `IdentityMonoid <#t:IdentityMonoid>`__ a = `IM <#v:IM>`__ {

   -  `unIM <#v:unIM>`__ :: a

   }
-  data `PathState <#t:PathState>`__

   -  = `Accept <#v:Accept>`__
   -  \| `Reject <#v:Reject>`__

-  data `PathStep <#t:PathStep>`__ a

   -  = `Next <#v:Next>`__
      (`PathAcceptor <Data-Conversion.html#t:PathAcceptor>`__ a)
   -  \| `Final <#v:Final>`__
      `PathState <Data-Conversion.html#t:PathState>`__

-  newtype `PathAcceptor <#t:PathAcceptor>`__ a = `PM <#v:PM>`__ {

   -  `unPM <#v:unPM>`__ :: a ->
      `PathStep <Data-Conversion.html#t:PathStep>`__ a

   }
-  `accept <#v:accept>`__ ::
   `PathStep <Data-Conversion.html#t:PathStep>`__ a
-  `reject <#v:reject>`__ ::
   `PathStep <Data-Conversion.html#t:PathStep>`__ a
-  `acceptor <#v:acceptor>`__ ::
   `PathAcceptor <Data-Conversion.html#t:PathAcceptor>`__ a
-  `continue <#v:continue>`__ ::
   `PathAcceptor <Data-Conversion.html#t:PathAcceptor>`__ a
-  `alter <#v:alter>`__ ::
   `PathAcceptor <Data-Conversion.html#t:PathAcceptor>`__ a ->
   `PathAcceptor <Data-Conversion.html#t:PathAcceptor>`__ a ->
   `PathAcceptor <Data-Conversion.html#t:PathAcceptor>`__ a
-  `apoint <#v:apoint>`__ :: Eq a => a ->
   `PathAcceptor <Data-Conversion.html#t:PathAcceptor>`__ a
-  `runPath <#v:runPath>`__ :: Eq a =>
   `PathAcceptor <Data-Conversion.html#t:PathAcceptor>`__ a -> [a] ->
   Bool
-  data `KindView <#t:KindView>`__

   -  = `TScalar <#v:TScalar>`__
   -  \| `TArray <#v:TArray>`__
   -  \| `TObject <#v:TObject>`__
   -  \| `TNone <#v:TNone>`__

-  `viewKind <#v:viewKind>`__ ::
   `InRule <Data-Conversion.html#t:InRule>`__ ->
   `KindView <Data-Conversion.html#t:KindView>`__
-  `kmap <#v:kmap>`__ :: (`InKey <Data-Conversion.html#t:InKey>`__ ->
   `InRule <Data-Conversion.html#t:InRule>`__ ->
   `InRule <Data-Conversion.html#t:InRule>`__) ->
   `InRule <Data-Conversion.html#t:InRule>`__ ->
   `InRule <Data-Conversion.html#t:InRule>`__
-  `pmap <#v:pmap>`__ :: (Monoid (f
   `InKey <Data-Conversion.html#t:InKey>`__), Pointed f) => (f
   `InKey <Data-Conversion.html#t:InKey>`__ ->
   `InRule <Data-Conversion.html#t:InRule>`__ ->
   `InRule <Data-Conversion.html#t:InRule>`__) ->
   `InRule <Data-Conversion.html#t:InRule>`__ ->
   `InRule <Data-Conversion.html#t:InRule>`__
-  `pfold <#v:pfold>`__ :: (Monoid (f
   `InKey <Data-Conversion.html#t:InKey>`__), Pointed f) => (f
   `InKey <Data-Conversion.html#t:InKey>`__ ->
   `InRule <Data-Conversion.html#t:InRule>`__ -> b -> b) ->
   `InRule <Data-Conversion.html#t:InRule>`__ -> b -> b
-  `kfold <#v:kfold>`__ :: (`InKey <Data-Conversion.html#t:InKey>`__ ->
   `InRule <Data-Conversion.html#t:InRule>`__ -> b -> b) ->
   `InRule <Data-Conversion.html#t:InRule>`__ -> b -> b
-  `readable <#v:readable>`__ :: String ->
   `Readable <Data-Conversion.html#t:Readable>`__
-  `viaReadable <#v:viaReadable>`__ :: Read a =>
   `InRule <Data-Conversion.html#t:InRule>`__ -> a
-  `asReadable <#v:asReadable>`__ ::
   `InRule <Data-Conversion.html#t:InRule>`__ ->
   `Readable <Data-Conversion.html#t:Readable>`__
-  class `ToInRule <#t:ToInRule>`__ a where

   -  `toInRule <#v:toInRule>`__ :: a ->
      `InRule <Data-Conversion.html#t:InRule>`__

-  class `FromInRule <#t:FromInRule>`__ a where

   -  `fromInRule <#v:fromInRule>`__ ::
      `InRule <Data-Conversion.html#t:InRule>`__ -> a

-  `validObject <#v:validObject>`__ ::
   `InRule <Data-Conversion.html#t:InRule>`__ -> Bool
-  `emptyObj <#v:emptyObj>`__ ::
   `InRule <Data-Conversion.html#t:InRule>`__
-  `singleObj <#v:singleObj>`__ ::
   `ToInRule <Data-Conversion.html#t:ToInRule>`__ a => String -> a ->
   `InRule <Data-Conversion.html#t:InRule>`__
-  `fromList <#v:fromList>`__ ::
   `ToInRule <Data-Conversion.html#t:ToInRule>`__ a => [(String, a)] ->
   `InRule <Data-Conversion.html#t:InRule>`__
-  `toList <#v:toList>`__ ::
   `FromInRule <Data-Conversion.html#t:FromInRule>`__ a =>
   `InRule <Data-Conversion.html#t:InRule>`__ -> [(String, a)]
-  `toListString <#v:toListString>`__ ::
   `InRule <Data-Conversion.html#t:InRule>`__ -> [(String, String)]
-  `unionObj <#v:unionObj>`__ ::
   `InRule <Data-Conversion.html#t:InRule>`__ ->
   `InRule <Data-Conversion.html#t:InRule>`__ ->
   `InRule <Data-Conversion.html#t:InRule>`__
-  `unionsObj <#v:unionsObj>`__ ::
   [`InRule <Data-Conversion.html#t:InRule>`__\ ] ->
   `InRule <Data-Conversion.html#t:InRule>`__
-  `toString <#v:toString>`__ ::
   `InRule <Data-Conversion.html#t:InRule>`__ -> String
-  `pprint <#v:pprint>`__ :: `InRule <Data-Conversion.html#t:InRule>`__
   -> IO ()
-  `pprints <#v:pprints>`__ ::
   [`InRule <Data-Conversion.html#t:InRule>`__\ ] -> IO ()
-  `object <#v:object>`__ :: [(String,
   `InRule <Data-Conversion.html#t:InRule>`__)] ->
   `InRule <Data-Conversion.html#t:InRule>`__
-  `list <#v:list>`__ :: [`InRule <Data-Conversion.html#t:InRule>`__\ ]
   -> `InRule <Data-Conversion.html#t:InRule>`__
-  `project <#v:project>`__ ::
   `InRule <Data-Conversion.html#t:InRule>`__ ->
   `InRule <Data-Conversion.html#t:InRule>`__ ->
   `InRule <Data-Conversion.html#t:InRule>`__
-  `keyFilter <#v:keyFilter>`__ :: (String -> Bool) ->
   `InRule <Data-Conversion.html#t:InRule>`__ ->
   `InRule <Data-Conversion.html#t:InRule>`__

Documentation
=============

(.>) :: `InRule <Data-Conversion.html#t:InRule>`__ -> String -> Maybe
`InRule <Data-Conversion.html#t:InRule>`__

Find top level matching keyword

(.>>) :: `InRule <Data-Conversion.html#t:InRule>`__ -> String ->
[`InRule <Data-Conversion.html#t:InRule>`__\ ]

Search all occuring keywords recursively

(==>) :: `ToInRule <Data-Conversion.html#t:ToInRule>`__ a => String -> a
-> `InRule <Data-Conversion.html#t:InRule>`__

``(==>``) Eq ``singleObj`` .

(..>) :: `FromInRule <Data-Conversion.html#t:FromInRule>`__ a =>
`InRule <Data-Conversion.html#t:InRule>`__ -> String -> Maybe a

Find top level value and convert to normal value

hmapKeys :: (Eq k, Hashable k) => (k1 -> k) -> HashMap k1 v -> HashMap k
v

Map all the hash map keys

hmapWithKey :: (Eq k, Hashable k) => (k -> v1 -> v) -> HashMap k v1 ->
HashMap k v

Map over all the hash map values with a key

data InRule

Primitive type, a subset of this type is isomorph to json and yaml

Constructors

+------------------------------------------------------------------------+-----+
| InString !String                                                       |     |
+------------------------------------------------------------------------+-----+
| InByteString !ByteString                                               |     |
+------------------------------------------------------------------------+-----+
| InInteger !Integer                                                     |     |
+------------------------------------------------------------------------+-----+
| InDouble !Double                                                       |     |
+------------------------------------------------------------------------+-----+
| InNumber !Rational                                                     |     |
+------------------------------------------------------------------------+-----+
| InBool !Bool                                                           |     |
+------------------------------------------------------------------------+-----+
| InNull                                                                 |     |
+------------------------------------------------------------------------+-----+
| InArray [`InRule <Data-Conversion.html#t:InRule>`__\ ]                 |     |
+------------------------------------------------------------------------+-----+
| InObject (HashMap String `InRule <Data-Conversion.html#t:InRule>`__)   |     |
+------------------------------------------------------------------------+-----+

Instances

+--------------------------------------------------------------------------------------------------------------------+-----+
| Eq `InRule <Data-Conversion.html#t:InRule>`__                                                                      |     |
+--------------------------------------------------------------------------------------------------------------------+-----+
| Show `InRule <Data-Conversion.html#t:InRule>`__                                                                    |     |
+--------------------------------------------------------------------------------------------------------------------+-----+
| IsString `InRule <Data-Conversion.html#t:InRule>`__                                                                |     |
+--------------------------------------------------------------------------------------------------------------------+-----+
| Monoid `InRule <Data-Conversion.html#t:InRule>`__                                                                  |     |
+--------------------------------------------------------------------------------------------------------------------+-----+
| Serialize `InRule <Data-Conversion.html#t:InRule>`__                                                               |     |
+--------------------------------------------------------------------------------------------------------------------+-----+
| Arbitrary `InRule <Data-Conversion.html#t:InRule>`__                                                               |     |
+--------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-Conversion.html#t:FromInRule>`__ `InRule <Data-Conversion.html#t:InRule>`__                      |     |
+--------------------------------------------------------------------------------------------------------------------+-----+
| `ToInRule <Data-Conversion.html#t:ToInRule>`__ `InRule <Data-Conversion.html#t:InRule>`__                          |     |
+--------------------------------------------------------------------------------------------------------------------+-----+
| Binary `InRule <Data-Conversion.html#t:InRule>`__                                                                  |     |
+--------------------------------------------------------------------------------------------------------------------+-----+
| `StringLike <Data-Tools.html#t:StringLike>`__ `InRule <Data-Conversion.html#t:InRule>`__                           |     |
+--------------------------------------------------------------------------------------------------------------------+-----+
| `ToInRule <Data-Conversion.html#t:ToInRule>`__ b => Convertible b `InRule <Data-Conversion.html#t:InRule>`__       |     |
+--------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-Conversion.html#t:FromInRule>`__ b => Convertible `InRule <Data-Conversion.html#t:InRule>`__ b   |     |
+--------------------------------------------------------------------------------------------------------------------+-----+

newtype Readable

Constructors

Readable

 

Fields

unReadable :: String
     

Instances

Show `Readable <Data-Conversion.html#t:Readable>`__

 

`FromInRule <Data-Conversion.html#t:FromInRule>`__
`Readable <Data-Conversion.html#t:Readable>`__

Dirty fallback strategy

Read a => Convertible `Readable <Data-Conversion.html#t:Readable>`__ a

 

data InKey

Data type used for viewing the type of a index

Constructors

+----------------+-----+
| Index Int      |     |
+----------------+-----+
| None           |     |
+----------------+-----+
| Assoc String   |     |
+----------------+-----+

Instances

+---------------------------------------------------+-----+
| Show `InKey <Data-Conversion.html#t:InKey>`__     |     |
+---------------------------------------------------+-----+
| Monoid `InKey <Data-Conversion.html#t:InKey>`__   |     |
+---------------------------------------------------+-----+

newtype IdentityMonoid a

Identity monoid, doesn't exist in prelude or anywhere else

Constructors

IM

 

Fields

unIM :: a
     

Instances

+-------------------------------------------------------------------------------------+-----+
| Functor `IdentityMonoid <Data-Conversion.html#t:IdentityMonoid>`__                  |     |
+-------------------------------------------------------------------------------------+-----+
| Pointed `IdentityMonoid <Data-Conversion.html#t:IdentityMonoid>`__                  |     |
+-------------------------------------------------------------------------------------+-----+
| Copointed `IdentityMonoid <Data-Conversion.html#t:IdentityMonoid>`__                |     |
+-------------------------------------------------------------------------------------+-----+
| Monoid a => Monoid (`IdentityMonoid <Data-Conversion.html#t:IdentityMonoid>`__ a)   |     |
+-------------------------------------------------------------------------------------+-----+

data PathState

Simple automaton for rejecting or accepting paths

Constructors

+----------+-----+
| Accept   |     |
+----------+-----+
| Reject   |     |
+----------+-----+

Instances

+---------------------------------------------------------+-----+
| Show `PathState <Data-Conversion.html#t:PathState>`__   |     |
+---------------------------------------------------------+-----+

data PathStep a

One step of the automata. Automata can be in two states: \| next step or
final path

Constructors

+-------------------------------------------------------------------+-----+
| Next (`PathAcceptor <Data-Conversion.html#t:PathAcceptor>`__ a)   |     |
+-------------------------------------------------------------------+-----+
| Final `PathState <Data-Conversion.html#t:PathState>`__            |     |
+-------------------------------------------------------------------+-----+

newtype PathAcceptor a

One machine step

Constructors

PM

 

Fields

unPM :: a -> `PathStep <Data-Conversion.html#t:PathStep>`__ a
     

Instances

Semigroup (`PathAcceptor <Data-Conversion.html#t:PathAcceptor>`__ a)

Path acceptor is a semigroup and acts semantically like a and operator

accept :: `PathStep <Data-Conversion.html#t:PathStep>`__ a

The always acceptor

reject :: `PathStep <Data-Conversion.html#t:PathStep>`__ a

The always rejector

acceptor :: `PathAcceptor <Data-Conversion.html#t:PathAcceptor>`__ a

Always accept the input

continue :: `PathAcceptor <Data-Conversion.html#t:PathAcceptor>`__ a

Always accept the complete input stream (will always be false for finite
streams and true for infinite ones)

alter :: `PathAcceptor <Data-Conversion.html#t:PathAcceptor>`__ a ->
`PathAcceptor <Data-Conversion.html#t:PathAcceptor>`__ a ->
`PathAcceptor <Data-Conversion.html#t:PathAcceptor>`__ a

Alternate two acceptors. If the first rejects try the next. Behaves like
an or \| operator

apoint :: Eq a => a ->
`PathAcceptor <Data-Conversion.html#t:PathAcceptor>`__ a

Creates a pointed acceptor

runPath :: Eq a =>
`PathAcceptor <Data-Conversion.html#t:PathAcceptor>`__ a -> [a] -> Bool

data KindView

View the kind of a InRule

Constructors

+-----------+-----+
| TScalar   |     |
+-----------+-----+
| TArray    |     |
+-----------+-----+
| TObject   |     |
+-----------+-----+
| TNone     |     |
+-----------+-----+

Instances

+-------------------------------------------------------+-----+
| Eq `KindView <Data-Conversion.html#t:KindView>`__     |     |
+-------------------------------------------------------+-----+
| Show `KindView <Data-Conversion.html#t:KindView>`__   |     |
+-------------------------------------------------------+-----+

viewKind :: `InRule <Data-Conversion.html#t:InRule>`__ ->
`KindView <Data-Conversion.html#t:KindView>`__

kmap :: (`InKey <Data-Conversion.html#t:InKey>`__ ->
`InRule <Data-Conversion.html#t:InRule>`__ ->
`InRule <Data-Conversion.html#t:InRule>`__) ->
`InRule <Data-Conversion.html#t:InRule>`__ ->
`InRule <Data-Conversion.html#t:InRule>`__

Maps through the structure

pmap :: (Monoid (f `InKey <Data-Conversion.html#t:InKey>`__), Pointed f)
=> (f `InKey <Data-Conversion.html#t:InKey>`__ ->
`InRule <Data-Conversion.html#t:InRule>`__ ->
`InRule <Data-Conversion.html#t:InRule>`__) ->
`InRule <Data-Conversion.html#t:InRule>`__ ->
`InRule <Data-Conversion.html#t:InRule>`__

Maps trough the structure with a history of the path kept in a monoid

pfold :: (Monoid (f `InKey <Data-Conversion.html#t:InKey>`__), Pointed
f) => (f `InKey <Data-Conversion.html#t:InKey>`__ ->
`InRule <Data-Conversion.html#t:InRule>`__ -> b -> b) ->
`InRule <Data-Conversion.html#t:InRule>`__ -> b -> b

Fold trough a structure with a history of the path kept in a monoid

kfold :: (`InKey <Data-Conversion.html#t:InKey>`__ ->
`InRule <Data-Conversion.html#t:InRule>`__ -> b -> b) ->
`InRule <Data-Conversion.html#t:InRule>`__ -> b -> b

Fold through the structure

readable :: String -> `Readable <Data-Conversion.html#t:Readable>`__

Transform a string into a readable

viaReadable :: Read a => `InRule <Data-Conversion.html#t:InRule>`__ -> a

asReadable :: `InRule <Data-Conversion.html#t:InRule>`__ ->
`Readable <Data-Conversion.html#t:Readable>`__

class ToInRule a where

Methods

toInRule :: a -> `InRule <Data-Conversion.html#t:InRule>`__

Instances

`ToInRule <Data-Conversion.html#t:ToInRule>`__ Bool

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__ Char

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__ Double

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__ Float

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__ Int

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__ Int32

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__ Int64

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__ Integer

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__ Rational

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__ Word32

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__ Word64

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__ String

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__ ()

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__
`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__

Renders InRule to String.

`ToInRule <Data-Conversion.html#t:ToInRule>`__ ByteString

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__ Value

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__ ByteString

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__ UTCTime

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__ LocalTime

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__ Day

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__ TimeOfDay

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__
`InRule <Data-Conversion.html#t:InRule>`__

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__
`Application <Model-Application.html#t:Application>`__

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__ a =>
`ToInRule <Data-Conversion.html#t:ToInRule>`__ [a]

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__ a =>
`ToInRule <Data-Conversion.html#t:ToInRule>`__ (Maybe a)

 

(`ToInRule <Data-Conversion.html#t:ToInRule>`__ t1,
`ToInRule <Data-Conversion.html#t:ToInRule>`__ t2) =>
`ToInRule <Data-Conversion.html#t:ToInRule>`__ (t1, t2)

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__ a =>
`ToInRule <Data-Conversion.html#t:ToInRule>`__ (HashMap String a)

 

(`ToInRule <Data-Conversion.html#t:ToInRule>`__ k,
`ToInRule <Data-Conversion.html#t:ToInRule>`__ v) =>
`ToInRule <Data-Conversion.html#t:ToInRule>`__ (HashMap k v)

 

(`ToInRule <Data-Conversion.html#t:ToInRule>`__ t1,
`ToInRule <Data-Conversion.html#t:ToInRule>`__ t2,
`ToInRule <Data-Conversion.html#t:ToInRule>`__ t3) =>
`ToInRule <Data-Conversion.html#t:ToInRule>`__ (t1, t2, t3)

 

(`ToInRule <Data-Conversion.html#t:ToInRule>`__ t1,
`ToInRule <Data-Conversion.html#t:ToInRule>`__ t2,
`ToInRule <Data-Conversion.html#t:ToInRule>`__ t3,
`ToInRule <Data-Conversion.html#t:ToInRule>`__ t4) =>
`ToInRule <Data-Conversion.html#t:ToInRule>`__ (t1, t2, t3, t4)

 

(`ToInRule <Data-Conversion.html#t:ToInRule>`__ t1,
`ToInRule <Data-Conversion.html#t:ToInRule>`__ t2,
`ToInRule <Data-Conversion.html#t:ToInRule>`__ t3,
`ToInRule <Data-Conversion.html#t:ToInRule>`__ t4,
`ToInRule <Data-Conversion.html#t:ToInRule>`__ t5) =>
`ToInRule <Data-Conversion.html#t:ToInRule>`__ (t1, t2, t3, t4, t5)

 

class FromInRule a where

Methods

fromInRule :: `InRule <Data-Conversion.html#t:InRule>`__ -> a

Instances

`FromInRule <Data-Conversion.html#t:FromInRule>`__ Bool

 

`FromInRule <Data-Conversion.html#t:FromInRule>`__ Double

 

`FromInRule <Data-Conversion.html#t:FromInRule>`__ Float

 

`FromInRule <Data-Conversion.html#t:FromInRule>`__ Int

 

`FromInRule <Data-Conversion.html#t:FromInRule>`__ Int32

 

`FromInRule <Data-Conversion.html#t:FromInRule>`__ Int64

 

`FromInRule <Data-Conversion.html#t:FromInRule>`__ Integer

 

`FromInRule <Data-Conversion.html#t:FromInRule>`__ Rational

 

`FromInRule <Data-Conversion.html#t:FromInRule>`__ Word32

 

`FromInRule <Data-Conversion.html#t:FromInRule>`__ Word64

 

`FromInRule <Data-Conversion.html#t:FromInRule>`__ String

 

`FromInRule <Data-Conversion.html#t:FromInRule>`__
`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__

 

`FromInRule <Data-Conversion.html#t:FromInRule>`__ ByteString

 

`FromInRule <Data-Conversion.html#t:FromInRule>`__ Value

 

`FromInRule <Data-Conversion.html#t:FromInRule>`__ ByteString

 

`FromInRule <Data-Conversion.html#t:FromInRule>`__ UTCTime

 

`FromInRule <Data-Conversion.html#t:FromInRule>`__ LocalTime

 

`FromInRule <Data-Conversion.html#t:FromInRule>`__ Day

 

`FromInRule <Data-Conversion.html#t:FromInRule>`__ TimeOfDay

 

`FromInRule <Data-Conversion.html#t:FromInRule>`__
`Readable <Data-Conversion.html#t:Readable>`__

Dirty fallback strategy

`FromInRule <Data-Conversion.html#t:FromInRule>`__
`InRule <Data-Conversion.html#t:InRule>`__

 

`FromInRule <Data-Conversion.html#t:FromInRule>`__
`Application <Model-Application.html#t:Application>`__

 

`FromInRule <Data-Conversion.html#t:FromInRule>`__ a =>
`FromInRule <Data-Conversion.html#t:FromInRule>`__ [a]

 

`FromInRule <Data-Conversion.html#t:FromInRule>`__ a =>
`FromInRule <Data-Conversion.html#t:FromInRule>`__ (Maybe a)

 

(`FromInRule <Data-Conversion.html#t:FromInRule>`__ t1,
`FromInRule <Data-Conversion.html#t:FromInRule>`__ t2) =>
`FromInRule <Data-Conversion.html#t:FromInRule>`__ (t1, t2)

 

`FromInRule <Data-Conversion.html#t:FromInRule>`__ a =>
`FromInRule <Data-Conversion.html#t:FromInRule>`__ (HashMap String a)

 

(Eq k, Hashable k, `FromInRule <Data-Conversion.html#t:FromInRule>`__ k,
`FromInRule <Data-Conversion.html#t:FromInRule>`__ v) =>
`FromInRule <Data-Conversion.html#t:FromInRule>`__ (HashMap k v)

 

(`FromInRule <Data-Conversion.html#t:FromInRule>`__ t1,
`FromInRule <Data-Conversion.html#t:FromInRule>`__ t2,
`FromInRule <Data-Conversion.html#t:FromInRule>`__ t3) =>
`FromInRule <Data-Conversion.html#t:FromInRule>`__ (t1, t2, t3)

 

(`FromInRule <Data-Conversion.html#t:FromInRule>`__ t1,
`FromInRule <Data-Conversion.html#t:FromInRule>`__ t2,
`FromInRule <Data-Conversion.html#t:FromInRule>`__ t3,
`FromInRule <Data-Conversion.html#t:FromInRule>`__ t4) =>
`FromInRule <Data-Conversion.html#t:FromInRule>`__ (t1, t2, t3, t4)

 

(`FromInRule <Data-Conversion.html#t:FromInRule>`__ t1,
`FromInRule <Data-Conversion.html#t:FromInRule>`__ t2,
`FromInRule <Data-Conversion.html#t:FromInRule>`__ t3,
`FromInRule <Data-Conversion.html#t:FromInRule>`__ t4,
`FromInRule <Data-Conversion.html#t:FromInRule>`__ t5) =>
`FromInRule <Data-Conversion.html#t:FromInRule>`__ (t1, t2, t3, t4, t5)

 

validObject :: `InRule <Data-Conversion.html#t:InRule>`__ -> Bool

emptyObj :: `InRule <Data-Conversion.html#t:InRule>`__

singleObj :: `ToInRule <Data-Conversion.html#t:ToInRule>`__ a => String
-> a -> `InRule <Data-Conversion.html#t:InRule>`__

Create single InRule object.

fromList :: `ToInRule <Data-Conversion.html#t:ToInRule>`__ a =>
[(String, a)] -> `InRule <Data-Conversion.html#t:InRule>`__

Create InRule object from list.

toList :: `FromInRule <Data-Conversion.html#t:FromInRule>`__ a =>
`InRule <Data-Conversion.html#t:InRule>`__ -> [(String, a)]

Create InRule object from list.

toListString :: `InRule <Data-Conversion.html#t:InRule>`__ -> [(String,
String)]

unionObj :: `InRule <Data-Conversion.html#t:InRule>`__ ->
`InRule <Data-Conversion.html#t:InRule>`__ ->
`InRule <Data-Conversion.html#t:InRule>`__

unionsObj :: [`InRule <Data-Conversion.html#t:InRule>`__\ ] ->
`InRule <Data-Conversion.html#t:InRule>`__

Merge InRule objects from list.

toString :: `InRule <Data-Conversion.html#t:InRule>`__ -> String

Renders InRule to String.

pprint :: `InRule <Data-Conversion.html#t:InRule>`__ -> IO ()

Pretty-prints InRule.

pprints :: [`InRule <Data-Conversion.html#t:InRule>`__\ ] -> IO ()

Pretty-prints InRules.

object :: [(String, `InRule <Data-Conversion.html#t:InRule>`__)] ->
`InRule <Data-Conversion.html#t:InRule>`__

list :: [`InRule <Data-Conversion.html#t:InRule>`__\ ] ->
`InRule <Data-Conversion.html#t:InRule>`__

project :: `InRule <Data-Conversion.html#t:InRule>`__ ->
`InRule <Data-Conversion.html#t:InRule>`__ ->
`InRule <Data-Conversion.html#t:InRule>`__

keyFilter :: (String -> Bool) ->
`InRule <Data-Conversion.html#t:InRule>`__ ->
`InRule <Data-Conversion.html#t:InRule>`__

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
