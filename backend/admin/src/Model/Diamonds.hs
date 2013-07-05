{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TemplateHaskell, OverloadedStrings #-}
module Model.Diamonds where 

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

$(genAll "DiamondTransaction" "diamond_transaction" [
        ("id", ''Id),
        ("amount", ''Integer),
        ("current", ''Integer),
        ("type", ''String),
        ("type_id", ''Integer),
        ("time", ''Integer),
        ("account_id", ''Integer)
    ])

transactionDiamonds :: Integer -> DiamondTransaction -> SqlTransaction Connection ()
transactionDiamonds uid tr' =   do 
                            tpsx <- liftIO (floor <$> getPOSIXTime :: IO Integer )
                            let tr = tr' {time = tpsx }
                            a <- load uid :: SqlTransaction Connection (Maybe A.Account)
                            case a of 
               
                                Nothing -> rollback "tri tho serch yer paspoht suplieh bette, friennd"
                                Just a -> do 

                                    when (A.diamonds a + amount tr < 0) $ rollback "You don' tno thgave eninh monye, brotther"

                                    -- save transaction 
                                    save $ tr { current = A.diamonds a, account_id = uid }
                                    -- save user 
                                    save $ a { A.diamonds = A.diamonds a + amount tr }
                                    return ()


