============
Data.InRules
============

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Data.InRules

Contents

-  `Data types and classes <#g:1>`__
-  `Pretty print <#g:2>`__

Description

This module implements a dynamic type system

Synopsis

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
      [`InRule <Data-InRules.html#t:InRule>`__\ ]
   -  \| `InObject <#v:InObject>`__ (HashMap String
      `InRule <Data-InRules.html#t:InRule>`__)

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
      (`PathAcceptor <Data-InRules.html#t:PathAcceptor>`__ a)
   -  \| `Final <#v:Final>`__
      `PathState <Data-InRules.html#t:PathState>`__

-  newtype `PathAcceptor <#t:PathAcceptor>`__ a = `PM <#v:PM>`__ {

   -  `unPM <#v:unPM>`__ :: a ->
      `PathStep <Data-InRules.html#t:PathStep>`__ a

   }
-  `accept <#v:accept>`__ :: `PathStep <Data-InRules.html#t:PathStep>`__
   a
-  `reject <#v:reject>`__ :: `PathStep <Data-InRules.html#t:PathStep>`__
   a
-  `acceptor <#v:acceptor>`__ ::
   `PathAcceptor <Data-InRules.html#t:PathAcceptor>`__ a
-  `rejector <#v:rejector>`__ ::
   `PathAcceptor <Data-InRules.html#t:PathAcceptor>`__ a
-  `continue <#v:continue>`__ ::
   `PathAcceptor <Data-InRules.html#t:PathAcceptor>`__ a
-  `alter <#v:alter>`__ ::
   `PathAcceptor <Data-InRules.html#t:PathAcceptor>`__ a ->
   `PathAcceptor <Data-InRules.html#t:PathAcceptor>`__ a ->
   `PathAcceptor <Data-InRules.html#t:PathAcceptor>`__ a
-  `apoint <#v:apoint>`__ :: Eq a => a ->
   `PathAcceptor <Data-InRules.html#t:PathAcceptor>`__ a
-  `runPath <#v:runPath>`__ :: Eq a =>
   `PathAcceptor <Data-InRules.html#t:PathAcceptor>`__ a -> [a] -> Bool
-  data `KindView <#t:KindView>`__

   -  = `TScalar <#v:TScalar>`__
   -  \| `TArray <#v:TArray>`__
   -  \| `TObject <#v:TObject>`__
   -  \| `TNone <#v:TNone>`__

-  `viewKind <#v:viewKind>`__ :: `InRule <Data-InRules.html#t:InRule>`__
   -> `KindView <Data-InRules.html#t:KindView>`__
-  `kmap <#v:kmap>`__ :: (`InKey <Data-InRules.html#t:InKey>`__ ->
   `InRule <Data-InRules.html#t:InRule>`__ ->
   `InRule <Data-InRules.html#t:InRule>`__) ->
   `InRule <Data-InRules.html#t:InRule>`__ ->
   `InRule <Data-InRules.html#t:InRule>`__
-  `pmap <#v:pmap>`__ :: (Monoid (f
   `InKey <Data-InRules.html#t:InKey>`__), Pointed f) => (f
   `InKey <Data-InRules.html#t:InKey>`__ ->
   `InRule <Data-InRules.html#t:InRule>`__ ->
   `InRule <Data-InRules.html#t:InRule>`__) ->
   `InRule <Data-InRules.html#t:InRule>`__ ->
   `InRule <Data-InRules.html#t:InRule>`__
-  `pfold <#v:pfold>`__ :: (Monoid (f
   `InKey <Data-InRules.html#t:InKey>`__), Pointed f) => (f
   `InKey <Data-InRules.html#t:InKey>`__ ->
   `InRule <Data-InRules.html#t:InRule>`__ -> b -> b) ->
   `InRule <Data-InRules.html#t:InRule>`__ -> b -> b
-  `longest\_path <#v:longest_path>`__ ::
   `InRule <Data-InRules.html#t:InRule>`__ -> Int
-  `ckey <#v:ckey>`__ :: Num a =>
   [`InKey <Data-InRules.html#t:InKey>`__\ ] -> a
-  `kfold <#v:kfold>`__ :: (`InKey <Data-InRules.html#t:InKey>`__ ->
   `InRule <Data-InRules.html#t:InRule>`__ -> b -> b) ->
   `InRule <Data-InRules.html#t:InRule>`__ -> b -> b
-  `(.>) <#v:.-62->`__ :: `InRule <Data-InRules.html#t:InRule>`__ ->
   String -> Maybe `InRule <Data-InRules.html#t:InRule>`__
-  `(..>) <#v:..-62->`__ ::
   `FromInRule <Data-InRules.html#t:FromInRule>`__ a =>
   `InRule <Data-InRules.html#t:InRule>`__ -> String -> Maybe a
-  `(.>>) <#v:.-62--62->`__ :: `InRule <Data-InRules.html#t:InRule>`__
   -> String -> [`InRule <Data-InRules.html#t:InRule>`__\ ]
-  `readable <#v:readable>`__ :: String ->
   `Readable <Data-InRules.html#t:Readable>`__
-  `viaReadable <#v:viaReadable>`__ :: Read a =>
   `InRule <Data-InRules.html#t:InRule>`__ -> a
-  `asReadable <#v:asReadable>`__ ::
   `InRule <Data-InRules.html#t:InRule>`__ ->
   `Readable <Data-InRules.html#t:Readable>`__
-  type `InRules <#t:InRules>`__ =
   [`InRule <Data-InRules.html#t:InRule>`__\ ]
-  class `ToInRule <#t:ToInRule>`__ a where

   -  `toInRule <#v:toInRule>`__ :: a ->
      `InRule <Data-InRules.html#t:InRule>`__

-  class `FromInRule <#t:FromInRule>`__ a where

   -  `fromInRule <#v:fromInRule>`__ ::
      `InRule <Data-InRules.html#t:InRule>`__ -> a

-  `toCompatible <#v:toCompatible>`__ ::
   `InRule <Data-InRules.html#t:InRule>`__ ->
   `InRule <Data-InRules.html#t:InRule>`__
-  `validObject <#v:validObject>`__ ::
   `InRule <Data-InRules.html#t:InRule>`__ -> Bool
-  `emptyObj <#v:emptyObj>`__ :: `InRule <Data-InRules.html#t:InRule>`__
-  `object <#v:object>`__ :: [(String,
   `InRule <Data-InRules.html#t:InRule>`__)] ->
   `InRule <Data-InRules.html#t:InRule>`__
-  `list <#v:list>`__ :: [`InRule <Data-InRules.html#t:InRule>`__\ ] ->
   `InRule <Data-InRules.html#t:InRule>`__
-  `project <#v:project>`__ :: `InRule <Data-InRules.html#t:InRule>`__
   -> `InRule <Data-InRules.html#t:InRule>`__ ->
   `InRule <Data-InRules.html#t:InRule>`__
-  `mapWithKey <#v:mapWithKey>`__ :: (k -> a -> b) -> HashMap k a ->
   HashMap k b
-  `arrayToObj <#v:arrayToObj>`__ ::
   `InRule <Data-InRules.html#t:InRule>`__ ->
   `InRule <Data-InRules.html#t:InRule>`__
-  `shp <#v:shp>`__ :: `InRule <Data-InRules.html#t:InRule>`__ ->
   `InRule <Data-InRules.html#t:InRule>`__ -> Bool
-  `shpTestAB <#v:shpTestAB>`__ :: Bool
-  `shpTestArr <#v:shpTestArr>`__ :: Bool
-  `singleObj <#v:singleObj>`__ ::
   `ToInRule <Data-InRules.html#t:ToInRule>`__ a => String -> a ->
   `InRule <Data-InRules.html#t:InRule>`__
