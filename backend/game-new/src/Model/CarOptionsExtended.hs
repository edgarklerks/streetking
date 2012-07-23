{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TemplateHaskell #-}
module Model.CarOptionsExtended where 

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

$(genAll "CarOptionsExtended" "car_options_extended"
    [
        ("car_instance_id", ''Integer),
        ("account_id", ''Integer),
        ("key", ''String),
        ("value", ''MString)
    ])
