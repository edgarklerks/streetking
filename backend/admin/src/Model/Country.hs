{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses #-}
module Model.Country where 

import Data.SqlTransaction 
import Database.HDBC
import Data.Convertible 
import Model.General 
import Data.Database 
import Data.InRules 
import Control.Monad

import Control.Applicative
import qualified Data.Map as M 
import Model.TH 
import Prelude hiding (id)

$(genAll "Country" "country" [
    ("id", ''Id),
    ("name", ''String),
    ("shortname", ''String)]
    )
