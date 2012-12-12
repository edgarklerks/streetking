{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TemplateHaskell, OverloadedStrings #-}
module Model.Config where 

import           Data.SqlTransaction
import           Database.HDBC (toSql, fromSql)
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

$(genAllId "Config" "game_config" "key" [
    ("id", ''Id),
    ("key", ''String),
    ("value", ''String)
 ])

--getKey :: Read a => String -> SqlTransaction Connection a
--getKey k = (read . value) <$> aget (rollback $ "unable to load game configuration for key " ++ k) ["key" |== toSql k] 

getKey :: Read a => String -> SqlTransaction Connection a
getKey k = do 
            s <- search ["key" |== toSql k] [] 1 0 :: SqlTransaction Connection [Config]
            case s of
                [] -> rollback $ "unable to load game configuration for key " ++ k
                x:_ -> return (read $ value x)


