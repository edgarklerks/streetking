{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TemplateHaskell, OverloadedStrings #-}
module Model.CarMarket where 

import           Data.SqlTransaction
import           Database.HDBC
import           Data.Convertible
import           Model.General
import           Data.Database 
import           Control.Monad
import qualified Data.Aeson as AS
import Data.InRules

import           Control.Applicative
import qualified Data.Map as M
import           Model.TH
import           Prelude hiding (id)

$(genAll "CarMarket" "car_market"
    [
        ("id", ''Id),
        ("manufacturer_id", ''Integer),
        ("top_speed", ''Integer),
        ("acceleration", ''Integer),
        ("braking", ''Integer),
        ("nos", ''Integer),
        ("handling", ''Integer),
        ("name", ''String),
        ("use_3d", ''String),
        ("year", ''Integer),
        ("level", ''Integer),
        ("manufacturer_name", ''String),
        ("label", ''String),
        ("price", ''Integer)
    ])
