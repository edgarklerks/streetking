
module Data.Driver (
    Driver (..),
    accountDriver
) where

import Data.Constants
import qualified Model.Account as A

data Driver = Driver {
    acceleration :: Double,
    braking :: Double,
    control :: Double,
    intelligence :: Double,
    reactions :: Double
} deriving Show

defaultDriver :: Driver
defaultDriver = Driver 0.5 0.5 0.5 0.5 0.5

testDriver :: Driver
testDriver = defaultDriver 

noobDriver :: Driver
noobDriver = Driver 0.05 0.05 0.05 0.05 0.05

leetDriver :: Driver
leetDriver = Driver 0.8 0.8 0.8 0.8 0.8

accountDriver :: A.Account -> Driver
accountDriver a = Driver acc brk ctl itl rct
    where
        m = normalizeSkill 
        acc = m $ (fromInteger . A.skill_acceleration) a
        brk = m $ (fromInteger . A.skill_braking) a
        ctl = m $ (fromInteger . A.skill_control) a
        itl = m $ (fromInteger . A.skill_intelligence) a
        rct = m $ (fromInteger . A.skill_reactions) a

skillCushionFactor :: Double
skillCushionFactor = 40

normalizeSkill :: Double -> Double
normalizeSkill = (1-) . (1/) . (1+) . (/skillCushionFactor)


