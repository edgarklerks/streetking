{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TemplateHaskell #-}
module Model.ShopReport where 

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

$(genAll "ShopReport" "shopping_reports" 
    [ ("id", ''Id),
        ("account_id", ''Integer),
        ("time", ''Integer),
        ("report_type_id", ''Integer),
        ("report_type", ''String),
        ("report_descriptor", ''String),
        ("part_instance_id", ''Integer),
        ("part_id", ''Integer),
        ("amount", ''Integer)
    ])
