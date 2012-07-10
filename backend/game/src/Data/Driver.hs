
module Data.Driver where

import Data.Constants

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


