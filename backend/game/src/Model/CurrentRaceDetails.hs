{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TemplateHaskell #-}
module Model.CurrentRaceDetails where

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

$(genAll "CurrentRaceDetails" "current_race_details" [             
--                    ("id", ''Id),
                    ("race_id", ''Integer),
                    ("track_id", ''Integer),
                    ("section_id", ''Integer),
                    ("account_id", ''Integer),
                    ("start_time", ''Integer),
                    ("end_time", ''Integer),
                    ("time", ''Double),
                    ("path", ''Double),
                    ("speed_max", ''Double),
                    ("speed_avg", ''Double),
                    ("speed_out", ''Double)
    ]
    )
