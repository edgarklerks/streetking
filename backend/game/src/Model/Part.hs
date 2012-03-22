{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TemplateHaskell #-}
module Model.Part where 

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


$(genAll "Part" "part" [
    ("id", ''Id),
    ("manufacturer_id", ''Integer),
    ("part_type_id", ''Integer),
    ("weight", ''Integer),
    ("parameter", ''Integer)
 ])


