{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TemplateHaskell #-}
module Model.CarInstanceParts where 

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

type MString =  Maybe String 
type MInteger = Maybe Integer 
$(genAllId "CarInstanceParts" "car_instance_parts" "car_instance_id" 
    [
        ("part_instance_id", ''Integer),
        ("car_instance_id", ''Integer),
        ("part_id", ''Integer),
        ("name", ''String),
        ("part_type_id", ''Integer),
        ("weight", ''Integer),
        ("parameter1", ''MInteger),
        ("parameter1_unit", ''MString),
        ("parameter1_name", ''MString),
        ("parameter2", ''MInteger),
        ("parameter2_unit", ''MString),
        ("parameter2_name", ''MString),
        ("parameter3", ''MInteger),
        ("parameter3_unit", ''MString),
        ("parameter3_name", ''MString),
        ("car_id", ''Id),
        ("d3d_model_id", ''Integer),
        ("level", ''Integer),
        ("price", ''Integer),
        ("car_model", ''MString),
        ("manufacturer_name", ''MString),
        ("part_modifier", ''MString),
        ("unique", ''Bool),
        ("sort_part_type", ''Integer),
        ("new_price", ''Integer),
        ("account_id", ''MInteger)

    ])


