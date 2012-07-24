{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TemplateHaskell #-}
module Model.Support where 

import Data.SqlTransaction
import Database.HDBC
import Data.Convertible
import Model.General 
import Data.Database 
import Control.Monad 
import Control.Applicative
import qualified Data.Map as M 
import Model.TH 
import Prelude hiding (id)


$(genAll "Support" "support" [
        ("id", ''Id),
        ("account_id", ''Integer),
        ("subject", ''String),
        ("message", ''String)
 ])
