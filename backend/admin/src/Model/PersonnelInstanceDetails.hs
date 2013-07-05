{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TemplateHaskell, OverloadedStrings #-}
module Model.PersonnelInstanceDetails where 

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
import qualified Data.Relation as Rel


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
    ("task_id", ''Integer),
    ("task_name", ''String),
    ("task_started", ''Integer),
    ("task_end", ''Integer),
    ("task_updated", ''Integer),
    ("task_time_left", ''Integer),
    ("task_subject_id", ''Integer),
    ("paid_until", ''Integer)
    ])
