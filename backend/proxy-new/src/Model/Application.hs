{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TemplateHaskell,
 OverloadedStrings #-}
module Model.Application where 
import qualified Data.Aeson as AS
import           Data.Conversion

import           Data.SqlTransaction
import           Database.HDBC
import           Data.Convertible
import           Model.General
import           Data.Database 
import           Control.Monad

import           Control.Applicative
import qualified Data.Map as M
import           Model.TH
import qualified Data.ByteString as B
import qualified Data.Relation as Rel
import           Prelude hiding (id)

$(genAll "Application" "application" 
    [ 
        ("id", ''Id),
        ("platform", ''String),
        ("token", ''String)
    ])
