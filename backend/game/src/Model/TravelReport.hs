{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TemplateHaskell, OverloadedStrings #-}
module Model.TravelReport where 

import           Data.SqlTransaction
import           Database.HDBC
import           Data.Convertible
import           Model.General
import           Data.Database 
import           Control.Monad
import qualified Data.Aeson as AS

import           Control.Applicative
import qualified Data.Map as M
import           Model.TH
import           Prelude hiding (id)

type MInteger = Maybe Integer
type MString = Maybe String 
type MBool = Maybe Bool

$(genAll "TravelReport" "travel_reports"
    [ ("id", ''Id),
        ("account_id", ''Integer),
        ("time", ''Integer),
        ("report_type_id", ''Integer),
        ("report_descriptor", ''String),
        ("city_to", ''String),
        ("city_from", ''String),
        ("continent_to", ''MString),
        ("continent_from", ''MString)
    ]) 
