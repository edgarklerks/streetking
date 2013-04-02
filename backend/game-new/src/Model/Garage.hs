{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TemplateHaskell, OverloadedStrings #-}
module Model.Garage where 

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

$(genAll "Garage" "garage"
    [
        ("id", ''Id),
        ("account_id", ''Integer),
        ("name", ''String)
    ])

target = "garage"
fs = [
        ("id", ''Id),
        ("account_id", ''Integer),
        ("name", ''String)
    ]

schema = map fst fs
relation = Rel.view target schema
