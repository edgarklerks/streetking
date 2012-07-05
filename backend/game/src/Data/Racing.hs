

module Data.Racing where

import Data.Constants
import Data.Car
import Data.Environment
-- import Data.Track

{-
 - in: Car, Environment, [Cell]
 - out: [Progress]
 -
 - v_in (speed into cell)
 - v_out (speed out of cell)
 - v_max (highest speed achieved)
 - v_avg (average speed over cell)
 - t (total time in cell)
 - path (path quality %, worst 0 to best 1)
 -}

-- general

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

-- minimum distance traveled before car can be stopped from v (m/s)
stoppingDistance :: Car -> Environment -> Double -> Double
stoppingDistance c e v = m * v^2 / (2 * b)
    where
        b = min (brf c) (mu * m * g) -- max braking is lower value of braking force and maximum force applied through tyres
        m = mass c
        mu = (tco c) * (mtraction e)
        g = constant "g"

lateralAcceleration :: Car -> Environment -> Double -> Double
lateralAcceleration c e r = h * mu * g / (1 - r * df / m) 
    where
        h = hlm c
        mu = (tco c) * (mtraction e)
        df = dnf c
        m = mass c
        g = constant "g"

corneringSpeed :: Car -> Environment -> Double -> Double
corneringSpeed c e r = sqrt $ (r *) $ lateralAcceleration c e r

-- display quantities

acceleration :: Car -> Environment -> Double
acceleration c e = accelerationTime c e $ 100 * (constant "kmh")

topspeed :: Car -> Environment -> Double
topspeed c e = (p / ak) ** (1.0/3.0)
    where
        p = pwr c
        ak = 0.5 * (rho e) * (cda c)

cornering :: Car -> Environment -> Double
cornering c e = lateralAcceleration c e 100

stopping :: Car -> Environment -> Double
stopping c e = stoppingDistance c e $ 100 * (constant "kmh")

nitrous :: Car -> Environment -> Double
nitrous c e = nos c


