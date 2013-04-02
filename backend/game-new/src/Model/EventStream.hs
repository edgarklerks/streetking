{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TemplateHaskell, OverloadedStrings #-}
module Model.EventStream where 

import           Data.SqlTransaction
import           Database.HDBC
import           Data.Convertible
import           Model.General
import           Data.Database 
import           Control.Monad

import           Control.Applicative
import qualified Data.Map as M
import           Model.TH
import           Prelude hiding (id)
import qualified Data.Relation as Rel
import qualified Data.Aeson as AS
import Data.Conversion
import Data.Event 
type Stream = Maybe [Event]
$(genAll "EventStream" "event_stream" 
    [
      ("id", ''Id)
    , ("account_id", ''Id)
    , ("rule_id", ''Id)
    , ("stream", ''Stream)
    , ("active", ''Bool)
    ])

getEventStream uid = runTestDb $ do 
                xs <- search ["account_id" |== (toSql uid)] [] 10000 0 :: SqlTransaction Connection [EventStream]
                return xs

emitEvent :: Integer -> Event -> SqlTransaction Connection ()
emitEvent uid e = do 
            xs <- search ["account_id" |== toSql uid .&& "active" |== toSql True] [] 100000 0 :: SqlTransaction Connection [EventStream]
            forM_ xs $ \x -> do 
                    
                    save (x {
                        stream = ((e :) <$> stream x) <|> (Just [e]) 
                        })
        

