{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TemplateHaskell, OverloadedStrings #-}
module Model.Mission where 

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

$(genAll "Mission" "mission"
    [
        ("id", ''Id),
        ("description", ''String),
        ("time_limit", ''Integer),
        ("rule_id", ''Integer)
    ])

