{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TemplateHaskell #-}
module Model.Application where 

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
import qualified Data.Aeson as AS 
import Data.InRules

$(genAll "Application" "application" 
    [
        ("id", ''Id),
        ("platform", ''String),
        ("token", ''String)
    ])
