{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TemplateHaskell, OverloadedStrings #-}
module Model.Race where

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
import Data.Aeson.Parser
import Data.Aeson.Types 
import qualified Data.ByteString.Lazy as LB
import qualified Data.HashMap.Strict as HM

-- import Data.Racing
import Data.RacingNew

import Data.Maybe
--import Model.FindInterface

-- move this somewhere proper
instance Default LB.ByteString where
    def = LB.empty

$(genAll "Race" "races" [             
                    ("id", ''Id),
                    ("track_id", ''Integer),
                    ("start_time", ''Integer),
                    ("end_time", ''Integer),
                    ("type", ''Integer),
                    ("data", ''RaceDataList)
    ])


