{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TemplateHaskell, OverloadedStrings #-}
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

import qualified Data.Aeson as AS
import qualified Data.ByteString.Lazy as LB
import qualified Data.HashMap.Strict as HM

import Data.Maybe

-- move this somewhere proper
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

instance AS.ToJSON Race where
        toJSON c = AS.toJSON $ HM.fromList $ [ 
                        ("race_id" :: LB.ByteString, AS.toJSON $  id c),
                        ("track_id", AS.toJSON $ track_id c),
                        ("start_time", AS.toJSON $ start_time c),
                        ("end_time", AS.toJSON $ end_time c),
                        ("type", AS.toJSON $ Model.Race.type c),
--                        ("data", AS.toJSON $ Model.Race.data c)
                        ("data", maybe (AS.toJSON LB.empty) fromJust $ AS.decode $ Model.Race.data c)
                    ]

instance AS.FromJSON Race where
        parseJSON (AS.Object v) = Race <$>
            v AS..: "race_id" <*>
            v AS..: "track_id" <*>
            v AS..: "start_time" <*>
            v AS..: "end_time" <*>
            v AS..: "type" <*>
            v AS..: "data"

