{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TemplateHaskell, OverloadedStrings #-}
module Model.Escrow where 

import           Data.SqlTransaction
import           Database.HDBC
import           Data.Convertible
import           Model.General
import           Data.Database 
import           Control.Monad
import qualified Data.Aeson as AS
import           Data.InRules
import qualified Data.ByteString.Char8 as C
import qualified Data.ByteString.Lazy as B

import qualified Data.HashMap.Strict as HM
import           Control.Applicative
import qualified Data.Map as M
import           Model.TH
import           Prelude hiding (id)
import qualified Model.Transaction as TR 

$(genAll "Escrow" "escrow" [             
                    ("id", ''Id),
                    ("account_id", ''Integer),
                    ("amount", ''Integer),
                    ("deleted", ''Bool)
   ])

-- deposit money in an escrow account, return ID
deposit :: Integer -> Integer -> SqlTransaction Connection Integer
deposit uid amt = do
        unless (amt > 0) $ Data.SqlTransaction.rollback "Deposit: amount must be greater than 0"
        eid <- save $ def {
                account_id = uid,
                amount = amt,
                deleted = False
            }
        TR.transactionMoney uid (def {
                TR.amount = 0 - amt,
                TR.type = "escrow_deposit",
                TR.type_id = eid
            })
        return eid

-- return money to depositing user; delete
cancel :: Integer -> SqlTransaction Connection ()
cancel eid = do
        me <- load eid :: SqlTransaction Connection (Maybe Escrow)
        case me of
                Nothing -> Data.SqlTransaction.rollback $ "Cancel: Escrow id not found: " ++ (show eid)
                Just e -> do
                        TR.transactionMoney (account_id e) (def {
                                TR.amount = amount e,
                                TR.type = "escrow_cancel",
                                TR.type_id = eid
                            })
                        save $ e { deleted = True }
                        return ()

-- release escrow account to a user's account
release :: Integer -> Integer -> SqlTransaction Connection () 
release eid uid = do
        me <- load eid :: SqlTransaction Connection (Maybe Escrow)
        case me of
                Nothing -> Data.SqlTransaction.rollback $ "Release: Escrow id not found: " ++ (show eid)
                Just e -> do
                        TR.transactionMoney uid (def {
                                TR.amount = amount e,
                                TR.type = "escrow_release",
                                TR.type_id = eid
                            })
                        save $ e { deleted = True }
                        return ()

