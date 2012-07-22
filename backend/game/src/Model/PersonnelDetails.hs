{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TemplateHaskell, OverloadedStrings #-}
module Model.PersonnelDetails where 

import           Data.SqlTransaction
import           Database.HDBC
import           Data.Convertible
import           Model.General
import           Data.Database 
import           Data.InRules
import           Control.Monad
import qualified Data.Aeson as AS

import           Control.Applicative
import qualified Data.Map as M
import           Model.TH
import           Prelude hiding (id)


type MInteger = Maybe Integer 
$(genAllId "PersonnelDetails" "personnel_details" "personnel_id" [
    ("personnel_id", ''Id),
    ("name", ''String),
    ("country_name", ''String),
    ("country_shortname", ''String),
    ("gender", ''Bool),
    ("picture", ''String),
    ("salary", ''Integer),
    ("price", ''Integer),
    ("skill_repair", ''Integer),
    ("skill_engineering", ''Integer),
    ("sort", ''Integer)
    ])
