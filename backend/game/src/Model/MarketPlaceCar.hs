{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TemplateHaskell, OverloadedStrings #-}
module Model.MarketPlaceCar where 

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

$(genAllId "MarketPlaceCar" "market_place_car" "car_instance_id" [
        ("car_instance_id", ''Id),
        ("price", ''Integer),
        ("top_speed", ''Integer),
        ("acceleration", ''Integer),
        ("braking", ''Integer),
        ("handling", ''Integer),
        ("nos", ''Integer),
        ("weight", ''Integer),
        ("manufacturer_name", ''String),
        ("level", ''Integer),
        ("year", ''Integer),
        ("wear", ''Integer),
        ("improvement", ''Integer),
        ("account_id", ''Integer),
        ("model", ''String)
    ])
