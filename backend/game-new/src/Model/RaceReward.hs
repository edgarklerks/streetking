{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TemplateHaskell, OverloadedStrings #-}
module Model.RaceReward where 

import           Data.SqlTransaction
import           Database.HDBC
import           Data.Convertible
import           Model.General
import           Data.Database 
import           Control.Monad
import qualified Data.Aeson as AS
import           Data.InRules
import qualified Data.ByteString.Char8 as C
import qualified Data.ByteString.Lazy as B

import qualified Data.HashMap.Strict as HM
import           Control.Applicative
import qualified Data.Map as M
import           Model.TH
import           Prelude hiding (id)
import qualified Data.Relation as Rel

--import           Data.Racing
import Data.RaceReward

$(genAll "RaceReward" "race_rewards" [             
                    ("id", ''Id),
                    ("race_id", ''Integer),
                    ("account_id", ''Integer),
                    ("time", ''Integer),
                    ("rewards", ''RaceRewards)
   ])


