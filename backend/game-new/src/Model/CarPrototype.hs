{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TemplateHaskell, OverloadedStrings #-}
module Model.CarPrototype where 

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
import qualified Data.Relation as Rel

$(genAll "CarPrototype" "car_prototype"
    [
        ("id", ''Id),
        ("car_model_id", ''Integer),
        ("manufacturer_id", ''Integer),

        ("top_speed", ''Integer),
        ("acceleration", ''Integer),
        ("stopping", ''Integer),
        ("cornering", ''Integer),
        ("nitrous", ''Integer),

        ("power", ''Integer),
        ("aero", ''Integer),
        ("braking", ''Integer),
        ("nos", ''Integer),
        ("handling", ''Integer),

        ("prototype_name", ''String),
        ("prototype_available", ''Bool),
        ("prototype_claimable", ''Bool),

        ("name", ''String),
        ("use_3d", ''String),
        ("year", ''Integer),
        ("level", ''Integer),
        ("manufacturer_name", ''String),
        ("label", ''String),
        ("car_label", ''String),
        ("price", ''Integer)
    ])
