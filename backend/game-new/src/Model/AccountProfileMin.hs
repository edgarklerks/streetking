{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TemplateHaskell, OverloadedStrings #-}
module Model.AccountProfileMin where 

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

import qualified Data.ByteString.Lazy as LB
import qualified Data.HashMap.Strict as HM
import qualified Data.Aeson as AS

import Data.Conversion

$(genAll "AccountProfileMin" "account_profile" [             
                    ("id", ''Id),
                    ("nickname", ''String),
                    ("picture_small", ''String),
                    ("picture_medium", ''String),
                    ("picture_large", ''String),
                    ("level", ''Integer),
                    ("city_name", ''String),
                    ("continent_name", ''String)
        ])


