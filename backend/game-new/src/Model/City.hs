{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TemplateHaskell, OverloadedStrings #-}
module Model.City where 

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

import qualified Data.Aeson as AS
import Data.Conversion
import qualified Data.Relation as Rel

$(genAll "City" "city"
    [
        ("id", ''Id),
        ("continent_id", ''Integer),
        ("level", ''Integer),
        ("name", ''String),
        ("data", ''String),
        ("default", ''Bool)
    ]
 )

fs = [
        ("id", ''Id),
        ("continent_id", ''Integer),
        ("level", ''Integer),
        ("name", ''String),
        ("data", ''String),
        ("default", ''Bool)
    ]

target = "city"

schema = map fst fs
relation = Rel.view target schema
