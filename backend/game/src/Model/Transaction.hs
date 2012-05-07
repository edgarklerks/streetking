{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TemplateHaskell #-}
module Model.Transaction where 

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

$(genAll "Transaction" "transaction" [
    ("id", ''Id),
    ("amount", ''Integer),
    ("current", ''Integer),
    ("type", ''String),
    ("type_id", ''Integer),
    ("time", ''Integer)
    ])
