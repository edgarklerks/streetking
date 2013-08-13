{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TemplateHaskell, OverloadedStrings #-}
module Model.RuleReward where 

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

$(genAll "RuleReward" "rule_reward"
    [
          ("id", ''Id)
        , ("rule", ''String)
        , ("name", ''String)
        , ("change", ''Integer)
        , ("money", ''Integer)
        , ("experience", ''Integer)
    ])