-  `(==>) <#v:-61--61--62->`__ ::
   `ToInRule <Data-InRules.html#t:ToInRule>`__ a => String -> a ->
   `InRule <Data-InRules.html#t:InRule>`__
-  `orM <#v:orM>`__ :: Maybe a -> a -> Maybe a
-  `withDefault <#v:withDefault>`__ :: a -> Maybe a -> Maybe a
-  `fromList <#v:fromList>`__ ::
   `ToInRule <Data-InRules.html#t:ToInRule>`__ a => [(String, a)] ->
   `InRule <Data-InRules.html#t:InRule>`__
-  `toList <#v:toList>`__ ::
   `FromInRule <Data-InRules.html#t:FromInRule>`__ a =>
   `InRule <Data-InRules.html#t:InRule>`__ -> [(String, a)]
-  `toListString <#v:toListString>`__ ::
   `InRule <Data-InRules.html#t:InRule>`__ -> [(String, String)]
-  `unionObj <#v:unionObj>`__ :: `InRule <Data-InRules.html#t:InRule>`__
   -> `InRule <Data-InRules.html#t:InRule>`__ ->
   `InRule <Data-InRules.html#t:InRule>`__
-  `unionsObj <#v:unionsObj>`__ ::
   [`InRule <Data-InRules.html#t:InRule>`__\ ] ->
   `InRule <Data-InRules.html#t:InRule>`__
-  `unionRecObj <#v:unionRecObj>`__ ::
   `InRule <Data-InRules.html#t:InRule>`__ ->
   `InRule <Data-InRules.html#t:InRule>`__ ->
   `InRule <Data-InRules.html#t:InRule>`__
-  `toString <#v:toString>`__ :: `InRule <Data-InRules.html#t:InRule>`__
   -> String
-  `pprint <#v:pprint>`__ :: `InRule <Data-InRules.html#t:InRule>`__ ->
   IO ()
-  `pprint' <#v:pprint-39->`__ :: String -> Integer ->
   `InRule <Data-InRules.html#t:InRule>`__ -> String
-  `pprints <#v:pprints>`__ ::
   [`InRule <Data-InRules.html#t:InRule>`__\ ] -> IO ()
-  `escInStr <#v:escInStr>`__ :: String -> String
-  `escInChar <#v:escInChar>`__ :: Char -> String

Documentation
=============

hmapKeys :: (Eq k, Hashable k) => (k1 -> k) -> HashMap k1 v -> HashMap k
v

Map all the hash map keys

hmapWithKey :: (Eq k, Hashable k) => (k -> v1 -> v) -> HashMap k v1 ->
HashMap k v

Map over all the hash map values with a key

Data types and classes
======================

data InRule

Primitive type, a subset of this type is isomorph to json and yaml

Constructors

+---------------------------------------------------------------------+-----+
| InString !String                                                    |     |
+---------------------------------------------------------------------+-----+
| InByteString !ByteString                                            |     |
+---------------------------------------------------------------------+-----+
| InInteger !Integer                                                  |     |
+---------------------------------------------------------------------+-----+
| InDouble !Double                                                    |     |
+---------------------------------------------------------------------+-----+
| InNumber !Rational                                                  |     |
+---------------------------------------------------------------------+-----+
| InBool !Bool                                                        |     |
+---------------------------------------------------------------------+-----+
| InNull                                                              |     |
+---------------------------------------------------------------------+-----+
| InArray [`InRule <Data-InRules.html#t:InRule>`__\ ]                 |     |
+---------------------------------------------------------------------+-----+
| InObject (HashMap String `InRule <Data-InRules.html#t:InRule>`__)   |     |
+---------------------------------------------------------------------+-----+

Instances

+--------------------------------------------------------------------------------------------------------------+-----+
| Eq `InRule <Data-InRules.html#t:InRule>`__                                                                   |     |
+--------------------------------------------------------------------------------------------------------------+-----+
| Show `InRule <Data-InRules.html#t:InRule>`__                                                                 |     |
+--------------------------------------------------------------------------------------------------------------+-----+
| IsString `InRule <Data-InRules.html#t:InRule>`__                                                             |     |
+--------------------------------------------------------------------------------------------------------------+-----+
| Monoid `InRule <Data-InRules.html#t:InRule>`__                                                               |     |
+--------------------------------------------------------------------------------------------------------------+-----+
| Binary `InRule <Data-InRules.html#t:InRule>`__                                                               |     |
+--------------------------------------------------------------------------------------------------------------+-----+
| Arbitrary `InRule <Data-InRules.html#t:InRule>`__                                                            |     |
+--------------------------------------------------------------------------------------------------------------+-----+
| Serialize `InRule <Data-InRules.html#t:InRule>`__                                                            |     |
+--------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-InRules.html#t:FromInRule>`__ `InRule <Data-InRules.html#t:InRule>`__                      |     |
+--------------------------------------------------------------------------------------------------------------+-----+
| `ToInRule <Data-InRules.html#t:ToInRule>`__ `InRule <Data-InRules.html#t:InRule>`__                          |     |
+--------------------------------------------------------------------------------------------------------------+-----+
| `StringLike <Data-Tools.html#t:StringLike>`__ `InRule <Data-InRules.html#t:InRule>`__                        |     |
+--------------------------------------------------------------------------------------------------------------+-----+
| `ToInRule <Data-InRules.html#t:ToInRule>`__ b => Convertible b `InRule <Data-InRules.html#t:InRule>`__       |     |
+--------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-InRules.html#t:FromInRule>`__ b => Convertible `InRule <Data-InRules.html#t:InRule>`__ b   |     |
+--------------------------------------------------------------------------------------------------------------+-----+

newtype Readable

Constructors

Readable

 

Fields

unReadable :: String
     

Instances

Show `Readable <Data-InRules.html#t:Readable>`__

 

`FromInRule <Data-InRules.html#t:FromInRule>`__
`Readable <Data-InRules.html#t:Readable>`__

Dirty fallback strategy

Read a => Convertible `Readable <Data-InRules.html#t:Readable>`__ a

 

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

+------------------------------------------------+-----+
| Show `InKey <Data-InRules.html#t:InKey>`__     |     |
+------------------------------------------------+-----+
| Monoid `InKey <Data-InRules.html#t:InKey>`__   |     |
+------------------------------------------------+-----+

newtype IdentityMonoid a

Identity monoid, doesn't exist in prelude or anywhere else

Constructors

IM

 

Fields

unIM :: a
     

Instances

+----------------------------------------------------------------------------------+-----+
| Functor `IdentityMonoid <Data-InRules.html#t:IdentityMonoid>`__                  |     |
+----------------------------------------------------------------------------------+-----+
| Pointed `IdentityMonoid <Data-InRules.html#t:IdentityMonoid>`__                  |     |
+----------------------------------------------------------------------------------+-----+
| Copointed `IdentityMonoid <Data-InRules.html#t:IdentityMonoid>`__                |     |
+----------------------------------------------------------------------------------+-----+
| Monoid a => Monoid (`IdentityMonoid <Data-InRules.html#t:IdentityMonoid>`__ a)   |     |
+----------------------------------------------------------------------------------+-----+

data PathState

Simple automaton for rejecting or accepting paths

Constructors

+----------+-----+
| Accept   |     |
+----------+-----+
| Reject   |     |
+----------+-----+

Instances

+------------------------------------------------------+-----+
| Show `PathState <Data-InRules.html#t:PathState>`__   |     |
+------------------------------------------------------+-----+

data PathStep a

One step of the automata. Automata can be in two states: \| next step or
final path

Constructors

