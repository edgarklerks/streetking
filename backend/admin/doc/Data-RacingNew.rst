==============
Data.RacingNew
==============

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Data.RacingNew

Documentation
=============

data RaceResult

Constructors

RaceResult

 

Fields

trackId :: Integer
     
raceTime :: Double
     
raceSpeedTop :: Double
     
raceSpeedFin :: Double
     
raceSpeedAvg :: Double
     
sectionResults :: SectionResultList
     

Instances

+-----------------------------------------------------------------------------------------------------+-----+
| Eq `RaceResult <Data-RacingNew.html#t:RaceResult>`__                                                |     |
+-----------------------------------------------------------------------------------------------------+-----+
| Ord `RaceResult <Data-RacingNew.html#t:RaceResult>`__                                               |     |
+-----------------------------------------------------------------------------------------------------+-----+
| Show `RaceResult <Data-RacingNew.html#t:RaceResult>`__                                              |     |
+-----------------------------------------------------------------------------------------------------+-----+
| ToJSON `RaceResult <Data-RacingNew.html#t:RaceResult>`__                                            |     |
+-----------------------------------------------------------------------------------------------------+-----+
| FromJSON `RaceResult <Data-RacingNew.html#t:RaceResult>`__                                          |     |
+-----------------------------------------------------------------------------------------------------+-----+
| Default `RaceResult <Data-RacingNew.html#t:RaceResult>`__                                           |     |
+-----------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-InRules.html#t:FromInRule>`__ `RaceResult <Data-RacingNew.html#t:RaceResult>`__   |     |
+-----------------------------------------------------------------------------------------------------+-----+
| `ToInRule <Data-InRules.html#t:ToInRule>`__ `RaceResult <Data-RacingNew.html#t:RaceResult>`__       |     |
+-----------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `RaceResult <Data-RacingNew.html#t:RaceResult>`__        |     |
+-----------------------------------------------------------------------------------------------------+-----+

raceResult2FE :: `RaceResult <Data-RacingNew.html#t:RaceResult>`__ ->
`RaceResult <Data-RacingNew.html#t:RaceResult>`__

data SectionResult

Constructors

SectionResult

 

Fields

sectionId :: Integer
     
performance ::
`RaceSectionPerformance <Data-RaceSectionPerformance.html#t:RaceSectionPerformance>`__
     
effectiveRadius :: MDouble
     
effectiveArclength :: Double
     
lengthAccelerationPhase :: Double
     
lengthBrakingPhase :: Double
     
lengthConstantPhase :: Double
     
sectionLength :: Double
     
timeAccelerationPhase :: Double
     
timeBrakingPhase :: Double
     
timeConstantPhase :: Double
     
sectionTime :: Double
     
sectionSpeedIn :: Double
     
sectionSpeedOut :: Double
     
sectionSpeedCap :: Double
     
sectionSpeedMax :: Double
     
sectionSpeedAvg :: Double
     

Instances

+-----------------------------------------------------------------------------------------------------------+-----+
| Eq `SectionResult <Data-RacingNew.html#t:SectionResult>`__                                                |     |
+-----------------------------------------------------------------------------------------------------------+-----+
| Show `SectionResult <Data-RacingNew.html#t:SectionResult>`__                                              |     |
+-----------------------------------------------------------------------------------------------------------+-----+
| ToJSON `SectionResult <Data-RacingNew.html#t:SectionResult>`__                                            |     |
+-----------------------------------------------------------------------------------------------------------+-----+
| FromJSON `SectionResult <Data-RacingNew.html#t:SectionResult>`__                                          |     |
+-----------------------------------------------------------------------------------------------------------+-----+
| Default `SectionResult <Data-RacingNew.html#t:SectionResult>`__                                           |     |
+-----------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-InRules.html#t:FromInRule>`__ `SectionResult <Data-RacingNew.html#t:SectionResult>`__   |     |
+-----------------------------------------------------------------------------------------------------------+-----+
| `ToInRule <Data-InRules.html#t:ToInRule>`__ `SectionResult <Data-RacingNew.html#t:SectionResult>`__       |     |
+-----------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `SectionResult <Data-RacingNew.html#t:SectionResult>`__        |     |
+-----------------------------------------------------------------------------------------------------------+-----+

data RaceConfig

Constructors

RaceConfig

 

Fields

car :: `Car <Data-Car.html#t:Car>`__
     
driver :: `Driver <Data-Driver.html#t:Driver>`__
     
environment :: `Environment <Data-Environment.html#t:Environment>`__
     
track :: `Track <Data-Track.html#t:Track>`__
     

Instances

+----------------------------------------------------------+-----+
| Show `RaceConfig <Data-RacingNew.html#t:RaceConfig>`__   |     |
+----------------------------------------------------------+-----+

data SectionConfig

Constructors

SectionConfig

 

Fields

section :: `Section <Data-Section.html#t:Section>`__
     
