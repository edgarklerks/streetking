{-# LANGUAGE ViewPatterns #-}
module Database.LoginRegister where


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
import Database.HDBC.PostgreSQL -- Database.HaskellDB.HDBC.PostgreSQL

--import JSONRPC.Server
--import Database.HDBC.PostgreSQL
   
primaryEmail ::  ToInRule a => a -> InRule
primaryEmail email =  fromList $ Data.List.zip ["primaryEmail", "email1"] [email,email]
 

namePassword :: String -> String ->  InRule
namePassword name pwd =  InArray [toInRule name, toInRule pwd ]


registerLogin :: String -> String -> String ->  InRule
registerLogin name pwd eml =  InArray [toInRule name, toInRule pwd, toInRule eml,toInRule $ toHstoreString $ primaryEmail eml]

registerLoginSql :: String -> String -> String ->  [SqlValue]
registerLoginSql name pwd eml = conv2SqlArray $ registerLogin name pwd eml

registerLoginClearText :: String -> String -> String ->  InRule
registerLoginClearText name pwd eml =  InArray [toInRule name, toInRule $ tiger pwd, toInRule eml,toInRule $ toHstoreString $ primaryEmail eml]
registerLoginSqlClearText :: String -> String -> String ->  [SqlValue]
registerLoginSqlClearText name pwd eml = conv2SqlArray $ registerLoginClearText name pwd eml


registerLoginMin :: String -> String ->  InRule
registerLoginMin eml pwd =  InArray [toInRule pwd, toInRule eml, toInRule $ toHstoreString $ primaryEmail eml]

registerLoginSqlMin :: String -> String ->  [SqlValue]
registerLoginSqlMin eml pwd = conv2SqlArray $ registerLoginMin eml pwd 


insertDevString:: String
insertDevString = "insert into developer (date_created,date_updated, name,password,email, devInfo) values (now() , now(), ? , ?, ? , ? );" 

insertDevMinString:: String
insertDevMinString = "insert into developer (date_created,date_updated, password,email, devInfo) values ( now(), now(), ?, ?, ?);" 

getPasswordDevString:: String
getPasswordDevString = "select password from developer where email = ? ;" 

{--register dev
    check if email is present
    if email is present
        check if email is verified
            send an email asking: Does the password need to be changed? Otherwise ignore this message
        if email is unverified
            resend the verification email. (with password change ability...)
    if email is Not present  
        insert new developer.

 - --}
checkDevExistsString:: String
checkDevExistsString = "select count(*)> 0  from developer where email = ? ;" 
 
emailVerifiedPasswordDevString:: String
emailVerifiedPasswordDevString = "select email_exists, password from developer where email = ? ;" 
emailVerifiedIdDevString:: String
emailVerifiedIdDevString = "select email_exists, id from developer where email = ? ;" 

boolEmailDevMinString:: String
boolEmailDevMinString = "select count(*)>0 from emails where email=? and usertype='developer' and  emailtype= ? and  person_id=?"

insertEmailDevMinString :: String
insertEmailDevMinString = "insert into emails (date_created,date_updated, email, usertype, emailtype, person_id)"
                           ++" values(now(), now(), ?, 'developer', ?, ? );" 
updateEmailDevMinString :: String
updateEmailDevMinString = "update emails set date_updated = now() where email = ? and usertype = 'developer' and "
                           ++"emailtype=? and person_id = ? ;" 


emailDev :: String -> String -> Integer -> [SqlValue]
emailDev eml emltype userid =  [toSql eml,toSql emltype,toSql userid] 

registerDevMinClearText ::[Char] -> String -> SqlTransaction Connection Integer 
registerDevMinClearText email passwd = registerDevMin email $ tiger passwd

registerDevMin ::  String -> String -> SqlTransaction Connection Integer 
registerDevMin email@(toSql -> semail) passwd =  do   
                            acExist <- quickQuery' checkDevExistsString [semail]
                            if fromSql (Data.List.head $ Data.List.head acExist) then do 
                                ((fromSql -> verb):(fromSql -> id):_) <-  sqlGetRow emailVerifiedIdDevString [toSql email]
                                if verb then do
                                   let pwdChange = emailDev email "passwordchange" id 
                                   getExist <- fromSql <$> sqlGetOne boolEmailDevMinString pwdChange 
                                   if getExist 
                                        then run updateEmailDevMinString pwdChange
                                        else run insertEmailDevMinString pwdChange
                                else do
                                    let verify = emailDev email "verify2" id
                                    getExistV <-  fromSql <$> sqlGetOne boolEmailDevMinString verify 
                                    if getExistV 
                                        then run updateEmailDevMinString verify
                                        else run insertEmailDevMinString verify
                            else run insertDevMinString $ registerLoginSqlMin email passwd 
                            
                            

{--
 -register
        username, password, email, Data.Map String String
 - register user email
    check if email is present
    if email is present
        check if email is verified
            send an email asking: Does the password need to be changed? Otherwise ignore this message
        if email is unverified
            resend the verification email. (It should have a link to a password change page )
    if email is Not present  
        insert new user
        send the verification email. (It should have a link to a password change page )

 - --}

checkUserExistsString :: String
checkUserExistsString = "select count(*)> 0  from account where email = ? ;" 
emailVerifiedIdUserString :: String
emailVerifiedIdUserString = "select email_exists, id from account where email = ? ;" 

boolEmailUserMinString:: String
boolEmailUserMinString = "select count(*)>0 from emails where email=? and usertype='user' and  emailtype= ? and  person_id=?"

insertEmailUserMinString:: String
insertEmailUserMinString = "insert into emails (date_created,date_updated, email, usertype, emailtype, person_id)"
                           ++" values(now(), now(), ?, 'user', ?, ? );" 
updateEmailUserMinString:: String
updateEmailUserMinString = "update emails set date_updated = now() where email = ? and usertype = 'user' and "
                           ++"emailtype=? and person_id = ? ;" 

insertUserMinString:: String
insertUserMinString = "insert into account (date_created,date_updated, password,email, profile) values ( now(), now(), ?, ?, ?);" 


registerUserMinClearText ::  [Char] -> String -> SqlTransaction Connection Integer 
registerUserMinClearText email passwd = registerUserMin email $ tiger passwd

{--
 - TODO 
this could be written in applicative style more neatly. Something like this:
t = (userExist *> userAction)  <|> registerUserEmail
    where userAction = (userCheckVerified *> userPasswordChange) <|> userEmailVerify 

--}

registerUserMin ::  String -> String -> SqlTransaction Connection Integer 
registerUserMin email@(toSql -> semail) passwd =  do  
                            acExist <- quickQuery' checkUserExistsString [semail]
                            if fromSql $ Data.List.head $ Data.List.head acExist then do 
                                (((fromSql -> verb):(fromSql -> id):_):_) <-  quickQuery' emailVerifiedIdUserString [semail]
                                if verb then do
                                   let pwdChange = emailDev email "passwordchange" id 
                                   getExist <-  quickQuery' boolEmailUserMinString pwdChange
                                   if fromSql $ head $ head getExist 
                                    then run updateEmailUserMinString pwdChange
                                    else run insertEmailUserMinString pwdChange
                                else
                                    do
                                    let verify = emailDev email "verify2" id
                                    getExistV <-  quickQuery' boolEmailUserMinString verify
                                    if fromSql $ head $ head getExistV 
                                        then run updateEmailUserMinString verify
                                        else run insertEmailUserMinString verify
                            else do 
                                run insertUserMinString $ registerLoginSqlMin email passwd 

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

                            when ( (fromSql pwd) /=  passwd) (rollback "Password verification")
                            
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

 
