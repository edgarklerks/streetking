{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TemplateHaskell, OverloadedStrings #-}
module Model.AccountProfile where 

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

import qualified Data.ByteString.Lazy as LB
import qualified Data.HashMap.Strict as HM
import qualified Data.Aeson as AS
import Data.InRules


$(genAll "AccountProfile" "account_profile" [             
                    ("id", ''Id),
                    ("firstname", ''String),
                    ("lastname", ''String),
                    ("nickname", ''String),
                    ("picture_small", ''String),
                    ("picture_medium", ''String),
                    ("picture_large", ''String),
                    ("level", ''Integer),
                    ("skill_acceleration", ''Integer),
                    ("skill_braking", ''Integer),
                    ("skill_control", ''Integer),
                    ("skill_reactions", ''Integer),
                    ("skill_intelligence", ''Integer),
                    ("money", ''Integer),
                    ("respect", ''Integer),
                    ("diamonds", ''Integer),
                    ("energy", ''Integer),
                    ("max_energy", ''Integer),
                    ("energy_recovery", ''Integer),
                    ("energy_updated", ''Integer),
                    ("busy_until", ''Integer),
                    ("till", ''Integer),
                    ("city_id", ''Integer),
                    ("city_name", ''String),
--                    ("city_data", ''String),
                    ("continent_id", ''Integer),
                    ("continent_name", ''String),
--                    ("continent_data", ''String),
                    ("skill_unused", ''Integer),
                    ("busy_subject_id", ''Integer),
                    ("busy_type", ''String),
                    ("busy_timeleft", ''Integer)
        ])
     
