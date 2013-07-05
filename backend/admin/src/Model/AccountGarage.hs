{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TemplateHaskell, OverloadedStrings #-}
module Model.AccountGarage where 

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
import Data.Conversion
import qualified Data.Relation as Rel

type MString = Maybe String 
type MInteger = Maybe Integer 

$(genAll "AccountGarage" "account_garage" [             
                    ("id", ''Id),
                    ("firstname", ''MString),
                    ("lastname", ''MString),
                    ("nickname", ''MString),
                    ("picture_small", ''MString),
                    ("picture_medium", ''MString),
                    ("picture_large", ''MString),
                    ("level", ''MInteger),
                    ("skill_acceleration", ''MInteger),
                    ("skill_braking", ''MInteger),
                    ("skill_control", ''MInteger),
                    ("skill_reactions", ''MInteger),
                    ("skill_intelligence", ''MInteger),
                    ("money", ''MInteger),
                    ("respect", ''MInteger),
                    ("diamonds", ''MInteger),
                    ("energy", ''MInteger),
                    ("max_energy", ''MInteger),
                    ("energy_recovery", ''MInteger),
                    ("energy_updated", ''MInteger),
                    ("busy_until", ''MInteger),
                    ("email", ''String),

                    ("till", ''MInteger),
                    ("city_id", ''MInteger),
                    ("city_name", ''String),
--                    ("city_data", ''String),
                    ("continent_id", ''MInteger),
                    ("continent_name", ''String),
--                    ("continent_data", ''String),
                    ("skill_unused", ''MInteger),
                    ("busy_subject_id", ''MInteger),
                    ("busy_type", ''String),
                    ("busy_timeleft", ''MInteger),
                    ("free_car", ''Bool),

                    ("garage_id", ''MInteger)
        ])
     
