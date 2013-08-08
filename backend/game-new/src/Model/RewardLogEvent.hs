{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TemplateHaskell, OverloadedStrings #-}
module Model.RewardLogEvent where 

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
import Data.Conversion

type MInteger = Maybe Integer 

$(genAll "RewardLogEvent" "reward_log_event"
    [
          ("id", ''Id)
        , ("account_id", ''Id)
        , ("rule", ''String)
        , ("name", ''String)
        , ("money", ''Integer)
        , ("viewed", ''Bool)
        , ("experience", ''Integer)
        , ("type_id", ''Integer)
        , ("type", ''String)
    ])

