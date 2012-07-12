{-# LANGUAGE TemplateHaskell, LiberalTypeSynonyms #-}

module Data.Racing where

import Data.Constants
import Data.Car
import Data.Driver
import Data.Environment
import Data.Section
import Data.Maybe
import Model.TH
import Model.General
import Data.InRules
import Data.Conversion
import Database.HDBC
import qualified Data.HashMap.Strict as H
import Debug.Trace

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
        ("sectionPath", ''Path),
        ("sectionSpeedMax", ''Speed),
        ("sectionSpeedAvg", ''Speed),
        ("sectionSpeedOut", ''Speed),
        ("sectionTime", ''Time')
        ])

type SectionResults = [SectionResult]
instance FromInRule SectionResult 
instance ToInRule SectionResult

$(genMapableRecord "RaceResult"
    [
            ("raceTime", ''Time'),
            ("raceSpeedMax", ''Speed),
            ("raceSpeedAvg", ''Speed),
            ("raceSpeedFin", ''Speed),
            ("sectionResults", ''SectionResults)
        ])

raceResult2FE :: RaceResult -> RaceResult
raceResult2FE (RaceResult t vm va vf ss) = RaceResult t (ms2kmh vm) (ms2kmh va) (ms2kmh vf) (map sectionResult2FE ss)

sectionResult2FE :: SectionResult -> SectionResult
sectionResult2FE (SectionResult p vm va vo t)  = SectionResult p (ms2kmh vm) (ms2kmh va) (ms2kmh vo) t

-- RaceResult to writable HashMap list
mapRaceResult :: RaceResult -> [H.HashMap String SqlValue]
mapRaceResult = (map mapSectionResult) . sectionResults

-- SectionResult to writable HashMap;
mapSectionResult :: SectionResult -> H.HashMap String SqlValue
mapSectionResult s = H.fromList $ [
        ("time", toSql $ sectionTime s),
        ("path", toSql $ sectionPath s),
        ("speed_max", toSql $ sectionSpeedMax s),
        ("speed_avg", toSql $ sectionSpeedAvg s),
        ("speed_out", toSql $ sectionSpeedOut s)
   ]

-- 500m straight
testSection1 = Section Nothing 500

-- 25m sharp turn, approx. quarter circle
testSection2 = Section (Just 15) 25

-- 300m weak turn
testSection3 = Section (Just 100) 300

-- race track
testTrack = [
        Section Nothing 1000,
        Section (Just 20) 30,
        Section Nothing 250,
        Section (Just 100) 300,
        Section Nothing 500
    ]

track1 = [
        Section Nothing 100,
        Section (Just 20) 30,
        Section Nothing 100
    ]

-- run a path using driver skills. path is a double 0 - 1 indicating the quality of the traveled path.
-- from this and the section properties, the effective radius and path length are calculated.
path :: Driver -> Path
path d = skillIntelligence d -- TODO: randomize

-- "correct" a section, i.e. take into account the path and modify the angle, arclength and radius accordingly
pathSection :: Section -> Path -> Section
pathSection s p = Section (sectionPathRadius s p) (sectionPathLength s p)

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

-- TODO: path generally worse than section line if radius is very large. disallow large radii or fix path in these instances
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

-- for a driver, car and environment, given a list of sections, make a list of section results
runRace :: [Section] -> Driver -> Car -> Environment -> RaceResult
runRace ss d c e = res $ runRace' ss' d c e
    where
        ss' :: [(Section, Path, Speed)] -- each section with a path and the exit speed limit (i.e., the max speed in the next section). the last section effectively has no exit speed limit.
        ss' = zipWith3 (\s p v -> (s,p,v)) ss ps (tail $ vs ++ [lightSpeed])
        vs :: [Speed] -- the max speed in each section, based on section properties, path, driver, car and environment
        vs = zipWith (\s p -> topSpeed (pathSection s p) d c e) ss ps
        ps :: [Path] -- a path for each section, based on driver only
        ps = map (\_ -> path d) ss
        res :: [SectionResult] -> RaceResult
        res rs = RaceResult t vm va vf rs
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
data IState = IState Time' Length Speed Speed Bool

-- runSection: integrate over section 
runSection :: Section -> Path -> Speed -> Speed -> Driver -> Car -> Environment -> SectionResult
runSection s p vin vnext d c e = proc $ IState 0 0 vin vin False
    where
        s' = pathSection s p
        l = arclength s'
        vlim = topSpeed s d c e
        proc :: IState -> SectionResult
        proc (IState t x vm v b) = case (x >= l) of
--            True -> SectionResult p (kmh vm) (kmh (l/t)) (kmh v) t
            True -> SectionResult p vm (l/t) v t
--            False -> traceShow ((show s) ++ " -- " ++ (show t) ++ "s, " ++ (show x) ++ "m, " ++ (show v) ++ "m/s") $ proc $ IState (t + deltaTime) (x + deltaTime * v) (max v vm) v' b'
            False -> proc $ IState (t + deltaTime) (x + deltaTime * v) (max v vm) v' b'
                where
                    -- determine distance needed to brake to vnext
                    -- TODO: driver always brakes too early: (l - x + err). err is reduced by driver skill.
                    -- TODO: speed reduction is based on braking only and should account for drag force, too.
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


