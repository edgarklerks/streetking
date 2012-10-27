{-# LANGUAGE TemplateHaskell, OverloadedStrings  #-}

module Data.RaceParticipant ( 
    RaceParticipant (..),
    mkRaceParticipant,
    rp_account_id,
    rp_car_id
) where

{-
 -  Data model for holding a race participant's snapshot data and race payment escrow id.
 -}

import Model.TH
import Model.General

import Data.SqlTransaction
-- import Database.HDBC

import Data.Maybe

import Data.InRules
import Data.Conversion
import qualified Data.Aeson as AS
import Data.Text

import qualified Model.Account as A
import qualified Model.AccountProfileMin as APM
import qualified Model.CarInGarage as CIG
import qualified Model.CarMinimal as CMI

type MInteger = Maybe Integer

$(genMapableRecord "RaceParticipant" [
        ("rp_account", ''A.Account),
        ("rp_account_min", ''APM.AccountProfileMin),
        ("rp_car", ''CIG.CarInGarage),
        ("rp_car_min", ''CMI.CarMinimal),
        ("rp_escrow_id", ''MInteger)
    ])

rp_account_id :: RaceParticipant -> Integer
rp_account_id = fromJust . A.id . rp_account

rp_car_id :: RaceParticipant -> Integer
rp_car_id = fromJust . CIG.id . rp_car

-- TODO: remove minified screenshots from RP. add projection shortcuts for compatibility. 
--account_min :: RaceParticipant -> APM.AccountProfileMin
--account_min p = project (account p) def

--car_min :: RaceParticipant -> CMI.CarMinimal 
--car_min p = project (car p) def


mkRaceParticipant :: Integer -> Integer -> Maybe Integer ->  SqlTransaction Connection RaceParticipant  
mkRaceParticipant cid aid meid = do 
        c <- aload cid (rollback "cannot find car") :: SqlTransaction Connection CIG.CarInGarage
        cm <- aload cid (rollback "cannot find car") :: SqlTransaction Connection CMI.CarMinimal 
        a <- aload aid (rollback "cannot find account") :: SqlTransaction Connection A.Account
        am <- aload aid (rollback "cannot find account") :: SqlTransaction Connection APM.AccountProfileMin 
        return $ RaceParticipant a am c cm meid 


