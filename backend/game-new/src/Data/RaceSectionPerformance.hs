{-# LANGUAGE TemplateHaskell, OverloadedStrings  #-}

module Data.RaceSectionPerformance (
        RaceSectionPerformance(..),
        perfectPerformance
    ) where

import Model.TH
import Model.General

import Data.Maybe

import Data.InRules
import Data.Conversion
import qualified Data.Aeson as AS
import Data.Text

import Data.Section

type Performance = Double

$(genMapableRecord "RaceSectionPerformance" [
        ("intelligence", ''Performance),
        ("acceleration", ''Performance),
        ("braking", ''Performance),
        ("control", ''Performance),
        ("reactions", ''Performance)
    ])

perfectPerformance :: RaceSectionPerformance
perfectPerformance = RaceSectionPerformance {   
        intelligence = 1,
        acceleration = 1,
        braking = 1,
        control = 1,
        reactions = 1
    }

