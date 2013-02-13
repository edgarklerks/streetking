{-# LANGUAGE TemplateHaskell, FlexibleContexts, FlexibleInstances, TypeSynonymInstances, FunctionalDependencies, MultiParamTypeClasses, OverloadedStrings, RankNTypes, ScopedTypeVariables #-}

module Data.CarDerivedParameters ( 
--        withDerivedParameters,
--        withDerivedParametersMin
        searchCarInGarage,
        getCarInGarage,
        loadCarInGarage,
        previewWithPartList,
        previewWithPart,
        searchCarMinified,
        loadCarMinified,
        getCarMinified

) where


--import Control.Monad
import Model.TH
import Model.General
import Data.InRules
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
import Data.Maybe
import Data.Default
import qualified Data.HashMap.Strict as HM
import qualified Data.Aeson as AS

import qualified Model.CarInGarage as CIG
import qualified Model.CarMinimal as CMI
import qualified Model.GarageParts as GP
import qualified Model.CarInstanceParts as CIP

import qualified Model.MarketPlaceCar as MPC

import Data.CarReady
import Debug.Trace
import qualified Data.Car as C

type BaseParameter = Double
type BaseParameterModifier = Double

zeroBaseParam :: BaseParameter
zeroBaseParam = 0

zeroBaseParamModifier :: BaseParameterModifier
zeroBaseParamModifier = 1

$(genMapableRecord "CarBaseParameters" [
        ("car_mass", ''BaseParameter),
        ("car_power", ''BaseParameter),
        ("car_power_m", ''BaseParameterModifier),
        ("car_traction", ''BaseParameter),
        ("car_traction_m", ''BaseParameterModifier),
        ("car_braking", ''BaseParameter),
        ("car_braking_m", ''BaseParameterModifier),
        ("car_handling", ''BaseParameter),
        ("car_handling_m", ''BaseParameterModifier),
        ("car_aero", ''BaseParameter),
        ("car_aero_m", ''BaseParameterModifier),
        ("car_nos", ''BaseParameter),
        ("car_nos_m", ''BaseParameterModifier)
    ])

zeroParams :: CarBaseParameters
zeroParams = CarBaseParameters {
        car_mass = zeroBaseParam,
        car_power = zeroBaseParam,
        car_power_m = zeroBaseParamModifier,
        car_traction = zeroBaseParam,
        car_traction_m = zeroBaseParamModifier,
        car_braking = zeroBaseParam,
        car_braking_m = zeroBaseParamModifier,
        car_handling = zeroBaseParam,
        car_handling_m = zeroBaseParamModifier,
        car_aero = zeroBaseParam,
        car_aero_m = zeroBaseParamModifier,
        car_nos = zeroBaseParam,
        car_nos_m = zeroBaseParamModifier
    }

$(genMapableRecord "CarDerivedParameters" [
        ("car_acceleration", ''Integer),
        ("car_top_speed", ''Integer),
        ("car_cornering", ''Integer),
        ("car_stopping", ''Integer),
        ("car_nitrous", ''Integer)
    ]) 


$(genMapableRecord "PartParameter" [
        ("parameter", ''Double),
        ("parameter_name", ''String),
        ("parameter_is_modifier", ''Bool)
    ])

$(genMapableRecord "PreviewPart" [
        ("part", ''GP.GaragePart),
        ("params", ''CarDerivedParameters)
    ])

type PreviewParts = [PreviewPart]

type PartData = (Integer, [PartParameter])

todbi :: Double -> Integer
todbi = floor . (10000 *)
fromdbi :: Integer -> Double
fromdbi = (/ 10000) . fromInteger

type Speed = Double
type Length = Double

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
searchCarMinified cs os l o = (map CMI.toCM) <$> searchCarInGarage cs os l o

getCarMinified :: Constraints -> SqlTransaction Connection CIG.CarInGarage -> SqlTransaction Connection CMI.CarMinimal
getCarMinified cs f = CMI.toCM <$> getCarInGarage cs f

loadCarMinified :: Integer -> SqlTransaction Connection CIG.CarInGarage -> SqlTransaction Connection CMI.CarMinimal
loadCarMinified i f = CMI.toCM <$> loadCarInGarage i f


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


deriveParameters :: CarBaseParameters -> CarDerivedParameters
deriveParameters b = CarDerivedParameters {
        car_acceleration = todbi $ derive acceleration car,
        car_top_speed = todbi $ derive topspeed car,
        car_cornering = todbi $ derive cornering car,
        car_stopping = todbi $ derive stopping car,
        car_nitrous = todbi $ derive nitrous car
    }
        where car = C.Car {
                C.mass = car_mass b,
                C.power = (car_power b) * (car_power_m b),
                C.traction = (car_traction b) * (car_traction_m b),
                C.handling = (car_handling b) * (car_handling_m b),
                C.braking = (car_braking b) * (car_braking_m b),
                C.aero = (car_aero b) * (car_aero_m b),
                C.nos = (car_nos b) * (car_nos_m b)
            }

zeroParameters :: CarDerivedParameters
zeroParameters = CarDerivedParameters {
        car_acceleration = 0,
        car_top_speed = 0,
        car_cornering = 0,
        car_stopping = 0,
        car_nitrous = 0
}

type CarPartMap = HM.HashMap Integer PartData 

garagePartsToMap :: [GP.GaragePart] -> CarPartMap
garagePartsToMap ps = foldr insertGaragePart HM.empty ps

insertGaragePart :: GP.GaragePart -> CarPartMap -> CarPartMap
insertGaragePart p m = HM.insert (GP.part_type_id p) (GP.weight p, garagePartParams p) m

garagePartParams :: GP.GaragePart -> [PartParameter] 
garagePartParams p = addParam i w (fromdbi <$> GP.parameter1 p, GP.parameter1_name p, GP.parameter1_is_modifier p) $
                     addParam i w (fromdbi <$> GP.parameter2 p, GP.parameter2_name p, GP.parameter2_is_modifier p) $
                     addParam i w (fromdbi <$> GP.parameter3 p, GP.parameter3_name p, GP.parameter3_is_modifier p) []
                            where
                                    i = fromdbi $ GP.improvement p
                                    w = fromdbi $ GP.wear p

carPartsToMap :: [CIP.CarInstanceParts] -> CarPartMap
carPartsToMap ps = foldr insertCarPart HM.empty ps

insertCarPart :: CIP.CarInstanceParts -> CarPartMap -> CarPartMap
insertCarPart p m = HM.insert (CIP.part_type_id p) (CIP.weight p, carPartParams p) m

carPartParams :: CIP.CarInstanceParts -> [PartParameter] 
carPartParams p = addParam i w (fromdbi <$> CIP.parameter1 p, CIP.parameter1_name p, CIP.parameter1_is_modifier p) $
                     addParam i w (fromdbi <$> CIP.parameter2 p, CIP.parameter2_name p, CIP.parameter2_is_modifier p) $
                     addParam i w (fromdbi <$> CIP.parameter3 p, CIP.parameter3_name p, CIP.parameter3_is_modifier p) []
                            where
                                    i = fromdbi $ CIP.improvement p
                                    w = fromdbi $ CIP.wear p

addParam :: Double -> Double -> (Maybe Double, Maybe String, Maybe Bool) -> [PartParameter] -> [PartParameter]
addParam i w p ps = case p of
        (Just v, Just n, Just m) -> (PartParameter { parameter = paramModified v i w, parameter_name = n, parameter_is_modifier = m }) : ps
        otherwise -> ps

-- modify parameter for improvement and wear. improvement can add up to 50% and wear can reduce up to 50%. effects are multiplicative.
-- parameter = parameter0 * (1 + 0.5 * (improvement / 10000.0)) * (1 - 0.5 * (wear / 10000.0));
paramModified :: Double -> Double -> Double -> Double
paramModified v i w = v * (1 + 0.3 * i) * (1 - 0.5 * w);

baseParameters :: CarPartMap -> CarBaseParameters
baseParameters m = HM.foldr step zeroParams m
    where
        step :: PartData -> CarBaseParameters -> CarBaseParameters
        step (m, ps) b = let o = car_mass b in foldr step' (b { car_mass = o + (fromInteger m)} ) ps
        step' :: PartParameter -> CarBaseParameters -> CarBaseParameters
        step' p b = apl (parameter p) (parameter_name p) (parameter_is_modifier p) b
        apl :: Double -> String -> Bool -> CarBaseParameters -> CarBaseParameters
        apl v n m p = case (n,m) of
                ("Power", False) -> let o = car_power p in p { car_power = o + v } 
                ("Power", True) -> let o = car_power_m p in p { car_power_m = o * (1+v) } 
                ("Traction", False) -> let o = car_traction p in p { car_traction = o + v } 
                ("Traction", True) -> let o = car_traction_m p in p { car_traction_m = o * (1+v) } 
                ("Handling", False) -> let o = car_handling p in p { car_handling = o + v } 
                ("Handling", True) -> let o = car_handling_m p in p { car_handling_m = o * (1+v) } 
                ("Aerodynamics", False) -> let o = car_aero p in p { car_aero = o + v } 
                ("Aerodynamics", True) -> let o = car_aero_m p in p { car_aero_m = o * (1+v) } 
                ("Braking", False) -> let o = car_braking p in p { car_braking = o + v } 
                ("Braking", True) -> let o = car_braking_m p in p { car_braking_m = o * (1+v) } 
                ("NOS", False) -> let o = car_nos p in p { car_nos = o + v } 
                ("NOS", True) -> let o = car_nos_m p in p { car_nos_m = o * (1+v) } 
                otherwise -> p

previewWithPart :: CIG.CarInGarage -> GP.GaragePart -> SqlTransaction Connection PreviewPart
previewWithPart cig gp = head <$> previewWithPartList cig [gp]

-- TODO: previewWithoutPart -> same stuff for removing attached parts

-- TODO: wtf -- reload the car from database when we already have a car? this file is an unspeakable mess and needs to be cleaned up.

previewWithPartList :: CIG.CarInGarage -> [GP.GaragePart] -> SqlTransaction Connection [PreviewPart]
previewWithPartList cig gps = do
        m <- carPartsToMap <$> search ["car_instance_id" |== toSql (CIG.id cig)] [] 1000 0 :: SqlTransaction Connection CarPartMap
        let ds = map (\p -> case GP.wear p > 9999 of
                        True -> zeroParameters
                        False -> deriveParameters $ baseParameters $ insertGaragePart p m
                    ) gps
        return $ zipWith (\d p -> PreviewPart { part = p, params = d } ) ds gps

-- doSql $ testPreview 442 ["part_type_id" |== SqlInteger 19]
testPreview :: Integer -> Constraints -> SqlTransaction Connection [PreviewPart]
testPreview cid q = do
        cig <- loadCarInGarage cid $ rollback "could not retrieve car"
        gps <- search q [] 10 0 :: SqlTransaction Connection [GP.GaragePart]
        previewWithPartList cig gps




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

