{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TemplateHaskell #-}
module Model.PersonnelReport where 

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

type MInteger = Maybe Integer 
type MString = Maybe String
type MBool = Maybe Bool 
$(genAll "PersonnelReport" "personnel_reports" 
    [ ("id", ''Id),
        ("account_id", ''Integer),
        ("time", ''Integer),
        ("report_type_id", ''Integer),
        ("report_type", ''String),
        ("report_descriptor", ''String),
        ("personnel_instance_id", ''MInteger),
        ("part_instance_id", ''MInteger),
        ("cost", ''MInteger),
        ("result", ''String),
        ("data", ''String)

    ])
