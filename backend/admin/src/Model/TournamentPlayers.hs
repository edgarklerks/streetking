{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TemplateHaskell, OverloadedStrings #-}
module Model.TournamentPlayers where 

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
import           Prelude hiding (id)
import qualified Data.Relation as Rel

$(genAll "TournamentPlayer" "tournament_players" 
    [
        ("id", ''Id),
        ("account_id", ''Id),
        ("tournament_id", ''Id),
        ("car_instance_id", ''Id),
        ("deleted", ''Bool)
    ])