+----------------------------------------------------------------+-----+
| Next (`PathAcceptor <Data-InRules.html#t:PathAcceptor>`__ a)   |     |
+----------------------------------------------------------------+-----+
| Final `PathState <Data-InRules.html#t:PathState>`__            |     |
+----------------------------------------------------------------+-----+

newtype PathAcceptor a

One machine step

Constructors

PM

 

Fields

unPM :: a -> `PathStep <Data-InRules.html#t:PathStep>`__ a
     

Instances

Semigroup (`PathAcceptor <Data-InRules.html#t:PathAcceptor>`__ a)

Path acceptor is a semigroup and acts semantically like a and operator

accept :: `PathStep <Data-InRules.html#t:PathStep>`__ a

The always acceptor

reject :: `PathStep <Data-InRules.html#t:PathStep>`__ a

The always rejector

acceptor :: `PathAcceptor <Data-InRules.html#t:PathAcceptor>`__ a

Always accept the input

rejector :: `PathAcceptor <Data-InRules.html#t:PathAcceptor>`__ a

Always reject the input

continue :: `PathAcceptor <Data-InRules.html#t:PathAcceptor>`__ a

Always accept the complete input stream (will always be false for finite
streams and true for infinite ones)

alter :: `PathAcceptor <Data-InRules.html#t:PathAcceptor>`__ a ->
`PathAcceptor <Data-InRules.html#t:PathAcceptor>`__ a ->
`PathAcceptor <Data-InRules.html#t:PathAcceptor>`__ a

Alternate two acceptors. If the first rejects try the next. Behaves like
an or \| operator

apoint :: Eq a => a ->
`PathAcceptor <Data-InRules.html#t:PathAcceptor>`__ a

Creates a pointed acceptor

runPath :: Eq a => `PathAcceptor <Data-InRules.html#t:PathAcceptor>`__ a
-> [a] -> Bool

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

+----------------------------------------------------+-----+
| Eq `KindView <Data-InRules.html#t:KindView>`__     |     |
+----------------------------------------------------+-----+
| Show `KindView <Data-InRules.html#t:KindView>`__   |     |
+----------------------------------------------------+-----+

viewKind :: `InRule <Data-InRules.html#t:InRule>`__ ->
`KindView <Data-InRules.html#t:KindView>`__

kmap :: (`InKey <Data-InRules.html#t:InKey>`__ ->
`InRule <Data-InRules.html#t:InRule>`__ ->
`InRule <Data-InRules.html#t:InRule>`__) ->
`InRule <Data-InRules.html#t:InRule>`__ ->
`InRule <Data-InRules.html#t:InRule>`__

Maps through the structure

pmap :: (Monoid (f `InKey <Data-InRules.html#t:InKey>`__), Pointed f) =>
(f `InKey <Data-InRules.html#t:InKey>`__ ->
`InRule <Data-InRules.html#t:InRule>`__ ->
`InRule <Data-InRules.html#t:InRule>`__) ->
`InRule <Data-InRules.html#t:InRule>`__ ->
`InRule <Data-InRules.html#t:InRule>`__

Maps trough the structure with a history of the path kept in a monoid

pfold :: (Monoid (f `InKey <Data-InRules.html#t:InKey>`__), Pointed f)
=> (f `InKey <Data-InRules.html#t:InKey>`__ ->
`InRule <Data-InRules.html#t:InRule>`__ -> b -> b) ->
`InRule <Data-InRules.html#t:InRule>`__ -> b -> b

Fold trough a structure with a history of the path kept in a monoid

longest\_path :: `InRule <Data-InRules.html#t:InRule>`__ -> Int

Example of the longest path in the inrule structure

ckey :: Num a => [`InKey <Data-InRules.html#t:InKey>`__\ ] -> a

kfold :: (`InKey <Data-InRules.html#t:InKey>`__ ->
`InRule <Data-InRules.html#t:InRule>`__ -> b -> b) ->
`InRule <Data-InRules.html#t:InRule>`__ -> b -> b

Fold through the structure

(.>) :: `InRule <Data-InRules.html#t:InRule>`__ -> String -> Maybe
`InRule <Data-InRules.html#t:InRule>`__

Find top level matching keyword

(..>) :: `FromInRule <Data-InRules.html#t:FromInRule>`__ a =>
`InRule <Data-InRules.html#t:InRule>`__ -> String -> Maybe a

Find top level value and convert to normal value

(.>>) :: `InRule <Data-InRules.html#t:InRule>`__ -> String ->
[`InRule <Data-InRules.html#t:InRule>`__\ ]

Search all occuring keywords recursively

readable :: String -> `Readable <Data-InRules.html#t:Readable>`__

Transform a string into a readable

viaReadable :: Read a => `InRule <Data-InRules.html#t:InRule>`__ -> a

asReadable :: `InRule <Data-InRules.html#t:InRule>`__ ->
`Readable <Data-InRules.html#t:Readable>`__

type InRules = [`InRule <Data-InRules.html#t:InRule>`__\ ]

class ToInRule a where

Methods

toInRule :: a -> `InRule <Data-InRules.html#t:InRule>`__

Instances

`ToInRule <Data-InRules.html#t:ToInRule>`__ Bool

 

`ToInRule <Data-InRules.html#t:ToInRule>`__ Char

 

`ToInRule <Data-InRules.html#t:ToInRule>`__ Double

 

`ToInRule <Data-InRules.html#t:ToInRule>`__ Float

 

`ToInRule <Data-InRules.html#t:ToInRule>`__ Int

 

`ToInRule <Data-InRules.html#t:ToInRule>`__ Int32

 

`ToInRule <Data-InRules.html#t:ToInRule>`__ Int64

 

`ToInRule <Data-InRules.html#t:ToInRule>`__ Integer

 

`ToInRule <Data-InRules.html#t:ToInRule>`__ Rational

 

`ToInRule <Data-InRules.html#t:ToInRule>`__ Word32

 

`ToInRule <Data-InRules.html#t:ToInRule>`__ Word64

 

`ToInRule <Data-InRules.html#t:ToInRule>`__ String

 

`ToInRule <Data-InRules.html#t:ToInRule>`__ ()

 

`ToInRule <Data-InRules.html#t:ToInRule>`__ UTCTime

 

`ToInRule <Data-InRules.html#t:ToInRule>`__ Day

 

`ToInRule <Data-InRules.html#t:ToInRule>`__
`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__

Renders InRule to String.

`ToInRule <Data-InRules.html#t:ToInRule>`__ LocalTime

 

`ToInRule <Data-InRules.html#t:ToInRule>`__ ByteString

 

`ToInRule <Data-InRules.html#t:ToInRule>`__ ByteString

 

`ToInRule <Data-InRules.html#t:ToInRule>`__ TimeOfDay

 

`ToInRule <Data-InRules.html#t:ToInRule>`__ Value

 

`ToInRule <Data-InRules.html#t:ToInRule>`__
`InRule <Data-InRules.html#t:InRule>`__

 

`ToInRule <Data-InRules.html#t:ToInRule>`__
`Data <Data-DataPack.html#t:Data>`__

 

`ToInRule <Data-InRules.html#t:ToInRule>`__
`Event <Data-Event.html#t:Event>`__

 

`ToInRule <Data-InRules.html#t:ToInRule>`__
`Account <Model-Account.html#t:Account>`__

 

`ToInRule <Data-InRules.html#t:ToInRule>`__
`Transaction <Model-Transaction.html#t:Transaction>`__

 

`ToInRule <Data-InRules.html#t:ToInRule>`__
`Escrow <Model-Escrow.html#t:Escrow>`__

 

