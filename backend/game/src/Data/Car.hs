

module Data.Car where

import Data.Constants

data Car = Car {
    mass :: Double,     -- kg
    power :: Double,    -- %
    traction :: Double, -- %
    handling :: Double, -- %
    braking :: Double,  -- %
    aero :: Double,     -- %
    nos :: Double       -- %
} deriving Show

testCar :: Car
testCar = Car 1200 0.6 0.3 0.2 0.4 0.1 0.2

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
cda = (1.0 / ) . ((constant "cdai0") -) . ((constant "cdaiR") *) . aero

-- downforce per square m/s
dnf :: Car -> Double
dnf = ((constant "df0") +) . ((constant "dfR") *) . aero

-- braking force
brf :: Car -> Double
brf = ((constant "bf0") +) . ((constant "bfR") *) . braking


