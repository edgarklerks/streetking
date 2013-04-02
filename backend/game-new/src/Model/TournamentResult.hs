{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TemplateHaskell, OverloadedStrings #-}
module Model.TournamentResult where 

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
import           Prelude hiding (id, round)
import qualified Data.Relation as Rel
--import           Data.Racing

import Data.RaceParticipant
import Data.RacingNew

type RaceResultTuple = Maybe (RaceParticipant, RaceResult)

$(genAll "TournamentResult" "tournament_result" 
    [
        ("id", ''Id),
        ("tournament_id", ''Id),
        ("race_id", ''Id),
        ("participant1_id", ''Id),
        ("participant2_id", ''Id),
        ("round", ''Integer),
        ("race_time1", ''Double),
        ("race_time2", ''Double),
        ("car1_id", ''Integer),
        ("car2_id", ''Integer)
    ])
