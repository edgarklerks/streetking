{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TemplateHaskell #-}
module Model.Race where

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

instance Default LB.ByteString where
    def = LB.empty 

$(genAll "Race" "races" [             
                    ("id", ''Id),
                    ("track_id", ''Integer),
                    ("start_time", ''Integer),
                    ("end_time", ''Integer),
                    ("type", ''Integer),
                    ("data", ''LB.ByteString)
    ])
