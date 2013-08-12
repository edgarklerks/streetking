{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TemplateHaskell #-}
module Model.Access where 

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
import qualified Data.Relation as Rel

$(genAll "Access" "access" [
    ("id", ''Id),
    ("account_id", ''Integer)
 ])
