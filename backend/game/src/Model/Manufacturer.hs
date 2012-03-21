{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TemplateHaskell #-}
module Model.Manufacturer where 

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

$(genRecord "Manufacturer" 
    [
        ("id", ''Id),
        ("name", ''String),
        ("picture", ''String)
    ]
    )

$(genInstance "Manufacturer" 
 [
        ("id", ''Id),
        ("name", ''String),
        ("picture", ''String)
    ]
 )

$(genDatabase "Manufacturer" "manufacturer")
