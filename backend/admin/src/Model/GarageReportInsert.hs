{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TemplateHaskell, OverloadedStrings #-}
module Model.GarageReportInsert where 

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
type MString = Maybe String 
type MBool = Maybe Bool 
$(genAll "GarageReportInsert" "garage_reports" [
                ("id", ''Id),
                ("account_id", ''Integer),
                ("time", ''Integer),
                ("report_type_id", ''Integer),
                ("report_descriptor", ''String),
                ("personnel_instance_id", ''Integer),
                ("part_instance_id", ''Integer),
                ("ready", ''Bool),
                ("data", ''String),
                ("task", ''String)
                ])

