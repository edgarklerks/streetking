{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TemplateHaskell #-}
module Model.Car where 

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

$(genAll "Car" "car"
    [
        ("id", ''Id),
        ("manufacturer_id", ''Integer),
        ("acceleration", ''Integer),
        ("top_speed", ''Integer),
        ("braking", ''Integer),
        ("nos", ''Integer),
        ("handling", ''Integer)
    ])
