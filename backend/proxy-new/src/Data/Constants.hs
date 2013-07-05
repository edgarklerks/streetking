
module Data.Constants (
    constant, ms2kmh, kmh2ms
) where

import           Control.Monad
import           Control.Monad.State 
import           Data.HashMap.Strict as H

type Constants = HashMap String Double

bla :: String -> Double -> State Constants ()
bla x y = modify (insert x y)

p xs = snd $ flip runState empty $ do 
            forM_ xs $ \(x,y) -> bla x y

-- 1000 power in -> 500 work out of it
constants = p [

        ("W/hp", 746.0),                    -- Watt per hp
        ("pe", 0.55),                       -- power efficiency of car engine

        ("g", 9.81),                        -- gravitational acceleration
        ("kmh", 1 / 3.6),                   -- km/h per m/s
        ("e", 2.7182818284),                -- Euler's number (base of the natural logarithm) 

        ("rhoV", -0.004351),                -- air density variation per K around 273K
        ("rho0", 1.2922),                   -- air density at 273K

        ("p0", 0),                         -- car power hp base
        ("pR", 500),                        -- car power hp range

        ("mu0", 0.75),                      -- car traction coefficient base
        ("muR", 0.75),                      -- car traction coefficient range

        ("cda0", 0.75),                     -- drag coefficient base
        ("cdaR", -0.5),                     -- drag coefficient range

        ("df0", 0),                         -- car downforce base
        ("dfR", 3),                         -- car downforce range

        ("he0", 0.5),                       -- car handling multiplier base
        ("heR", 0.5),                       -- car handling multiplier range

--        ("bf0", 7000),                      -- car braking force base -- TODO: eliminate
--        ("bfR", 21000),                     -- car braking force range -- TODO: eliminate

        ("bp0", 0.5),                       -- car braking percentage of max traction 
        ("bpR", 0.5)                        -- car braking percentage of force base
     ]

constant :: String -> Double
constant k = case H.lookup k constants of
    Just v -> v
    Nothing -> error $ "constant doesn't exist: " ++ k 

ms2kmh :: Double -> Double
ms2kmh = (/ (constant "kmh"))

kmh2ms :: Double -> Double
kmh2ms = (* (constant "kmh"))


