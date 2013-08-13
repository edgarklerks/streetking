{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TemplateHaskell, OverloadedStrings #-}
module Model.Track where 

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
import           Prelude hiding (id, length)
import qualified Data.Relation as Rel

type MInteger = Maybe Integer
type Data = Maybe String 
$(genAll "Track" "track" 
    [
        ("id", ''Id),
        ("name", ''String),
        ("city_id", ''Integer),
        ("level", ''Integer),
        ("data", ''Data),
        ("loop", ''Bool),
        ("length", ''Integer),
        ("top_time_id", ''MInteger),
        ("energy_cost", ''Integer)
        
    ])
