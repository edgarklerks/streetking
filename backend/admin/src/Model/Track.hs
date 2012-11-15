{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TemplateHaskell, OverloadedStrings #-}
module Model.Track where 

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
import           Prelude hiding (id, length)

$(genAll "Track" "track" 
    [
        ("id", ''Id),
        ("city_id", ''Integer),
        ("name", ''String),
        ("level", ''Integer),
        ("energy_cost", ''Integer),
        ("data", ''String),
        ("loop", ''Bool),
        ("length", ''Double),
        ("top_time_id", ''Id)
    ])
