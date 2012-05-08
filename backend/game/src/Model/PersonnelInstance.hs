{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TemplateHaskell #-}
module Model.PersonnelInstance where 

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
$(genAll "PersonnelInstance" "personnel_instance" [
    ("id", ''Id),
    ("personnel_id", ''MInteger),
    ("garage_id", ''Integer),
    ("skill_repair", ''Integer),
    ("skill_engineering", ''Integer),
    ("salary", ''Integer),
    ("paid_until", ''Integer),
    ("busy_until", ''Integer)
    ])
