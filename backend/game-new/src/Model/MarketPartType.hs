{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TemplateHaskell, OverloadedStrings #-}
module Model.MarketPartType where 

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

$(genAllId "MarketPartType" "market_part_types" "car_id" [
    ("car_id", ''Id),
    ("name", ''String),
    ("level", ''Integer)
    ])
