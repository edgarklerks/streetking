{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TemplateHaskell, OverloadedStrings #-}
module Model.TrackDetails where 

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
import           Prelude hiding (id, length)
import qualified Data.Relation as Rel

$(genAll "TrackDetails" "track_details" [             
                    ("id", ''Id),
                    ("track_id", ''Integer),
                    ("radius", ''Double),
                    ("length", ''Double),
                    ("segment", ''String)
    ]
    )

type TrackDetailss = [TrackDetails]
