{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TemplateHaskell, OverloadedStrings #-}
module Model.TournamentType where 

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
--import           Data.Racing 
import Data.RaceReward

import qualified Data.HashMap.Strict as HM
import           Control.Applicative
import qualified Data.Map as M
import           Model.TH
import           Prelude hiding (id)
import qualified Data.Relation as Rel


type MRaceReward = Maybe RaceRewards 
type MInteger = Maybe Integer

$(genAll "TournamentType" "tournament_type" [
    ("id", ''Id),
    ("name", ''String)
        ]
    )
