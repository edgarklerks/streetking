{-# LANGUAGE TemplateHaskell, DeriveDataTypeable, OverloadedStrings, FlexibleContexts #-}

------------------------------------------------------------------------------
-- | This module defines our application's state type and an alias for its
-- handler monad.
module Application where

------------------------------------------------------------------------------
import Data.Lens.Template
import Snap.Snaplet
import ConfigSnaplet 
import SqlTransactionSnaplet hiding (runDb)
import qualified SqlTransactionSnaplet as ST 
import Data.Aeson
import           Data.Attoparsec.Lazy
import Control.Monad.State
import Data.SortOrder
import Data.Database hiding (Value)
import Model.General
import Data.InRules
import qualified Data.ByteString.Lazy.Char8 as L
import qualified Data.ByteString.Char8 as B 
import Snap.Core 
import qualified Data.HashMap.Strict as S
import Data.Conversion
import qualified Control.Monad.CatchIO as CIO
import Control.Applicative
import Data.Typeable
import Data.Monoid
import Database.HDBC
import Database.HDBC.PostgreSQL (Connection)
import qualified Database.HDBC.PostgreSQL as DB 
import qualified Database.HDBC as DB
import           Data.DatabaseTemplate 
import  Data.Convertible
import RandomSnaplet as R 
import NodeSnaplet as D 
import Data.Role as R 
import qualified Data.Binary as BI 
import Proto 
import Data.MemState 
import Data.ComposeModel  
import NotificationSnaplet as N  
import qualified LockSnaplet as L 








data ApplicationException = UserErrorE B.ByteString 
    deriving (Typeable, Show)

instance CIO.Exception ApplicationException




------------------------------------------------------------------------------
data App = App
    { 
      _db :: Snaplet SqlTransactionConfig
    , _config :: Snaplet ConfigSnaplet 
    , _rnd :: Snaplet RandomConfig 
    , _nde :: Snaplet DHTConfig 
    , _notf :: Snaplet N.NotificationConfig
    , _slock :: Snaplet L.Lock 
    }

makeLens ''App

getUniqueKey :: Application (B.ByteString)
getUniqueKey = with rnd $ R.getUniqueKey 

runDb a = with db $ ST.runDb error a

sendLetter uid letter = with notf $ N.sendLetter uid letter 

setRead uid letter = with notf $ N.setRead uid letter 

setArchive uid letter = with notf $ N.setArchive uid letter
checkMailBox uid = with notf $ N.checkMailBox uid 
instance HasDHT App where 
    dhtLens = subSnaplet nde 

instance HasConfig App where 
    configLens = subSnaplet config 

instance HasSqlTransaction App where 
    sqlLens = subSnaplet db 

instance HasRandom App where 
    randomLens = subSnaplet rnd 

instance L.HasLock App where 
    lockLens = subSnaplet slock 
------------------------------------------------------------------------------
type AppHandler = Handler App App

type Application = AppHandler 
toAeson :: InRule -> L.ByteString  
toAeson = (Data.Aeson.encode :: Value -> L.ByteString) . fromInRule

writeAeson :: ToInRule a => a -> Application ()
writeAeson = writeLBS . toAeson . toInRule

writeError :: ToInRule a => a -> Application ()
writeError x = writeAeson $ S.fromList [("error" :: String, x)]

writeResult :: ToInRule a => a -> Application ()
writeResult x = writeAeson $ S.fromList [("result" :: String, x)]

writeResult' :: ToJSON a => a -> Application ()
writeResult' x = writeAeson' $ S.fromList [("result" :: String, x)]


writeMapable :: Mapable a => a -> Application ()
writeMapable = writeResult . toHashMap 

writeMapables :: Mapable a => [a] -> Application ()
writeMapables = writeResult . fmap toHashMap 

getUserId :: Application Integer 
getUserId =  do 
        x <- getParam "userid"
        case x of 
                Just y -> return (read $ B.unpack y)
                Nothing -> internalError "No userid"


getOParam :: B.ByteString -> Application B.ByteString
getOParam x = do 
    p <- getParam x
    case p of 
        Nothing -> internalError $ "param: " `mappend` (B.unpack x) `mappend`  "must provided"
        Just a -> return a

type SqlMap = S.HashMap String SqlValue 
getJson :: Application  SqlMap 
getJson = do 
    t <- parse json <$> getRequestBody 
    case t of 
        (Done _ v)  -> return (fromInRule $ toInRule v)
        otherwise -> return S.empty --- internalError "No json provided" 

getJsons :: Application [SqlMap]
getJsons = do 
    t <- parse json <$> getRequestBody 
    case t of 
        (Done _ v)  -> return (fromInRule $ toInRule v)
        otherwise -> return [] --- internalError "No json provided" 

getPagesWithDTDOrdered :: [String] -> DTD -> Application (((Integer, Integer), Constraints), Orders)
getPagesWithDTDOrdered vs d = do 
                xs <- getJson
                let b = S.lookupDefault (DB.SqlInteger 100) "limit" xs
                let o = S.lookupDefault (DB.SqlInteger 0) "offset" xs 
                let od = S.lookupDefault "" "sql" xs
                let cst = dtd d $ convert xs 
                let od' = getSortOrder (convert od) >>= \od -> sortOrder od vs 
                case od' of 
                    Left e -> internalError e
                    Right x -> do 
                        return (((DB.fromSql b, DB.fromSql o), cst), x)

getPagesWithDTDOrderedAndParams :: SqlMap -> [String] -> DTD -> Application (((Integer, Integer), Constraints), Orders)
getPagesWithDTDOrderedAndParams xs vs d = do 
                let b = S.lookupDefault (DB.SqlInteger 100) "limit" xs
                let o = S.lookupDefault (DB.SqlInteger 0) "offset" xs 
                let od = S.lookupDefault "" "sql" xs
                let cst = dtd d $ convert xs 
                let od' = getSortOrder (convert od) >>= \od -> sortOrder od vs 
                case od' of 
                    Left e -> internalError e
                    Right x -> do 
                        return (((DB.fromSql b, DB.fromSql o), cst), x)



getPagesWithDTD :: DTD -> Application ((Integer, Integer), Constraints)
getPagesWithDTD d = do 
        xs <- getJson 
        let b = S.lookupDefault (DB.SqlInteger 100) "limit" xs
        let o = S.lookupDefault (DB.SqlInteger 0) "offset" xs 
        return ((DB.fromSql b, DB.fromSql o),(dtd d $ convert xs ))



addRole i k =  with nde $ do 
                    sendQuery (Proto.insert k rs) 
        where rs = B.pack $ L.unpack $ BI.encode $ User (Just i) 



writeError' :: ToJSON a => a -> Application ()
writeError' x = writeAeson' $ S.fromList [("error" :: String, x)]


writeAeson' :: ToJSON a => a -> Application ()
writeAeson' = writeLBS . Data.Aeson.encode




internalError :: String -> Application a 
internalError x = modifyResponse (setResponseCode 500) *> (CIO.throw $ UserErrorE (B.pack x))



runCompose m = with db $ withConnection $ \c -> do 
                frp <- runComposeMonad m error c
                frp `seq` return frp 


withLockBlock l n a m = with slock $ L.withLockBlock l n a m 

withLockNonBlock l n a m = with slock $ L.withLockNonBlock l n a m  

getLock :: Application L.Lock 
getLock = with slock $ L.getLock  
