{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TemplateHaskell, OverloadedStrings #-}
module Model.MarketItem where 

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

type MInteger = Maybe Integer 
$(genAll "MarketItem" "market_item"
    [
        ("id", ''Id),
        ("car_instance_id", ''MInteger),
        ("part_instance_id", ''MInteger),
        ("price", ''Integer),
        ("account_id", ''Integer)
        ]
    )
