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

type MInteger = Maybe Integer
type MString = Maybe String 

$(genAll "PartDetails" "parts_details"
    [
        ("id", ''Id),
        ("name", ''String),
        ("weight", ''Integer),
        ("parameter1", ''MInteger),
        ("parameter1_name", ''MString),
        ("parameter1_unit", ''MString),
        ("parameter2", ''MInteger),
        ("parameter2_name", ''MString),
        ("parameter2_unit", ''MString),
        ("parameter3", ''MInteger),
        ("parameter3_name", ''MString),
        ("parameter3_unit", ''MString),
        ("car_id", ''Integer),
        ("d3d_model_id", ''Integer),
        ("level", ''Integer),
        ("price", ''Integer),
        ("car_model", ''MString),
        ("manufacturer_name", ''MString),
        ("part_modifier", ''String),
        ("unique", ''Bool),
        ("sort_part_type", ''Integer),
        ("required", ''Bool),
        ("fixed", ''Bool),
        ("hidden", ''Bool)
   ])
