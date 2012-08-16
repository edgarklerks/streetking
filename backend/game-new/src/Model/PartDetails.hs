{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TemplateHaskell, OverloadedStrings #-}
module Model.PartDetails where 

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


$(genAll "PartDetails" "parts_details"
    [
        ("id", ''Id),
        ("name", ''String),
        ("weight", ''Integer),
        ("parameter1", ''Integer),
        ("parameter1_name", ''String),
        ("parameter1_unit", ''String),
        ("parameter2", ''Integer),
        ("parameter2_name", ''String),
        ("parameter2_unit", ''String),
        ("parameter3", ''Integer),
        ("parameter3_name", ''String),
        ("parameter3_unit", ''String),
        ("car_id", ''Integer),
        ("d3d_model_id", ''Integer),
        ("level", ''Integer),
        ("price", ''Integer),
        ("car_model", ''String),
        ("manufacturer_name", ''String),
        ("part_modifier", ''String),
        ("unique", ''Bool),
        ("sort_part_type", ''Integer),
        ("required", ''Bool),
        ("fixed", ''Bool),
        ("hidden", ''Bool)
   ])
