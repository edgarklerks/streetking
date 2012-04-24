{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TemplateHaskell #-}
module Model.PartMarket where 

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


$(genAll "PartMarket" "market_parts" [
    ("id", ''Id),
    ("part_type_id", ''Integer),
    ("weight", ''Integer),
    ("parameter", ''Integer),
    ("car_id", ''Id),
    ("d3d_model_id", ''Integer),
    ("level", ''Integer),
    ("name", ''String),
    ("price", ''Integer)
 ])


