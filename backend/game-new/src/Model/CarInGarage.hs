{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TemplateHaskell, OverloadedStrings #-}
module Model.CarInGarage where 

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


$(genAll "CarInGarage" "car_in_garage"
    [
        ("id", ''Id),
        ("car_id", ''Integer),
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
        ("parts_price", ''Integer),
        ("total_price", ''Integer),
        ("account_id", ''Integer),
        ("level", ''Integer),
        ("wear", ''Integer),
        ("improvement", ''Integer),
        ("active", ''Bool),
        ("ready", ''Bool),
        ("year", ''Integer),
        ("car_label", ''String),
        ("car_color", ''String)
    ])

{-
instance AS.ToJSON CarInGarage where
        toJSON c = AS.toJSON $ HM.fromList $ [ 
                        ("car_instance_id" :: LB.ByteString, AS.toJSON $  id c),
                        ("name", AS.toJSON $  name c)
                    ]

instance AS.FromJSON CarInGarage where
        parseJSON (AS.Object v) = do
            i <- v AS..: "car_instance_id"
            n <- v AS..: "name"
            return $ (def :: CarInGarage) { id = i, name = n }

-}
