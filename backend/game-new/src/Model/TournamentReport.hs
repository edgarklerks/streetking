{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TemplateHaskell, OverloadedStrings #-}
module Model.TournamentReport where 

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
import           Data.Racing 

import qualified Data.HashMap.Strict as HM
import           Control.Applicative
import qualified Data.Map as M
import           Model.TH
import qualified Model.Tournament as T 
import qualified Model.TournamentResult as TR
import qualified Model.TournamentPlayers as TP 
import           Prelude hiding (id)

type MRaceReward = Maybe RaceRewards 
type TournamentResults = [TR.TournamentResult]
type Tournament = Maybe T.Tournament 
type Players = [TP.TournamentPlayer]

$(genAll "TournamentReport" "tournament_report" [
    ("id", ''Id),
    ("tournament_id", ''Integer),
    ("tournament_result", ''TournamentResults),
    ("account_id", ''Integer),
    ("tournament", ''Tournament),
    ("players", ''Players),
    ("created", ''Integer)
    ]   )
