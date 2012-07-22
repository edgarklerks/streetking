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

import Data.Aeson 
import Data.Aeson.Parser
import Data.Aeson.Types 
import qualified Data.ByteString.Lazy as LB
import qualified Data.HashMap.Strict as HM

import Data.Racing

import Data.Maybe
import Model.FindInterface

-- move this somewhere proper
instance Default LB.ByteString where
    def = LB.empty

$(genAll "Race" "races" [             
                    ("id", ''Id),
                    ("track_id", ''Integer),
                    ("start_time", ''Integer),
                    ("end_time", ''Integer),
                    ("type", ''Integer),
                    ("data", ''LB.ByteString)
    ])

$(mkInstanceDeclFromJSON "Race" ["id", "track_id", "start_time", "end_time", "type", "data"])
$(mkInstanceDeclToJSON "Race" ["id", "track_id", "start_time", "end_time", "type", "data"])

{--
instance FromJSON Race where
        parseJSON (Object v) = Race <$>
            v .: "race_id" <*>
            v .: "track_id" <*>
            v .: "start_time" <*>
            v .: "end_time" <*>
            v .: "type" <*>
            v .: "data"
--}

