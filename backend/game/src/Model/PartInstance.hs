{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TemplateHaskell #-}
module Model.PartInstance where 

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


$(genAll "PartInstance" "part_instance"
    [
        ("id", ''Id),
        ("part_id", ''Integer),
        ("garage_id", ''Integer),
        ("car_instance_id", ''Integer),
        ("improvement", ''Integer),
        ("wear", ''Integer)
    ])
