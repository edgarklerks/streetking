{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TemplateHaskell, OverloadedStrings #-}
module Model.ManufacturerMarket where 

import           Data.SqlTransaction
import           Database.HDBC
import           Data.Convertible
import           Model.General
import           Data.Database 
import           Control.Monad
import qualified Data.Aeson as AS
import Data.Conversion

import           Control.Applicative
import qualified Data.Map as M
import           Model.TH
import           Prelude hiding (id)

$(genAll "ManufacturerMarket" "manufacturer_market"
    [
        ("id", ''Id),
        ("name", ''String),
        ("picture", ''String),
        ("text", ''String),
        ("label", ''String),
        ("level", ''Integer)
    ]
    )
