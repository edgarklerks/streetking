{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TemplateHaskell #-}
module Model.PartType where 

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

$(genAll "PartType" "part_type"
    [
    ("id", ''Id),
    ("name", ''String),
    ("sort", ''Integer),
    ("use_3d", ''String),
    ("required", ''Bool),
    ("default_universal", ''Bool)
    ]
    )
