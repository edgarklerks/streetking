{-# LANGUAGE TemplateHaskell, LiberalTypeSynonyms, GeneralizedNewtypeDeriving, ScopedTypeVariables, OverloadedStrings #-}

module Data.Racing where

import Data.Constants
import Data.Car
import Data.Driver
import Data.Environment
import Data.Track
import Data.Section
import Data.Maybe
import Model.TH
import Model.General
import Data.InRules
import Data.Conversion
import Database.HDBC
import qualified Data.HashMap.Strict as H
import qualified Data.ByteString.Lazy as LB
import qualified Data.Aeson as AS
import Debug.Trace
import System.Random
import Control.Monad.State 
import Control.Monad.Random 
import Control.Monad.Writer 
import Control.Monad
import Control.Applicative
import Data.InRules

import qualified Model.AccountProfile as AP
import qualified Model.CarInGarage as CIG

type Path = Double
type Speed = Double
type Radius = Double
type Length = Double
type Angle = Double
type Time' = Double

deltaTime :: Time'
deltaTime = 0.01

lightSpeed :: Speed
lightSpeed = 299792458

initialSpeed :: Speed
initialSpeed = 0

trackWidth :: Radius
trackWidth = 10.0 -- road width in metres. TODO: this should be a variable in every section.

{--
data RaceResult = RaceResult {
    raceTime :: Time',
    raceSpeedMax :: Speed,
    raceSpeedAvg :: Speed,
    raceSpeedFin :: Speed,
    sectionResults :: [SectionResult]
} deriving Show

data SectionResult = SectionResult {
    sectionPath :: Path,        -- path taken (0-1)
    sectionSpeedMax :: Speed,   -- highest speed achieved in section
    sectionSpeedAvg :: Speed,   -- average speed across section
    sectionSpeedOut :: Speed,   -- speed on leaving section
    sectionTime :: Time'        -- time taken for section
} deriving Show
--}

$(genMapableRecord "SectionResult" 
    [
        ("sectionId", ''Integer),
        ("sectionPath", ''Path),
        ("sectionSpeedMax", ''Speed),
        ("sectionSpeedAvg", ''Speed),
        ("sectionSpeedOut", ''Speed),
        ("sectionTime", ''Time')
        ])

type SectionResults = [SectionResult]

$(genMapableRecord "RaceResult"
    [
            ("trackId", ''Integer),
            ("raceTime", ''Time'),
            ("raceSpeedMax", ''Speed),
            ("raceSpeedAvg", ''Speed),
            ("raceSpeedFin", ''Speed),
            ("sectionResults", ''SectionResults)
        ])

$(genMapableRecord "RaceData"
    [
            ("rd_user", ''AP.AccountProfile),
            ("rd_car", ''CIG.CarInGarage),
            ("rd_result", ''RaceResult)
       ])

type RaceDatas = [RaceData]

raceResult2FE :: RaceResult -> RaceResult
raceResult2FE (RaceResult i t vm va vf ss) = RaceResult i t (ms2kmh vm) (ms2kmh va) (ms2kmh vf) (map sectionResult2FE ss)

sectionResult2FE :: SectionResult -> SectionResult
sectionResult2FE (SectionResult i p vm va vo t)  = SectionResult i p (ms2kmh vm) (ms2kmh va) (ms2kmh vo) t

-- instance Convertible 



{-
-- RaceResult to writable HashMap list
mapRaceResult :: RaceResult -> [H.HashMap String SqlValue]
mapRaceResult = (map mapSectionResult) . sectionResults

-- SectionResult to writable HashMap;
mapSectionResult :: SectionResult -> H.HashMap String SqlValue
mapSectionResult s = H.fromList $ [
        ("time", toSql $ sectionTime s),
        ("path", toSql $ sectionPath s),
        ("section_id", toSql $ sectionId s),
        ("speed_max", toSql $ sectionSpeedMax s),
        ("speed_avg", toSql $ sectionSpeedAvg s),
        ("speed_out", toSql $ sectionSpeedOut s)
   ]

instance AS.ToJSON RaceResult where
    toJSON r = AS.toJSON $ H.fromList $ [
                        ("track_id" :: LB.ByteString, AS.toJSON $ trackId r),
                        ("time", AS.toJSON $ raceTime r),
                        ("speed_max", AS.toJSON $ raceSpeedMax r),
                        ("speed_avg", AS.toJSON $ raceSpeedAvg r),
                        ("speed_fin", AS.toJSON $ raceSpeedFin r),
                        ("sections", AS.toJSON $ map AS.toJSON $ sectionResults r)
                    ] 

instance AS.FromJSON RaceResult where
    parseJSON (AS.Object v) = RaceResult <$>
            v AS..: "track_id" <*>
            v AS..: "time" <*>
            v AS..: "speed_max" <*>
            v AS..: "speed_avg" <*>
            v AS..: "speed_fin" <*>
            v AS..: "sections"

instance AS.ToJSON SectionResult where
    toJSON s = AS.toJSON $ H.fromList $ [
                       ("section_id" :: LB.ByteString, AS.toJSON $ sectionId s),
                       ("path", AS.toJSON $ sectionPath s),
                       ("time", AS.toJSON $ sectionTime s),
                       ("speed_out", AS.toJSON $ sectionSpeedOut s),
                       ("speed_avg", AS.toJSON $ sectionSpeedAvg s),
                       ("speed_max", AS.toJSON $ sectionSpeedMax s)
                    ]

instance AS.FromJSON SectionResult where
    parseJSON (AS.Object v) = SectionResult <$>
            v AS..: "section_id" <*>
            v AS..: "path" <*>
            v AS..: "speed_max" <*>
            v AS..: "speed_avg" <*>
            v AS..: "speed_out" <*>
            v AS..: "time"
 
instance ToInRule RaceResult where
        toInRule r = InObject $ H.fromList $ [
                        ("track_id", toInRule $ trackId r),
                        ("time", toInRule $ raceTime r),
                        ("speed_max", toInRule $ raceSpeedMax r),
                        ("speed_avg", toInRule $ raceSpeedAvg r),
                        ("speed_fin", toInRule $ raceSpeedFin r),
                        ("sections", toInRule $ map toInRule $ sectionResults r)
                    ]

instance FromInRule RaceResult where
         fromInRule (InObject d) = RaceResult (foo "track_id") (foo "time") (foo "speed_max") (foo "speed_avg") (foo "speed_fin") (foo "sections")
            where
                foo k = fromInRule $ fromJust $ H.lookup k d
 -}

{-
data RaceData = RaceData {
        rd_user :: AP.AccountProfile,
        rd_car :: CIG.CarInGarage,
        rd_result :: RaceResult
    } deriving (Show, Eq)

instance Default RaceData where
    def = RaceData (def :: AP.AccountProfile) (def :: CIG.CarInGarage) (def :: RaceResult)

instance AS.ToJSON RaceData where
        toJSON d = AS.toJSON $ H.fromList $ [
                ("user" :: LB.ByteString, AS.toJSON $ rd_user d),
                ("car", AS.toJSON $ rd_car d),
                ("result", AS.toJSON $ rd_result d)
            ]

instance AS.FromJSON RaceData where
        parseJSON (AS.Object v) = RaceData <$> v AS..: "user" <*> v AS..: "car" <*> v AS..: "result"

instance ToInRule RaceData where
         toInRule d = InObject $ H.fromList $ [
                ("user", toInRule $ rd_user d),
                ("car", toInRule $ rd_car d),
                ("result", toInRule $ rd_result d)
            ]

instance FromInRule RaceData where
         fromInRule (InObject d) = RaceData (foo "user") (foo "car") (foo "result")
            where
                foo k = fromInRule $ fromJust $ H.lookup k d
       
-}

-- 500m straight
testSection1 = Section 0 Nothing 500

-- 25m sharp turn, approx. quarter circle
testSection2 = Section 0 (Just 15) 25

-- 300m weak turn
testSection3 = Section 0 (Just 100) 300

-- race tracks
track0 = Track 0  [Section 0 Nothing 10000]

track1 = Track 0 [
        Section 0 Nothing 2000,
        Section 0 (Just 20) 33,
        Section 0 Nothing 3000
    ]

track2 = Track 0 [
        Section 0 Nothing 2000,
        Section 0 (Just 100) 200,
        Section 0 (Just 20) 30,
        Section 0 (Just 100) 150,
        Section 0 (Just 20) 30,
        Section 0 (Just 100) 200,
        Section 0 Nothing 3000
    ]

track3 = Track 0 [Section 0 (Just 100) 700]
track4 = Track 0 [Section 0 Nothing 700]

-- run a path using driver skills. path is a double 0 - 1 indicating the quality of the traveled path.
-- from this and the section properties, the effective radius and path length are calculated.
path :: Driver -> Path
path d =  skillIntelligence d 

-- "correct" a section, i.e. take into account the path and modify the angle, arclength and radius accordingly
pathSection :: Section -> Path -> Section
pathSection s@(Section i _ _) p = Section i (sectionPathRadius s p) (sectionPathLength s p)

{-
sectionPathAngle :: Section -> Path -> Maybe Angle
sectionPathAngle s p = case (radius s) of
    Nothing -> Nothing
    Just r -> Just $ (2 *) $ asin $ y / (fromJust $ sectionPathRadius s p)
        where
            y = (r *) $ sin $ (arclength s) / (r * 2)
-}

pathDeviation :: Path -> Length
pathDeviation p = trackWidth * (0.5 - p)

sectionPathAngle :: Section -> Path -> Maybe Angle
sectionPathAngle s p = case (radius s) of
    Nothing -> Nothing
    Just r0 -> case (sectionPathRadius s p) of
        Nothing -> Nothing
        Just rp -> Just $ 2 * ap
            where
                ap = atan2 y x
                y = r0 * sin a0
                x = (r0 * cos a0) - (d + r0 - rp)
                a0 = (/2) $ fromJust $ angle s
                d = pathDeviation p

sectionPathRadius :: Section -> Path -> Maybe Radius
sectionPathRadius s p = case (radius s) of
    Nothing -> Nothing
    Just r -> case ((n <) $ (0.01 +) $ r * (ca - 1)) of
                True -> Nothing -- path cuts through the section in a straight line; effective path radius goes to infinity
                False -> Just $ (2*(r+n)*x - 2*r^2 - 2*n*r - n^2) / (2*(x-r-n))
            where
                x = r * (cos a)
                n = pathDeviation p
                a = fromJust $ angle s
                ca = cos a

sectionPathLength :: Section -> Path -> Length
sectionPathLength s p = case (radius s) of
    Nothing -> arclength s
    Just r -> case (sectionPathRadius s p) of
        Nothing -> 2 * r * (sin $ (/2) $ fromJust $ (angle s)) -- path cuts through the section in a straight line; length is the difference between the y-coordinates of the intersection points
        Just rp -> rp * (fromJust $ sectionPathAngle s p)

-- calculate maximum speed in a section
topSpeed :: Section -> Driver -> Car -> Environment -> Speed
topSpeed s d c e = case (radius s) of
    Nothing -> lightSpeed
    Just r -> corneringSpeed c e r -- TODO: account for driver handling skill

data RaceConfig = RC {
        track :: Track,
        driver :: Driver,
        car :: Car,
        env :: Environment
    }

-- randT
-- State 
-- IO 
-- a

{----

newtype RaceMonad a = RM {
        unRM :: RandT StdGen (State RaceConfig) a 
    } deriving (Monad, Functor, Applicative, MonadState RaceConfig, MonadRandom) 
runRaceMonad :: RaceMonad a -> StdGen -> RaceConfig -> a 
runRaceMonad m g c = evalState (evalRandT (unRM m) g) c

raceM :: RaceMonad [a] 
raceM = do 
    p <- gets driver 
    (r :: Double) <- getRandomR (0, 1)
    return []
--}
  
-- for a driver, car and environment, given a list of sections, make a list of section results
runRace :: Track -> Driver -> Car -> Environment -> RaceResult
runRace (Track i ss) d c e = res $ runRace' ss' d c e
    where
        ss' :: [(Section, Path, Speed)] -- each section with a path and the exit speed limit (i.e., the max speed in the next section). the last section effectively has no exit speed limit.
        ss' = zipWith3 (\s p v -> (s,p,v)) ss ps (tail $ vs ++ [lightSpeed])
        vs :: [Speed] -- the max speed in each section, based on section properties, path, driver, car and environment
        vs = zipWith (\s p -> topSpeed (pathSection s p) d c e) ss ps
        ps :: [Path] -- a path for each section, based on driver only
        ps = map (\_ -> path d) ss
        res :: [SectionResult] -> RaceResult
        res rs = RaceResult i t vm va vf rs
            where
                t = sum $ map sectionTime rs
                vm = maximum $ map sectionSpeedMax rs
                va = (sum $ map arclength ss) / t
                vf = sectionSpeedOut $ last rs
       
-- (section, path, speed): for each section, the path has been determined. the speed is the maximum entry speed for the next section.
runRace' :: [(Section, Path, Speed)] -> Driver -> Car -> Environment -> [SectionResult]
runRace' sps d c e = fst $ foldl step ([], 0) sps
    where
        step :: ([SectionResult], Speed) -> (Section, Path, Speed) -> ([SectionResult], Speed)
        step (rs, vin) (s, p, vnx) = (rs ++ [res], sectionSpeedOut res)
            where
                res = runSection s p vin vnx d c e

-- integration state: current time, distance traveled, highest speed, current speed, currently braking
data IState = IState Time' Length Speed Speed Bool Integer

-- runSection: integrate over section 
runSection :: Section -> Path -> Speed -> Speed -> Driver -> Car -> Environment -> SectionResult
runSection s@(Section i _ _) p vin vnext d c e = proc $ IState 0 0 vin vin False 0
    where
        s' = pathSection s p
        l = arclength s'
        vlim = topSpeed s d c e
        proc :: IState -> SectionResult
        proc ist@(IState t x vm v b n) = case (x >= l) of
            True -> SectionResult i p (max v vm) (l/t) v t
            False -> (tr t x vm v b n) $ proc $ IState (t + deltaTime) (x + deltaTime * v) (max v vm) v' b' (n+1)
                where
                    -- determine distance needed to brake to vnext
                    -- TODO: driver always brakes too early: (l - x + err). err is reduced by driver skill.
                    -- TODO: speed reduction is based on braking only and should account for drag force, too.
                    tr t x vm v b n = case (mod n 10) of
--                        0 -> traceShow ((show s) ++ " - #" ++ (show n) ++ " - " ++ (show t) ++ "s - " ++ (show x) ++ "m - " ++ (show v) ++ "m/s")
                        _ -> id
                    b' = (||) b $ (speedReductionDistance c e v vnext) >= (l-x)
                    v' = case b' of
                        True -> max vnext $ v - deltaTime * ((brakingForce c e) + (dragForce c e v)) / (mass c)
                        False -> min vlim $ v + deltaTime * ((accelerationForce c e v) - (dragForce c e v)) / (mass c)


{-
 - General calculations
 -}

-- speed where engine power overtakes tyre traction as limiting factor to acceleration.
tractionSpeedTreshold :: Car -> Environment -> Double
tractionSpeedTreshold c e = p / (m * mu * g)
    where
        m = mass c
        mu = (tco c) * (mtraction e)
        p = pwr c
        g = constant "g"

-- time to reach traction speed treshold.
tractionSpeedTresholdTime :: Car -> Environment -> Double
tractionSpeedTresholdTime c e = p / (m * mu^2 * g^2)
    where
        m = mass c
        mu = (tco c) * (mtraction e)
        p = pwr c
        g = constant "g"

-- time to reach v (m/s). note: does not account for drag; highly inaccurate for high v.
accelerationTime :: Car -> Environment -> Double -> Double
accelerationTime c e v = (v^2 * m / p + p / (m * mu^2 * g^2)) / 2
    where
        m = mass c
        mu = (tco c) * (mtraction e)
        p = pwr c
        g = constant "g"

-- maximum braking force that can be applied is lower value of braking force and maximum force applied through tyres
brakingForce :: Car -> Environment -> Double
brakingForce c e = min (brf c) (mu * m * g) 
    where
        m = mass c
        mu = (tco c) * (mtraction e)
        g = constant "g"
 
-- minimum distance traveled before car can be stopped from v (m/s)
stoppingDistance :: Car -> Environment -> Double -> Double
stoppingDistance c e v = m * v^2 / (2 * b)
    where
        b = brakingForce c e 
        m = mass c
        mu = (tco c) * (mtraction e)
        g = constant "g"

-- distance to reduce speed from v1 to v2. TODO: this should take drag force into account!!
speedReductionDistance :: Car -> Environment -> Speed -> Speed -> Length
speedReductionDistance c e v1 v2 = (stoppingDistance c e v1) - (stoppingDistance c e v2)

-- maximum lateral acceleration in m / s^2; this limits cornering speed.
lateralAcceleration :: Car -> Environment -> Double -> Double
lateralAcceleration c e r = h * mu * g / (1 - r * df / m) 
    where
        h = hlm c
        mu = (tco c) * (mtraction e)
        df = dnf c
        m = mass c
        g = constant "g"

-- speed achievable in a corner with radius r in m.
corneringSpeed :: Car -> Environment -> Double -> Double
corneringSpeed c e r = sqrt $ (r *) $ lateralAcceleration c e r

-- drag force for car in environment at speed v
dragForce :: Car -> Environment -> Speed -> Double
dragForce c e v = v^2 * 0.5 * (rho e) * (cda c)

-- acceleration force for car in environment at speed v using continuous transmission approximation: torque T ~ P/v. at low speeds, T is limited by tyre traction.
accelerationForce :: Car -> Environment -> Speed -> Double
accelerationForce c e v = case (v <= tractionSpeedTreshold c e) of
    True -> (mass c) * (tco c) * (mtraction e) * (constant "g")
    False -> (pwr c) / v


{-
 - Display quantities
 -}

-- acceleration: time for 0 - 100 km/h in s, disregarding drag
acceleration :: Car -> Environment -> Double
acceleration c e = accelerationTime c e $ 100 * (constant "kmh")

-- topspeed: maximum speed reachable due to engine power opposed by drag
topspeed :: Car -> Environment -> Double
topspeed c e = (p / ak) ** (1/3 :: Double) / (constant "kmh")
    where
        p = pwr c
        ak = 0.5 * (rho e) * (cda c)

-- cornering: maximum lateral acceleration in g for a curve with radius 100 m
cornering :: Car -> Environment -> Double
cornering c e = (lateralAcceleration c e 100) / (constant "g") 

-- stopping: distance traveled while braking from 100 - 0 km/h, disregarding drag and reactions
stopping :: Car -> Environment -> Double
stopping c e = stoppingDistance c e $ 100 * (constant "kmh")

-- nitrous: not yet specified
nitrous :: Car -> Environment -> Double
nitrous c e = nos c


{-
 - Randomization
 -}

-- generate a random number in range [0,1] biased towards m
-- TODO: include bias level d (now fixed on power 2)
drand :: Double -> IO Double 
drand m = do
        n <- randomIO 
        case n > m of
            False -> return $ sqrt $ n * m
            True -> return $ (1 -) $ sqrt $ (m-1) *  (n-1)


