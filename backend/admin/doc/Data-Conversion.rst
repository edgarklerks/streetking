===============
Data.Conversion
===============

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Data.Conversion

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

hmapWithKey :: (Eq k, Hashable k) => (k -> v1 -> v) -> HashMap k v1 ->
HashMap k v

data InRule

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
| Arbitrary `InRule <Data-Conversion.html#t:InRule>`__                                                               |     |
+--------------------------------------------------------------------------------------------------------------------+-----+
| Serialize `InRule <Data-Conversion.html#t:InRule>`__                                                               |     |
+--------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-Conversion.html#t:FromInRule>`__ `InRule <Data-Conversion.html#t:InRule>`__                      |     |
+--------------------------------------------------------------------------------------------------------------------+-----+
| `ToInRule <Data-Conversion.html#t:ToInRule>`__ `InRule <Data-Conversion.html#t:InRule>`__                          |     |
+--------------------------------------------------------------------------------------------------------------------+-----+
| `StringLike <Data-Tools.html#t:StringLike>`__ `InRule <Data-Conversion.html#t:InRule>`__                           |     |
+--------------------------------------------------------------------------------------------------------------------+-----+
| Binary `InRule <Data-Conversion.html#t:InRule>`__                                                                  |     |
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

+-----------------------------------------------------------------------------------------------------+-----+
| Show `Readable <Data-Conversion.html#t:Readable>`__                                                 |     |
+-----------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-Conversion.html#t:FromInRule>`__ `Readable <Data-Conversion.html#t:Readable>`__   |     |
+-----------------------------------------------------------------------------------------------------+-----+
| Read a => Convertible `Readable <Data-Conversion.html#t:Readable>`__ a                              |     |
+-----------------------------------------------------------------------------------------------------+-----+

data InKey

Setters, getters, folds, unfolds and maps.

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

Constructors

+-------------------------------------------------------------------+-----+
| Next (`PathAcceptor <Data-Conversion.html#t:PathAcceptor>`__ a)   |     |
+-------------------------------------------------------------------+-----+
| Final `PathState <Data-Conversion.html#t:PathState>`__            |     |
+-------------------------------------------------------------------+-----+

newtype PathAcceptor a

Constructors

PM

 

Fields

unPM :: a -> `PathStep <Data-Conversion.html#t:PathStep>`__ a
     

Instances

+------------------------------------------------------------------------+-----+
| Semigroup (`PathAcceptor <Data-Conversion.html#t:PathAcceptor>`__ a)   |     |
+------------------------------------------------------------------------+-----+

accept :: `PathStep <Data-Conversion.html#t:PathStep>`__ a

reject :: `PathStep <Data-Conversion.html#t:PathStep>`__ a

acceptor :: `PathAcceptor <Data-Conversion.html#t:PathAcceptor>`__ a

Always accept the input

continue :: `PathAcceptor <Data-Conversion.html#t:PathAcceptor>`__ a

Always accept the complete input stream (will always be false for finite
streams and true for infinite ones)

alter :: `PathAcceptor <Data-Conversion.html#t:PathAcceptor>`__ a ->
`PathAcceptor <Data-Conversion.html#t:PathAcceptor>`__ a ->
`PathAcceptor <Data-Conversion.html#t:PathAcceptor>`__ a

apoint :: Eq a => a ->
`PathAcceptor <Data-Conversion.html#t:PathAcceptor>`__ a

runPath :: Eq a =>
`PathAcceptor <Data-Conversion.html#t:PathAcceptor>`__ a -> [a] -> Bool

