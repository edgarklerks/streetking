{-# LANGUAGE ViewPatterns #-}
module Data.Tournament (
        joinTournament                   
    ) where 

import Model.TournamentPlayers as TP
import Model.Tournament as T
import Model.General 
import Data.Convertible 
import Data.InRules 
import qualified Data.Aeson as AS
import Data.SqlTransaction
import Model.Account as A 
import Model.Transaction as TR  
import Model.CarInstance  
import Model.CarInGarage 
import Data.Maybe 
import Control.Monad 
import Control.Applicative
import Data.Database
import Database.HDBC.SqlValue 
import qualified Data.List as L
import Test.QuickCheck as Q 



joinTournament :: Integer -> Integer -> SqlTransaction Connection () 
joinTournament n acid = do 
                trn <- load n :: SqlTransaction Connection (Maybe Tournament)
                ac <- fromJust <$> load acid
                
            
                when (isNothing trn) $ rollback "no such tournament"
                
                checkPrequisites ac (fromJust $ trn)
                addClownToTournament ac (fromJust $ trn)

                return () 

addClownToTournament :: Account -> Tournament -> SqlTransaction Connection ()
addClownToTournament a t = do 
                        transactionMoney (fromJust $ A.id a) (def {
                                    amount = -(T.costs t),
                                    type_id = 10,
                                    TR.type = "tournament_cost" 
                                })
                              
                        save (def {
                            TP.account_id = A.id a, 
                            TP.tournament_id = T.id t 
                                    } :: TP.TournamentPlayer )
                        return ()
-- | check car, enough money, time prequisites
checkPrequisites :: Account -> Tournament -> SqlTransaction Connection () 
checkPrequisites a (Tournament id cid st cs mnl mxl rw) = do 
        when (isJust cid) $ do 
                    xs <- search ["car_id" |== (toSql $ cid) .&& "account_id" |== (toSql $ A.id a)] [] 1 0 :: SqlTransaction Connection [CarInGarage]
                    when (null xs) $ rollback "doesn't own correct car"
        when ( A.money a < cs ) $ rollback "you do not have enough money" 
        when (A.level a > mxl) $ rollback "your level is too high"
        when (A.level a < mnl) $ rollback "your level is not high enough"


                           




-- divideClowns :: Tournament -> SqlTransaction Connection [(TP.TournamentPlayer, TP.TournamentPlayer)]
divideClowns t = do 
                xs <- search ["tournament_id" |== (toSql $ T.id t)] [] 10000 0 :: SqlTransaction Connection [TP.TournamentPlayer]
                return (divd xs) 


-- 2 | 3 solutions 
--
--

twothree :: [a] -> [[a]]
twothree [] = [] 
twothree [x] = [[x]]
twothree [x,y] = [[x,y]]
twothree [x,y,z] = [[x,y,z]]
twothree (x:y:xs) = [x,y] : twothree xs 

-- | Problem: I have to divide a group fairly into groups of 2,3,5,7 etc, with fair 
-- dirty solution, calc mod of list length at 2,3,5,7 etc 
-- more dirty, just search solution from list [1..100] 
divd :: [a] -> [[a]]
divd xs@(length -> l) = dvd (fromJust prs) xs 
        where prs = L.find (\x -> l `mod` x == 0 || (l - (l `div` 2)) `mod` x == 0) [2..(l - 1)]


dvd :: Int -> [a] -> [[a]] 
dvd n [] = []
dvd n [x,y] = [[x,y]]
dvd n [x,y,z] = [[x,y,z]]
dvd n xs = take n xs : dvd n (drop n xs)


testlnotone = property test
    where test :: [()] -> Bool
          test [] = True 
          test [x] = True 
          test xs = minimum (fmap length $ divd xs) > 1

testpnotone = property test 
    where test :: [()] -> Bool 
          test [] = True 
          test [x] = True 
          test xs = minimum (fmap length $ twothree xs) > 1


