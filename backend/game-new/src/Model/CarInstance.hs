{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TemplateHaskell, OverloadedStrings, ViewPatterns #-}
{-- Change log 
- Edgar - added immutable predicate 
- Edgar - added immutable setters and getters 
-
--}
module Model.CarInstance where 

import           Data.SqlTransaction
import           Database.HDBC
import           Data.Convertible
import           Model.General
import           Data.Database 
import           Control.Monad
import qualified Data.Aeson as AS
import Data.Conversion

import           Control.Applicative
import qualified Data.Map as M
import           Model.TH
import           Prelude hiding (id)
import           Data.Maybe 

type MInteger = Maybe Integer 


$(genAll "CarInstance" "car_instance"
    [
        ("id", ''Id),
        ("car_id", ''Integer),
        ("garage_id", ''MInteger),
        ("deleted", ''Bool),
        ("prototype", ''Bool),
        ("active", ''Bool),
        ("immutable", ''Bool)

    ]
    )
isMutable :: Integer -> SqlTransaction Connection Bool 
isMutable = fmap (not . immutable . fromJust) . load 


setImmutable :: Integer -> SqlTransaction Connection Integer 
setImmutable = load >=> \(fromJust -> c) -> save (c { immutable = True})

setMutable :: Integer -> SqlTransaction Connection Integer 
setMutable = load >=> \(fromJust -> c) -> save (c { immutable = False})
