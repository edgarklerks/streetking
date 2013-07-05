
module Data.Environment (
        Environment (..),
        defaultEnvironment,
        rho,
        environment
    ) where

import           Data.Constants
import           Data.Track

data Environment = Environment {
    mtraction :: Double,    -- traction multiplier due to weather conditions (i.e. frost, rain etc.)
    temperature :: Double,  -- temperature in degrees C
    humidity :: Double      -- humidity (not currently used, greater humidity reduces rho)
} deriving Show

defaultEnvironment :: Environment
defaultEnvironment = Environment 1 15 0.5 

-- density of air 
rho :: Environment -> Double
rho = ((constant "rho0") +) . ((constant "rhoV") *) . temperature

environment :: Track -> Environment
environment _ = defaultEnvironment