sectionPerformance ::
`RaceSectionPerformance <Data-RaceSectionPerformance.html#t:RaceSectionPerformance>`__
     
mass :: Double
     
aero :: Double
     
downforce :: Double
     
power :: Double
     
braking :: Double
     
traction :: Double
     
handling :: Double
     
topSpeed :: Double
     

Instances

+----------------------------------------------------------------+-----+
| Show `SectionConfig <Data-RacingNew.html#t:SectionConfig>`__   |     |
+----------------------------------------------------------------+-----+

data RaceData

Constructors

RaceData

 

Fields

rd\_user ::
`AccountProfileMin <Model-AccountProfileMin.html#t:AccountProfileMin>`__
     
rd\_car :: `CarMinimal <Model-CarMinimal.html#t:CarMinimal>`__
     
rd\_result :: `RaceResult <Data-RacingNew.html#t:RaceResult>`__
     

Instances

+-------------------------------------------------------------------------------------------------+-----+
| Eq `RaceData <Data-RacingNew.html#t:RaceData>`__                                                |     |
+-------------------------------------------------------------------------------------------------+-----+
| Show `RaceData <Data-RacingNew.html#t:RaceData>`__                                              |     |
+-------------------------------------------------------------------------------------------------+-----+
| ToJSON `RaceData <Data-RacingNew.html#t:RaceData>`__                                            |     |
+-------------------------------------------------------------------------------------------------+-----+
| FromJSON `RaceData <Data-RacingNew.html#t:RaceData>`__                                          |     |
+-------------------------------------------------------------------------------------------------+-----+
| Default `RaceData <Data-RacingNew.html#t:RaceData>`__                                           |     |
+-------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-InRules.html#t:FromInRule>`__ `RaceData <Data-RacingNew.html#t:RaceData>`__   |     |
+-------------------------------------------------------------------------------------------------+-----+
| `ToInRule <Data-InRules.html#t:ToInRule>`__ `RaceData <Data-RacingNew.html#t:RaceData>`__       |     |
+-------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `RaceData <Data-RacingNew.html#t:RaceData>`__        |     |
+-------------------------------------------------------------------------------------------------+-----+

type RaceDataList = [`RaceData <Data-RacingNew.html#t:RaceData>`__\ ]

type RaceM a = RandomGen g => ErrorT String (RandT g (Reader
`RaceConfig <Data-RacingNew.html#t:RaceConfig>`__)) a

type SectionM a = ErrorT String (Reader
`SectionConfig <Data-RacingNew.html#t:SectionConfig>`__) a

sectionConfig :: `Section <Data-Section.html#t:Section>`__ ->
`RaceSectionPerformance <Data-RaceSectionPerformance.html#t:RaceSectionPerformance>`__
-> `RaceM <Data-RacingNew.html#t:RaceM>`__
`SectionConfig <Data-RacingNew.html#t:SectionConfig>`__

runSectionM :: `SectionM <Data-RacingNew.html#t:SectionM>`__ a ->
`SectionConfig <Data-RacingNew.html#t:SectionConfig>`__ -> Either String
a

runRaceM :: RandomGen g => `RaceM <Data-RacingNew.html#t:RaceM>`__ a ->
g -> `RaceConfig <Data-RacingNew.html#t:RaceConfig>`__ -> Either String
a

raceWithParticipant :: RandomGen g =>
`RaceParticipant <Data-RaceParticipant.html#t:RaceParticipant>`__ ->
`Track <Data-Track.html#t:Track>`__ -> g -> Either String
`RaceResult <Data-RacingNew.html#t:RaceResult>`__

runRaceWithParticipant ::
`RaceParticipant <Data-RaceParticipant.html#t:RaceParticipant>`__ ->
`Track <Data-Track.html#t:Track>`__ ->
`Environment <Data-Environment.html#t:Environment>`__ ->
`RaceResult <Data-RacingNew.html#t:RaceResult>`__

race :: RandomGen g => `RaceConfig <Data-RacingNew.html#t:RaceConfig>`__
-> g -> Either String `RaceResult <Data-RacingNew.html#t:RaceResult>`__

raceData ::
`RaceParticipant <Data-RaceParticipant.html#t:RaceParticipant>`__ ->
`RaceResult <Data-RacingNew.html#t:RaceResult>`__ ->
`RaceData <Data-RacingNew.html#t:RaceData>`__

accelerationTime :: Speed -> Speed ->
`SectionM <Data-RacingNew.html#t:SectionM>`__ Time

brakingDistance :: Speed -> Speed ->
`SectionM <Data-RacingNew.html#t:SectionM>`__ Double

lateralAcceleration :: `SectionM <Data-RacingNew.html#t:SectionM>`__
Double

partsWear :: Integer ->
`RaceResult <Data-RacingNew.html#t:RaceResult>`__ ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ ()

healthLost :: Integer ->
`RaceResult <Data-RacingNew.html#t:RaceResult>`__ ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ ()

testDefRace :: IO ()

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
