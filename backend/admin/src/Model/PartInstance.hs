{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TemplateHaskell, OverloadedStrings #-}
module Model.PartInstance where 

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


$(genAll "PartInstance" "part_instance"
    [
        ("id", ''Id),
        ("part_id", ''Integer),
        ("garage_id", ''Id),
        ("car_instance_id", ''Id),
        ("improvement", ''Integer),
        ("wear", ''Integer),
        ("account_id", ''Integer),
        ("deleted", ''Bool),
        ("immutable", ''Integer)
    ])