`ToInRule <Data-InRules.html#t:ToInRule>`__
`DiamondTransaction <Model-Diamonds.html#t:DiamondTransaction>`__

 

`ToInRule <Data-InRules.html#t:ToInRule>`__
`AccountProfile <Model-AccountProfile.html#t:AccountProfile>`__

 

`ToInRule <Data-InRules.html#t:ToInRule>`__
`AccountProfileMin <Model-AccountProfileMin.html#t:AccountProfileMin>`__

 

`ToInRule <Data-InRules.html#t:ToInRule>`__
`Car <Model-Car.html#t:Car>`__

 

`ToInRule <Data-InRules.html#t:ToInRule>`__
`Car3dModel <Model-Car3dModel.html#t:Car3dModel>`__

 

`ToInRule <Data-InRules.html#t:ToInRule>`__
`CarInGarage <Model-CarInGarage.html#t:CarInGarage>`__

 

`ToInRule <Data-InRules.html#t:ToInRule>`__
`CarInstance <Model-CarInstance.html#t:CarInstance>`__

 

`ToInRule <Data-InRules.html#t:ToInRule>`__
`CarInstanceParts <Model-CarInstanceParts.html#t:CarInstanceParts>`__

 

`ToInRule <Data-InRules.html#t:ToInRule>`__
`CarMarket <Model-CarMarket.html#t:CarMarket>`__

 

`ToInRule <Data-InRules.html#t:ToInRule>`__
`CarMinimal <Model-CarMinimal.html#t:CarMinimal>`__

 

`ToInRule <Data-InRules.html#t:ToInRule>`__
`RaceParticipant <Data-RaceParticipant.html#t:RaceParticipant>`__

 

`ToInRule <Data-InRules.html#t:ToInRule>`__
`TrackTime <Model-TrackTime.html#t:TrackTime>`__

 

`ToInRule <Data-InRules.html#t:ToInRule>`__
`CarOptions <Model-CarOptions.html#t:CarOptions>`__

 

`ToInRule <Data-InRules.html#t:ToInRule>`__
`CarOptionsExtended <Model-CarOptionsExtended.html#t:CarOptionsExtended>`__

 

`ToInRule <Data-InRules.html#t:ToInRule>`__
`CarOwners <Model-CarOwners.html#t:CarOwners>`__

 

`ToInRule <Data-InRules.html#t:ToInRule>`__
`CarStockPart <Model-CarStockParts.html#t:CarStockPart>`__

 

`ToInRule <Data-InRules.html#t:ToInRule>`__
`Challenge <Model-Challenge.html#t:Challenge>`__

 

`ToInRule <Data-InRules.html#t:ToInRule>`__
`ChallengeAccept <Model-ChallengeAccept.html#t:ChallengeAccept>`__

 

`ToInRule <Data-InRules.html#t:ToInRule>`__
`ChallengeExtended <Model-ChallengeExtended.html#t:ChallengeExtended>`__

 

`ToInRule <Data-InRules.html#t:ToInRule>`__
`ChallengeType <Model-ChallengeType.html#t:ChallengeType>`__

 

`ToInRule <Data-InRules.html#t:ToInRule>`__
`City <Model-City.html#t:City>`__

 

`ToInRule <Data-InRules.html#t:ToInRule>`__
`Config <Model-Config.html#t:Config>`__

 

`ToInRule <Data-InRules.html#t:ToInRule>`__
`Continent <Model-Continent.html#t:Continent>`__

 

`ToInRule <Data-InRules.html#t:ToInRule>`__
`EventStream <Model-EventStream.html#t:EventStream>`__

 

`ToInRule <Data-InRules.html#t:ToInRule>`__
`Garage <Model-Garage.html#t:Garage>`__

 

`ToInRule <Data-InRules.html#t:ToInRule>`__
`GaragePart <Model-GarageParts.html#t:GaragePart>`__

 

`ToInRule <Data-InRules.html#t:ToInRule>`__
`GarageReport <Model-GarageReport.html#t:GarageReport>`__

 

`ToInRule <Data-InRules.html#t:ToInRule>`__
`GarageReportInsert <Model-GarageReportInsert.html#t:GarageReportInsert>`__

 

`ToInRule <Data-InRules.html#t:ToInRule>`__
`GeneralReport <Model-GeneralReport.html#t:GeneralReport>`__

 

`ToInRule <Data-InRules.html#t:ToInRule>`__
`Manufacturer <Model-Manufacturer.html#t:Manufacturer>`__

 

`ToInRule <Data-InRules.html#t:ToInRule>`__
`ManufacturerMarket <Model-ManufacturerMarket.html#t:ManufacturerMarket>`__

 

`ToInRule <Data-InRules.html#t:ToInRule>`__
`MarketCarInstanceParts <Model-MarketCarInstanceParts.html#t:MarketCarInstanceParts>`__

 

`ToInRule <Data-InRules.html#t:ToInRule>`__
`MarketItem <Model-MarketItem.html#t:MarketItem>`__

 

`ToInRule <Data-InRules.html#t:ToInRule>`__
`MarketPartType <Model-MarketPartType.html#t:MarketPartType>`__

 

`ToInRule <Data-InRules.html#t:ToInRule>`__
`MarketPlace <Model-MarketPlace.html#t:MarketPlace>`__

 

`ToInRule <Data-InRules.html#t:ToInRule>`__
`MarketPlaceCar <Model-MarketPlaceCar.html#t:MarketPlaceCar>`__

 

`ToInRule <Data-InRules.html#t:ToInRule>`__
`MenuModel <Model-MenuModel.html#t:MenuModel>`__

 

`ToInRule <Data-InRules.html#t:ToInRule>`__
`Part <Model-Part.html#t:Part>`__

 

`ToInRule <Data-InRules.html#t:ToInRule>`__
`PartDetails <Model-PartDetails.html#t:PartDetails>`__

 

`ToInRule <Data-InRules.html#t:ToInRule>`__
`RaceRewards <Data-RaceReward.html#t:RaceRewards>`__

 

`ToInRule <Data-InRules.html#t:ToInRule>`__
`RaceReward <Model-RaceReward.html#t:RaceReward>`__

 

`ToInRule <Data-InRules.html#t:ToInRule>`__
`Tournament <Model-Tournament.html#t:Tournament>`__

 

`ToInRule <Data-InRules.html#t:ToInRule>`__
`TournamentExtended <Model-TournamentExtended.html#t:TournamentExtended>`__

 

`ToInRule <Data-InRules.html#t:ToInRule>`__
`PartInstance <Model-PartInstance.html#t:PartInstance>`__

 

`ToInRule <Data-InRules.html#t:ToInRule>`__
`PartMarket <Model-PartMarket.html#t:PartMarket>`__

 

`ToInRule <Data-InRules.html#t:ToInRule>`__
`PartMarketPlaceType <Model-PartMarketPlaceType.html#t:PartMarketPlaceType>`__

 

`ToInRule <Data-InRules.html#t:ToInRule>`__
`PartMarketType <Model-PartMarketType.html#t:PartMarketType>`__

 

`ToInRule <Data-InRules.html#t:ToInRule>`__
`PartType <Model-PartType.html#t:PartType>`__

 

`ToInRule <Data-InRules.html#t:ToInRule>`__
`Personnel <Model-Personnel.html#t:Personnel>`__

 

`ToInRule <Data-InRules.html#t:ToInRule>`__
`PersonnelDetails <Model-PersonnelDetails.html#t:PersonnelDetails>`__

 

`ToInRule <Data-InRules.html#t:ToInRule>`__
`PersonnelInstance <Model-PersonnelInstance.html#t:PersonnelInstance>`__

 

