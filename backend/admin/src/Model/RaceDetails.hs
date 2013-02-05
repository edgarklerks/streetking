{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TemplateHaskell, OverloadedStrings #-}
module Model.RaceDetails where

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
import Data.Aeson.Parser
import Data.Aeson.Types 
import qualified Data.ByteString.Lazy as LB
import qualified Data.HashMap.Strict as HM

--import Data.Racing
import Data.RacingNew

import Data.Maybe

$(genAll "RaceDetails" "race_details" [             
--                    ("id", ''Id),
                    ("race_id", ''Integer),
                    ("track_id", ''Integer),
                    ("start_time", ''Integer),
                    ("end_time", ''Integer),
                    ("time_left", ''Integer),
                    ("type", ''String),
                    ("data", ''RaceDataList)
    ])