data KindView

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

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__ ByteString

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__ Value

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__ ByteString

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__ UTCTime

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__ Day

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__ TimeOfDay

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__ LocalTime

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__
`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__

Renders InRule to String.

`ToInRule <Data-Conversion.html#t:ToInRule>`__
`InRule <Data-Conversion.html#t:InRule>`__

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__
`Event <Data-Event.html#t:Event>`__

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__
`Data <Data-DataPack.html#t:Data>`__

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__
`PartDetails <Model-PartDetails.html#t:PartDetails>`__

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__
`RaceRewards <Data-RaceReward.html#t:RaceRewards>`__

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__
`Tournament <Model-Tournament.html#t:Tournament>`__

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__
`TournamentType <Model-TournamentType.html#t:TournamentType>`__

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__
`EventStream <Model-EventStream.html#t:EventStream>`__

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__
`RaceReward <Model-RaceReward.html#t:RaceReward>`__

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__
`Type <Model-Report.html#t:Type>`__

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__
`Report <Model-Report.html#t:Report>`__

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__
`Task <Model-Task.html#t:Task>`__

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__
`TrackDetails <Model-TrackDetails.html#t:TrackDetails>`__

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__
`TrackMaster <Model-TrackMaster.html#t:TrackMaster>`__

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__
`PreLetter <Model-PreLetter.html#t:PreLetter>`__

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__
`RaceSectionPerformance <Data-RaceSectionPerformance.html#t:RaceSectionPerformance>`__

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__
`AccountProfile <Model-AccountProfile.html#t:AccountProfile>`__

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__
`TaskTrigger <Model-TaskTrigger.html#t:TaskTrigger>`__

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__
`MenuModel <Model-MenuModel.html#t:MenuModel>`__

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__
`Reward <Model-Reward.html#t:Reward>`__

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__
`RuleReward <Model-RuleReward.html#t:RuleReward>`__

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__
`Action <Model-Action.html#t:Action>`__

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__
`Rule <Model-Rule.html#t:Rule>`__

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__
`RewardLog <Model-RewardLog.html#t:RewardLog>`__

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__
`PartType <Model-PartType.html#t:PartType>`__

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__
`Part <Model-Part.html#t:Part>`__

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__
`AccountGarage <Model-AccountGarage.html#t:AccountGarage>`__

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__
`PartMarket <Model-PartMarket.html#t:PartMarket>`__

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__
`ParameterTable <Model-ParameterTable.html#t:ParameterTable>`__

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__
`PersonnelInstance <Model-PersonnelInstance.html#t:PersonnelInstance>`__

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__
`Personnel <Model-Personnel.html#t:Personnel>`__

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__
`Notification <Model-Notification.html#t:Notification>`__

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__
`GaragePart <Model-GarageParts.html#t:GaragePart>`__

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__
`Garage <Model-Garage.html#t:Garage>`__

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__
`Config <Model-Config.html#t:Config>`__

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__
`Continent <Model-Continent.html#t:Continent>`__

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__
`Country <Model-Country.html#t:Country>`__

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__
`City <Model-City.html#t:City>`__

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__
`Track <Model-Track.html#t:Track>`__

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__
`ChallengeType <Model-ChallengeType.html#t:ChallengeType>`__

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__
`ChallengeAccept <Model-ChallengeAccept.html#t:ChallengeAccept>`__

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__
`Application <Model-Application.html#t:Application>`__

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__
`CarInstanceParts <Model-CarInstanceParts.html#t:CarInstanceParts>`__

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__
`PartInstance <Model-PartInstance.html#t:PartInstance>`__

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__
`PartModifier <Model-PartModifier.html#t:PartModifier>`__

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__
`Account <Model-Account.html#t:Account>`__

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__
`Transaction <Model-Transaction.html#t:Transaction>`__

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__
`Escrow <Model-Escrow.html#t:Escrow>`__

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__ Box

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__ ComposeMap

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__
`NotificationParam <Notifications.html#t:NotificationParam>`__

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__ RaceType

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__
`AccountProfileMin <Model-AccountProfileMin.html#t:AccountProfileMin>`__

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__
`CarOptions <Model-CarOptions.html#t:CarOptions>`__

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__
`CarInGarage <Model-CarInGarage.html#t:CarInGarage>`__

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__
`CarMinimal <Model-CarMinimal.html#t:CarMinimal>`__

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__
`TrackTime <Model-TrackTime.html#t:TrackTime>`__

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__
`RaceParticipant <Data-RaceParticipant.html#t:RaceParticipant>`__

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__
`Challenge <Model-Challenge.html#t:Challenge>`__

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__ SectionResult

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__ RaceResult

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__ RaceParticipant

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__ RaceRewards

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__ RaceData

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__
`TournamentPlayer <Model-TournamentPlayers.html#t:TournamentPlayer>`__

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__
`CarInstance <Model-CarInstance.html#t:CarInstance>`__

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__
`SectionResult <Data-RacingNew.html#t:SectionResult>`__

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__
`RaceResult <Data-RacingNew.html#t:RaceResult>`__

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__
`RaceData <Data-RacingNew.html#t:RaceData>`__

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__
`Race <Model-Race.html#t:Race>`__

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__
`TournamentResult <Model-TournamentResult.html#t:TournamentResult>`__

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__
`TournamentReport <Model-TournamentReport.html#t:TournamentReport>`__

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__ RoundResult

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__ TournamentFullData

 

