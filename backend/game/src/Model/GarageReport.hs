{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TemplateHaskell #-}
module Model.GarageReport where 

import           Data.SqlTransaction
import           Database.HDBC
import           Data.Convertible
import           Model.General
import           Data.Database 
import           Data.InRules
import           Control.Monad

import           Control.Applicative
import qualified Data.Map as M
import           Model.TH
import           Prelude hiding (id)


type MInteger = Maybe Integer 
type MString = Maybe String 
type MBool = Maybe Bool 
$(genAll "GarageReport" "garage_reports" [
                ("id", ''Id),
                ("account_id", ''Integer),
                ("time", ''Integer),
                ("report_type_id", ''Integer),
                ("report_type", ''String),
                ("report_descriptor", ''String),
                ("personnel_instance_id", ''Integer),
                ("part_instance_id", ''Integer),
                ("personnel_id", ''Id),
                ("garage_id", ''Id),
                ("name", ''String),
                ("country_name", ''String),
                ("country_shortname", ''String),
                ("gender", ''Bool),
                ("picture", ''String),
                ("salary", ''Integer),
                ("skill_repair", ''Integer),
                ("skill_engineering", ''Integer),
                ("training_cost_repair", ''Integer),
                ("training_cost_engineering", ''Integer),
                ("paid_until", ''Integer),
                ("part_type", ''String),
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
                ("level", ''Integer),
                ("price", ''Integer),
                ("car_model", ''MString),
                ("manufacturer_name", ''MString),
                ("part_modifier", ''MString),
                ("unique", ''Bool),
                ("improvement_change", ''MInteger),
                ("wear_changed", ''MInteger),
                ("task", ''String)

                ])

