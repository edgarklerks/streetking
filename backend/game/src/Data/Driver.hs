
module Data.Driver where

import Data.Constants
import Model.Account

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

-- TODO: normalize skills by relative values between skills
accountDriver :: Account -> Driver
accountDriver a = Driver ((fromInteger . skill_acceleration) a) ((fromInteger . skill_braking) a) ((fromInteger . skill_control) a) ((fromInteger . skill_intelligence) a) ((fromInteger . skill_reactions) a)

-- TODO: make drivers from list of accounts -> normalize skills by relative values between accounts
