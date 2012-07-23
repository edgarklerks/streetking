{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TemplateHaskell #-}
module Model.PartDetails where 

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


$(genAll "PartDetails" "parts_details"
    [
        ("id", ''Id),
        ("name", ''String),
        ("required", ''Bool),
        ("fixed", ''Bool),
        ("hidden", ''Bool)
    ])
