{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TemplateHaskell, OverloadedStrings #-}
module Model.Challenge where


import           Data.SqlTransaction
import           Database.HDBC
import           Data.Convertible
import           Model.General
import           Data.Database 
import           Control.Monad
import           Data.Conversion 

import           Control.Applicative
import qualified Data.Map as M
import           Model.TH
import           Prelude hiding (id)

import qualified Data.Aeson as AS
import Data.InRules

import Data.Maybe
import qualified Model.Account as A
import qualified Model.AccountProfileMin as APM
import qualified Model.CarInGarage as CIG
import qualified Model.CarMinimal as CMI

type MInteger = Maybe Integer

$(genAll "Challenge" "challenge" [
                    ("id", ''Id),
                    ("account_id", ''Integer),
                    ("track_id", ''Integer),
                    ("participants", ''Integer),
                    ("type", ''Integer),
                    ("account", ''A.Account),
                    ("account_min", ''APM.AccountProfileMin),
                    ("car", ''CIG.CarInGarage),
                    ("car_min", ''CMI.CarMinimal),
                    ("deleted", ''Bool),
                    ("amount", ''Integer),
                    ("escrow_id", ''MInteger)
   ])

