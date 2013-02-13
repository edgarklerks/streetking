{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TemplateHaskell, OverloadedStrings #-}
module Model.TournamentExtended where 

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

type MRaceReward = Maybe RaceRewards 
type MInteger = Maybe Integer

$(genAll "TournamentExtended" "tournament_extended" [
    ("id", ''Id),
    ("car_id", ''Id),
    ("start_time", ''MInteger),
    ("costs", ''Integer),
    ("minlevel", ''Integer),
    ("maxlevel", ''Integer),
    ("rewards", ''MRaceReward),
    ("track_id", ''Integer),
    ("players", ''Integer),
    ("name", ''String),
    ("current_players", ''Integer),
    ("done", ''Bool),
    ("running", ''Bool),
    ("tournament_type_id", ''Integer),
    ("tournament_type", ''String)

    ])