`ToInRule <Data-InRules.html#t:ToInRule>`__
`PersonnelInstanceDetails <Model-PersonnelInstanceDetails.html#t:PersonnelInstanceDetails>`__

 

`ToInRule <Data-InRules.html#t:ToInRule>`__
`PersonnelReport <Model-PersonnelReport.html#t:PersonnelReport>`__

 

`ToInRule <Data-InRules.html#t:ToInRule>`__
`PersonnelTaskType <Model-PersonnelTaskType.html#t:PersonnelTaskType>`__

 

`ToInRule <Data-InRules.html#t:ToInRule>`__
`PreLetter <Model-PreLetter.html#t:PreLetter>`__

 

`ToInRule <Data-InRules.html#t:ToInRule>`__
`Type <Model-Report.html#t:Type>`__

 

`ToInRule <Data-InRules.html#t:ToInRule>`__
`Report <Model-Report.html#t:Report>`__

 

`ToInRule <Data-InRules.html#t:ToInRule>`__
`RewardLog <Model-RewardLog.html#t:RewardLog>`__

 

`ToInRule <Data-InRules.html#t:ToInRule>`__
`RewardLogEvent <Model-RewardLogEvent.html#t:RewardLogEvent>`__

 

`ToInRule <Data-InRules.html#t:ToInRule>`__
`ShopReport <Model-ShopReport.html#t:ShopReport>`__

 

`ToInRule <Data-InRules.html#t:ToInRule>`__
`Support <Model-Support.html#t:Support>`__

 

`ToInRule <Data-InRules.html#t:ToInRule>`__
`TrackCity <Model-TrackCity.html#t:TrackCity>`__

 

`ToInRule <Data-InRules.html#t:ToInRule>`__
`TrackContinent <Model-TrackContinent.html#t:TrackContinent>`__

 

`ToInRule <Data-InRules.html#t:ToInRule>`__
`TrackDetails <Model-TrackDetails.html#t:TrackDetails>`__

 

`ToInRule <Data-InRules.html#t:ToInRule>`__
`TrackMaster <Model-TrackMaster.html#t:TrackMaster>`__

 

`ToInRule <Data-InRules.html#t:ToInRule>`__
`TravelReport <Model-TravelReport.html#t:TravelReport>`__

 

`ToInRule <Data-InRules.html#t:ToInRule>`__
`Notification <Model-Notification.html#t:Notification>`__

 

`ToInRule <Data-InRules.html#t:ToInRule>`__
`Task <Model-Task.html#t:Task>`__

 

`ToInRule <Data-InRules.html#t:ToInRule>`__
`CarReadyState <Data-CarReady.html#t:CarReadyState>`__

 

`ToInRule <Data-InRules.html#t:ToInRule>`__
`RaceSectionPerformance <Data-RaceSectionPerformance.html#t:RaceSectionPerformance>`__

 

`ToInRule <Data-InRules.html#t:ToInRule>`__
`TaskTrigger <Model-TaskTrigger.html#t:TaskTrigger>`__

 

`ToInRule <Data-InRules.html#t:ToInRule>`__
`TaskLog <Model-TaskLog.html#t:TaskLog>`__

 

`ToInRule <Data-InRules.html#t:ToInRule>`__
`Action <Model-Action.html#t:Action>`__

 

`ToInRule <Data-InRules.html#t:ToInRule>`__
`RewardLogEvents <Model-RewardLogEvents.html#t:RewardLogEvents>`__

 

`ToInRule <Data-InRules.html#t:ToInRule>`__
`Rule <Model-Rule.html#t:Rule>`__

 

`ToInRule <Data-InRules.html#t:ToInRule>`__
`RuleReward <Model-RuleReward.html#t:RuleReward>`__

 

`ToInRule <Data-InRules.html#t:ToInRule>`__
`Prize <Data-Reward.html#t:Prize>`__

 

`ToInRule <Data-InRules.html#t:ToInRule>`__
`Reward <Data-Reward.html#t:Reward>`__

 

`ToInRule <Data-InRules.html#t:ToInRule>`__
`Rewards <Data-Reward.html#t:Rewards>`__

 

`ToInRule <Data-InRules.html#t:ToInRule>`__ Box

 

`ToInRule <Data-InRules.html#t:ToInRule>`__ ComposeMap

 

`ToInRule <Data-InRules.html#t:ToInRule>`__
`SectionResult <Data-RacingNew.html#t:SectionResult>`__

 

`ToInRule <Data-InRules.html#t:ToInRule>`__
`RaceResult <Data-RacingNew.html#t:RaceResult>`__

 

`ToInRule <Data-InRules.html#t:ToInRule>`__
`RaceData <Data-RacingNew.html#t:RaceData>`__

 

`ToInRule <Data-InRules.html#t:ToInRule>`__ CarBaseParameters

 

`ToInRule <Data-InRules.html#t:ToInRule>`__ CarDerivedParameters

 

`ToInRule <Data-InRules.html#t:ToInRule>`__ PartParameter

 

`ToInRule <Data-InRules.html#t:ToInRule>`__ PreviewPart

 

`ToInRule <Data-InRules.html#t:ToInRule>`__
`Race <Model-Race.html#t:Race>`__

 

`ToInRule <Data-InRules.html#t:ToInRule>`__
`RaceDetails <Model-RaceDetails.html#t:RaceDetails>`__

 

`ToInRule <Data-InRules.html#t:ToInRule>`__ SectionResult

 

`ToInRule <Data-InRules.html#t:ToInRule>`__ RaceResult

 

`ToInRule <Data-InRules.html#t:ToInRule>`__ RaceParticipant

 

`ToInRule <Data-InRules.html#t:ToInRule>`__ RaceRewards

 

`ToInRule <Data-InRules.html#t:ToInRule>`__ RaceData

 

`ToInRule <Data-InRules.html#t:ToInRule>`__
`TournamentPlayer <Model-TournamentPlayers.html#t:TournamentPlayer>`__

 

`ToInRule <Data-InRules.html#t:ToInRule>`__
`TournamentResult <Model-TournamentResult.html#t:TournamentResult>`__

 

`ToInRule <Data-InRules.html#t:ToInRule>`__
`TournamentReport <Model-TournamentReport.html#t:TournamentReport>`__

 

`ToInRule <Data-InRules.html#t:ToInRule>`__
`NotificationParam <Notifications.html#t:NotificationParam>`__

 

`ToInRule <Data-InRules.html#t:ToInRule>`__ RaceType

 

`ToInRule <Data-InRules.html#t:ToInRule>`__ RoundResult

 

`ToInRule <Data-InRules.html#t:ToInRule>`__ TournamentFullData

 

`ToInRule <Data-InRules.html#t:ToInRule>`__ a =>
`ToInRule <Data-InRules.html#t:ToInRule>`__ [a]

 

`ToInRule <Data-InRules.html#t:ToInRule>`__ a =>
`ToInRule <Data-InRules.html#t:ToInRule>`__ (Maybe a)

 

(`ToInRule <Data-InRules.html#t:ToInRule>`__ t1,
`ToInRule <Data-InRules.html#t:ToInRule>`__ t2) =>
`ToInRule <Data-InRules.html#t:ToInRule>`__ (t1, t2)

 

`ToInRule <Data-InRules.html#t:ToInRule>`__ a =>
`ToInRule <Data-InRules.html#t:ToInRule>`__ (HashMap String a)

 

(`ToInRule <Data-InRules.html#t:ToInRule>`__ k,
`ToInRule <Data-InRules.html#t:ToInRule>`__ v) =>
`ToInRule <Data-InRules.html#t:ToInRule>`__ (HashMap k v)

 

