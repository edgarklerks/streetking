{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TemplateHaskell #-}
module Model.Account where 

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
$(genAll "Account" "account" [             
                    ("id", ''Id),
                    ("firstname", ''String),
                    ("lastname", ''String),
                    ("picture_small", ''String),
                    ("picture_medium", ''String),
                    ("picture_large", ''String),
                    ("level", ''Integer),
                    ("skill_accelleration", ''Integer),
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
                    ("energy_update", ''Integer),
                    ("busy_until", ''Integer)
    ]
    )
