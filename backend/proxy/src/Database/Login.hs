{-# LANGUAGE ViewPatterns #-}
module Database.Login where


import Control.Concurrent
import Control.Applicative
import Control.Monad
import Control.Monad.State
import Control.Monad.Identity
import Control.Monad.Trans
import Data.Maybe
import Control.Monad.Maybe
import Data.Generics
import Data.Word
import Data.Int
import Control.Monad.Error

import qualified Data.Text as T

import Data.List

--
import Network
import Data.Bits

import qualified Data.ByteString.Char8 as S
import qualified Data.ByteString.Lazy.Char8 as L
import qualified Data.IntSet as I

import Data.Object
import Data.Object.Yaml

import Data.InRules
import Data.Conversion
 
import Data.Security

import Data.Time.Calendar
import Data.Time.Clock 
import Data.Time.LocalTime


import Database.HDBC.SqlValue


--import Database.HDBC
import Data.SqlTransaction 
import Database.HDBC.PostgreSQL  

import Database.Register

{--
register new user facebook/twitter/etc.. 
    check if user exists
        if so login
    Else 
        insert verified new user
 - --}


{--

inloggen email 
    username==email
    check if email is present
        if email is Not present  
            error "Email is not in the database, please register or fill in the correct email"
        check if password matches
            if not error "Wrong password"
    password exist?

    return userId 
        else return Nothing

 --}
 --
emailVerifiedPasswordIdDevString :: String
emailVerifiedPasswordIdDevString = "select email_exists, password, id from developer where email = ? ;" 


loginDevMinClearText ::  String ->String -> SqlTransaction Connection Integer 
loginDevMinClearText email passwd = loginDevMin email (tiger passwd)

loginDevMin ::  String -> String -> SqlTransaction Connection Integer 
loginDevMin email@(toSql -> semail) passwd =  do  
                            acExist <- quickQuery' checkDevExistsString  [semail]
                            when (not $ fromSql $ head $ head acExist) (rollback "Account doesn't exist")
                            very <- quickQuery' emailVerifiedPasswordIdDevString [semail]
                            let (vrow:pwd:id:_) = head very 
                            when (not $ fromSql $ vrow) (rollback "Verify email please")
                            when (fromSql pwd /=  passwd) (rollback "Password verification")                            
                            return $ fromSql  id

emailVerifiedPasswordIdUserString :: String
emailVerifiedPasswordIdUserString = "select email_exists, password, id from account where email = ? ;" 



loginUserMinClearText:: String -> String -> SqlTransaction Connection Integer
loginUserMinClearText email passwd = loginUserMin  email (tiger passwd)


loginUserMin ::  String -> String -> SqlTransaction Connection Integer  
loginUserMin (toSql -> semail) passwd =  do  
                            acExist <- fromSql <$> sqlGetOne  checkUserExistsString  [semail]
                            when (not acExist) (rollback "Account doesn't exist")
                            (vrow:pwd:id:_) <- sqlGetRow emailVerifiedPasswordIdUserString [semail]
                            when (not $ fromSql vrow) $ rollback "Verify email please"
                            when (fromSql pwd /=  passwd) $ rollback "Password verification"
                            return $ fromSql  id


emailVerifiedPasswordIdUserAppIdString :: String
emailVerifiedPasswordIdUserAppIdString = "select email_exists, password, id from account where email = ? and application_id =? ;" 


loginUserAppClearText:: String -> String ->  Integer -> SqlTransaction Connection Integer
loginUserAppClearText email passwd appid = loginUserApp  email (tiger passwd) appid


loginUserApp ::  String -> String -> Integer -> SqlTransaction Connection Integer  
loginUserApp (toSql -> semail) passwd appid@(toSql -> sappid) =  do  
                            acExist <- fromSql <$> sqlGetOne  checkUserAppExistsString  [semail , sappid]
                            when (not acExist) (rollback "Account doesn't exist")
                            (vrow:pwd:id:_) <- sqlGetRow emailVerifiedPasswordIdUserAppIdString [semail , sappid]
                            when (not $ fromSql vrow) $ rollback "Verify email please"
                            when (fromSql pwd ==  passwd) $ rollback "Password verification"
                            return $ fromSql  id


