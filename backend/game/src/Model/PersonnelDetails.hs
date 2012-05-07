{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TemplateHaskell #-}
module Model.PersonnelDetails where 

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
$(genAll "PersonnelDetails" "personnel_details" [
    ("id", ''Id),
    ("name", ''String),
    ("country_name", ''String),
    ("country_shortname", ''String),
    ("personnel_id", ''MInteger),
    ("gender", ''Bool),
    ("picture", ''String),
    ("skill", ''Integer),
    ("salary", ''Integer),
    ("price", ''Integer),
    ("sort", ''Integer)
    ])
