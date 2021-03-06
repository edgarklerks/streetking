{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TemplateHaskell, OverloadedStrings #-}
module Model.Car3dModel where 

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


$(genAll "Car3dModel" "car_3d_model"
    [
        ("id", ''Id),
        ("name", ''String) ,
        ("use_3d", ''String),
        ("part_instance_id", ''String),
        ("part_type_id", ''Integer)
    ])
