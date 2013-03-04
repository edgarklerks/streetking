{-# LANGUAGE TemplateHaskell, OverloadedStrings  #-}

module Data.CarReady (
        CarReadyState (..),
        carReady
    ) where

import Model.TH
import Model.General

import Data.SqlTransaction
import Data.Database
import Control.Applicative 

import Data.Maybe

import Data.InRules
import Data.Conversion
import qualified Data.Aeson as AS
import Data.Text
import qualified Data.List as L

import qualified Model.Functions as DBF

import qualified Model.PartType as PT
import qualified Model.CarInstanceParts as CIP

type Types = [PT.PartType]
type Parts = [CIP.CarInstanceParts]

$(genMapableRecord "CarReadyState" [
        ("ready", ''Bool),
        ("missing", ''Types),
        ("worn", ''Parts)
    ])

carReady :: Integer -> SqlTransaction Connection CarReadyState
carReady cid = do
            ms <- L.map (flip updateHashMap (def :: PT.PartType)) <$> DBF.car_get_missing_parts cid
            ws <- L.map (flip updateHashMap (def :: CIP.CarInstanceParts)) <$> DBF.car_get_worn_parts cid
            return $ CarReadyState {
                    ready = not $ (L.length ms) > 0 || (L.length ws) > 0,
                    missing = ms,
                    worn = ws
                }


