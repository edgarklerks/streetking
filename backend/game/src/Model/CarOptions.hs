{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TemplateHaskell #-}
module Model.CarOptions where 

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

type MString = Maybe String 

$(genAll "CarOptions" "car_options"
    [
        ("id", ''Id),
        ("car_instance_id", ''Integer),
        ("key", ''String),
        ("value", ''MString)
    ])