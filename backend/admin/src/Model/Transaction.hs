{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TemplateHaskell, OverloadedStrings #-}
module Model.Transaction where 

import           Data.SqlTransaction
import           Database.HDBC hiding (rollback)
import           Control.Monad.Trans
import           Data.Time.Clock.POSIX
import           Data.Convertible
import           Model.General
import           Data.Database 
import           Control.Monad
import qualified Data.Aeson as AS
import Data.InRules

import           Control.Applicative
import qualified Data.Map as M
import           Model.TH
import           Prelude hiding (id)
import qualified Model.Account as A 
import qualified Data.Relation as Rel

$(genAll "Transaction" "transaction" [
        ("id", ''Id),
        ("amount", ''Integer),
        ("current", ''Integer),
        ("type", ''String),
        ("type_id", ''Integer),
        ("time", ''Integer),
        ("account_id", ''Integer)
    ])

transactionMoney :: Integer -> Transaction -> SqlTransaction Connection ()
transactionMoney uid tr' =   do 
                            tpsx <- liftIO (floor <$> getPOSIXTime :: IO Integer )
                            let tr = tr' {time = tpsx }
                            a <- load uid :: SqlTransaction Connection (Maybe A.Account)
                            case a of 
               
                                Nothing -> rollback "tri tho serch yer paspoht suplieh bette, friennd"
                                Just a -> do 

                                    when (A.money a + amount tr < 0) $ rollback "You don' tno thgave eninh monye, brotther"

                                    -- save transaction 
                                    save $ tr { current = A.money a, account_id = uid }
                                    -- save user 
                                    save $ a { A.money = A.money a + amount tr }
                                    return ()


