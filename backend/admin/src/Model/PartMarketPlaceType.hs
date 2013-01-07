{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TemplateHaskell, OverloadedStrings #-}
module Model.PartMarketPlaceType where 

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

$(genAll "PartMarketPlaceType" "market_place_part_type" [
        ("id", ''Id),
        ("name", ''String),
        ("min_level", ''Integer),
        ("max_level", ''Integer),
        ("min_price", ''Integer),
        ("max_price", ''Integer),
        ("sort", ''Integer),
        ("use_3d", ''String),
        ("required", ''Bool),
        ("fixed", ''Bool),
        ("hidden", ''Bool)
    ])
