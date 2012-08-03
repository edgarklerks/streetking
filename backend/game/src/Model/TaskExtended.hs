{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TemplateHaskell, OverloadedStrings #-}
module Model.TaskExtended where 

import           Data.SqlTransaction
import           Database.HDBC
import           Data.Convertible
import           Model.General
import           Data.Database 
import           Control.Monad
import qualified Data.Aeson as AS
import Data.InRules
import qualified Data.ByteString.Char8 as C
import qualified Data.ByteString.Lazy as B


import qualified Data.HashMap.Strict as HM
import           Control.Applicative
import qualified Data.Map as M
import           Model.TH
import           Prelude hiding (id)

instance Default C.ByteString where def = C.empty

$(genAll "TaskExtended" "task_extended" [
                    ("id", ''Id),
                    ("time", ''Integer),
                    ("data", ''C.ByteString),
                    ("subject_type", ''String),
                    ("subject_id", ''Integer)
       ])

