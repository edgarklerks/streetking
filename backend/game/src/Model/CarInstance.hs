{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TemplateHaskell, OverloadedStrings #-}
module Model.CarInstance where 

import           Data.SqlTransaction
import           Database.HDBC
import           Data.Convertible
import           Model.General
import           Data.Database 
import           Control.Monad
import qualified Data.Aeson as AS
import Data.InRules

import           Control.Applicative
import qualified Data.Map as M
import           Model.TH
import           Prelude hiding (id)

type MInteger = Maybe Integer 

$(genAll "CarInstance" "car_instance"
    [
        ("id", ''Id),
        ("car_id", ''Integer),
        ("garage_id", ''MInteger),
        ("deleted", ''Bool)
    ]
    )
