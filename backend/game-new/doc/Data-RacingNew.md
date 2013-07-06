% Data.RacingNew
% 
% 

-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Data.RacingNew

Documentation
=============

data RaceConfig

Constructors

RaceConfig

 

Fields

car :: [Car](Data-Car.html#t:Car)
:    
driver :: [Driver](Data-Driver.html#t:Driver)
:    
environment :: [Environment](Data-Environment.html#t:Environment)
:    
track :: [Track](Data-Track.html#t:Track)
:    

Instances

  ----------------------------------------------------- ---
  Show [RaceConfig](Data-RacingNew.html#t:RaceConfig)    
  ----------------------------------------------------- ---

data RaceData

Constructors

RaceData

 

Fields

rd\_user :: [AccountProfileMin](Model-AccountProfileMin.html#t:AccountProfileMin)
:    
rd\_car :: [CarMinimal](Model-CarMinimal.html#t:CarMinimal)
:    
rd\_result :: [RaceResult](Data-RacingNew.html#t:RaceResult)
:    

Instances

  ----------------------------------------------------------------------------------------- ---
  Eq [RaceData](Data-RacingNew.html#t:RaceData)                                              
  Show [RaceData](Data-RacingNew.html#t:RaceData)                                            
  ToJSON [RaceData](Data-RacingNew.html#t:RaceData)                                          
  FromJSON [RaceData](Data-RacingNew.html#t:RaceData)                                        
  Default [RaceData](Data-RacingNew.html#t:RaceData)                                         
  [FromInRule](Data-InRules.html#t:FromInRule) [RaceData](Data-RacingNew.html#t:RaceData)    
  [ToInRule](Data-InRules.html#t:ToInRule) [RaceData](Data-RacingNew.html#t:RaceData)        
  [Mapable](Model-General.html#t:Mapable) [RaceData](Data-RacingNew.html#t:RaceData)         
  ----------------------------------------------------------------------------------------- ---

type RaceDataList = [[RaceData](Data-RacingNew.html#t:RaceData)]

type RaceM a = RandomGen g =\> ErrorT String (RandT g (Reader
[RaceConfig](Data-RacingNew.html#t:RaceConfig))) a

data RaceResult

Constructors

RaceResult

 

Fields

trackId :: Integer
:    
raceTime :: Double
:    
raceSpeedTop :: Double
:    
raceSpeedFin :: Double
:    
raceSpeedAvg :: Double
:    
sectionResults :: SectionResultList
:    

Instances

  --------------------------------------------------------------------------------------------- ---
  Eq [RaceResult](Data-RacingNew.html#t:RaceResult)                                              
  Ord [RaceResult](Data-RacingNew.html#t:RaceResult)                                             
  Show [RaceResult](Data-RacingNew.html#t:RaceResult)                                            
  ToJSON [RaceResult](Data-RacingNew.html#t:RaceResult)                                          
  FromJSON [RaceResult](Data-RacingNew.html#t:RaceResult)                                        
  Default [RaceResult](Data-RacingNew.html#t:RaceResult)                                         
  [FromInRule](Data-InRules.html#t:FromInRule) [RaceResult](Data-RacingNew.html#t:RaceResult)    
  [ToInRule](Data-InRules.html#t:ToInRule) [RaceResult](Data-RacingNew.html#t:RaceResult)        
  [Mapable](Model-General.html#t:Mapable) [RaceResult](Data-RacingNew.html#t:RaceResult)         
  --------------------------------------------------------------------------------------------- ---

data SectionConfig

Constructors

SectionConfig

 

Fields

section :: [Section](Data-Section.html#t:Section)
:    
sectionPerformance :: [RaceSectionPerformance](Data-RaceSectionPerformance.html#t:RaceSectionPerformance)
:    
mass :: Double
:    
aero :: Double
:    
downforce :: Double
:    
power :: Double
:    
braking :: Double
:    
traction :: Double
:    
handling :: Double
:    
topSpeed :: Double
:    

Instances

  ----------------------------------------------------------- ---
  Show [SectionConfig](Data-RacingNew.html#t:SectionConfig)    
  ----------------------------------------------------------- ---

type SectionM a = ErrorT String (Reader
[SectionConfig](Data-RacingNew.html#t:SectionConfig)) a

data SectionResult

Constructors

SectionResult

 

Fields

sectionId :: Integer
:    
performance :: [RaceSectionPerformance](Data-RaceSectionPerformance.html#t:RaceSectionPerformance)
:    
effectiveRadius :: MDouble
:    
effectiveArclength :: Double
:    
lengthAccelerationPhase :: Double
:    
lengthBrakingPhase :: Double
:    
lengthConstantPhase :: Double
:    
sectionLength :: Double
:    
timeAccelerationPhase :: Double
:    
timeBrakingPhase :: Double
:    
timeConstantPhase :: Double
:    
sectionTime :: Double
:    
sectionSpeedIn :: Double
:    
sectionSpeedOut :: Double
:    
sectionSpeedCap :: Double
:    
sectionSpeedMax :: Double
:    
sectionSpeedAvg :: Double
:    

Instances

  --------------------------------------------------------------------------------------------------- ---
  Eq [SectionResult](Data-RacingNew.html#t:SectionResult)                                              
  Show [SectionResult](Data-RacingNew.html#t:SectionResult)                                            
  ToJSON [SectionResult](Data-RacingNew.html#t:SectionResult)                                          
  FromJSON [SectionResult](Data-RacingNew.html#t:SectionResult)                                        
  Default [SectionResult](Data-RacingNew.html#t:SectionResult)                                         
  [FromInRule](Data-InRules.html#t:FromInRule) [SectionResult](Data-RacingNew.html#t:SectionResult)    
  [ToInRule](Data-InRules.html#t:ToInRule) [SectionResult](Data-RacingNew.html#t:SectionResult)        
  [Mapable](Model-General.html#t:Mapable) [SectionResult](Data-RacingNew.html#t:SectionResult)         
  --------------------------------------------------------------------------------------------------- ---

accelerationTime :: Speed -\> Speed -\>
[SectionM](Data-RacingNew.html#t:SectionM) Time

brakingDistance :: Speed -\> Speed -\>
[SectionM](Data-RacingNew.html#t:SectionM) Double

healthLost :: Integer -\> [RaceResult](Data-RacingNew.html#t:RaceResult)
-\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction)
[Connection](Data-SqlTransaction.html#t:Connection) ()

lateralAcceleration :: [SectionM](Data-RacingNew.html#t:SectionM) Double

partsWear :: Integer -\> [RaceResult](Data-RacingNew.html#t:RaceResult)
-\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction)
[Connection](Data-SqlTransaction.html#t:Connection) ()

race :: RandomGen g =\> [RaceConfig](Data-RacingNew.html#t:RaceConfig)
-\> g -\> Either String [RaceResult](Data-RacingNew.html#t:RaceResult)

raceData ::
[RaceParticipant](Data-RaceParticipant.html#t:RaceParticipant) -\>
[RaceResult](Data-RacingNew.html#t:RaceResult) -\>
[RaceData](Data-RacingNew.html#t:RaceData)

raceResult2FE :: [RaceResult](Data-RacingNew.html#t:RaceResult) -\>
[RaceResult](Data-RacingNew.html#t:RaceResult)

raceWithParticipant :: RandomGen g =\>
[RaceParticipant](Data-RaceParticipant.html#t:RaceParticipant) -\>
[Track](Data-Track.html#t:Track) -\> g -\> Either String
[RaceResult](Data-RacingNew.html#t:RaceResult)

runRaceM :: RandomGen g =\> [RaceM](Data-RacingNew.html#t:RaceM) a -\> g
-\> [RaceConfig](Data-RacingNew.html#t:RaceConfig) -\> Either String a

runRaceWithParticipant ::
[RaceParticipant](Data-RaceParticipant.html#t:RaceParticipant) -\>
[Track](Data-Track.html#t:Track) -\>
[Environment](Data-Environment.html#t:Environment) -\>
[RaceResult](Data-RacingNew.html#t:RaceResult)

runSectionM :: [SectionM](Data-RacingNew.html#t:SectionM) a -\>
[SectionConfig](Data-RacingNew.html#t:SectionConfig) -\> Either String a

sectionConfig :: [Section](Data-Section.html#t:Section) -\>
[RaceSectionPerformance](Data-RaceSectionPerformance.html#t:RaceSectionPerformance)
-\> [RaceM](Data-RacingNew.html#t:RaceM)
[SectionConfig](Data-RacingNew.html#t:SectionConfig)

testDefRace :: IO ()

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
