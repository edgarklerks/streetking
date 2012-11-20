{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TemplateHaskell, OverloadedStrings, ScopedTypeVariables, ViewPatterns, ScopedTypeVariables #-}
module Model.Account where 

import           Data.SqlTransaction
import           Database.HDBC
import           Data.Convertible
import           Model.General
import           Data.Database 
import           Control.Monad
import qualified Data.Aeson as AS
import Data.Conversion

import           Control.Applicative
import qualified Data.Map as M
import           Model.TH
import           Prelude hiding (id)
type MString = Maybe String 
$(genAll "Account" "account" [             
                    ("id", ''Id),
                    ("firstname", ''MString),
                    ("lastname", ''MString),
                    ("nickname", ''String),
                    ("picture_small", ''MString),
                    ("picture_medium", ''MString),
                    ("picture_large", ''MString),
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
                    ("password", ''String),
                    ("email", ''String),
                    ("skill_unused", ''Integer),
                    ("city", ''Integer),
                    ("busy_type", ''Integer),
                    ("busy_subject_id", ''Integer),
                    ("free_car", ''Bool)
    ])

