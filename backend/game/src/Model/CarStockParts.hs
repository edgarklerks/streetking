{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TemplateHaskell, OverloadedStrings #-}
module Model.CarStockParts where 

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

type MInteger = Maybe Integer 
$(genAll "CarStockPart" "car_stock_parts" [
    ("id", ''Id),
    ("part_type_id", ''Integer),
    ("weight", ''Integer),
    ("parameter1", ''MInteger),
    ("parameter2", ''MInteger),
    ("parameter3", ''MInteger),
    ("parameter1_type_id", ''MInteger),
    ("parameter2_type_id", ''MInteger),
    ("parameter3_type_id", ''MInteger),
    ("car_id", ''Id),
    ("d3d_model_id", ''Integer),
    ("level", ''Integer),
    ("price", ''Integer),
    ("part_modifier_id", ''MInteger),
    ("unique", ''Bool)
 ])


