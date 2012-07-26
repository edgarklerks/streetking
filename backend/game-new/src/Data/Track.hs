
module Data.Track where

import Data.Section
import qualified Model.TrackDetails as TD

data Track = Track {
        track_id :: Integer,
        sections :: [Section]
    }

trackDetailsTrack :: [TD.TrackDetails] -> Track
trackDetailsTrack [] = Track 0 []
trackDetailsTrack ts = Track (TD.track_id $ head ts) (map trackDetailsSection  ts)
