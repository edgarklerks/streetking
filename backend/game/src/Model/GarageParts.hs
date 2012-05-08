{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TemplateHaskell #-}
module Model.GarageParts where 

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
$(genAll "GaragePart" "garage_parts" [
    ("id", ''Id),
    ("account_id", ''Integer),
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
    ("name", ''String),
    ("price", ''Integer),
    ("car_model", ''MString),
    ("manufacturer_name", ''MString),
    ("part_modifier", ''MString),
    ("wear", ''Integer),
    ("improvement", ''Integer),
    ("unique", ''Bool),
    ("part_instance_id", ''Integer),
    ("trash_price", ''Integer)
 ])


