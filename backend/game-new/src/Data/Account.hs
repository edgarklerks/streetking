{-# LANGUAGE ScopedTypeVariables, ViewPatterns #-}
module Data.Account (
        addRespect
    ) where


import qualified Model.Account as A
import qualified Model.Config as CFG
import Data.SqlTransaction
import Data.Database
import Database.HDBC (toSql)
import Control.Applicative 
import Data.Maybe
import Data.InRules
import Data.Conversion
import Model.General
import Debug.Trace
import Control.Monad 

addRespect :: Integer -> Integer -> SqlTransaction Connection ()
addRespect uid amt = do
        a <- aload uid (rollback $ "account not found for id " ++ (show uid)) :: SqlTransaction Connection A.Account
        update "account" ["id" |== (toSql $ uid)] [] [("respect", toSql $ (A.respect a) + amt)]
        checkLevel uid

respFunc :: Integer -> Integer -> Integer 
respFunc (fromInteger -> k) (fromInteger -> l) = floor $ k * ((l**2) + l) / 2

levelFunc :: Integer -> Integer -> Integer
levelFunc (fromInteger -> k) (fromInteger -> r) = floor $ (sqrt (k + 8 * r) - sqrt k ) / (2  * sqrt k)

checkLevel :: Integer -> SqlTransaction Connection ()
checkLevel uid = do
        k :: Integer <- CFG.getKey "respect_for_level"
        a <- aload uid (rollback $ "account not found for id " ++ (show uid)) :: SqlTransaction Connection A.Account
        let nl = levelFunc k (A.respect a)
        when (nl > A.level a ) $ do 
                    s :: Integer <- CFG.getKey "skillpoints_per_level"
                    e :: Integer <- CFG.getKey "energy_per_level"
                    let en = (A.max_energy a) + e * (nl - A.level a)
                    let su = A.skill_unused a + s * (nl - A.level a)
                    void $ update "account" 
                                    [
                                        "id" |== (toSql $ uid)
                                    ] [] 
                                    [  
                                        ("level", toSql $ nl), 
                                        ("skill_unused", toSql $ su), 
                                        ("max_energy", toSql en),
                                        ("energy", toSql en),
                                        ("till", SqlInteger 0)
                                    ]



     
