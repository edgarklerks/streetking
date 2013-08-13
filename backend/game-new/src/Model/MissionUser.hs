{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TemplateHaskell, OverloadedStrings, RankNTypes #-}
module Model.MissionUser where 

import           Control.Applicative
import           Control.Monad
import           Data.Convertible
import           Data.Database 
import           Data.SqlTransaction
import           Database.HDBC
import           Model.General
import           Model.TH
import           Prelude hiding (id)
import qualified Data.Relation as Rel
import           Data.Conversion
import qualified Data.Aeson as AS
import qualified Data.Map as M
import           Data.Event 
import           Data.Decider 


$(genAll "MissionUser" "mission_user"
    [
        ("id", ''Id),
        ("time_start", ''Integer),
        ("time_left", ''Integer),
        ("mission_id", ''Integer),
        ("tasks_left", ''String),
        ("tasks_done", ''String),
        ("account_id", ''Integer)
    ])

