{-# LANGUAGE TemplateHaskell, DeriveDataTypeable, OverloadedStrings #-}

------------------------------------------------------------------------------
-- | This module defines our application's state type and an alias for its
-- handler monad.
module Application where

------------------------------------------------------------------------------
import Control.Lens
import Snap.Snaplet
import Snap.Snaplet.Heist
import Snap.Snaplet.Auth
import Snap.Snaplet.Session
import SqlTransactionSnaplet as ST 
import Data.ComposeModel  
import qualified Control.Monad.CatchIO as CIO
import Control.Applicative
import Data.Typeable
import Data.Monoid
import Data.Database hiding (sql, Value)
import qualified Data.ByteString.Lazy.Char8 as L
import Data.Convertible
import Data.InRules 
import Data.Conversion
import Model.General
import Database.HDBC as DB
import Database.HDBC.PostgreSQL (Connection)
import Snap.Core 
import Data.Aeson 
import Data.Attoparsec.Lazy
import           Data.DatabaseTemplate 
import qualified Data.ByteString.Char8 as B 
import qualified Data.HashMap.Strict as S
import Data.SortOrder

------------------------------------------------------------------------------


data ApplicationException = UserErrorE B.ByteString 
    deriving (Typeable, Show)

instance CIO.Exception ApplicationException


data App = App
    { 
      _sess :: Snaplet SessionManager
    , _auth :: Snaplet (AuthManager App)
    , _sql :: Snaplet SqlTransactionConfig
    }

makeLenses ''App



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



getPagesWithDTD :: DTD -> Application ((Integer, Integer), Constraints)
getPagesWithDTD d = do 
        xs <- getJson 
        let b = S.lookupDefault (DB.SqlInteger 100) "limit" xs
        let o = S.lookupDefault (DB.SqlInteger 0) "offset" xs 
        return ((DB.fromSql b, DB.fromSql o),(dtd d $ convert xs ))




writeError' :: ToJSON a => a -> Application ()
writeError' x = writeAeson' $ S.fromList [("error" :: String, x)]


writeAeson' :: ToJSON a => a -> Application ()
writeAeson' = writeLBS . Data.Aeson.encode




internalError :: String -> Application a 
internalError x = modifyResponse (setResponseCode 500) *> (CIO.throw $ UserErrorE (B.pack x))



runCompose m = with sql $ withConnection $ \c -> do 
                frp <- runComposeMonad undefined m error c
                frp `seq` return frp 


runDb a = do
    with sql $ ST.runDb (error "no locking installed") error a

