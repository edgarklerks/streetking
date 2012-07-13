{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TemplateHaskell #-}
module Model.RaceResult where

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

$(genAll "RaceResult" "race_results" [             
                    ("id", ''Id),
                    ("account_id", ''Integer),
                    ("section_id", ''Integer),
                    ("time", ''Double),
                    ("path", ''Double),
                    ("speed_max", ''Double),
                    ("speed_avg", ''Double),
                    ("speed_out", ''Double)
    ]
    )
