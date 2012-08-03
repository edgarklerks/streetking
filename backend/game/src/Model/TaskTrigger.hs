{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TemplateHaskell, OverloadedStrings #-}
module Model.TaskTrigger where 

import           Data.SqlTransaction
import           Database.HDBC
import           Data.Convertible
import           Model.General
import           Data.Database 
import           Control.Monad
import qualified Data.Aeson as AS
import Data.InRules

import qualified Data.HashMap.Strict as HM
import           Control.Applicative
import qualified Data.Map as M
import           Model.TH
import           Prelude hiding (id)


$(genAll "TaskTrigger" "task_trigger" [
                    ("id", ''Id),
                    ("type", ''String),
                    ("task_id", ''Integer),
                    ("subject_id", ''Integer)
   ])

