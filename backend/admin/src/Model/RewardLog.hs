{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TemplateHaskell, OverloadedStrings #-}
module Model.RewardLog where 

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
import Data.Conversion
import qualified Data.Relation as Rel

$(genAll "RewardLog" "reward_log"
    [
          ("id", ''Id)
        , ("account_id", ''Id)
        , ("rule", ''String)
        , ("name", ''String)
        , ("money", ''Integer)
        , ("viewed", ''Bool)
        , ("experience", ''Integer)
    ])

