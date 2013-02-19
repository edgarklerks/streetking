{-# LANGUAGE TemplateHaskell, OverloadedStrings  #-}

module Data.CarReady (
        Car,
        CarReadyState (..),
        carReadyState,
        carReady,
        carFromParts
    ) where

import Model.TH
import Model.General

import Data.SqlTransaction
import Database.HDBC (toSql, fromSql)
import Data.Database
import Control.Applicative 
import Control.Monad
import Data.Maybe
import qualified Data.HashMap.Strict as HM

import Data.InRules
import Data.Conversion
import qualified Data.Aeson as AS
import Data.Text
import qualified Data.List as L

import qualified Model.Functions as DBF

import qualified Model.PartType as PT
import qualified Model.CarInstanceParts as CIP

type Type = PT.PartType
type Types = [Type]
type Part = CIP.CarInstanceParts
type Parts = [Part]

type Car = HM.HashMap Integer Part 

$(genMapableRecord "CarReadyState" [
        ("ready", ''Bool),
        ("missing", ''Types),
        ("worn", ''Parts)
    ])

{-
-- TODO: transfer database functionalities to application server to enable part modification previews that include the readyState
carReady :: Integer -> SqlTransaction Connection CarReadyState
carReady cid = do
            ms <- L.map (flip updateHashMap (def :: PT.PartType)) <$> DBF.car_get_missing_parts cid
            ws <- L.map (flip updateHashMap (def :: CIP.CarInstanceParts)) <$> DBF.car_get_worn_parts cid
            return $ CarReadyState {
                    ready = not $ (L.length ms) > 0 || (L.length ws) > 0,
                    missing = ms,
                    worn = ws
                }
-}

carReady :: Integer -> SqlTransaction Connection CarReadyState
carReady cid = fetchCarById cid >>= carReadyState

-- get all part types
partTypes :: SqlTransaction Connection Types
partTypes = search [] [] 1000 0

-- get all part types
requiredPartTypes :: SqlTransaction Connection Types
requiredPartTypes = search ["required" |== toSql True] [] 1000 0

-- get all parts for car instance id
carInstanceParts :: Integer -> SqlTransaction Connection Parts 
carInstanceParts cid = search ["car_instance_id" |== toSql cid] [] 1000 0

-- construct car from parts
carFromParts :: Parts -> SqlTransaction Connection Car
carFromParts ps = return $ L.foldr (\p c -> HM.insert (CIP.part_type_id p) p c) HM.empty ps

-- fetch all parts in car instance and construct Car
fetchCarById :: Integer -> SqlTransaction Connection Car
fetchCarById cid = carInstanceParts cid >>= carFromParts

-- get missing required parts for car
carMissingParts :: Car -> SqlTransaction Connection Types
carMissingParts c = do
            ts <- requiredPartTypes
            let ms = L.foldr (\t ms -> case HM.lookup (fromJust $ PT.id t) c of
                            Just _ -> ms
                            Nothing -> t:ms
                        ) [] ts
            return ms

-- get worn parts for car
carWornParts :: Car -> SqlTransaction Connection Parts
carWornParts c = do
            let ws = HM.foldr (\p ws -> case CIP.wear p > 9999 of
                            True -> p:ws
                            False -> ws
                        ) [] c
            return ws

-- construct car ready state
carReadyState :: Car -> SqlTransaction Connection CarReadyState
carReadyState c = do
            ms <- carMissingParts c
            ws <- carWornParts c
            return $ CarReadyState {
                    ready = not $ (L.length ms) > 0 || (L.length ws) > 0,
                    missing = ms,
                    worn = ws
                }

