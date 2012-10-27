{-# LANGUAGE TemplateHaskell, OverloadedStrings  #-}

module Data.RaceParticipant ( 
    RaceParticipant (..),
    mkRaceParticipant,
    account_id,
    car_id
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
        ("account", ''A.Account),
        ("account_min", ''APM.AccountProfileMin),
        ("car", ''CIG.CarInGarage),
        ("car_min", ''CMI.CarMinimal),
        ("escrow_id", ''MInteger)
    ])

account_id :: RaceParticipant -> Integer
account_id = fromJust . A.id . account

car_id :: RaceParticipant -> Integer
car_id = fromJust . CIG.id . car

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


