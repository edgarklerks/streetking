{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TemplateHaskell, OverloadedStrings #-}
module Model.TrackMaster where 

import           Data.SqlTransaction
import           Database.HDBC
import           Data.Convertible
import           Model.General
import           Data.Database 
import           Control.Monad
import qualified Data.Aeson as AS

import           Control.Applicative
import qualified Data.Map as M
import           Model.TH
import           Prelude hiding (id)

$(genAll "TrackMaster" "track_master"
    [
--        ("id", ''Id),
        ("track_id", ''Integer),
        ("track_name", ''String),
        ("track_data", ''String),
        ("track_level", ''Integer),
        ("city_id", ''Integer),
        ("city_name", ''String),
        ("city_data", ''String),
        ("continent_id", ''Integer),
        ("continent_name", ''String),
        ("continent_data", ''String)
    ]
 )

