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
import qualified Data.Relation as Rel

instance Default C.ByteString where def = C.empty

$(genAll "TaskExtended" "task_extended" [
                    ("task_id", ''Integer),
                    ("time", ''Integer),
                    ("data", ''C.ByteString),
                    ("type", ''Integer),
                    ("target_id", ''Integer)
       ])

