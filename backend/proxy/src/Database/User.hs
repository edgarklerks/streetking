{-# LANGUAGE ViewPatterns #-}
module Database.User where 

import Data.SqlTransaction
import Data.Digest.TigerHash
import Data.Digest.TigerHash.ByteString
import qualified Data.ByteString.Char8 as B


salt :: String 
salt = "brllsls"

mkPasswd = b32TigerHash . tigerHash . B.pack . (++salt)

loginUser :: IConnection c => String -> String -> SqlTransaction c Integer
loginUser (mkPasswd -> pw) em = do 
              x <- sqlGetOne "select id from account where email = ? and password = ?" [toSql em, toSql pw] 
              case fromSql x of 
                Just id -> return id 
                Nothing -> rollback "no such user"

            
