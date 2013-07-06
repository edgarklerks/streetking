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
  Binary [InRule](Data-Conversion.html#t:InRule)                                                                 
  Arbitrary [InRule](Data-Conversion.html#t:InRule)                                                              
  Serialize [InRule](Data-Conversion.html#t:InRule)                                                              
  [FromInRule](Data-Conversion.html#t:FromInRule) [InRule](Data-Conversion.html#t:InRule)                        
  [ToInRule](Data-Conversion.html#t:ToInRule) [InRule](Data-Conversion.html#t:InRule)                            
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

 

[ToInRule](Data-Conversion.html#t:ToInRule) UTCTime

 

[ToInRule](Data-Conversion.html#t:ToInRule) Day

 

[ToInRule](Data-Conversion.html#t:ToInRule)
[SqlValue](Data-SqlTransaction.html#t:SqlValue)

Renders InRule to String.

[ToInRule](Data-Conversion.html#t:ToInRule) LocalTime

 

[ToInRule](Data-Conversion.html#t:ToInRule) ByteString

 

[ToInRule](Data-Conversion.html#t:ToInRule) ByteString

 

[ToInRule](Data-Conversion.html#t:ToInRule) TimeOfDay

 

[ToInRule](Data-Conversion.html#t:ToInRule) Value

 

[ToInRule](Data-Conversion.html#t:ToInRule)
[InRule](Data-Conversion.html#t:InRule)

 

[ToInRule](Data-Conversion.html#t:ToInRule)
[Data](Data-DataPack.html#t:Data)

 

[ToInRule](Data-Conversion.html#t:ToInRule)
[Event](Data-Event.html#t:Event)

 

[ToInRule](Data-Conversion.html#t:ToInRule)
[Account](Model-Account.html#t:Account)

 

[ToInRule](Data-Conversion.html#t:ToInRule)
[Transaction](Model-Transaction.html#t:Transaction)

 

[ToInRule](Data-Conversion.html#t:ToInRule)
[Escrow](Model-Escrow.html#t:Escrow)

 

[ToInRule](Data-Conversion.html#t:ToInRule)
[DiamondTransaction](Model-Diamonds.html#t:DiamondTransaction)

 

[ToInRule](Data-Conversion.html#t:ToInRule)
[AccountProfile](Model-AccountProfile.html#t:AccountProfile)

 

[ToInRule](Data-Conversion.html#t:ToInRule)
[AccountProfileMin](Model-AccountProfileMin.html#t:AccountProfileMin)

 

[ToInRule](Data-Conversion.html#t:ToInRule) [Car](Model-Car.html#t:Car)

 

[ToInRule](Data-Conversion.html#t:ToInRule)
[Car3dModel](Model-Car3dModel.html#t:Car3dModel)

 

[ToInRule](Data-Conversion.html#t:ToInRule)
[CarInGarage](Model-CarInGarage.html#t:CarInGarage)

 

[ToInRule](Data-Conversion.html#t:ToInRule)
[CarInstance](Model-CarInstance.html#t:CarInstance)

 

[ToInRule](Data-Conversion.html#t:ToInRule)
[CarInstanceParts](Model-CarInstanceParts.html#t:CarInstanceParts)

 

[ToInRule](Data-Conversion.html#t:ToInRule)
[CarMarket](Model-CarMarket.html#t:CarMarket)

 

[ToInRule](Data-Conversion.html#t:ToInRule)
[CarMinimal](Model-CarMinimal.html#t:CarMinimal)

 

[ToInRule](Data-Conversion.html#t:ToInRule)
[RaceParticipant](Data-RaceParticipant.html#t:RaceParticipant)

 

[ToInRule](Data-Conversion.html#t:ToInRule)
[TrackTime](Model-TrackTime.html#t:TrackTime)

 

[ToInRule](Data-Conversion.html#t:ToInRule)
[CarOptions](Model-CarOptions.html#t:CarOptions)

 

[ToInRule](Data-Conversion.html#t:ToInRule)
[CarOptionsExtended](Model-CarOptionsExtended.html#t:CarOptionsExtended)

 

[ToInRule](Data-Conversion.html#t:ToInRule)
[CarOwners](Model-CarOwners.html#t:CarOwners)

 

[ToInRule](Data-Conversion.html#t:ToInRule)
[CarStockPart](Model-CarStockParts.html#t:CarStockPart)

 

[ToInRule](Data-Conversion.html#t:ToInRule)
[Challenge](Model-Challenge.html#t:Challenge)

 

[ToInRule](Data-Conversion.html#t:ToInRule)
[ChallengeAccept](Model-ChallengeAccept.html#t:ChallengeAccept)

 

[ToInRule](Data-Conversion.html#t:ToInRule)
[ChallengeExtended](Model-ChallengeExtended.html#t:ChallengeExtended)

 

[ToInRule](Data-Conversion.html#t:ToInRule)
[ChallengeType](Model-ChallengeType.html#t:ChallengeType)

 

[ToInRule](Data-Conversion.html#t:ToInRule)
[City](Model-City.html#t:City)

 

[ToInRule](Data-Conversion.html#t:ToInRule)
[Config](Model-Config.html#t:Config)

 

[ToInRule](Data-Conversion.html#t:ToInRule)
[Continent](Model-Continent.html#t:Continent)

 

[ToInRule](Data-Conversion.html#t:ToInRule)
[EventStream](Model-EventStream.html#t:EventStream)

 

[ToInRule](Data-Conversion.html#t:ToInRule)
[Garage](Model-Garage.html#t:Garage)

 

[ToInRule](Data-Conversion.html#t:ToInRule)
[GaragePart](Model-GarageParts.html#t:GaragePart)

 

[ToInRule](Data-Conversion.html#t:ToInRule)
[GarageReport](Model-GarageReport.html#t:GarageReport)

 

[ToInRule](Data-Conversion.html#t:ToInRule)
[GarageReportInsert](Model-GarageReportInsert.html#t:GarageReportInsert)

 

[ToInRule](Data-Conversion.html#t:ToInRule)
[GeneralReport](Model-GeneralReport.html#t:GeneralReport)

 

[ToInRule](Data-Conversion.html#t:ToInRule)
[Manufacturer](Model-Manufacturer.html#t:Manufacturer)

 

[ToInRule](Data-Conversion.html#t:ToInRule)
[ManufacturerMarket](Model-ManufacturerMarket.html#t:ManufacturerMarket)

 

[ToInRule](Data-Conversion.html#t:ToInRule)
[MarketCarInstanceParts](Model-MarketCarInstanceParts.html#t:MarketCarInstanceParts)

 

[ToInRule](Data-Conversion.html#t:ToInRule)
[MarketItem](Model-MarketItem.html#t:MarketItem)

 

[ToInRule](Data-Conversion.html#t:ToInRule)
[MarketPartType](Model-MarketPartType.html#t:MarketPartType)

 

[ToInRule](Data-Conversion.html#t:ToInRule)
[MarketPlace](Model-MarketPlace.html#t:MarketPlace)

 

[ToInRule](Data-Conversion.html#t:ToInRule)
[MarketPlaceCar](Model-MarketPlaceCar.html#t:MarketPlaceCar)

 

[ToInRule](Data-Conversion.html#t:ToInRule)
[MenuModel](Model-MenuModel.html#t:MenuModel)

 

[ToInRule](Data-Conversion.html#t:ToInRule)
[Part](Model-Part.html#t:Part)

 

[ToInRule](Data-Conversion.html#t:ToInRule)
[PartDetails](Model-PartDetails.html#t:PartDetails)

 

[ToInRule](Data-Conversion.html#t:ToInRule)
[RaceRewards](Data-RaceReward.html#t:RaceRewards)

 

[ToInRule](Data-Conversion.html#t:ToInRule)
[RaceReward](Model-RaceReward.html#t:RaceReward)

 

[ToInRule](Data-Conversion.html#t:ToInRule)
[Tournament](Model-Tournament.html#t:Tournament)

 

[ToInRule](Data-Conversion.html#t:ToInRule)
[TournamentExtended](Model-TournamentExtended.html#t:TournamentExtended)

 

[ToInRule](Data-Conversion.html#t:ToInRule)
[PartInstance](Model-PartInstance.html#t:PartInstance)

 

[ToInRule](Data-Conversion.html#t:ToInRule)
[PartMarket](Model-PartMarket.html#t:PartMarket)

 

[ToInRule](Data-Conversion.html#t:ToInRule)
[PartMarketPlaceType](Model-PartMarketPlaceType.html#t:PartMarketPlaceType)

 

[ToInRule](Data-Conversion.html#t:ToInRule)
[PartMarketType](Model-PartMarketType.html#t:PartMarketType)

 

[ToInRule](Data-Conversion.html#t:ToInRule)
[PartType](Model-PartType.html#t:PartType)

 

[ToInRule](Data-Conversion.html#t:ToInRule)
[Personnel](Model-Personnel.html#t:Personnel)

 

[ToInRule](Data-Conversion.html#t:ToInRule)
[PersonnelDetails](Model-PersonnelDetails.html#t:PersonnelDetails)

 

[ToInRule](Data-Conversion.html#t:ToInRule)
[PersonnelInstance](Model-PersonnelInstance.html#t:PersonnelInstance)

 

[ToInRule](Data-Conversion.html#t:ToInRule)
[PersonnelInstanceDetails](Model-PersonnelInstanceDetails.html#t:PersonnelInstanceDetails)

 

[ToInRule](Data-Conversion.html#t:ToInRule)
[PersonnelReport](Model-PersonnelReport.html#t:PersonnelReport)

 

[ToInRule](Data-Conversion.html#t:ToInRule)
[PersonnelTaskType](Model-PersonnelTaskType.html#t:PersonnelTaskType)

 

[ToInRule](Data-Conversion.html#t:ToInRule)
[PreLetter](Model-PreLetter.html#t:PreLetter)

 

[ToInRule](Data-Conversion.html#t:ToInRule)
[Type](Model-Report.html#t:Type)

 

[ToInRule](Data-Conversion.html#t:ToInRule)
[Report](Model-Report.html#t:Report)

 

[ToInRule](Data-Conversion.html#t:ToInRule)
[RewardLog](Model-RewardLog.html#t:RewardLog)

 

[ToInRule](Data-Conversion.html#t:ToInRule)
[RewardLogEvent](Model-RewardLogEvent.html#t:RewardLogEvent)

 

[ToInRule](Data-Conversion.html#t:ToInRule)
[ShopReport](Model-ShopReport.html#t:ShopReport)

 

[ToInRule](Data-Conversion.html#t:ToInRule)
[Support](Model-Support.html#t:Support)

 

[ToInRule](Data-Conversion.html#t:ToInRule)
[TrackCity](Model-TrackCity.html#t:TrackCity)

 

[ToInRule](Data-Conversion.html#t:ToInRule)
[TrackContinent](Model-TrackContinent.html#t:TrackContinent)

 

[ToInRule](Data-Conversion.html#t:ToInRule)
[TrackDetails](Model-TrackDetails.html#t:TrackDetails)

 

[ToInRule](Data-Conversion.html#t:ToInRule)
[TrackMaster](Model-TrackMaster.html#t:TrackMaster)

 

[ToInRule](Data-Conversion.html#t:ToInRule)
[TravelReport](Model-TravelReport.html#t:TravelReport)

 

[ToInRule](Data-Conversion.html#t:ToInRule)
[Notification](Model-Notification.html#t:Notification)

 

[ToInRule](Data-Conversion.html#t:ToInRule)
[Task](Model-Task.html#t:Task)

 

[ToInRule](Data-Conversion.html#t:ToInRule)
[CarReadyState](Data-CarReady.html#t:CarReadyState)

 

[ToInRule](Data-Conversion.html#t:ToInRule)
[RaceSectionPerformance](Data-RaceSectionPerformance.html#t:RaceSectionPerformance)

 

[ToInRule](Data-Conversion.html#t:ToInRule)
[TaskTrigger](Model-TaskTrigger.html#t:TaskTrigger)

 

[ToInRule](Data-Conversion.html#t:ToInRule)
[TaskLog](Model-TaskLog.html#t:TaskLog)

 

[ToInRule](Data-Conversion.html#t:ToInRule)
[Action](Model-Action.html#t:Action)

 

[ToInRule](Data-Conversion.html#t:ToInRule)
[RewardLogEvents](Model-RewardLogEvents.html#t:RewardLogEvents)

 

[ToInRule](Data-Conversion.html#t:ToInRule)
[Rule](Model-Rule.html#t:Rule)

 

[ToInRule](Data-Conversion.html#t:ToInRule)
[RuleReward](Model-RuleReward.html#t:RuleReward)

 

[ToInRule](Data-Conversion.html#t:ToInRule)
[Prize](Data-Reward.html#t:Prize)

 

[ToInRule](Data-Conversion.html#t:ToInRule)
[Reward](Data-Reward.html#t:Reward)

 

[ToInRule](Data-Conversion.html#t:ToInRule)
[Rewards](Data-Reward.html#t:Rewards)

 

[ToInRule](Data-Conversion.html#t:ToInRule) Box

 

[ToInRule](Data-Conversion.html#t:ToInRule) ComposeMap

 

[ToInRule](Data-Conversion.html#t:ToInRule)
[SectionResult](Data-RacingNew.html#t:SectionResult)

 

[ToInRule](Data-Conversion.html#t:ToInRule)
[RaceResult](Data-RacingNew.html#t:RaceResult)

 

[ToInRule](Data-Conversion.html#t:ToInRule)
[RaceData](Data-RacingNew.html#t:RaceData)

 

[ToInRule](Data-Conversion.html#t:ToInRule) CarBaseParameters

 

[ToInRule](Data-Conversion.html#t:ToInRule) CarDerivedParameters

 

[ToInRule](Data-Conversion.html#t:ToInRule) PartParameter

 

[ToInRule](Data-Conversion.html#t:ToInRule) PreviewPart

 

[ToInRule](Data-Conversion.html#t:ToInRule)
[Race](Model-Race.html#t:Race)

 

[ToInRule](Data-Conversion.html#t:ToInRule)
[RaceDetails](Model-RaceDetails.html#t:RaceDetails)

 

[ToInRule](Data-Conversion.html#t:ToInRule) SectionResult

 

[ToInRule](Data-Conversion.html#t:ToInRule) RaceResult

 

[ToInRule](Data-Conversion.html#t:ToInRule) RaceParticipant

 

[ToInRule](Data-Conversion.html#t:ToInRule) RaceRewards

 

[ToInRule](Data-Conversion.html#t:ToInRule) RaceData

 

[ToInRule](Data-Conversion.html#t:ToInRule)
[TournamentPlayer](Model-TournamentPlayers.html#t:TournamentPlayer)

 

[ToInRule](Data-Conversion.html#t:ToInRule)
[TournamentResult](Model-TournamentResult.html#t:TournamentResult)

 

[ToInRule](Data-Conversion.html#t:ToInRule)
[TournamentReport](Model-TournamentReport.html#t:TournamentReport)

 

[ToInRule](Data-Conversion.html#t:ToInRule)
[NotificationParam](Notifications.html#t:NotificationParam)

 

[ToInRule](Data-Conversion.html#t:ToInRule) RaceType

 

[ToInRule](Data-Conversion.html#t:ToInRule) RoundResult

 

[ToInRule](Data-Conversion.html#t:ToInRule) TournamentFullData

 

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

 

[FromInRule](Data-Conversion.html#t:FromInRule) UTCTime

 

[FromInRule](Data-Conversion.html#t:FromInRule) Day

 

[FromInRule](Data-Conversion.html#t:FromInRule)
[SqlValue](Data-SqlTransaction.html#t:SqlValue)

 

[FromInRule](Data-Conversion.html#t:FromInRule) LocalTime

 

[FromInRule](Data-Conversion.html#t:FromInRule) ByteString

 

[FromInRule](Data-Conversion.html#t:FromInRule) ByteString

 

[FromInRule](Data-Conversion.html#t:FromInRule) TimeOfDay

 

[FromInRule](Data-Conversion.html#t:FromInRule) Value

 

[FromInRule](Data-Conversion.html#t:FromInRule)
[Readable](Data-Conversion.html#t:Readable)

Dirty fallback strategy

[FromInRule](Data-Conversion.html#t:FromInRule)
[InRule](Data-Conversion.html#t:InRule)

 

[FromInRule](Data-Conversion.html#t:FromInRule)
[Data](Data-DataPack.html#t:Data)

 

[FromInRule](Data-Conversion.html#t:FromInRule)
[Event](Data-Event.html#t:Event)

 

[FromInRule](Data-Conversion.html#t:FromInRule)
[Account](Model-Account.html#t:Account)

 

[FromInRule](Data-Conversion.html#t:FromInRule)
[Transaction](Model-Transaction.html#t:Transaction)

 

[FromInRule](Data-Conversion.html#t:FromInRule)
[Escrow](Model-Escrow.html#t:Escrow)

 

[FromInRule](Data-Conversion.html#t:FromInRule)
[DiamondTransaction](Model-Diamonds.html#t:DiamondTransaction)

 

[FromInRule](Data-Conversion.html#t:FromInRule)
[AccountProfile](Model-AccountProfile.html#t:AccountProfile)

 

[FromInRule](Data-Conversion.html#t:FromInRule)
[AccountProfileMin](Model-AccountProfileMin.html#t:AccountProfileMin)

 

[FromInRule](Data-Conversion.html#t:FromInRule)
[Car](Model-Car.html#t:Car)

 

[FromInRule](Data-Conversion.html#t:FromInRule)
[Car3dModel](Model-Car3dModel.html#t:Car3dModel)

 

[FromInRule](Data-Conversion.html#t:FromInRule)
[CarInGarage](Model-CarInGarage.html#t:CarInGarage)

 

[FromInRule](Data-Conversion.html#t:FromInRule)
[CarInstance](Model-CarInstance.html#t:CarInstance)

 

[FromInRule](Data-Conversion.html#t:FromInRule)
[CarInstanceParts](Model-CarInstanceParts.html#t:CarInstanceParts)

 

[FromInRule](Data-Conversion.html#t:FromInRule)
[CarMarket](Model-CarMarket.html#t:CarMarket)

 

[FromInRule](Data-Conversion.html#t:FromInRule)
[CarMinimal](Model-CarMinimal.html#t:CarMinimal)

 

[FromInRule](Data-Conversion.html#t:FromInRule)
[RaceParticipant](Data-RaceParticipant.html#t:RaceParticipant)

 

[FromInRule](Data-Conversion.html#t:FromInRule)
[TrackTime](Model-TrackTime.html#t:TrackTime)

 

[FromInRule](Data-Conversion.html#t:FromInRule)
[CarOptions](Model-CarOptions.html#t:CarOptions)

 

[FromInRule](Data-Conversion.html#t:FromInRule)
[CarOptionsExtended](Model-CarOptionsExtended.html#t:CarOptionsExtended)

 

[FromInRule](Data-Conversion.html#t:FromInRule)
[CarOwners](Model-CarOwners.html#t:CarOwners)

 

[FromInRule](Data-Conversion.html#t:FromInRule)
[CarStockPart](Model-CarStockParts.html#t:CarStockPart)

 

[FromInRule](Data-Conversion.html#t:FromInRule)
[Challenge](Model-Challenge.html#t:Challenge)

 

[FromInRule](Data-Conversion.html#t:FromInRule)
[ChallengeAccept](Model-ChallengeAccept.html#t:ChallengeAccept)

 

[FromInRule](Data-Conversion.html#t:FromInRule)
[ChallengeExtended](Model-ChallengeExtended.html#t:ChallengeExtended)

 

[FromInRule](Data-Conversion.html#t:FromInRule)
[ChallengeType](Model-ChallengeType.html#t:ChallengeType)

 

[FromInRule](Data-Conversion.html#t:FromInRule)
[City](Model-City.html#t:City)

 

[FromInRule](Data-Conversion.html#t:FromInRule)
[Config](Model-Config.html#t:Config)

 

[FromInRule](Data-Conversion.html#t:FromInRule)
[Continent](Model-Continent.html#t:Continent)

 

[FromInRule](Data-Conversion.html#t:FromInRule)
[EventStream](Model-EventStream.html#t:EventStream)

 

[FromInRule](Data-Conversion.html#t:FromInRule)
[Garage](Model-Garage.html#t:Garage)

 

[FromInRule](Data-Conversion.html#t:FromInRule)
[GaragePart](Model-GarageParts.html#t:GaragePart)

 

[FromInRule](Data-Conversion.html#t:FromInRule)
[GarageReport](Model-GarageReport.html#t:GarageReport)

 

[FromInRule](Data-Conversion.html#t:FromInRule)
[GarageReportInsert](Model-GarageReportInsert.html#t:GarageReportInsert)

 

[FromInRule](Data-Conversion.html#t:FromInRule)
[GeneralReport](Model-GeneralReport.html#t:GeneralReport)

 

[FromInRule](Data-Conversion.html#t:FromInRule)
[Manufacturer](Model-Manufacturer.html#t:Manufacturer)

 

[FromInRule](Data-Conversion.html#t:FromInRule)
[ManufacturerMarket](Model-ManufacturerMarket.html#t:ManufacturerMarket)

 

[FromInRule](Data-Conversion.html#t:FromInRule)
[MarketCarInstanceParts](Model-MarketCarInstanceParts.html#t:MarketCarInstanceParts)

 

[FromInRule](Data-Conversion.html#t:FromInRule)
[MarketItem](Model-MarketItem.html#t:MarketItem)

 

[FromInRule](Data-Conversion.html#t:FromInRule)
[MarketPartType](Model-MarketPartType.html#t:MarketPartType)

 

[FromInRule](Data-Conversion.html#t:FromInRule)
[MarketPlace](Model-MarketPlace.html#t:MarketPlace)

 

[FromInRule](Data-Conversion.html#t:FromInRule)
[MarketPlaceCar](Model-MarketPlaceCar.html#t:MarketPlaceCar)

 

[FromInRule](Data-Conversion.html#t:FromInRule)
[MenuModel](Model-MenuModel.html#t:MenuModel)

 

[FromInRule](Data-Conversion.html#t:FromInRule)
[Part](Model-Part.html#t:Part)

 

[FromInRule](Data-Conversion.html#t:FromInRule)
[PartDetails](Model-PartDetails.html#t:PartDetails)

 

[FromInRule](Data-Conversion.html#t:FromInRule)
[RaceRewards](Data-RaceReward.html#t:RaceRewards)

 

[FromInRule](Data-Conversion.html#t:FromInRule)
[RaceReward](Model-RaceReward.html#t:RaceReward)

 

[FromInRule](Data-Conversion.html#t:FromInRule)
[Tournament](Model-Tournament.html#t:Tournament)

 

[FromInRule](Data-Conversion.html#t:FromInRule)
[TournamentExtended](Model-TournamentExtended.html#t:TournamentExtended)

 

[FromInRule](Data-Conversion.html#t:FromInRule)
[PartInstance](Model-PartInstance.html#t:PartInstance)

 

[FromInRule](Data-Conversion.html#t:FromInRule)
[PartMarket](Model-PartMarket.html#t:PartMarket)

 

[FromInRule](Data-Conversion.html#t:FromInRule)
[PartMarketPlaceType](Model-PartMarketPlaceType.html#t:PartMarketPlaceType)

 

[FromInRule](Data-Conversion.html#t:FromInRule)
[PartMarketType](Model-PartMarketType.html#t:PartMarketType)

 

[FromInRule](Data-Conversion.html#t:FromInRule)
[PartType](Model-PartType.html#t:PartType)

 

[FromInRule](Data-Conversion.html#t:FromInRule)
[Personnel](Model-Personnel.html#t:Personnel)

 

[FromInRule](Data-Conversion.html#t:FromInRule)
[PersonnelDetails](Model-PersonnelDetails.html#t:PersonnelDetails)

 

[FromInRule](Data-Conversion.html#t:FromInRule)
[PersonnelInstance](Model-PersonnelInstance.html#t:PersonnelInstance)

 

[FromInRule](Data-Conversion.html#t:FromInRule)
[PersonnelInstanceDetails](Model-PersonnelInstanceDetails.html#t:PersonnelInstanceDetails)

 

[FromInRule](Data-Conversion.html#t:FromInRule)
[PersonnelReport](Model-PersonnelReport.html#t:PersonnelReport)

 

[FromInRule](Data-Conversion.html#t:FromInRule)
[PersonnelTaskType](Model-PersonnelTaskType.html#t:PersonnelTaskType)

 

[FromInRule](Data-Conversion.html#t:FromInRule)
[PreLetter](Model-PreLetter.html#t:PreLetter)

 

[FromInRule](Data-Conversion.html#t:FromInRule)
[Type](Model-Report.html#t:Type)

 

[FromInRule](Data-Conversion.html#t:FromInRule)
[Report](Model-Report.html#t:Report)

 

[FromInRule](Data-Conversion.html#t:FromInRule)
[RewardLog](Model-RewardLog.html#t:RewardLog)

 

[FromInRule](Data-Conversion.html#t:FromInRule)
[RewardLogEvent](Model-RewardLogEvent.html#t:RewardLogEvent)

 

[FromInRule](Data-Conversion.html#t:FromInRule)
[ShopReport](Model-ShopReport.html#t:ShopReport)

 

[FromInRule](Data-Conversion.html#t:FromInRule)
[Support](Model-Support.html#t:Support)

 

[FromInRule](Data-Conversion.html#t:FromInRule)
[TrackCity](Model-TrackCity.html#t:TrackCity)

 

[FromInRule](Data-Conversion.html#t:FromInRule)
[TrackContinent](Model-TrackContinent.html#t:TrackContinent)

 

[FromInRule](Data-Conversion.html#t:FromInRule)
[TrackDetails](Model-TrackDetails.html#t:TrackDetails)

 

[FromInRule](Data-Conversion.html#t:FromInRule)
[TrackMaster](Model-TrackMaster.html#t:TrackMaster)

 

[FromInRule](Data-Conversion.html#t:FromInRule)
[TravelReport](Model-TravelReport.html#t:TravelReport)

 

[FromInRule](Data-Conversion.html#t:FromInRule)
[Notification](Model-Notification.html#t:Notification)

 

[FromInRule](Data-Conversion.html#t:FromInRule)
[Task](Model-Task.html#t:Task)

 

[FromInRule](Data-Conversion.html#t:FromInRule)
[CarReadyState](Data-CarReady.html#t:CarReadyState)

 

[FromInRule](Data-Conversion.html#t:FromInRule)
[RaceSectionPerformance](Data-RaceSectionPerformance.html#t:RaceSectionPerformance)

 

[FromInRule](Data-Conversion.html#t:FromInRule)
[TaskTrigger](Model-TaskTrigger.html#t:TaskTrigger)

 

[FromInRule](Data-Conversion.html#t:FromInRule)
[TaskLog](Model-TaskLog.html#t:TaskLog)

 

[FromInRule](Data-Conversion.html#t:FromInRule)
[Action](Model-Action.html#t:Action)

 

[FromInRule](Data-Conversion.html#t:FromInRule)
[RewardLogEvents](Model-RewardLogEvents.html#t:RewardLogEvents)

 

[FromInRule](Data-Conversion.html#t:FromInRule)
[Rule](Model-Rule.html#t:Rule)

 

[FromInRule](Data-Conversion.html#t:FromInRule)
[RuleReward](Model-RuleReward.html#t:RuleReward)

 

[FromInRule](Data-Conversion.html#t:FromInRule)
[SectionResult](Data-RacingNew.html#t:SectionResult)

 

[FromInRule](Data-Conversion.html#t:FromInRule)
[RaceResult](Data-RacingNew.html#t:RaceResult)

 

[FromInRule](Data-Conversion.html#t:FromInRule)
[RaceData](Data-RacingNew.html#t:RaceData)

 

[FromInRule](Data-Conversion.html#t:FromInRule) CarBaseParameters

 

[FromInRule](Data-Conversion.html#t:FromInRule) CarDerivedParameters

 

[FromInRule](Data-Conversion.html#t:FromInRule) PartParameter

 

[FromInRule](Data-Conversion.html#t:FromInRule) PreviewPart

 

[FromInRule](Data-Conversion.html#t:FromInRule)
[Race](Model-Race.html#t:Race)

 

[FromInRule](Data-Conversion.html#t:FromInRule)
[RaceDetails](Model-RaceDetails.html#t:RaceDetails)

 

[FromInRule](Data-Conversion.html#t:FromInRule) SectionResult

 

[FromInRule](Data-Conversion.html#t:FromInRule) RaceResult

 

[FromInRule](Data-Conversion.html#t:FromInRule) RaceParticipant

 

[FromInRule](Data-Conversion.html#t:FromInRule) RaceRewards

 

[FromInRule](Data-Conversion.html#t:FromInRule) RaceData

 

[FromInRule](Data-Conversion.html#t:FromInRule)
[TournamentPlayer](Model-TournamentPlayers.html#t:TournamentPlayer)

 

[FromInRule](Data-Conversion.html#t:FromInRule)
[TournamentResult](Model-TournamentResult.html#t:TournamentResult)

 

[FromInRule](Data-Conversion.html#t:FromInRule)
[TournamentReport](Model-TournamentReport.html#t:TournamentReport)

 

[FromInRule](Data-Conversion.html#t:FromInRule) RoundResult

 

[FromInRule](Data-Conversion.html#t:FromInRule) TournamentFullData

 

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
