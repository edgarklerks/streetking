{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TemplateHaskell, OverloadedStrings #-}
module Model.PersonnelInstance where 

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
$(genAll "PersonnelInstance" "personnel_instance" [
    ("id", ''Id),
    ("personnel_id", ''MInteger),
    ("garage_id", ''Integer),
    ("skill_repair", ''Integer),
    ("skill_engineering", ''Integer),
    ("training_cost_repair", ''Integer),
    ("training_cost_engineering", ''Integer),
    ("salary", ''Integer),
    ("paid_until", ''Integer),
    ("task_id", ''Integer),
    ("task_started", ''Integer),
    ("task_end", ''Integer),
    ("task_updated", ''Integer),
    ("task_subject_id", ''Integer),
    ("deleted", ''Bool)
    ])
