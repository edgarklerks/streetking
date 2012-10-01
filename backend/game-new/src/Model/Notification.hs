{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TemplateHaskell, OverloadedStrings #-}
module Model.Notification where 

import           Data.SqlTransaction
import           Database.HDBC
import           Data.Convertible
import           Model.General
import           Data.Database 
import           Control.Monad
import qualified Data.Aeson as AS
import           Data.Conversion
import           Control.Applicative
import qualified Data.Map as M
import           Model.TH
import           Prelude hiding (id, read)

type MInteger = Maybe Integer 
type MString = Maybe String 

$(genAll "Notification" "notifications" [
                                        ("id", ''Id),
                                        ("name", ''String),
                                        ("type", ''MString),
                                        ("language", ''Integer),
                                        ("body", ''String),
                                        ("title", ''String)
    ])
 
