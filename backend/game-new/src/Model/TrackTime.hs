{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TemplateHaskell, OverloadedStrings #-}
module Model.TrackTime where


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

import qualified Data.Aeson as AS
import Data.InRules

import qualified Model.AccountProfileMin as APM
import qualified Model.CarMinimal as CMI

import Data.Maybe

$(genAll "TrackTime" "track_time" [
                    ("id", ''Id),
                    ("account_id", ''Integer),
                    ("track_id", ''Integer),
                    ("time", ''Double)
   ])

