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

import qualified Model.Account as A
import qualified Model.AccountProfile as AP

import Data.Conversion

type MString = Maybe String 
type MInteger = Maybe Integer 

$(genAll "AccountProfileMin" "account_profile" [             
                    ("id", ''Id),
                    ("nickname", ''String),
                    ("picture_small", ''MString),
                    ("picture_medium", ''MString),
                    ("picture_large", ''MString),
                    ("level", ''Integer),
                    ("city_name", ''String),
                    ("continent_name", ''String)
        ])

class ToAccountProfileMin a where
        toAPM :: a -> AccountProfileMin

instance ToAccountProfileMin AP.AccountProfile where
        toAPM x = let y = def :: AccountProfileMin in fromInRule $ project (toInRule y) (toInRule x)

instance ToAccountProfileMin A.Account where
        toAPM x = let y = def :: AccountProfileMin in fromInRule $ project (toInRule y) (toInRule x)


--minify :: AP.AccountProfile -> AccountProfileMin 
--minify c = fromInRule $ project (toInRule (def :: AccountProfileMin)) (toInRule c) 

