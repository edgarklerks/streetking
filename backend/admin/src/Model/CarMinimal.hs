{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TemplateHaskell, OverloadedStrings #-}
module Model.CarMinimal where 

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

import qualified Data.ByteString.Lazy as LB
import qualified Data.HashMap.Strict as HM
import qualified Data.Aeson as AS
import Data.Conversion

import qualified Model.CarInGarage as CIG
import qualified Data.Relation as Rel


$(genAll "CarMinimal" "car_in_garage"
    [
        ("id", ''Id),
        ("manufacturer_name", ''String),
        ("manufacturer_picture", ''String),
        ("weight", ''Integer),
        ("top_speed", ''Integer),
        ("acceleration", ''Integer),
        ("stopping", ''Integer),
        ("cornering", ''Integer),
        ("nitrous", ''Integer),
        ("power", ''Integer),
        ("traction", ''Integer),
        ("handling", ''Integer),
        ("braking", ''Integer),
        ("aero", ''Integer),
        ("nos", ''Integer),
        ("name", ''String),
        ("level", ''Integer),
        ("year", ''Integer)
    ])

class ToCarMinimal a where
        toCM :: a -> CarMinimal

instance ToCarMinimal CIG.CarInGarage where
        toCM x = let y = def :: CarMinimal in fromInRule $ project (toInRule y) (toInRule x) 


--minify :: CIG.CarInGarage -> CarMinimal
--minify = toCM

