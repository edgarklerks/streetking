
module Data.Driver where

import Data.Constants
import qualified Model.Account as A

data Driver = Driver {
    skillAcceleration :: Double,
    skillBraking :: Double,
    skillControl :: Double,
    skillIntelligence :: Double,
    skillReactions :: Double
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
accountDriver a = Driver (m acc) (m brk) (m ctl) (m itl) (m rct)
    where
        m = normalizeSkill 
        acc = (fromInteger . A.skill_acceleration) a
        brk = (fromInteger . A.skill_braking) a
        ctl = (fromInteger . A.skill_control) a
        itl = (fromInteger . A.skill_intelligence) a
        rct = (fromInteger . A.skill_reactions) a

skillCushionFactor :: Double
skillCushionFactor = 40

normalizeSkill :: Double -> Double
normalizeSkill = (1-) . (1/) . (1+) . (/skillCushionFactor)


