-- | Car specific functions 
module Data.Car (
        Car (..),
        pwr,
        hlm,
        tco,
        cda,
        dnf,
        brp,
        carInGarageCar,
        carMinimalCar,
        testCar, zeroCar, noobCar, leetCar, oneCar

    ) where

import Data.Constants
import qualified Model.CarInGarage as CIG
import qualified Model.CarMinimal as CMI

-- | Car parameters, units as described, % from 0 to 1 
data Car = Car {
    mass :: Double,     -- ^ kg
    power :: Double,    -- ^ %
    traction :: Double, -- ^ %
    handling :: Double, -- ^ %
    braking :: Double,  -- ^ %
    aero :: Double,     -- ^ %
    nos :: Double       -- ^ %
} deriving Show

-- | Car is stored in integer format in database 
dbCar :: Integer -> Integer -> Integer -> Integer -> Integer -> Integer -> Integer -> Car
dbCar m p t h b a n = Car (fromInteger m) (cast p) (cast t) (cast h) (cast b) (cast a) (cast n)
    where
        cast = (/10000) . fromInteger

-- | Transform a CarInCarage to a Car 
carInGarageCar :: CIG.CarInGarage -> Car
carInGarageCar gc = dbCar (CIG.weight gc) (CIG.power gc) (CIG.traction gc) (CIG.handling gc) (CIG.braking gc) (CIG.aero gc) (CIG.nos gc)

-- | Transform a CarMinimal to a Car  
carMinimalCar :: CMI.CarMinimal -> Car
carMinimalCar gc = dbCar (CMI.weight gc) (CMI.power gc) (CMI.traction gc) (CMI.handling gc) (CMI.braking gc) (CMI.aero gc) (CMI.nos gc)

-- | The zero car, doesn't drive
zeroCar :: Car
zeroCar = Car 1500 0 0 0 0 0 0

-- | A minimal running car 
noobCar :: Car
noobCar = Car 1800 0.1 0.1 0.1 0.1 0.1 0.1

-- | Default car 
defaultCar :: Car
defaultCar = Car 1400 0.5 0.5 0.5 0.5 0.5 0.5

-- | Very good car 
leetCar :: Car
leetCar = Car 1200 0.9 0.9 0.9 0.9 0.9 0.9

-- | Best car 
oneCar :: Car
oneCar = Car 1200 1 1 1 1 1 1

-- | Test car, is the same as default car 
testCar :: Car
testCar = defaultCar



-- | power in hp
pwr' :: Car -> Double
pwr' = ((constant "p0") +) . ((constant "pR") *) . power

-- | effectively usable power in Watt
pwr :: Car -> Double
pwr = ((constant "pe") *) . ((constant "W/hp") *) . pwr'

-- | traction coefficient
tco :: Car -> Double
tco = ((constant "mu0") +) . ((constant "muR") *) . traction

-- | handling multiplier to maximum lateral acceleration
hlm :: Car -> Double
hlm = ((constant "he0") +) . ((constant "heR") *) . handling

-- | drag coefficient
cda :: Car -> Double
cda = ((constant "cda0") +) . ((constant "cdaR") *) . normalizeProperty . aero

-- | downforce per square m/s
dnf :: Car -> Double
dnf = ((constant "df0") +) . ((constant "dfR") *) . aero

-- braking force -- TODO: eliminate
--brf :: Car -> Double
--brf = ((constant "bf0") +) . ((constant "bfR") *) . braking

-- | braking force as a factor of the traction limit
brp :: Car -> Double
brp = ((constant "bp0") +) . ((constant "bpR") *) . braking


-- | some properties can run into negatives and must be normalized to avoid weird values
propertyCushionFactor :: Double
propertyCushionFactor = 0.25 -- normalize to 0-1: np cf = 0.5

-- | Normalize a car property 
normalizeProperty :: Double -> Double
normalizeProperty = (1-) . (1/) . (1+) . (/propertyCushionFactor)


