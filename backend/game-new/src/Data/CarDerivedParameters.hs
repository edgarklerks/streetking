{-# LANGUAGE FlexibleContexts, FlexibleInstances, TypeSynonymInstances, FunctionalDependencies, MultiParamTypeClasses, OverloadedStrings, RankNTypes #-}


module Data.CarDerivedParameters ( 
--        withDerivedParameters,
--        withDerivedParametersMin
        searchCarInGarage,
        getCarInGarage,
        loadCarInGarage
) where


--import Control.Monad
import Data.Database
import Data.SqlTransaction
import Database.HDBC (toSql)
import Data.Conversion
import Data.InRules
import System.Random
import Data.Constants
import Data.Car
import Data.Environment
import Control.Monad.Error
import qualified Data.RacingNew as R
import qualified Data.RaceSectionPerformance as P
import Data.Section
import Control.Monad.Reader
import Control.Applicative
import Data.Database
import Model.General
import Data.Maybe

import qualified Model.CarInGarage as CIG
import qualified Model.CarMinimal as CMI

import qualified Model.MarketPlaceCar as MPC

import Data.CarReady

todbi :: Double -> Integer
todbi = floor . (10000 *)
fromdbi :: Integer -> Double
fromdbi = (/ 10000) . fromInteger

type Speed = Double
type Length = Double


{-

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
--brakingForce c e = min (brf c) (mu * m * g) 
-- braking force is braking factor multiplied with tyre traction factor
brakingForce c e = (brf c) * mu * m * g 
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
dragForce c e v = {-# SCC dragForce #-} v^2 * 0.5 * (rho e) * (cda c)

-- acceleration force for car in environment at speed v using continuous transmission approximation: torque T ~ P/v. at low speeds, T is limited by tyre traction.
accelerationForce :: Car -> Environment -> Speed -> Double
accelerationForce c e v = {-# SCC accelerationForce #-} case (v <= tractionSpeedTreshold c e) of
    True -> {-# SCC aTrue #-}  (mass c) * (tco c) * (mtraction e) * (constant "g")
    False -> {-# SCC aFalse #-} (pwr c) / v
    
-- acceleration: time for 0 - 100 km/h in s, disregarding drag
acceleration :: Car -> Double
acceleration c = accelerationTime c defaultEnvironment $ 100 * (constant "kmh")

-- topspeed: maximum speed reachable due to engine power opposed by drag
topspeed :: Car -> Double
topspeed c = (p / ak) ** (1/3 :: Double) / (constant "kmh")
    where
        p = pwr c
        ak = 0.5 * (rho defaultEnvironment) * (cda c)

-- cornering: maximum lateral acceleration in g for a curve with radius 100 m
cornering :: Car -> Double
cornering c = (lateralAcceleration c defaultEnvironment 100) / (constant "g") 

-- stopping: distance traveled while braking from 100 - 0 km/h, disregarding drag and reactions
stopping :: Car -> Double
stopping c = stoppingDistance c defaultEnvironment $ 100 * (constant "kmh")

-- nitrous: not yet specified
nitrous :: Car -> Double
nitrous c = nos c

-}

searchCarInGarage :: Constraints -> Orders -> Integer -> Integer -> SqlTransaction Connection [CIG.CarInGarage]
searchCarInGarage cs os l o = do
        xs <- search cs os l o :: SqlTransaction Connection [CIG.CarInGarage]
        forM xs $ \x -> do
                r <- (carReady . fromJust . CIG.id) x
                case ready r of
                        True -> return $ withDerivedParameters x
                        False -> return $ withZeroParameters x

getCarInGarage :: [Constraint] -> SqlTransaction Connection CIG.CarInGarage -> SqlTransaction Connection CIG.CarInGarage
getCarInGarage cs f = do
        xs <- searchCarInGarage cs [] 1 0
        case xs of
                x:_ -> return x
                otherwise -> f

loadCarInGarage :: Integer -> SqlTransaction Connection CIG.CarInGarage -> SqlTransaction Connection CIG.CarInGarage
loadCarInGarage i f = getCarInGarage ["id" |== toSql i] f

--ptest :: (ToInRule a, ToInRule b, FromInRule b) => a -> b -> b 
--ptest a b = fromInRule $ project (toInRule b) (toInRule a)

searchCarMinified :: Constraints -> Orders -> Integer -> Integer -> SqlTransaction Connection [CMI.CarMinimal]
searchCarMinified cs os l o = (map CMI.minify) <$> searchCarInGarage cs os l o

getCarMinified :: Constraints -> SqlTransaction Connection CIG.CarInGarage -> SqlTransaction Connection CMI.CarMinimal
getCarMinified cs f = CMI.minify <$> getCarInGarage cs f

loadCarMinified :: Integer -> SqlTransaction Connection CIG.CarInGarage -> SqlTransaction Connection CMI.CarMinimal
loadCarMinified i f = CMI.minify <$> loadCarInGarage i f


withDerivedParameters :: CIG.CarInGarage -> CIG.CarInGarage
withDerivedParameters cig = cig {
        CIG.acceleration = todbi $ derive acceleration car,
        CIG.top_speed = todbi $ derive topspeed car,
        CIG.cornering = todbi $ derive cornering car,
        CIG.stopping = todbi $ derive stopping car,
        CIG.nitrous = todbi $ derive nitrous car
    }
        where car = carInGarageCar cig

withZeroParameters :: CIG.CarInGarage -> CIG.CarInGarage
withZeroParameters cig = cig {
        CIG.acceleration = 0,
        CIG.top_speed = 0,
        CIG.cornering = 0,
        CIG.stopping = 0,
        CIG.nitrous = 0
    }
        where car = carInGarageCar cig

{-
ithDerivedParametersMin :: CMI.CarMinimal -> CMI.CarMinimal 
withDerivedParametersMin cig = cig {
        CMI.acceleration = todbi $ derive acceleration car,
        CMI.top_speed = todbi $ derive topspeed car,
        CMI.cornering = todbi $ derive cornering car,
        CMI.stopping = todbi $ derive stopping car,
        CMI.nitrous = todbi $ derive nitrous car
    }
        where car = carMinimalCar cig
-}


derive :: R.RaceM a -> Car -> a
derive m c = case R.runRaceM m g rc of
            Left err -> undefined -- derivation cannot return error
            Right r -> r
    where
        g :: StdGen = undefined -- derivation must be deterministic
        rc = R.RaceConfig {
                R.car = c,
                R.environment = defaultEnvironment,
                R.driver = undefined, -- derivation is driver independent
                R.track = undefined -- derivation is track independent
            }
 
deriveM :: R.SectionM a -> R.RaceM a
deriveM m = do
        c <- R.sectionConfig defaultSection $ P.perfectPerformance -- { P.intelligence = 0.5, P.reaction = 0.5 } -- maximize car potential but do not perturb section
        case R.runSectionM m c of
                Left e -> throwError e
                Right r -> return r
    where
        defaultSection = Section 0 (Just 100) 250

-- time to accelerate from 0 to 100 km/h
acceleration :: R.RaceM Double
acceleration = deriveM $ R.accelerationTime 0 $ kmh2ms 100 

-- distance to stop from 100 km/h
stopping :: R.RaceM Double
stopping = deriveM $ R.brakingDistance (kmh2ms 100) 0

-- car top speed
topspeed :: R.RaceM Double
topspeed = deriveM $ ms2kmh <$> asks R.topSpeed

-- cornering in maximum g's. this depends on the corner radius because of aerodynamic downforce effects being speed dependent.
cornering :: R.RaceM Double
cornering = deriveM $ (/ (constant "g")) <$> R.lateralAcceleration

nitrous :: R.RaceM Double
nitrous = return 0

