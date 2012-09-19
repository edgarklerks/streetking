{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TemplateHaskell, OverloadedStrings #-}
module Model.ParameterTable where 

import           Data.SqlTransaction
import           Database.HDBC
import           Data.Convertible
import           Model.General
import           Data.Database 
import           Control.Monad
import qualified Data.Aeson as AS
import           Data.Conversion

import           Control.Applicative
import qualified Data.Map as M
import           Model.TH
import           Prelude hiding (id)
type MString = Maybe String 
$(genAll "ParameterTable" "parameter_table" [
        ("id", ''Id),
        ("name", ''String),
        ("unit", ''MString),
        ("modifier", ''Bool)
    ])
