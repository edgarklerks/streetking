{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TemplateHaskell, OverloadedStrings #-}
module Model.ShopReport where 

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
type MBool = Maybe Bool

$(genAll "ShopReport" "shopping_reports" 
    [ ("id", ''Id),
        ("account_id", ''Integer),
        ("time", ''Integer),
        ("report_type_id", ''Integer),
        ("report_type", ''String),
        ("report_descriptor", ''String),
        ("part_instance_id", ''MInteger),
        ("car_instance_id",''MInteger),
        ("car_id", ''MInteger),
        ("part_id", ''MInteger),
        ("amount", ''Integer),
        ("car_manufacturer_name", ''MString),
        ("car_top_speed", ''MInteger),
        ("car_acceleration", ''MInteger),
        ("car_braking", ''MInteger),
        ("car_nos", ''MInteger),
        ("car_handling", ''MInteger),
        ("car_name", ''MString),
        ("car_level", ''MInteger),
        ("car_year", ''MInteger),
        ("car_price", ''MInteger),
        ("car_weight", ''MInteger),
        ("car_improvement", ''MInteger),
        ("car_wear", ''MInteger),
        ("part_weight", ''MInteger),
        ("part_level", ''MInteger),
        ("part_car_model", ''MString),
        ("part_parameter1", ''MInteger),
        ("part_parameter2", ''MInteger),
        ("part_parameter3", ''MInteger),
        ("part_parameter1_type", ''MString),
        ("part_parameter2_type", ''MString),
        ("part_parameter3_type", ''MString),
        ("part_parameter1_name", ''MString),
        ("part_parameter2_name", ''MString),
        ("part_parameter3_name", ''MString),
        ("part_modifier", ''MString),
        ("part_unique", ''MBool),
        ("part_improvement", ''MInteger),
        ("part_wear", ''MInteger),
        ("part_type", ''MString),
        ("part_manufacturer_name", ''MString),
        ("part_parameter1_modifier", ''MString),
        ("part_parameter2_modifier", ''MString),
        ("part_parameter3_modifier", ''MString)
    ])
