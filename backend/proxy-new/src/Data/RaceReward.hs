{-# LANGUAGE TemplateHaskell, OverloadedStrings  #-}

module Data.RaceReward (
    RaceRewards (..)
) where

import Model.TH
import Model.General
import Data.Monoid 
import Data.InRules
import Data.Conversion
import qualified Data.Aeson as AS
import Data.Text
import Data.Default

import qualified Model.PartDetails as PD

type PartDetailsList = [PD.PartDetails]

$(genMapableRecord "RaceRewards" [
        ("money", ''Integer),
        ("respect", ''Integer),
        ("parts", ''PartDetailsList)
    ])

type RaceRewardsList = [RaceRewards]

instance Monoid RaceRewards where 
        mempty = RaceRewards 0 0 []
        mappend (RaceRewards a b c)  (RaceRewards a' b' c') = RaceRewards (a + a') (b + b') (c <> c')

instance Num RaceRewards where
    (+) = (<>) 
    fromInteger n = RaceRewards n 0 []
    abs n = n 
    signum _ = 1
    (*) = error "race rewards doesn't implement multiplication"