(`ToInRule <Data-InRules.html#t:ToInRule>`__ t1,
`ToInRule <Data-InRules.html#t:ToInRule>`__ t2,
`ToInRule <Data-InRules.html#t:ToInRule>`__ t3) =>
`ToInRule <Data-InRules.html#t:ToInRule>`__ (t1, t2, t3)

 

(`ToInRule <Data-InRules.html#t:ToInRule>`__ t1,
`ToInRule <Data-InRules.html#t:ToInRule>`__ t2,
`ToInRule <Data-InRules.html#t:ToInRule>`__ t3,
`ToInRule <Data-InRules.html#t:ToInRule>`__ t4) =>
`ToInRule <Data-InRules.html#t:ToInRule>`__ (t1, t2, t3, t4)

 

(`ToInRule <Data-InRules.html#t:ToInRule>`__ t1,
`ToInRule <Data-InRules.html#t:ToInRule>`__ t2,
`ToInRule <Data-InRules.html#t:ToInRule>`__ t3,
`ToInRule <Data-InRules.html#t:ToInRule>`__ t4,
`ToInRule <Data-InRules.html#t:ToInRule>`__ t5) =>
`ToInRule <Data-InRules.html#t:ToInRule>`__ (t1, t2, t3, t4, t5)

 

class FromInRule a where

Methods

fromInRule :: `InRule <Data-InRules.html#t:InRule>`__ -> a

Instances

`FromInRule <Data-InRules.html#t:FromInRule>`__ Bool

 

`FromInRule <Data-InRules.html#t:FromInRule>`__ Double

 

`FromInRule <Data-InRules.html#t:FromInRule>`__ Float

 

`FromInRule <Data-InRules.html#t:FromInRule>`__ Int

 

`FromInRule <Data-InRules.html#t:FromInRule>`__ Int32

 

`FromInRule <Data-InRules.html#t:FromInRule>`__ Int64

 

`FromInRule <Data-InRules.html#t:FromInRule>`__ Integer

 

`FromInRule <Data-InRules.html#t:FromInRule>`__ Rational

 

`FromInRule <Data-InRules.html#t:FromInRule>`__ Word32

 

`FromInRule <Data-InRules.html#t:FromInRule>`__ Word64

 

`FromInRule <Data-InRules.html#t:FromInRule>`__ String

 

`FromInRule <Data-InRules.html#t:FromInRule>`__ UTCTime

 

`FromInRule <Data-InRules.html#t:FromInRule>`__ Day

 

`FromInRule <Data-InRules.html#t:FromInRule>`__
`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__

 

`FromInRule <Data-InRules.html#t:FromInRule>`__ LocalTime

 

`FromInRule <Data-InRules.html#t:FromInRule>`__ ByteString

 

`FromInRule <Data-InRules.html#t:FromInRule>`__ ByteString

 

`FromInRule <Data-InRules.html#t:FromInRule>`__ TimeOfDay

 

`FromInRule <Data-InRules.html#t:FromInRule>`__ Value

 

`FromInRule <Data-InRules.html#t:FromInRule>`__
`Readable <Data-InRules.html#t:Readable>`__

Dirty fallback strategy

`FromInRule <Data-InRules.html#t:FromInRule>`__
`InRule <Data-InRules.html#t:InRule>`__

 

`FromInRule <Data-InRules.html#t:FromInRule>`__
`Data <Data-DataPack.html#t:Data>`__

 

`FromInRule <Data-InRules.html#t:FromInRule>`__
`Event <Data-Event.html#t:Event>`__

 

`FromInRule <Data-InRules.html#t:FromInRule>`__
`Account <Model-Account.html#t:Account>`__

 

`FromInRule <Data-InRules.html#t:FromInRule>`__
`Transaction <Model-Transaction.html#t:Transaction>`__

 

`FromInRule <Data-InRules.html#t:FromInRule>`__
`Escrow <Model-Escrow.html#t:Escrow>`__

 

`FromInRule <Data-InRules.html#t:FromInRule>`__
`DiamondTransaction <Model-Diamonds.html#t:DiamondTransaction>`__

 

`FromInRule <Data-InRules.html#t:FromInRule>`__
`AccountProfile <Model-AccountProfile.html#t:AccountProfile>`__

 

`FromInRule <Data-InRules.html#t:FromInRule>`__
`AccountProfileMin <Model-AccountProfileMin.html#t:AccountProfileMin>`__

 

`FromInRule <Data-InRules.html#t:FromInRule>`__
`Car <Model-Car.html#t:Car>`__

 

`FromInRule <Data-InRules.html#t:FromInRule>`__
`Car3dModel <Model-Car3dModel.html#t:Car3dModel>`__

 

`FromInRule <Data-InRules.html#t:FromInRule>`__
`CarInGarage <Model-CarInGarage.html#t:CarInGarage>`__

 

`FromInRule <Data-InRules.html#t:FromInRule>`__
`CarInstance <Model-CarInstance.html#t:CarInstance>`__

 

`FromInRule <Data-InRules.html#t:FromInRule>`__
`CarInstanceParts <Model-CarInstanceParts.html#t:CarInstanceParts>`__

 

`FromInRule <Data-InRules.html#t:FromInRule>`__
`CarMarket <Model-CarMarket.html#t:CarMarket>`__

 

`FromInRule <Data-InRules.html#t:FromInRule>`__
`CarMinimal <Model-CarMinimal.html#t:CarMinimal>`__

 

`FromInRule <Data-InRules.html#t:FromInRule>`__
`RaceParticipant <Data-RaceParticipant.html#t:RaceParticipant>`__

 

`FromInRule <Data-InRules.html#t:FromInRule>`__
`TrackTime <Model-TrackTime.html#t:TrackTime>`__

 

`FromInRule <Data-InRules.html#t:FromInRule>`__
`CarOptions <Model-CarOptions.html#t:CarOptions>`__

 

`FromInRule <Data-InRules.html#t:FromInRule>`__
`CarOptionsExtended <Model-CarOptionsExtended.html#t:CarOptionsExtended>`__

 

`FromInRule <Data-InRules.html#t:FromInRule>`__
`CarOwners <Model-CarOwners.html#t:CarOwners>`__

 

`FromInRule <Data-InRules.html#t:FromInRule>`__
`CarStockPart <Model-CarStockParts.html#t:CarStockPart>`__

 

`FromInRule <Data-InRules.html#t:FromInRule>`__
`Challenge <Model-Challenge.html#t:Challenge>`__

 

`FromInRule <Data-InRules.html#t:FromInRule>`__
`ChallengeAccept <Model-ChallengeAccept.html#t:ChallengeAccept>`__

 

`FromInRule <Data-InRules.html#t:FromInRule>`__
`ChallengeExtended <Model-ChallengeExtended.html#t:ChallengeExtended>`__

 

`FromInRule <Data-InRules.html#t:FromInRule>`__
`ChallengeType <Model-ChallengeType.html#t:ChallengeType>`__

 

`FromInRule <Data-InRules.html#t:FromInRule>`__
`City <Model-City.html#t:City>`__

 

`FromInRule <Data-InRules.html#t:FromInRule>`__
`Config <Model-Config.html#t:Config>`__

 

`FromInRule <Data-InRules.html#t:FromInRule>`__
`Continent <Model-Continent.html#t:Continent>`__

 

`FromInRule <Data-InRules.html#t:FromInRule>`__
`EventStream <Model-EventStream.html#t:EventStream>`__

 

`FromInRule <Data-InRules.html#t:FromInRule>`__
`Garage <Model-Garage.html#t:Garage>`__

 

`FromInRule <Data-InRules.html#t:FromInRule>`__
`GaragePart <Model-GarageParts.html#t:GaragePart>`__

 