`ToInRule <Data-Conversion.html#t:ToInRule>`__
`Car <Model-Car.html#t:Car>`__

 

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

+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-Conversion.html#t:FromInRule>`__ Bool                                                                                                                                                                                                                                                                                                          |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-Conversion.html#t:FromInRule>`__ Double                                                                                                                                                                                                                                                                                                        |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-Conversion.html#t:FromInRule>`__ Float                                                                                                                                                                                                                                                                                                         |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-Conversion.html#t:FromInRule>`__ Int                                                                                                                                                                                                                                                                                                           |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-Conversion.html#t:FromInRule>`__ Int32                                                                                                                                                                                                                                                                                                         |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-Conversion.html#t:FromInRule>`__ Int64                                                                                                                                                                                                                                                                                                         |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-Conversion.html#t:FromInRule>`__ Integer                                                                                                                                                                                                                                                                                                       |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-Conversion.html#t:FromInRule>`__ Rational                                                                                                                                                                                                                                                                                                      |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-Conversion.html#t:FromInRule>`__ Word32                                                                                                                                                                                                                                                                                                        |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-Conversion.html#t:FromInRule>`__ Word64                                                                                                                                                                                                                                                                                                        |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-Conversion.html#t:FromInRule>`__ String                                                                                                                                                                                                                                                                                                        |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-Conversion.html#t:FromInRule>`__ ByteString                                                                                                                                                                                                                                                                                                    |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-Conversion.html#t:FromInRule>`__ Value                                                                                                                                                                                                                                                                                                         |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-Conversion.html#t:FromInRule>`__ ByteString                                                                                                                                                                                                                                                                                                    |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-Conversion.html#t:FromInRule>`__ UTCTime                                                                                                                                                                                                                                                                                                       |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-Conversion.html#t:FromInRule>`__ Day                                                                                                                                                                                                                                                                                                           |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-Conversion.html#t:FromInRule>`__ TimeOfDay                                                                                                                                                                                                                                                                                                     |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-Conversion.html#t:FromInRule>`__ LocalTime                                                                                                                                                                                                                                                                                                     |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-Conversion.html#t:FromInRule>`__ `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__                                                                                                                                                                                                                                                            |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-Conversion.html#t:FromInRule>`__ `Readable <Data-Conversion.html#t:Readable>`__                                                                                                                                                                                                                                                                |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-Conversion.html#t:FromInRule>`__ `InRule <Data-Conversion.html#t:InRule>`__                                                                                                                                                                                                                                                                    |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-Conversion.html#t:FromInRule>`__ `Event <Data-Event.html#t:Event>`__                                                                                                                                                                                                                                                                           |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-Conversion.html#t:FromInRule>`__ `Data <Data-DataPack.html#t:Data>`__                                                                                                                                                                                                                                                                          |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-Conversion.html#t:FromInRule>`__ `PartDetails <Model-PartDetails.html#t:PartDetails>`__                                                                                                                                                                                                                                                        |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-Conversion.html#t:FromInRule>`__ `RaceRewards <Data-RaceReward.html#t:RaceRewards>`__                                                                                                                                                                                                                                                          |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-Conversion.html#t:FromInRule>`__ `Tournament <Model-Tournament.html#t:Tournament>`__                                                                                                                                                                                                                                                           |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-Conversion.html#t:FromInRule>`__ `TournamentType <Model-TournamentType.html#t:TournamentType>`__                                                                                                                                                                                                                                               |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-Conversion.html#t:FromInRule>`__ `EventStream <Model-EventStream.html#t:EventStream>`__                                                                                                                                                                                                                                                        |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-Conversion.html#t:FromInRule>`__ `RaceReward <Model-RaceReward.html#t:RaceReward>`__                                                                                                                                                                                                                                                           |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-Conversion.html#t:FromInRule>`__ `Type <Model-Report.html#t:Type>`__                                                                                                                                                                                                                                                                           |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-Conversion.html#t:FromInRule>`__ `Report <Model-Report.html#t:Report>`__                                                                                                                                                                                                                                                                       |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-Conversion.html#t:FromInRule>`__ `Task <Model-Task.html#t:Task>`__                                                                                                                                                                                                                                                                             |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-Conversion.html#t:FromInRule>`__ `TrackDetails <Model-TrackDetails.html#t:TrackDetails>`__                                                                                                                                                                                                                                                     |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-Conversion.html#t:FromInRule>`__ `TrackMaster <Model-TrackMaster.html#t:TrackMaster>`__                                                                                                                                                                                                                                                        |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-Conversion.html#t:FromInRule>`__ `PreLetter <Model-PreLetter.html#t:PreLetter>`__                                                                                                                                                                                                                                                              |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-Conversion.html#t:FromInRule>`__ `RaceSectionPerformance <Data-RaceSectionPerformance.html#t:RaceSectionPerformance>`__                                                                                                                                                                                                                        |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-Conversion.html#t:FromInRule>`__ `AccountProfile <Model-AccountProfile.html#t:AccountProfile>`__                                                                                                                                                                                                                                               |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-Conversion.html#t:FromInRule>`__ `TaskTrigger <Model-TaskTrigger.html#t:TaskTrigger>`__                                                                                                                                                                                                                                                        |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-Conversion.html#t:FromInRule>`__ `MenuModel <Model-MenuModel.html#t:MenuModel>`__                                                                                                                                                                                                                                                              |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-Conversion.html#t:FromInRule>`__ `Reward <Model-Reward.html#t:Reward>`__                                                                                                                                                                                                                                                                       |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-Conversion.html#t:FromInRule>`__ `RuleReward <Model-RuleReward.html#t:RuleReward>`__                                                                                                                                                                                                                                                           |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-Conversion.html#t:FromInRule>`__ `Action <Model-Action.html#t:Action>`__                                                                                                                                                                                                                                                                       |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-Conversion.html#t:FromInRule>`__ `Rule <Model-Rule.html#t:Rule>`__                                                                                                                                                                                                                                                                             |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-Conversion.html#t:FromInRule>`__ `RewardLog <Model-RewardLog.html#t:RewardLog>`__                                                                                                                                                                                                                                                              |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-Conversion.html#t:FromInRule>`__ `PartType <Model-PartType.html#t:PartType>`__                                                                                                                                                                                                                                                                 |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-Conversion.html#t:FromInRule>`__ `Part <Model-Part.html#t:Part>`__                                                                                                                                                                                                                                                                             |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-Conversion.html#t:FromInRule>`__ `AccountGarage <Model-AccountGarage.html#t:AccountGarage>`__                                                                                                                                                                                                                                                  |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-Conversion.html#t:FromInRule>`__ `PartMarket <Model-PartMarket.html#t:PartMarket>`__                                                                                                                                                                                                                                                           |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-Conversion.html#t:FromInRule>`__ `ParameterTable <Model-ParameterTable.html#t:ParameterTable>`__                                                                                                                                                                                                                                               |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-Conversion.html#t:FromInRule>`__ `PersonnelInstance <Model-PersonnelInstance.html#t:PersonnelInstance>`__                                                                                                                                                                                                                                      |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-Conversion.html#t:FromInRule>`__ `Personnel <Model-Personnel.html#t:Personnel>`__                                                                                                                                                                                                                                                              |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-Conversion.html#t:FromInRule>`__ `Notification <Model-Notification.html#t:Notification>`__                                                                                                                                                                                                                                                     |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-Conversion.html#t:FromInRule>`__ `GaragePart <Model-GarageParts.html#t:GaragePart>`__                                                                                                                                                                                                                                                          |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-Conversion.html#t:FromInRule>`__ `Garage <Model-Garage.html#t:Garage>`__                                                                                                                                                                                                                                                                       |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-Conversion.html#t:FromInRule>`__ `Config <Model-Config.html#t:Config>`__                                                                                                                                                                                                                                                                       |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-Conversion.html#t:FromInRule>`__ `Continent <Model-Continent.html#t:Continent>`__                                                                                                                                                                                                                                                              |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-Conversion.html#t:FromInRule>`__ `Country <Model-Country.html#t:Country>`__                                                                                                                                                                                                                                                                    |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-Conversion.html#t:FromInRule>`__ `City <Model-City.html#t:City>`__                                                                                                                                                                                                                                                                             |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-Conversion.html#t:FromInRule>`__ `Track <Model-Track.html#t:Track>`__                                                                                                                                                                                                                                                                          |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-Conversion.html#t:FromInRule>`__ `ChallengeType <Model-ChallengeType.html#t:ChallengeType>`__                                                                                                                                                                                                                                                  |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-Conversion.html#t:FromInRule>`__ `ChallengeAccept <Model-ChallengeAccept.html#t:ChallengeAccept>`__                                                                                                                                                                                                                                            |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-Conversion.html#t:FromInRule>`__ `Application <Model-Application.html#t:Application>`__                                                                                                                                                                                                                                                        |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-Conversion.html#t:FromInRule>`__ `CarInstanceParts <Model-CarInstanceParts.html#t:CarInstanceParts>`__                                                                                                                                                                                                                                         |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-Conversion.html#t:FromInRule>`__ `PartInstance <Model-PartInstance.html#t:PartInstance>`__                                                                                                                                                                                                                                                     |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-Conversion.html#t:FromInRule>`__ `PartModifier <Model-PartModifier.html#t:PartModifier>`__                                                                                                                                                                                                                                                     |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-Conversion.html#t:FromInRule>`__ `Account <Model-Account.html#t:Account>`__                                                                                                                                                                                                                                                                    |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-Conversion.html#t:FromInRule>`__ `Transaction <Model-Transaction.html#t:Transaction>`__                                                                                                                                                                                                                                                        |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-Conversion.html#t:FromInRule>`__ `Escrow <Model-Escrow.html#t:Escrow>`__                                                                                                                                                                                                                                                                       |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-Conversion.html#t:FromInRule>`__ `AccountProfileMin <Model-AccountProfileMin.html#t:AccountProfileMin>`__                                                                                                                                                                                                                                      |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-Conversion.html#t:FromInRule>`__ `CarOptions <Model-CarOptions.html#t:CarOptions>`__                                                                                                                                                                                                                                                           |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-Conversion.html#t:FromInRule>`__ `CarInGarage <Model-CarInGarage.html#t:CarInGarage>`__                                                                                                                                                                                                                                                        |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-Conversion.html#t:FromInRule>`__ `CarMinimal <Model-CarMinimal.html#t:CarMinimal>`__                                                                                                                                                                                                                                                           |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-Conversion.html#t:FromInRule>`__ `TrackTime <Model-TrackTime.html#t:TrackTime>`__                                                                                                                                                                                                                                                              |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-Conversion.html#t:FromInRule>`__ `RaceParticipant <Data-RaceParticipant.html#t:RaceParticipant>`__                                                                                                                                                                                                                                             |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-Conversion.html#t:FromInRule>`__ `Challenge <Model-Challenge.html#t:Challenge>`__                                                                                                                                                                                                                                                              |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-Conversion.html#t:FromInRule>`__ SectionResult                                                                                                                                                                                                                                                                                                 |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-Conversion.html#t:FromInRule>`__ RaceResult                                                                                                                                                                                                                                                                                                    |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-Conversion.html#t:FromInRule>`__ RaceParticipant                                                                                                                                                                                                                                                                                               |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-Conversion.html#t:FromInRule>`__ RaceRewards                                                                                                                                                                                                                                                                                                   |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-Conversion.html#t:FromInRule>`__ RaceData                                                                                                                                                                                                                                                                                                      |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-Conversion.html#t:FromInRule>`__ `TournamentPlayer <Model-TournamentPlayers.html#t:TournamentPlayer>`__                                                                                                                                                                                                                                        |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-Conversion.html#t:FromInRule>`__ `CarInstance <Model-CarInstance.html#t:CarInstance>`__                                                                                                                                                                                                                                                        |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-Conversion.html#t:FromInRule>`__ `SectionResult <Data-RacingNew.html#t:SectionResult>`__                                                                                                                                                                                                                                                       |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-Conversion.html#t:FromInRule>`__ `RaceResult <Data-RacingNew.html#t:RaceResult>`__                                                                                                                                                                                                                                                             |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-Conversion.html#t:FromInRule>`__ `RaceData <Data-RacingNew.html#t:RaceData>`__                                                                                                                                                                                                                                                                 |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-Conversion.html#t:FromInRule>`__ `Race <Model-Race.html#t:Race>`__                                                                                                                                                                                                                                                                             |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-Conversion.html#t:FromInRule>`__ `TournamentResult <Model-TournamentResult.html#t:TournamentResult>`__                                                                                                                                                                                                                                         |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-Conversion.html#t:FromInRule>`__ `TournamentReport <Model-TournamentReport.html#t:TournamentReport>`__                                                                                                                                                                                                                                         |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-Conversion.html#t:FromInRule>`__ RoundResult                                                                                                                                                                                                                                                                                                   |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-Conversion.html#t:FromInRule>`__ TournamentFullData                                                                                                                                                                                                                                                                                            |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-Conversion.html#t:FromInRule>`__ `Car <Model-Car.html#t:Car>`__                                                                                                                                                                                                                                                                                |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-Conversion.html#t:FromInRule>`__ a => `FromInRule <Data-Conversion.html#t:FromInRule>`__ [a]                                                                                                                                                                                                                                                   |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-Conversion.html#t:FromInRule>`__ a => `FromInRule <Data-Conversion.html#t:FromInRule>`__ (Maybe a)                                                                                                                                                                                                                                             |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| (`FromInRule <Data-Conversion.html#t:FromInRule>`__ t1, `FromInRule <Data-Conversion.html#t:FromInRule>`__ t2) => `FromInRule <Data-Conversion.html#t:FromInRule>`__ (t1, t2)                                                                                                                                                                                    |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-Conversion.html#t:FromInRule>`__ a => `FromInRule <Data-Conversion.html#t:FromInRule>`__ (HashMap String a)                                                                                                                                                                                                                                    |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| (Eq k, Hashable k, `FromInRule <Data-Conversion.html#t:FromInRule>`__ k, `FromInRule <Data-Conversion.html#t:FromInRule>`__ v) => `FromInRule <Data-Conversion.html#t:FromInRule>`__ (HashMap k v)                                                                                                                                                               |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| (`FromInRule <Data-Conversion.html#t:FromInRule>`__ t1, `FromInRule <Data-Conversion.html#t:FromInRule>`__ t2, `FromInRule <Data-Conversion.html#t:FromInRule>`__ t3) => `FromInRule <Data-Conversion.html#t:FromInRule>`__ (t1, t2, t3)                                                                                                                         |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| (`FromInRule <Data-Conversion.html#t:FromInRule>`__ t1, `FromInRule <Data-Conversion.html#t:FromInRule>`__ t2, `FromInRule <Data-Conversion.html#t:FromInRule>`__ t3, `FromInRule <Data-Conversion.html#t:FromInRule>`__ t4) => `FromInRule <Data-Conversion.html#t:FromInRule>`__ (t1, t2, t3, t4)                                                              |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| (`FromInRule <Data-Conversion.html#t:FromInRule>`__ t1, `FromInRule <Data-Conversion.html#t:FromInRule>`__ t2, `FromInRule <Data-Conversion.html#t:FromInRule>`__ t3, `FromInRule <Data-Conversion.html#t:FromInRule>`__ t4, `FromInRule <Data-Conversion.html#t:FromInRule>`__ t5) => `FromInRule <Data-Conversion.html#t:FromInRule>`__ (t1, t2, t3, t4, t5)   |     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+

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

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
