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
|Binary [InRule](Data-InRules.html#t:InRule)| |
|Arbitrary [InRule](Data-InRules.html#t:InRule)| |
|Serialize [InRule](Data-InRules.html#t:InRule)| |
|[FromInRule](Data-InRules.html#t:FromInRule) [InRule](Data-InRules.html#t:InRule)| |
|[ToInRule](Data-InRules.html#t:ToInRule) [InRule](Data-InRules.html#t:InRule)| |
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

 

[ToInRule](Data-InRules.html#t:ToInRule) UTCTime

 

[ToInRule](Data-InRules.html#t:ToInRule) Day

 

[ToInRule](Data-InRules.html#t:ToInRule) [SqlValue](Data-SqlTransaction.html#t:SqlValue)

Renders InRule to String.

[ToInRule](Data-InRules.html#t:ToInRule) LocalTime

 

[ToInRule](Data-InRules.html#t:ToInRule) ByteString

 

[ToInRule](Data-InRules.html#t:ToInRule) ByteString

 

[ToInRule](Data-InRules.html#t:ToInRule) TimeOfDay

 

[ToInRule](Data-InRules.html#t:ToInRule) Value

 

[ToInRule](Data-InRules.html#t:ToInRule) [InRule](Data-InRules.html#t:InRule)

 

[ToInRule](Data-InRules.html#t:ToInRule) [Data](Data-DataPack.html#t:Data)

 

[ToInRule](Data-InRules.html#t:ToInRule) [Event](Data-Event.html#t:Event)

 

[ToInRule](Data-InRules.html#t:ToInRule) [Account](Model-Account.html#t:Account)

 

[ToInRule](Data-InRules.html#t:ToInRule) [Transaction](Model-Transaction.html#t:Transaction)

 

[ToInRule](Data-InRules.html#t:ToInRule) [Escrow](Model-Escrow.html#t:Escrow)

 

[ToInRule](Data-InRules.html#t:ToInRule) [DiamondTransaction](Model-Diamonds.html#t:DiamondTransaction)

 

[ToInRule](Data-InRules.html#t:ToInRule) [AccountProfile](Model-AccountProfile.html#t:AccountProfile)

 

[ToInRule](Data-InRules.html#t:ToInRule) [AccountProfileMin](Model-AccountProfileMin.html#t:AccountProfileMin)

 

[ToInRule](Data-InRules.html#t:ToInRule) [Car](Model-Car.html#t:Car)

 

[ToInRule](Data-InRules.html#t:ToInRule) [Car3dModel](Model-Car3dModel.html#t:Car3dModel)

 

[ToInRule](Data-InRules.html#t:ToInRule) [CarInGarage](Model-CarInGarage.html#t:CarInGarage)

 

[ToInRule](Data-InRules.html#t:ToInRule) [CarInstance](Model-CarInstance.html#t:CarInstance)

 

[ToInRule](Data-InRules.html#t:ToInRule) [CarInstanceParts](Model-CarInstanceParts.html#t:CarInstanceParts)

 

[ToInRule](Data-InRules.html#t:ToInRule) [CarMarket](Model-CarMarket.html#t:CarMarket)

 

[ToInRule](Data-InRules.html#t:ToInRule) [CarMinimal](Model-CarMinimal.html#t:CarMinimal)

 

[ToInRule](Data-InRules.html#t:ToInRule) [RaceParticipant](Data-RaceParticipant.html#t:RaceParticipant)

 

[ToInRule](Data-InRules.html#t:ToInRule) [TrackTime](Model-TrackTime.html#t:TrackTime)

 

[ToInRule](Data-InRules.html#t:ToInRule) [CarOptions](Model-CarOptions.html#t:CarOptions)

 

[ToInRule](Data-InRules.html#t:ToInRule) [CarOptionsExtended](Model-CarOptionsExtended.html#t:CarOptionsExtended)

 

[ToInRule](Data-InRules.html#t:ToInRule) [CarOwners](Model-CarOwners.html#t:CarOwners)

 

[ToInRule](Data-InRules.html#t:ToInRule) [CarStockPart](Model-CarStockParts.html#t:CarStockPart)

 

[ToInRule](Data-InRules.html#t:ToInRule) [Challenge](Model-Challenge.html#t:Challenge)

 

[ToInRule](Data-InRules.html#t:ToInRule) [ChallengeAccept](Model-ChallengeAccept.html#t:ChallengeAccept)

 

[ToInRule](Data-InRules.html#t:ToInRule) [ChallengeExtended](Model-ChallengeExtended.html#t:ChallengeExtended)

 

[ToInRule](Data-InRules.html#t:ToInRule) [ChallengeType](Model-ChallengeType.html#t:ChallengeType)

 

[ToInRule](Data-InRules.html#t:ToInRule) [City](Model-City.html#t:City)

 

[ToInRule](Data-InRules.html#t:ToInRule) [Config](Model-Config.html#t:Config)

 

[ToInRule](Data-InRules.html#t:ToInRule) [Continent](Model-Continent.html#t:Continent)

 

[ToInRule](Data-InRules.html#t:ToInRule) [EventStream](Model-EventStream.html#t:EventStream)

 

[ToInRule](Data-InRules.html#t:ToInRule) [Garage](Model-Garage.html#t:Garage)

 

[ToInRule](Data-InRules.html#t:ToInRule) [GaragePart](Model-GarageParts.html#t:GaragePart)

 

[ToInRule](Data-InRules.html#t:ToInRule) [GarageReport](Model-GarageReport.html#t:GarageReport)

 

[ToInRule](Data-InRules.html#t:ToInRule) [GarageReportInsert](Model-GarageReportInsert.html#t:GarageReportInsert)

 

[ToInRule](Data-InRules.html#t:ToInRule) [GeneralReport](Model-GeneralReport.html#t:GeneralReport)

 

[ToInRule](Data-InRules.html#t:ToInRule) [Manufacturer](Model-Manufacturer.html#t:Manufacturer)

 

[ToInRule](Data-InRules.html#t:ToInRule) [ManufacturerMarket](Model-ManufacturerMarket.html#t:ManufacturerMarket)

 

[ToInRule](Data-InRules.html#t:ToInRule) [MarketCarInstanceParts](Model-MarketCarInstanceParts.html#t:MarketCarInstanceParts)

 

[ToInRule](Data-InRules.html#t:ToInRule) [MarketItem](Model-MarketItem.html#t:MarketItem)

 

[ToInRule](Data-InRules.html#t:ToInRule) [MarketPartType](Model-MarketPartType.html#t:MarketPartType)

 

[ToInRule](Data-InRules.html#t:ToInRule) [MarketPlace](Model-MarketPlace.html#t:MarketPlace)

 

[ToInRule](Data-InRules.html#t:ToInRule) [MarketPlaceCar](Model-MarketPlaceCar.html#t:MarketPlaceCar)

 

[ToInRule](Data-InRules.html#t:ToInRule) [MenuModel](Model-MenuModel.html#t:MenuModel)

 

[ToInRule](Data-InRules.html#t:ToInRule) [Part](Model-Part.html#t:Part)

 

[ToInRule](Data-InRules.html#t:ToInRule) [PartDetails](Model-PartDetails.html#t:PartDetails)

 

[ToInRule](Data-InRules.html#t:ToInRule) [RaceRewards](Data-RaceReward.html#t:RaceRewards)

 

[ToInRule](Data-InRules.html#t:ToInRule) [RaceReward](Model-RaceReward.html#t:RaceReward)

 

[ToInRule](Data-InRules.html#t:ToInRule) [Tournament](Model-Tournament.html#t:Tournament)

 

[ToInRule](Data-InRules.html#t:ToInRule) [TournamentExtended](Model-TournamentExtended.html#t:TournamentExtended)

 

[ToInRule](Data-InRules.html#t:ToInRule) [PartInstance](Model-PartInstance.html#t:PartInstance)

 

[ToInRule](Data-InRules.html#t:ToInRule) [PartMarket](Model-PartMarket.html#t:PartMarket)

 

[ToInRule](Data-InRules.html#t:ToInRule) [PartMarketPlaceType](Model-PartMarketPlaceType.html#t:PartMarketPlaceType)

 

[ToInRule](Data-InRules.html#t:ToInRule) [PartMarketType](Model-PartMarketType.html#t:PartMarketType)

 

[ToInRule](Data-InRules.html#t:ToInRule) [PartType](Model-PartType.html#t:PartType)

 

[ToInRule](Data-InRules.html#t:ToInRule) [Personnel](Model-Personnel.html#t:Personnel)

 

[ToInRule](Data-InRules.html#t:ToInRule) [PersonnelDetails](Model-PersonnelDetails.html#t:PersonnelDetails)

 

[ToInRule](Data-InRules.html#t:ToInRule) [PersonnelInstance](Model-PersonnelInstance.html#t:PersonnelInstance)

 

[ToInRule](Data-InRules.html#t:ToInRule) [PersonnelInstanceDetails](Model-PersonnelInstanceDetails.html#t:PersonnelInstanceDetails)

 

[ToInRule](Data-InRules.html#t:ToInRule) [PersonnelReport](Model-PersonnelReport.html#t:PersonnelReport)

 

[ToInRule](Data-InRules.html#t:ToInRule) [PersonnelTaskType](Model-PersonnelTaskType.html#t:PersonnelTaskType)

 

[ToInRule](Data-InRules.html#t:ToInRule) [PreLetter](Model-PreLetter.html#t:PreLetter)

 

[ToInRule](Data-InRules.html#t:ToInRule) [Type](Model-Report.html#t:Type)

 

[ToInRule](Data-InRules.html#t:ToInRule) [Report](Model-Report.html#t:Report)

 

[ToInRule](Data-InRules.html#t:ToInRule) [RewardLog](Model-RewardLog.html#t:RewardLog)

 

[ToInRule](Data-InRules.html#t:ToInRule) [RewardLogEvent](Model-RewardLogEvent.html#t:RewardLogEvent)

 

[ToInRule](Data-InRules.html#t:ToInRule) [ShopReport](Model-ShopReport.html#t:ShopReport)

 

[ToInRule](Data-InRules.html#t:ToInRule) [Support](Model-Support.html#t:Support)

 

[ToInRule](Data-InRules.html#t:ToInRule) [TrackCity](Model-TrackCity.html#t:TrackCity)

 

[ToInRule](Data-InRules.html#t:ToInRule) [TrackContinent](Model-TrackContinent.html#t:TrackContinent)

 

[ToInRule](Data-InRules.html#t:ToInRule) [TrackDetails](Model-TrackDetails.html#t:TrackDetails)

 

[ToInRule](Data-InRules.html#t:ToInRule) [TrackMaster](Model-TrackMaster.html#t:TrackMaster)

 

[ToInRule](Data-InRules.html#t:ToInRule) [TravelReport](Model-TravelReport.html#t:TravelReport)

 

[ToInRule](Data-InRules.html#t:ToInRule) [Notification](Model-Notification.html#t:Notification)

 

[ToInRule](Data-InRules.html#t:ToInRule) [Task](Model-Task.html#t:Task)

 

[ToInRule](Data-InRules.html#t:ToInRule) [CarReadyState](Data-CarReady.html#t:CarReadyState)

 

[ToInRule](Data-InRules.html#t:ToInRule) [RaceSectionPerformance](Data-RaceSectionPerformance.html#t:RaceSectionPerformance)

 

[ToInRule](Data-InRules.html#t:ToInRule) [TaskTrigger](Model-TaskTrigger.html#t:TaskTrigger)

 

[ToInRule](Data-InRules.html#t:ToInRule) [TaskLog](Model-TaskLog.html#t:TaskLog)

 

[ToInRule](Data-InRules.html#t:ToInRule) [Action](Model-Action.html#t:Action)

 

[ToInRule](Data-InRules.html#t:ToInRule) [RewardLogEvents](Model-RewardLogEvents.html#t:RewardLogEvents)

 

[ToInRule](Data-InRules.html#t:ToInRule) [Rule](Model-Rule.html#t:Rule)

 

[ToInRule](Data-InRules.html#t:ToInRule) [RuleReward](Model-RuleReward.html#t:RuleReward)

 

[ToInRule](Data-InRules.html#t:ToInRule) [Prize](Data-Reward.html#t:Prize)

 

[ToInRule](Data-InRules.html#t:ToInRule) [Reward](Data-Reward.html#t:Reward)

 

[ToInRule](Data-InRules.html#t:ToInRule) [Rewards](Data-Reward.html#t:Rewards)

 

[ToInRule](Data-InRules.html#t:ToInRule) Box

 

[ToInRule](Data-InRules.html#t:ToInRule) ComposeMap

 

[ToInRule](Data-InRules.html#t:ToInRule) [SectionResult](Data-RacingNew.html#t:SectionResult)

 

[ToInRule](Data-InRules.html#t:ToInRule) [RaceResult](Data-RacingNew.html#t:RaceResult)

 

[ToInRule](Data-InRules.html#t:ToInRule) [RaceData](Data-RacingNew.html#t:RaceData)

 

[ToInRule](Data-InRules.html#t:ToInRule) CarBaseParameters

 

[ToInRule](Data-InRules.html#t:ToInRule) CarDerivedParameters

 

[ToInRule](Data-InRules.html#t:ToInRule) PartParameter

 

[ToInRule](Data-InRules.html#t:ToInRule) PreviewPart

 

[ToInRule](Data-InRules.html#t:ToInRule) [Race](Model-Race.html#t:Race)

 

[ToInRule](Data-InRules.html#t:ToInRule) [RaceDetails](Model-RaceDetails.html#t:RaceDetails)

 

[ToInRule](Data-InRules.html#t:ToInRule) SectionResult

 

[ToInRule](Data-InRules.html#t:ToInRule) RaceResult

 

[ToInRule](Data-InRules.html#t:ToInRule) RaceParticipant

 

[ToInRule](Data-InRules.html#t:ToInRule) RaceRewards

 

[ToInRule](Data-InRules.html#t:ToInRule) RaceData

 

[ToInRule](Data-InRules.html#t:ToInRule) [TournamentPlayer](Model-TournamentPlayers.html#t:TournamentPlayer)

 

[ToInRule](Data-InRules.html#t:ToInRule) [TournamentResult](Model-TournamentResult.html#t:TournamentResult)

 

[ToInRule](Data-InRules.html#t:ToInRule) [TournamentReport](Model-TournamentReport.html#t:TournamentReport)

 

[ToInRule](Data-InRules.html#t:ToInRule) [NotificationParam](Notifications.html#t:NotificationParam)

 

[ToInRule](Data-InRules.html#t:ToInRule) RaceType

 

[ToInRule](Data-InRules.html#t:ToInRule) RoundResult

 

[ToInRule](Data-InRules.html#t:ToInRule) TournamentFullData

 

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

 

[FromInRule](Data-InRules.html#t:FromInRule) UTCTime

 

[FromInRule](Data-InRules.html#t:FromInRule) Day

 

[FromInRule](Data-InRules.html#t:FromInRule) [SqlValue](Data-SqlTransaction.html#t:SqlValue)

 

[FromInRule](Data-InRules.html#t:FromInRule) LocalTime

 

[FromInRule](Data-InRules.html#t:FromInRule) ByteString

 

[FromInRule](Data-InRules.html#t:FromInRule) ByteString

 

[FromInRule](Data-InRules.html#t:FromInRule) TimeOfDay

 

[FromInRule](Data-InRules.html#t:FromInRule) Value

 

[FromInRule](Data-InRules.html#t:FromInRule) [Readable](Data-InRules.html#t:Readable)

Dirty fallback strategy

[FromInRule](Data-InRules.html#t:FromInRule) [InRule](Data-InRules.html#t:InRule)

 

[FromInRule](Data-InRules.html#t:FromInRule) [Data](Data-DataPack.html#t:Data)

 

[FromInRule](Data-InRules.html#t:FromInRule) [Event](Data-Event.html#t:Event)

 

[FromInRule](Data-InRules.html#t:FromInRule) [Account](Model-Account.html#t:Account)

 

[FromInRule](Data-InRules.html#t:FromInRule) [Transaction](Model-Transaction.html#t:Transaction)

 

[FromInRule](Data-InRules.html#t:FromInRule) [Escrow](Model-Escrow.html#t:Escrow)

 

[FromInRule](Data-InRules.html#t:FromInRule) [DiamondTransaction](Model-Diamonds.html#t:DiamondTransaction)

 

[FromInRule](Data-InRules.html#t:FromInRule) [AccountProfile](Model-AccountProfile.html#t:AccountProfile)

 

[FromInRule](Data-InRules.html#t:FromInRule) [AccountProfileMin](Model-AccountProfileMin.html#t:AccountProfileMin)

 

[FromInRule](Data-InRules.html#t:FromInRule) [Car](Model-Car.html#t:Car)

 

[FromInRule](Data-InRules.html#t:FromInRule) [Car3dModel](Model-Car3dModel.html#t:Car3dModel)

 

[FromInRule](Data-InRules.html#t:FromInRule) [CarInGarage](Model-CarInGarage.html#t:CarInGarage)

 

[FromInRule](Data-InRules.html#t:FromInRule) [CarInstance](Model-CarInstance.html#t:CarInstance)

 

[FromInRule](Data-InRules.html#t:FromInRule) [CarInstanceParts](Model-CarInstanceParts.html#t:CarInstanceParts)

 

[FromInRule](Data-InRules.html#t:FromInRule) [CarMarket](Model-CarMarket.html#t:CarMarket)

 

[FromInRule](Data-InRules.html#t:FromInRule) [CarMinimal](Model-CarMinimal.html#t:CarMinimal)

 

[FromInRule](Data-InRules.html#t:FromInRule) [RaceParticipant](Data-RaceParticipant.html#t:RaceParticipant)

 

[FromInRule](Data-InRules.html#t:FromInRule) [TrackTime](Model-TrackTime.html#t:TrackTime)

 

[FromInRule](Data-InRules.html#t:FromInRule) [CarOptions](Model-CarOptions.html#t:CarOptions)

 

[FromInRule](Data-InRules.html#t:FromInRule) [CarOptionsExtended](Model-CarOptionsExtended.html#t:CarOptionsExtended)

 

[FromInRule](Data-InRules.html#t:FromInRule) [CarOwners](Model-CarOwners.html#t:CarOwners)

 

[FromInRule](Data-InRules.html#t:FromInRule) [CarStockPart](Model-CarStockParts.html#t:CarStockPart)

 

[FromInRule](Data-InRules.html#t:FromInRule) [Challenge](Model-Challenge.html#t:Challenge)

 

[FromInRule](Data-InRules.html#t:FromInRule) [ChallengeAccept](Model-ChallengeAccept.html#t:ChallengeAccept)

 

[FromInRule](Data-InRules.html#t:FromInRule) [ChallengeExtended](Model-ChallengeExtended.html#t:ChallengeExtended)

 

[FromInRule](Data-InRules.html#t:FromInRule) [ChallengeType](Model-ChallengeType.html#t:ChallengeType)

 

[FromInRule](Data-InRules.html#t:FromInRule) [City](Model-City.html#t:City)

 

[FromInRule](Data-InRules.html#t:FromInRule) [Config](Model-Config.html#t:Config)

 

[FromInRule](Data-InRules.html#t:FromInRule) [Continent](Model-Continent.html#t:Continent)

 

[FromInRule](Data-InRules.html#t:FromInRule) [EventStream](Model-EventStream.html#t:EventStream)

 

[FromInRule](Data-InRules.html#t:FromInRule) [Garage](Model-Garage.html#t:Garage)

 

[FromInRule](Data-InRules.html#t:FromInRule) [GaragePart](Model-GarageParts.html#t:GaragePart)

 

[FromInRule](Data-InRules.html#t:FromInRule) [GarageReport](Model-GarageReport.html#t:GarageReport)

 

[FromInRule](Data-InRules.html#t:FromInRule) [GarageReportInsert](Model-GarageReportInsert.html#t:GarageReportInsert)

 

[FromInRule](Data-InRules.html#t:FromInRule) [GeneralReport](Model-GeneralReport.html#t:GeneralReport)

 

[FromInRule](Data-InRules.html#t:FromInRule) [Manufacturer](Model-Manufacturer.html#t:Manufacturer)

 

[FromInRule](Data-InRules.html#t:FromInRule) [ManufacturerMarket](Model-ManufacturerMarket.html#t:ManufacturerMarket)

 

[FromInRule](Data-InRules.html#t:FromInRule) [MarketCarInstanceParts](Model-MarketCarInstanceParts.html#t:MarketCarInstanceParts)

 

[FromInRule](Data-InRules.html#t:FromInRule) [MarketItem](Model-MarketItem.html#t:MarketItem)

 

[FromInRule](Data-InRules.html#t:FromInRule) [MarketPartType](Model-MarketPartType.html#t:MarketPartType)

 

[FromInRule](Data-InRules.html#t:FromInRule) [MarketPlace](Model-MarketPlace.html#t:MarketPlace)

 

[FromInRule](Data-InRules.html#t:FromInRule) [MarketPlaceCar](Model-MarketPlaceCar.html#t:MarketPlaceCar)

 

[FromInRule](Data-InRules.html#t:FromInRule) [MenuModel](Model-MenuModel.html#t:MenuModel)

 

[FromInRule](Data-InRules.html#t:FromInRule) [Part](Model-Part.html#t:Part)

 

[FromInRule](Data-InRules.html#t:FromInRule) [PartDetails](Model-PartDetails.html#t:PartDetails)

 

[FromInRule](Data-InRules.html#t:FromInRule) [RaceRewards](Data-RaceReward.html#t:RaceRewards)

 

[FromInRule](Data-InRules.html#t:FromInRule) [RaceReward](Model-RaceReward.html#t:RaceReward)

 

[FromInRule](Data-InRules.html#t:FromInRule) [Tournament](Model-Tournament.html#t:Tournament)

 

[FromInRule](Data-InRules.html#t:FromInRule) [TournamentExtended](Model-TournamentExtended.html#t:TournamentExtended)

 

[FromInRule](Data-InRules.html#t:FromInRule) [PartInstance](Model-PartInstance.html#t:PartInstance)

 

[FromInRule](Data-InRules.html#t:FromInRule) [PartMarket](Model-PartMarket.html#t:PartMarket)

 

[FromInRule](Data-InRules.html#t:FromInRule) [PartMarketPlaceType](Model-PartMarketPlaceType.html#t:PartMarketPlaceType)

 

[FromInRule](Data-InRules.html#t:FromInRule) [PartMarketType](Model-PartMarketType.html#t:PartMarketType)

 

[FromInRule](Data-InRules.html#t:FromInRule) [PartType](Model-PartType.html#t:PartType)

 

[FromInRule](Data-InRules.html#t:FromInRule) [Personnel](Model-Personnel.html#t:Personnel)

 

[FromInRule](Data-InRules.html#t:FromInRule) [PersonnelDetails](Model-PersonnelDetails.html#t:PersonnelDetails)

 

[FromInRule](Data-InRules.html#t:FromInRule) [PersonnelInstance](Model-PersonnelInstance.html#t:PersonnelInstance)

 

[FromInRule](Data-InRules.html#t:FromInRule) [PersonnelInstanceDetails](Model-PersonnelInstanceDetails.html#t:PersonnelInstanceDetails)

 

[FromInRule](Data-InRules.html#t:FromInRule) [PersonnelReport](Model-PersonnelReport.html#t:PersonnelReport)

 

[FromInRule](Data-InRules.html#t:FromInRule) [PersonnelTaskType](Model-PersonnelTaskType.html#t:PersonnelTaskType)

 

[FromInRule](Data-InRules.html#t:FromInRule) [PreLetter](Model-PreLetter.html#t:PreLetter)

 

[FromInRule](Data-InRules.html#t:FromInRule) [Type](Model-Report.html#t:Type)

 

[FromInRule](Data-InRules.html#t:FromInRule) [Report](Model-Report.html#t:Report)

 

[FromInRule](Data-InRules.html#t:FromInRule) [RewardLog](Model-RewardLog.html#t:RewardLog)

 

[FromInRule](Data-InRules.html#t:FromInRule) [RewardLogEvent](Model-RewardLogEvent.html#t:RewardLogEvent)

 

[FromInRule](Data-InRules.html#t:FromInRule) [ShopReport](Model-ShopReport.html#t:ShopReport)

 

[FromInRule](Data-InRules.html#t:FromInRule) [Support](Model-Support.html#t:Support)

 

[FromInRule](Data-InRules.html#t:FromInRule) [TrackCity](Model-TrackCity.html#t:TrackCity)

 

[FromInRule](Data-InRules.html#t:FromInRule) [TrackContinent](Model-TrackContinent.html#t:TrackContinent)

 

[FromInRule](Data-InRules.html#t:FromInRule) [TrackDetails](Model-TrackDetails.html#t:TrackDetails)

 

[FromInRule](Data-InRules.html#t:FromInRule) [TrackMaster](Model-TrackMaster.html#t:TrackMaster)

 

[FromInRule](Data-InRules.html#t:FromInRule) [TravelReport](Model-TravelReport.html#t:TravelReport)

 

[FromInRule](Data-InRules.html#t:FromInRule) [Notification](Model-Notification.html#t:Notification)

 

[FromInRule](Data-InRules.html#t:FromInRule) [Task](Model-Task.html#t:Task)

 

[FromInRule](Data-InRules.html#t:FromInRule) [CarReadyState](Data-CarReady.html#t:CarReadyState)

 

[FromInRule](Data-InRules.html#t:FromInRule) [RaceSectionPerformance](Data-RaceSectionPerformance.html#t:RaceSectionPerformance)

 

[FromInRule](Data-InRules.html#t:FromInRule) [TaskTrigger](Model-TaskTrigger.html#t:TaskTrigger)

 

[FromInRule](Data-InRules.html#t:FromInRule) [TaskLog](Model-TaskLog.html#t:TaskLog)

 

[FromInRule](Data-InRules.html#t:FromInRule) [Action](Model-Action.html#t:Action)

 

[FromInRule](Data-InRules.html#t:FromInRule) [RewardLogEvents](Model-RewardLogEvents.html#t:RewardLogEvents)

 

[FromInRule](Data-InRules.html#t:FromInRule) [Rule](Model-Rule.html#t:Rule)

 

[FromInRule](Data-InRules.html#t:FromInRule) [RuleReward](Model-RuleReward.html#t:RuleReward)

 

[FromInRule](Data-InRules.html#t:FromInRule) [SectionResult](Data-RacingNew.html#t:SectionResult)

 

[FromInRule](Data-InRules.html#t:FromInRule) [RaceResult](Data-RacingNew.html#t:RaceResult)

 

[FromInRule](Data-InRules.html#t:FromInRule) [RaceData](Data-RacingNew.html#t:RaceData)

 

[FromInRule](Data-InRules.html#t:FromInRule) CarBaseParameters

 

[FromInRule](Data-InRules.html#t:FromInRule) CarDerivedParameters

 

[FromInRule](Data-InRules.html#t:FromInRule) PartParameter

 

[FromInRule](Data-InRules.html#t:FromInRule) PreviewPart

 

[FromInRule](Data-InRules.html#t:FromInRule) [Race](Model-Race.html#t:Race)

 

[FromInRule](Data-InRules.html#t:FromInRule) [RaceDetails](Model-RaceDetails.html#t:RaceDetails)

 

[FromInRule](Data-InRules.html#t:FromInRule) SectionResult

 

[FromInRule](Data-InRules.html#t:FromInRule) RaceResult

 

[FromInRule](Data-InRules.html#t:FromInRule) RaceParticipant

 

[FromInRule](Data-InRules.html#t:FromInRule) RaceRewards

 

[FromInRule](Data-InRules.html#t:FromInRule) RaceData

 

[FromInRule](Data-InRules.html#t:FromInRule) [TournamentPlayer](Model-TournamentPlayers.html#t:TournamentPlayer)

 

[FromInRule](Data-InRules.html#t:FromInRule) [TournamentResult](Model-TournamentResult.html#t:TournamentResult)

 

[FromInRule](Data-InRules.html#t:FromInRule) [TournamentReport](Model-TournamentReport.html#t:TournamentReport)

 

[FromInRule](Data-InRules.html#t:FromInRule) RoundResult

 

[FromInRule](Data-InRules.html#t:FromInRule) TournamentFullData

 

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
