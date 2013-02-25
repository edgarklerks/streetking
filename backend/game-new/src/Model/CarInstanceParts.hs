{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TemplateHaskell, OverloadedStrings #-}
module Model.CarInstanceParts where 

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

type MString =  Maybe String 
type MInteger = Maybe Integer 
type MBool = Maybe Bool

$(genAllId "CarInstanceParts" "car_instance_parts" "car_instance_id" 
    [
        ("part_instance_id", ''Integer),
        ("car_instance_id", ''Integer),
        ("part_id", ''Integer),
        ("name", ''String),
        ("part_type_id", ''Integer),
        ("weight", ''Integer),
        ("improvement", ''Integer),
        ("wear", ''Integer),
        ("parameter1", ''MInteger),
        ("parameter1_unit", ''MString),
        ("parameter1_name", ''MString),
        ("parameter1_is_modifier", ''MBool),
        ("parameter2", ''MInteger),
        ("parameter2_unit", ''MString),
        ("parameter2_name", ''MString),
        ("parameter2_is_modifier", ''MBool),
        ("parameter3", ''MInteger),
        ("parameter3_unit", ''MString),
        ("parameter3_name", ''MString),
        ("parameter3_is_modifier", ''MBool),
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
        ("account_id", ''MInteger),
        ("required", ''Bool),
        ("fixed", ''Bool),
        ("hidden", ''Bool)

    ])


