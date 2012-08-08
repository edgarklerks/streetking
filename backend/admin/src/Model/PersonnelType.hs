{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TemplateHaskell #-}

module Model.PersonnelType where 

import           Data.SqlTransaction
import           Database.HDBC
import           Data.Convertible
import           Model.General
import           Data.Database 
import           Data.InRules
import           Control.Monad

import           Control.Applicative
import qualified Data.Map as M
import           Model.TH
import           Prelude hiding (id)

$(genAll "PersonnelType" "personnel_type" [
    ("id", ''Id),
    ("name", ''String)
    ])

