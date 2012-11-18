
module Data.Account (
        respectNext,
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

addRespect :: Integer -> Integer -> SqlTransaction Connection ()
addRespect uid amt = do
        a <- aload uid (rollback $ "account not found for id " ++ (show uid)) :: SqlTransaction Connection A.Account
        trace "updating account" $ update "account" ["id" |== (toSql $ uid)] [] [("respect", toSql $ (A.respect a) + amt)]
        trace "checking level" $ checkLevel uid

respectNext :: Integer -> SqlTransaction Connection Integer 
respectNext uid = do
        a <- aload uid (rollback $ "account not found for id " ++ (show uid)) :: SqlTransaction Connection A.Account
        k :: Integer <- CFG.getKey "respect_for_level"
        let r = (\l -> k * ((l ^ 2) + l) `div` 2) $ A.level a
        trace ("needed for next level: " ++ (show $ r - (A.respect a))) return $ r - (A.respect a) 

checkLevel :: Integer -> SqlTransaction Connection ()
checkLevel uid = do
        r <- respectNext uid
        case r < 0 of
                False -> trace "no update needed" $ return ()
                True -> do
                        trace "leveling up" $ levelUp uid
                        checkLevel uid

levelUp :: Integer -> SqlTransaction Connection () 
levelUp uid = do
        s :: Integer <- CFG.getKey "skillpoints_per_level"
        e :: Integer <- CFG.getKey "energy_per_level"
        a <- aload uid (rollback $ "account not found for id " ++ (show uid)) :: SqlTransaction Connection A.Account
        let fl = A.level a
        let su = A.skill_unused a
        let en = (A.max_energy a) + e
        update "account" ["id" |== (toSql $ uid)] [] [("level", toSql $ fl + 1), ("skill_unused", toSql $ su + s), ("max_energy", toSql en), ("energy", toSql en)]
        -- TODO: level-up notification 
        return ()
         

     
