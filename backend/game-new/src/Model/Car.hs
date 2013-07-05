{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TemplateHaskell, OverloadedStrings #-}
module Model.Car where 

import           Control.Applicative
import           Control.Monad
import           Data.Convertible
import           Data.Database 
import           Data.SqlTransaction
import           Database.HDBC
import           Model.General
import           Model.TH
import           Prelude hiding (id)
import qualified Data.Relation as Rel
import           Data.Conversion
import qualified Data.Aeson as AS
import qualified Data.Map as M

$(genAll "Car" "car_model"
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
        ("price", ''Integer)
    ])

