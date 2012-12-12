{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TemplateHaskell, OverloadedStrings #-}
module Model.GarageReport where 

import           Data.SqlTransaction
import           Database.HDBC
import           Data.Convertible
import           Model.General
import           Data.Database 
import           Data.Conversion
import           Control.Monad
import qualified Data.Aeson as AS
import Data.Conversion

import           Control.Applicative
import qualified Data.Map as M
import           Model.TH
import           Prelude hiding (id)


type MInteger = Maybe Integer 
type MString = Maybe String 
type MBool = Maybe Bool 
$(genAll "GarageReport" "garage_reports" [
                ("id", ''Id),
                ("account_id", ''MInteger),
                ("time", ''MInteger),
                ("report_type_id", ''MInteger),
                ("report_descriptor", ''MString),
                ("personnel_instance_id", ''MInteger),
                ("part_instance_id", ''MInteger),
                ("personnel_id", ''Id),
                ("name", ''MString),
                ("country_name", ''MString),
                ("country_shortname", ''MString),
                ("gender", ''MBool),
                ("picture", ''MString),
                ("salary", ''MInteger),
                ("skill_repair", ''MInteger),
                ("skill_engineering", ''MInteger),
                ("training_cost_repair", ''MInteger),
                ("training_cost_engineering", ''MInteger),
                ("paid_until", ''MInteger),
                ("part_type", ''MString),
                ("weight", ''MInteger),
                ("parameter1", ''MInteger),
                ("parameter1_unit", ''MString),
                ("parameter1_name", ''MString),
                ("parameter2", ''MInteger),
                ("parameter2_unit", ''MString),
                ("parameter2_name", ''MString),
                ("parameter3", ''MInteger),
                ("parameter3_unit", ''MString),
                ("parameter3_name", ''MString),
                ("level", ''MInteger),
                ("price", ''MInteger),
                ("car_model", ''MString),
                ("manufacturer_name", ''MString),
                ("part_modifier", ''MString),
                ("unique", ''MBool),
                ("improvement", ''MInteger),
                ("improvement_change", ''MInteger),
                ("wear", ''MInteger),
                ("wear_change", ''MInteger),
                ("task", ''MString),
                ("part_id", ''MInteger)

                ])

