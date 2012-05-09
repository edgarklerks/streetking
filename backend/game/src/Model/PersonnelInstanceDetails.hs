{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TemplateHaskell #-}
module Model.PersonnelInstanceDetails where 

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
$(genAllId "PersonnelInstanceDetails" "personnel_instance_details" "personnel_instance_id" [
    ("personnel_instance_id", ''Id),
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
    ("busy_until", ''Integer),
    ("paid_until", ''Integer)
    ])
