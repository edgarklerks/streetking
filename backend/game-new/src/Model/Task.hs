{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TemplateHaskell, OverloadedStrings #-}
module Model.Task where 

import           Data.SqlTransaction
import           Database.HDBC
import           Data.Conversion
import           Data.Convertible
import           Model.General
import           Data.Database 
import           Control.Monad
import qualified Data.Aeson as AS
import           Data.DataPack
import           Data.InRules 
import qualified Data.ByteString.Char8 as C
import qualified Data.ByteString.Lazy as B

import qualified Data.HashMap.Strict as HM
import           Control.Applicative
import qualified Data.Map as M
import           Model.TH
import           Prelude hiding (id)

$(genAll "Task" "task" [             
                    ("id", ''Id),
                    ("time", ''Integer),
                    ("data", ''Data),
                    ("state", ''String),
                    ("claimed", ''Integer)
   ])

