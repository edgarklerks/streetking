module Data.Tournament where 

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


                           






