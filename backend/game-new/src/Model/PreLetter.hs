{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TemplateHaskell, OverloadedStrings #-}
module Model.PreLetter where 

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
import qualified Data.Relation as Rel
import qualified Data.ByteString.Lazy as B 

type MInteger = Maybe Integer 
type BString = Maybe B.ByteString 

type MString = Maybe String 

$(genAll "PreLetter" "letters" [
    ("id", ''Id),
    ("ttl", ''MInteger),
    ("message", ''String),
    ("title",''String),
    ("sendat", ''Integer),
    ("to", ''Integer),
    ("from", ''MInteger),
    ("read", ''Bool),
    ("archive", ''Bool),
    ("data", ''BString),
    ("type", ''MString)
    ])
