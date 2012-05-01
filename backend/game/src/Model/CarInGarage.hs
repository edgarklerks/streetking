{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TemplateHaskell #-}
module Model.CarInGarage where 

import           Data.SqlTransaction
import           Database.HDBC
import           Data.Convertible
import           Model.General
import           Data.Database 
import           Control.Monad

import           Control.Applicative
import qualified Data.Map as M
import           Model.TH
import           Prelude hiding (id)

$(genAll "CarInGarage" "car_in_garage"
    [
        ("id", ''Id),
        ("car_id", ''Integer),
        ("manufacturer_name", ''String),
        ("manufacturer_picture", ''String),
        ("top_speed", ''Integer),
        ("braking", ''Integer),
        ("nos", ''Integer),
        ("handling", ''Integer),
        ("name", ''String),
        ("acceleration", ''Integer),
        ("price", ''Integer)
    ])
