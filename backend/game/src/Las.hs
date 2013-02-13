{-# LANGUAGE TemplateHaskell #-}
module Car where 

import Data.Lens.Common
import Data.Lens.Template 
import Data.Semigroupoid

data Car = Car {
        power :: Double,
        traction :: Double,
        handling :: Double,
        braking :: Double,
        aero :: Double,
        nos :: Double
    } deriving Show

test = Car 1 2 3 4 5 6
getLala p = nos p * 2 