`FromInRule <Data-InRules.html#t:FromInRule>`__
`GarageReport <Model-GarageReport.html#t:GarageReport>`__

 

`FromInRule <Data-InRules.html#t:FromInRule>`__
`GarageReportInsert <Model-GarageReportInsert.html#t:GarageReportInsert>`__

 

`FromInRule <Data-InRules.html#t:FromInRule>`__
`GeneralReport <Model-GeneralReport.html#t:GeneralReport>`__

 

`FromInRule <Data-InRules.html#t:FromInRule>`__
`Manufacturer <Model-Manufacturer.html#t:Manufacturer>`__

 

`FromInRule <Data-InRules.html#t:FromInRule>`__
`ManufacturerMarket <Model-ManufacturerMarket.html#t:ManufacturerMarket>`__

 

`FromInRule <Data-InRules.html#t:FromInRule>`__
`MarketCarInstanceParts <Model-MarketCarInstanceParts.html#t:MarketCarInstanceParts>`__

 

`FromInRule <Data-InRules.html#t:FromInRule>`__
`MarketItem <Model-MarketItem.html#t:MarketItem>`__

 

`FromInRule <Data-InRules.html#t:FromInRule>`__
`MarketPartType <Model-MarketPartType.html#t:MarketPartType>`__

 

`FromInRule <Data-InRules.html#t:FromInRule>`__
`MarketPlace <Model-MarketPlace.html#t:MarketPlace>`__

 

`FromInRule <Data-InRules.html#t:FromInRule>`__
`MarketPlaceCar <Model-MarketPlaceCar.html#t:MarketPlaceCar>`__

 

`FromInRule <Data-InRules.html#t:FromInRule>`__
`MenuModel <Model-MenuModel.html#t:MenuModel>`__

 

`FromInRule <Data-InRules.html#t:FromInRule>`__
`Part <Model-Part.html#t:Part>`__

 

`FromInRule <Data-InRules.html#t:FromInRule>`__
`PartDetails <Model-PartDetails.html#t:PartDetails>`__

 

`FromInRule <Data-InRules.html#t:FromInRule>`__
`RaceRewards <Data-RaceReward.html#t:RaceRewards>`__

 

`FromInRule <Data-InRules.html#t:FromInRule>`__
`RaceReward <Model-RaceReward.html#t:RaceReward>`__

 

`FromInRule <Data-InRules.html#t:FromInRule>`__
`Tournament <Model-Tournament.html#t:Tournament>`__

 

`FromInRule <Data-InRules.html#t:FromInRule>`__
`TournamentExtended <Model-TournamentExtended.html#t:TournamentExtended>`__

 

`FromInRule <Data-InRules.html#t:FromInRule>`__
`PartInstance <Model-PartInstance.html#t:PartInstance>`__

 

`FromInRule <Data-InRules.html#t:FromInRule>`__
`PartMarket <Model-PartMarket.html#t:PartMarket>`__

 

`FromInRule <Data-InRules.html#t:FromInRule>`__
`PartMarketPlaceType <Model-PartMarketPlaceType.html#t:PartMarketPlaceType>`__

 

`FromInRule <Data-InRules.html#t:FromInRule>`__
`PartMarketType <Model-PartMarketType.html#t:PartMarketType>`__

 

`FromInRule <Data-InRules.html#t:FromInRule>`__
`PartType <Model-PartType.html#t:PartType>`__

 

`FromInRule <Data-InRules.html#t:FromInRule>`__
`Personnel <Model-Personnel.html#t:Personnel>`__

 

`FromInRule <Data-InRules.html#t:FromInRule>`__
`PersonnelDetails <Model-PersonnelDetails.html#t:PersonnelDetails>`__

 

`FromInRule <Data-InRules.html#t:FromInRule>`__
`PersonnelInstance <Model-PersonnelInstance.html#t:PersonnelInstance>`__

 

`FromInRule <Data-InRules.html#t:FromInRule>`__
`PersonnelInstanceDetails <Model-PersonnelInstanceDetails.html#t:PersonnelInstanceDetails>`__

 

`FromInRule <Data-InRules.html#t:FromInRule>`__
`PersonnelReport <Model-PersonnelReport.html#t:PersonnelReport>`__

 

`FromInRule <Data-InRules.html#t:FromInRule>`__
`PersonnelTaskType <Model-PersonnelTaskType.html#t:PersonnelTaskType>`__

 

`FromInRule <Data-InRules.html#t:FromInRule>`__
`PreLetter <Model-PreLetter.html#t:PreLetter>`__

 

`FromInRule <Data-InRules.html#t:FromInRule>`__
`Type <Model-Report.html#t:Type>`__

 

`FromInRule <Data-InRules.html#t:FromInRule>`__
`Report <Model-Report.html#t:Report>`__

 

`FromInRule <Data-InRules.html#t:FromInRule>`__
`RewardLog <Model-RewardLog.html#t:RewardLog>`__

 

`FromInRule <Data-InRules.html#t:FromInRule>`__
`RewardLogEvent <Model-RewardLogEvent.html#t:RewardLogEvent>`__

 

`FromInRule <Data-InRules.html#t:FromInRule>`__
`ShopReport <Model-ShopReport.html#t:ShopReport>`__

 

`FromInRule <Data-InRules.html#t:FromInRule>`__
`Support <Model-Support.html#t:Support>`__

 

`FromInRule <Data-InRules.html#t:FromInRule>`__
`TrackCity <Model-TrackCity.html#t:TrackCity>`__

 

`FromInRule <Data-InRules.html#t:FromInRule>`__
`TrackContinent <Model-TrackContinent.html#t:TrackContinent>`__

 

`FromInRule <Data-InRules.html#t:FromInRule>`__
`TrackDetails <Model-TrackDetails.html#t:TrackDetails>`__

 

`FromInRule <Data-InRules.html#t:FromInRule>`__
`TrackMaster <Model-TrackMaster.html#t:TrackMaster>`__

 

`FromInRule <Data-InRules.html#t:FromInRule>`__
`TravelReport <Model-TravelReport.html#t:TravelReport>`__

 

`FromInRule <Data-InRules.html#t:FromInRule>`__
`Notification <Model-Notification.html#t:Notification>`__

 

`FromInRule <Data-InRules.html#t:FromInRule>`__
`Task <Model-Task.html#t:Task>`__

 

`FromInRule <Data-InRules.html#t:FromInRule>`__
`CarReadyState <Data-CarReady.html#t:CarReadyState>`__

 

`FromInRule <Data-InRules.html#t:FromInRule>`__
`RaceSectionPerformance <Data-RaceSectionPerformance.html#t:RaceSectionPerformance>`__

 

`FromInRule <Data-InRules.html#t:FromInRule>`__
`TaskTrigger <Model-TaskTrigger.html#t:TaskTrigger>`__

 

`FromInRule <Data-InRules.html#t:FromInRule>`__
`TaskLog <Model-TaskLog.html#t:TaskLog>`__

 

`FromInRule <Data-InRules.html#t:FromInRule>`__
`Action <Model-Action.html#t:Action>`__

 

`FromInRule <Data-InRules.html#t:FromInRule>`__
`RewardLogEvents <Model-RewardLogEvents.html#t:RewardLogEvents>`__

 

`FromInRule <Data-InRules.html#t:FromInRule>`__
`Rule <Model-Rule.html#t:Rule>`__

 

`FromInRule <Data-InRules.html#t:FromInRule>`__
`RuleReward <Model-RuleReward.html#t:RuleReward>`__

 

`FromInRule <Data-InRules.html#t:FromInRule>`__
`SectionResult <Data-RacingNew.html#t:SectionResult>`__

 

