{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TemplateHaskell, OverloadedStrings #-}
module Model.ChallengeExtended where


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
import Data.InRules

import qualified Model.AccountProfileMin as APM
import qualified Model.CarMinimal as CMI

import Data.Maybe


$(genAll "ChallengeExtended" "challenge_extended" [
                    ("challenge_id", ''Integer),
                    ("account_id", ''Integer),
                    ("track_id", ''Integer),
                    ("participants", ''Integer),
                    ("type_id", ''Integer),
                    ("type", ''String),
                    ("accepts", ''Integer),
                    ("user_nickname", ''String),
                    ("user_level", ''Integer),
                    ("track_name", ''String),
                    ("track_level", ''Integer),
                    ("city_id", ''Integer),
                    ("city_name", ''String),
                    ("continent_id", ''Integer),
                    ("continent_name", ''String),
                    ("track_length", ''Double),
                    ("top_time_exists", ''Bool),
                    ("top_time", ''Double),
                    ("top_time_id", ''Integer),
                    ("top_time_account_id", ''Integer),
                    ("top_time_name", ''String),
                    ("top_time_picture_small", ''String),
                    ("top_time_picture_medium", ''String),
                    ("top_time_picture_large", ''String),
                    ("amount", ''Integer),
                    ("profile", ''APM.AccountProfileMin),
                    ("car", ''CMI.CarMinimal),
                    ("deleted", ''Bool)
   ])

