

module Data.Car where

import Data.Constants
import qualified Model.CarInGarage as CIG

data Car = Car {
    mass :: Double,     -- kg
    power :: Double,    -- %
    traction :: Double, -- %
    handling :: Double, -- %
    braking :: Double,  -- %
    aero :: Double,     -- %
    nos :: Double       -- %
} deriving Show

dbCar :: Integer -> Integer -> Integer -> Integer -> Integer -> Integer -> Integer -> Car
dbCar m p t h b a n = Car (fromInteger m) (cast p) (cast t) (cast h) (cast b) (cast a) (cast n)
    where
        cast = (/10000) . fromInteger

carInGarageCar :: CIG.CarInGarage -> Car
carInGarageCar gc = dbCar (CIG.weight gc) (CIG.power gc) (CIG.traction gc) (CIG.handling gc) (CIG.braking gc) (CIG.aero gc) (CIG.nos gc)

noobCar :: Car
noobCar = Car 1800 0.1 0.1 0.1 0.1 0.1 0.1

defaultCar :: Car
defaultCar = Car 1400 0.5 0.5 0.5 0.5 0.5 0.5

leetCar :: Car
leetCar = Car 1200 0.9 0.9 0.9 0.9 0.9 0.9

testCar :: Car
testCar = defaultCar

nznCar :: Car
nznCar = Car 1329 0.35 0.3 0.66 0.0061 0.3 0



-- power in hp
pwr' :: Car -> Double
pwr' = ((constant "p0") +) . ((constant "pR") *) . power

-- effectively usable power in Watt
pwr :: Car -> Double
pwr = ((constant "pe") *) . ((constant "W/hp") *) . pwr'

-- traction coefficient
tco :: Car -> Double
tco = ((constant "mu0") +) . ((constant "muR") *) . traction

-- handling multiplier to maximum lateral acceleration
hlm :: Car -> Double
hlm = ((constant "he0") +) . ((constant "heR") *) . handling

-- drag coefficient
cda :: Car -> Double
cda = ((constant "cda0") +) . ((constant "cdaR") *) . normalizeProperty . aero

-- downforce per square m/s
dnf :: Car -> Double
dnf = ((constant "df0") +) . ((constant "dfR") *) . aero

-- braking force
brf :: Car -> Double
brf = ((constant "bf0") +) . ((constant "bfR") *) . braking


-- some properties can run into negatives and must be normalized to avoid weird values
propertyCushionFactor :: Double
propertyCushionFactor = 0.25 -- normalize to 0-1: np cf = 0.5

normalizeProperty :: Double -> Double
normalizeProperty = (1-) . (1/) . (1+) . (/propertyCushionFactor)


