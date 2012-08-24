{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TemplateHaskell, OverloadedStrings #-}
module Model.TrackCity where 

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

$(genAll "TrackCity" "track_city"
    [
--        ("id", ''Id),
        ("city_id", ''Integer),
        ("city_name", ''String),
        ("city_data", ''String),
        ("city_level", ''Integer),
        ("city_tracks", ''Integer),
        ("continent_id", ''Integer),
        ("continent_name", ''String),
        ("continent_data", ''String)
    ]
 )

