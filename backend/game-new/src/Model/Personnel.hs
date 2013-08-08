{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TemplateHaskell, OverloadedStrings #-}
module Model.Personnel where 

import           Data.SqlTransaction
import           Database.HDBC
import           Data.Convertible
import           Model.General
import           Data.Database 
import           Data.Conversion
import           Control.Monad
import qualified Data.Aeson as AS
import Data.Conversion

import           Control.Applicative
import qualified Data.Map as M
import           Model.TH
import           Prelude hiding (id)
import qualified Data.Relation as Rel


type MInteger = Maybe Integer 
$(genAll "Personnel" "personnel" [
    ("id", ''Id),
    ("name", ''String),
    ("country_id", ''Integer),
    ("gender", ''Bool),
    ("picture", ''String),
    ("salary", ''Integer),
    ("price", ''Integer),
    ("skill_repair", ''Integer),
    ("skill_engineering", ''Integer),
    ("sort", ''Integer)
    ])
