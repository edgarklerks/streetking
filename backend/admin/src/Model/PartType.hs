{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TemplateHaskell, OverloadedStrings #-}
module Model.PartType where 

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
import qualified Data.Relation as Rel

$(genAll "PartType" "part_type"
    [
    ("id", ''Id),
    ("name", ''String),
    ("sort", ''Integer),
    ("use_3d", ''String),
    ("required", ''Bool)
    ]
    )
