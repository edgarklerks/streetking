
module Data.Constants (
    constant, ms2kmh, kmh2ms
) where

import Data.HashMap.Strict as H
import Control.Monad
import Control.Monad.State 

type Constants = HashMap String Double

bla :: String -> Double -> State Constants ()
bla x y = modify (insert x y)

p xs = snd $ flip runState empty $ do 
            forM_ xs $ \(x,y) -> bla x y

constants = p [

        ("W/hp", 750.0),                    -- Watt per hp
        ("pe", 0.5),                        -- power efficiency of car engine

        ("g", 9.81),                        -- gravitational acceleration
        ("kmh", 1 / 3.6),                   -- km/h per m/s

        ("rhoV", -0.004351),                -- air density variation per K around 273K
        ("rho0", 1.2922),                   -- air density at 273K

        ("p0", 0),                          -- car power hp base
        ("pR", 500),                        -- car power hp range

        ("mu0", 0.75),                      -- car traction coefficient base
        ("muR", 0.75),                      -- car traction coefficient range

        ("cda0", 0.75),                     -- inverse car drag coefficient base
        ("cdaR", -0.5),                     -- inverse car drag coefficient range

        ("df0", 0),                         -- car downforce base
        ("dfR", 3),                         -- car downforce range

        ("he0", 0.5),                       -- car handling multiplier base
        ("heR", 0.5),                       -- car handling multiplier range

        ("bf0", 7000),                      -- car braking force base
        ("bfR", 21000)                      -- car braking force range
     ]

constant :: String -> Double
constant k = case H.lookup k constants of
    Just v -> v
    Nothing -> error $ "constant doesn't exist: " ++ k 

ms2kmh :: Double -> Double
ms2kmh = (/ (constant "kmh"))

kmh2ms :: Double -> Double
kmh2ms = (* (constant "kmh"))


