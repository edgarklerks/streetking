
module Data.Driver where

import Data.Constants
import qualified Model.Account as A

-- driver skills are projected percentage scores
-- in a test run with just one driver, skills are projected based on relative strength (weight of skill in sum of all skills)
-- in a race with more than one driver, skills are projected based on comparison with other driver(s) (weight of skill in sum of same skill for all drivers)

data Driver = Driver {
    skillAcceleration :: Double,
    skillBraking :: Double,
    skillControl :: Double,
    skillIntelligence :: Double,
    skillReactions :: Double
} deriving Show

testDriver :: Driver
testDriver = Driver 0.4 0.2 0.3 0.6 0.5

foolDriver :: Driver
foolDriver = Driver 0.4 0.2 0.3 0.01 0.5

leetDriver :: Driver
leetDriver = Driver 0.4 0.2 0.3 0.99 0.5

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

