{-# LANGUAGE ViewPatterns #-}
module Database.Register where


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

import Database.Task

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
insertDevString = "insert into developer (date_created,date_updated, name,password,email, devInfo) values (unix_timestamp() , unix_timestamp(), ? , ?, ? , ? );" 

insertDevMinString:: String
insertDevMinString = "insert into developer (date_created,date_updated, password,email, devInfo) values ( unix_timestamp(), unix_timestamp(), ?, ?, ?);" 

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
boolEmailDevMinString = "select count(*)>0 from emails "
                        ++"where email=? and usertype='developer' and  emailtype= ? and  person_id=?"

insertEmailDevMinString :: String
insertEmailDevMinString = "insert into emails (date_created,date_updated, email, usertype, emailtype, person_id)"
                           ++" values(unix_timestamp(), unix_timestamp(), ?, 'developer', ?, ? );" 
updateEmailDevMinString :: String
updateEmailDevMinString = "update emails set date_updated = unix_timestamp() where email = ? and usertype = 'developer' and "
                           ++"emailtype=? and person_id = ? ;" 



emailDev :: String -> String -> Integer -> [SqlValue]
emailDev eml emltype userid =  [toSql eml,toSql emltype,toSql userid] 

registerDevMinClearText ::String -> String -> SqlTransaction Connection Integer 
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
                           ++" values(unix_timestamp(), unix_timestamp(), ?, 'user', ?, ? );" 
updateEmailUserMinString:: String
updateEmailUserMinString = "update emails set date_updated = unix_timestamp() where email = ? and usertype = 'user' and "
                           ++"emailtype=? and person_id = ? ;" 

insertUserMinString:: String
insertUserMinString = "insert into account (date_created,date_updated, password,email, profile) values ( unix_timestamp(), unix_timestamp(), ?, ?, ?);" 


registerUserMinClearText ::  String -> String -> SqlTransaction Connection Integer 
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


checkUserAppExistsString :: String
checkUserAppExistsString = "select count(*)> 0  from account where email = ? and application_id = ? ;" 
-- App
emailVerifiedIdUserAppString :: String
emailVerifiedIdUserAppString = "select email_exists, id from account where email = ? and application_id = ?;" 

boolEmailUserAppString:: String
boolEmailUserAppString = "select count(*)>0 from emails "
                       ++"where email=? and usertype='app' and  emailtype= ? and  person_id=?"

insertEmailUserAppString:: String
insertEmailUserAppString = "insert into emails (date_created,date_updated, email, usertype, emailtype, person_id )"
                           ++" values(unix_timestamp(), unix_timestamp(), ?, 'app', ?,  ?);" 

updateEmailUserAppString:: String
updateEmailUserAppString = "update emails set date_updated = unix_timestamp() where email = ? and usertype = 'app' and "
                           ++"emailtype=? and person_id = ? ;" 

insertUserAppString:: String
insertUserAppString = "insert into account (date_created,date_updated, password,email, profile,application_id ) "
                        ++"values ( unix_timestamp(), unix_timestamp(), ?, ?, ?,?);" 


registerUserAppClearText ::  String -> String ->  Integer -> SqlTransaction Connection Integer 
registerUserAppClearText email passwd appid = registerUserApp email (tiger passwd) appid

{--
 - TODO 
this could be written in applicative style more neatly. Something like this:
t = (userExist *> userAction)  <|> registerUserEmail
    where userAction = (userCheckVerified *> userPasswordChange) <|> userEmailVerify 

--}

registerUserApp ::  String -> String -> Integer -> SqlTransaction Connection Integer 
registerUserApp email@(toSql -> semail) passwd appid@(toSql -> sappid) =  do  
                            acExist <- quickQuery' checkUserAppExistsString [semail ,sappid ]
                            if fromSql $ Data.List.head $ Data.List.head acExist then do 
                                (((fromSql -> verb):(fromSql -> id):_):_) <-  quickQuery' emailVerifiedIdUserAppString [semail , sappid]
                                if verb then do
                                   let pwdChange = emailDev email "passwordchange" id 
                                   getExist <-  quickQuery' boolEmailUserAppString pwdChange
                                   if fromSql $ head $ head getExist 
                                    then throwError "User already exists" -- run updateEmailUserAppString pwdChange 
                                    else run insertEmailUserAppString pwdChange
                                else
                                    do
                                    let verify = emailDev email "verify2" id
                                    getExistV <-  quickQuery' boolEmailUserAppString verify
                                    if fromSql $ head $ head getExistV 
                                        then throwError "User already exists" -- run updateEmailUserAppString verify
                                        else run insertEmailUserAppString verify
                            else do 
                                run insertUserAppString ( (registerLoginSqlMin email passwd) ++ [ sappid ] )


 --
 -- make Social link
 --
 -- 
 -- registerUserFromSocialMedia 
 --

insertSocialString:: String
insertSocialString = "insert into social (date_created,date_updated, user_token ,"
                        ++" network, user_token_secret ) "
                        ++"values ( unix_timestamp(), unix_timestamp(), ?, ?, ? ) returning id;" 
                        
checkSocialString :: String
checkSocialString = "select id from social where user_token = ? and  user_token_secret = ?  and  network =?  "

makeNewSocialLink ::  String -> String -> String ->  SqlTransaction Connection Integer 
makeNewSocialLink soctype@(toSql -> snetwork) soctoken@(toSql -> stoken) soctokensec@(toSql -> stokensec)= do 
     acExist <- quickQuery' checkSocialString [stoken , stokensec ,snetwork ]
     if not (null acExist ) then 
        return (fromSql $ head $ head acExist )
     else do 
        inserted <- quickQuery' insertSocialString [stoken ,snetwork , stokensec ]
        return (fromSql $ head $ head inserted )
    
    
        
checkAccountSocialString :: String
checkAccountSocialString = "select id from account where soc_linked = true and " 
                        ++ "application_id = ? and ?::BIGINT = ANY(social)  "

newAccountSocialString :: String
newAccountSocialString = "insert into account (date_created,date_updated, verified, " 
                       ++" application_id ,soc_linked, social ) " 
                       ++"values ( unix_timestamp(), unix_timestamp(), true, ?, true, (ARRAY[ ? ::BIGINT]) ) returning id;" 

makeNewAccountSocial :: Integer -> String -> String ->  String -> SqlTransaction Connection Integer 
makeNewAccountSocial appid@(toSql -> sappid ) soctype soctoken soctokensecret = do 
    socid <- makeNewSocialLink soctype soctoken soctokensecret
    let scid = toSql socid
    acExist <- quickQuery' checkAccountSocialString [sappid ,scid ]
    if not (null acExist ) then 
       return (fromSql $ head $ head acExist )
    else do 
       inserted <- quickQuery' newAccountSocialString [sappid ,scid  ]
       return (fromSql $ head $ head inserted )


addSocialAccountString :: String
addSocialAccountString = "update account  set date_updated = unix_timestamp(),soc_linked = true, " 
                       ++"social = ((select social from account where application_id = ? and id = ?)|| (? ::BIGINT))  "
                       ++"where application_id = ? and id = ? "


linkSocialAccount appid@(toSql -> sappid ) userid@(toSql -> suserid) soctype soctoken soctokensecret = do 
    socid <- makeNewSocialLink soctype soctoken soctokensecret
    let scid = toSql socid
    acExist <- quickQuery' checkAccountSocialString [sappid ,scid ]
    if not (null acExist ) then 
       return (fromSql $ head $ head acExist )
    else do   
       updated <- quickQuery' addSocialAccountString [sappid ,suserid, scid, sappid ,suserid  ]
       return (fromSql $ head $ head updated )



--  
makeNewAccountSocialTask :: String -> SqlTransaction Connection Integer 
makeNewAccountSocialTask tasktoken = do 
    (x:y:z:s:[]) <- getTaskSocial tasktoken    
    accid <- makeNewAccountSocial  (fromSql x) (fromSql y) (fromSql z) (sqlToString s)
    return accid
        where
            sqlToString SqlNull = ""
            sqlToString a = fromSql a
