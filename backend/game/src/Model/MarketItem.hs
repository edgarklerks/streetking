{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TemplateHaskell #-}
module Model.MarketItem where 

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

$(genAll "MarketItem" "market_item"
    [
        ("id", ''Id),
        ("car_instance_id", ''Integer),
        ("part_instance_id", ''Integer)
        ]
    )