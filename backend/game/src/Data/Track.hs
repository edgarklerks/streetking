
module Data.Track where

import Data.Section
import qualified Model.TrackDetails as TD

type Track = [Section]

trackDetailsTrack :: [TD.TrackDetails] -> Track
trackDetailsTrack ts = map trackDetailsSection  ts