`FromInRule <Data-InRules.html#t:FromInRule>`__
`RaceResult <Data-RacingNew.html#t:RaceResult>`__

 

`FromInRule <Data-InRules.html#t:FromInRule>`__
`RaceData <Data-RacingNew.html#t:RaceData>`__

 

`FromInRule <Data-InRules.html#t:FromInRule>`__ CarBaseParameters

 

`FromInRule <Data-InRules.html#t:FromInRule>`__ CarDerivedParameters

 

`FromInRule <Data-InRules.html#t:FromInRule>`__ PartParameter

 

`FromInRule <Data-InRules.html#t:FromInRule>`__ PreviewPart

 

`FromInRule <Data-InRules.html#t:FromInRule>`__
`Race <Model-Race.html#t:Race>`__

 

`FromInRule <Data-InRules.html#t:FromInRule>`__
`RaceDetails <Model-RaceDetails.html#t:RaceDetails>`__

 

`FromInRule <Data-InRules.html#t:FromInRule>`__ SectionResult

 

`FromInRule <Data-InRules.html#t:FromInRule>`__ RaceResult

 

`FromInRule <Data-InRules.html#t:FromInRule>`__ RaceParticipant

 

`FromInRule <Data-InRules.html#t:FromInRule>`__ RaceRewards

 

`FromInRule <Data-InRules.html#t:FromInRule>`__ RaceData

 

`FromInRule <Data-InRules.html#t:FromInRule>`__
`TournamentPlayer <Model-TournamentPlayers.html#t:TournamentPlayer>`__

 

`FromInRule <Data-InRules.html#t:FromInRule>`__
`TournamentResult <Model-TournamentResult.html#t:TournamentResult>`__

 

`FromInRule <Data-InRules.html#t:FromInRule>`__
`TournamentReport <Model-TournamentReport.html#t:TournamentReport>`__

 

`FromInRule <Data-InRules.html#t:FromInRule>`__ RoundResult

 

`FromInRule <Data-InRules.html#t:FromInRule>`__ TournamentFullData

 

`FromInRule <Data-InRules.html#t:FromInRule>`__ a =>
`FromInRule <Data-InRules.html#t:FromInRule>`__ [a]

 

`FromInRule <Data-InRules.html#t:FromInRule>`__ a =>
`FromInRule <Data-InRules.html#t:FromInRule>`__ (Maybe a)

 

(`FromInRule <Data-InRules.html#t:FromInRule>`__ t1,
`FromInRule <Data-InRules.html#t:FromInRule>`__ t2) =>
`FromInRule <Data-InRules.html#t:FromInRule>`__ (t1, t2)

 

`FromInRule <Data-InRules.html#t:FromInRule>`__ a =>
`FromInRule <Data-InRules.html#t:FromInRule>`__ (HashMap String a)

 

(Eq k, Hashable k, `FromInRule <Data-InRules.html#t:FromInRule>`__ k,
`FromInRule <Data-InRules.html#t:FromInRule>`__ v) =>
`FromInRule <Data-InRules.html#t:FromInRule>`__ (HashMap k v)

 

(`FromInRule <Data-InRules.html#t:FromInRule>`__ t1,
`FromInRule <Data-InRules.html#t:FromInRule>`__ t2,
`FromInRule <Data-InRules.html#t:FromInRule>`__ t3) =>
`FromInRule <Data-InRules.html#t:FromInRule>`__ (t1, t2, t3)

 

(`FromInRule <Data-InRules.html#t:FromInRule>`__ t1,
`FromInRule <Data-InRules.html#t:FromInRule>`__ t2,
`FromInRule <Data-InRules.html#t:FromInRule>`__ t3,
`FromInRule <Data-InRules.html#t:FromInRule>`__ t4) =>
`FromInRule <Data-InRules.html#t:FromInRule>`__ (t1, t2, t3, t4)

 

(`FromInRule <Data-InRules.html#t:FromInRule>`__ t1,
`FromInRule <Data-InRules.html#t:FromInRule>`__ t2,
`FromInRule <Data-InRules.html#t:FromInRule>`__ t3,
`FromInRule <Data-InRules.html#t:FromInRule>`__ t4,
`FromInRule <Data-InRules.html#t:FromInRule>`__ t5) =>
`FromInRule <Data-InRules.html#t:FromInRule>`__ (t1, t2, t3, t4, t5)

 

toCompatible :: `InRule <Data-InRules.html#t:InRule>`__ ->
`InRule <Data-InRules.html#t:InRule>`__

validObject :: `InRule <Data-InRules.html#t:InRule>`__ -> Bool

emptyObj :: `InRule <Data-InRules.html#t:InRule>`__

object :: [(String, `InRule <Data-InRules.html#t:InRule>`__)] ->
`InRule <Data-InRules.html#t:InRule>`__

list :: [`InRule <Data-InRules.html#t:InRule>`__\ ] ->
`InRule <Data-InRules.html#t:InRule>`__

project :: `InRule <Data-InRules.html#t:InRule>`__ ->
`InRule <Data-InRules.html#t:InRule>`__ ->
`InRule <Data-InRules.html#t:InRule>`__

mapWithKey :: (k -> a -> b) -> HashMap k a -> HashMap k b

arrayToObj :: `InRule <Data-InRules.html#t:InRule>`__ ->
`InRule <Data-InRules.html#t:InRule>`__

shp :: `InRule <Data-InRules.html#t:InRule>`__ ->
`InRule <Data-InRules.html#t:InRule>`__ -> Bool

shpTestAB :: Bool

shpTestArr :: Bool

singleObj :: `ToInRule <Data-InRules.html#t:ToInRule>`__ a => String ->
a -> `InRule <Data-InRules.html#t:InRule>`__

Create single InRule object.

(==>) :: `ToInRule <Data-InRules.html#t:ToInRule>`__ a => String -> a ->
`InRule <Data-InRules.html#t:InRule>`__

``(==>``) Eq ``singleObj`` .

orM :: Maybe a -> a -> Maybe a

withDefault :: a -> Maybe a -> Maybe a

fromList :: `ToInRule <Data-InRules.html#t:ToInRule>`__ a => [(String,
a)] -> `InRule <Data-InRules.html#t:InRule>`__

Create InRule object from list.

toList :: `FromInRule <Data-InRules.html#t:FromInRule>`__ a =>
`InRule <Data-InRules.html#t:InRule>`__ -> [(String, a)]

Create InRule object from list.

toListString :: `InRule <Data-InRules.html#t:InRule>`__ -> [(String,
String)]

unionObj :: `InRule <Data-InRules.html#t:InRule>`__ ->
`InRule <Data-InRules.html#t:InRule>`__ ->
`InRule <Data-InRules.html#t:InRule>`__

unionsObj :: [`InRule <Data-InRules.html#t:InRule>`__\ ] ->
`InRule <Data-InRules.html#t:InRule>`__

Merge InRule objects from list.

unionRecObj :: `InRule <Data-InRules.html#t:InRule>`__ ->
`InRule <Data-InRules.html#t:InRule>`__ ->
`InRule <Data-InRules.html#t:InRule>`__

toString :: `InRule <Data-InRules.html#t:InRule>`__ -> String

Renders InRule to String.

Pretty print
============

pprint :: `InRule <Data-InRules.html#t:InRule>`__ -> IO ()

Pretty-prints InRule.

pprint' :: String -> Integer -> `InRule <Data-InRules.html#t:InRule>`__
-> String

pprints :: [`InRule <Data-InRules.html#t:InRule>`__\ ] -> IO ()

Pretty-prints InRules.

escInStr :: String -> String

escInChar :: Char -> String

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
