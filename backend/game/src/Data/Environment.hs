
module Data.Environment where

import Data.Constants

data Environment = Environment {
    mtraction :: Double,    -- traction modifier due to weather conditions
    temperature :: Double,  -- temperature in degrees C
    humidity :: Double      -- humidity (not currently used, greater humidity reduces rho)
} deriving Show

defaultEnvironment = Environment 1 15 0.5 

-- density of air 
rho :: Environment -> Double
rho = ((constant "rho0") +) . ((constant "rhoV") *) . temperature

