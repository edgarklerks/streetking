{-# LANGUAGE MultiParamTypeClasses, FlexibleInstances, TemplateHaskell #-}
module Model.Personnel where 

import           Data.SqlTransaction
import           Database.HDBC
import           Data.Convertible
import           Model.General
import           Data.Database 

import           Control.Applicative
import qualified Data.Map as M
import           Model.TH
import           Prelude hiding (id)

$(genAll "Personnel" "personnel" [
        ("id", ''Id),
        ("garage_id", ''Integer),
        ("name", ''String),
        ("country", ''String),
        ("sex", ''Bool),
        ("picture", ''String),
        ("skill_repairs", ''Integer),
        ("skill_improvement", ''Integer),
        ("salary", ''Integer),
        ("paid_until", ''Integer),
        ("busy_until", ''Integer)
    ])
