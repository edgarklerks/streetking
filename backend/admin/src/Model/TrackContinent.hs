{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TemplateHaskell, OverloadedStrings #-}
module Model.TrackContinent where 

import           Data.SqlTransaction
import           Database.HDBC
import           Data.Convertible
import           Model.General
import           Data.Database 
import           Control.Monad
import qualified Data.Aeson as AS
import Data.Conversion

import           Control.Applicative
import qualified Data.Map as M
import           Model.TH
import           Prelude hiding (id)

$(genAll "TrackContinent" "track_continent"
    [
--        ("id", ''Id),
        ("continent_id", ''Integer),
        ("continent_name", ''String),
        ("continent_data", ''String),
        ("continent_level", ''Integer),
        ("continent_tracks", ''Integer)
    ]
 )

