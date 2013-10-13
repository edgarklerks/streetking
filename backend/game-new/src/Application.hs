{-# LANGUAGE TemplateHaskell, DeriveDataTypeable, OverloadedStrings, FlexibleContexts #-}

------------------------------------------------------------------------------
-- | This module defines our application's state type and an alias for its
-- handler monad.
module Application where

------------------------------------------------------------------------------


import           Data.Attoparsec.Lazy
import           Data.DatabaseTemplate 
import           Data.Convertible
import           ConfigSnaplet 
import           Control.Applicative
import           Control.Monad.State
import           Data.Aeson
import           Data.ComposeModel  
import           Data.Conversion
import           Data.Database hiding (Value)
import           Data.InRules
import           Control.Lens
import           Data.Monoid
import           Data.Role as R 
import           Data.SortOrder
import           Data.Typeable
import           Database.HDBC
import           Database.HDBC.PostgreSQL (Connection)
import           Model.General
import           NodeSnapletTest as D 
import           NotificationSnaplet as N  
import           RandomSnaplet as R 
import           Snap.Core 
import           Snap.Snaplet
import           SqlTransactionSnaplet hiding (runDb)
import qualified Control.Monad.CatchIO as CIO
import qualified Data.Binary as BI 
import qualified Data.ByteString.Char8 as B 
import qualified Data.ByteString.Lazy.Char8 as L
import qualified Data.HashMap.Strict as S
import qualified Database.HDBC as DB
import qualified Database.HDBC.PostgreSQL as DB 
import qualified LockSnaplet as L 
import qualified SqlTransactionSnaplet as ST 
import           LogSnaplet 
import qualified Data.Role as R 






data ApplicationException = UserErrorE B.ByteString 
    deriving (Typeable, Show)

instance CIO.Exception ApplicationException




------------------------------------------------------------------------------
data App = App
    { 
      _db :: Snaplet SqlTransactionConfig
    , _config :: Snaplet ConfigSnaplet 
    , _rnd :: Snaplet RandomConfig 
    , _nde :: Snaplet (DHTConfig R.Role) 
    , _notf :: Snaplet N.NotificationConfig
    , _slock :: Snaplet L.Lock 
    , _logcycle :: Snaplet Cycle 
    }

makeLenses ''App

getUniqueKey :: Application (L.ByteString)
getUniqueKey = with rnd $ do
                s <- R.getUniqueKey 
                return $ L.fromChunks [s]

runDb a = do
        l <- getLock 
        with db $ ST.runDb l error a

sendLetter uid letter = with notf $ N.sendLetter uid letter 

setRead uid letter = with notf $ N.setRead uid letter 

setArchive uid letter = with notf $ N.setArchive uid letter
checkMailBox uid = with notf $ N.checkMailBox uid 
------------------------------------------------------------------------------
type AppHandler = Handler App App

type Application = AppHandler 
toAeson :: InRule -> L.ByteString  
toAeson = (Data.Aeson.encode :: Value -> L.ByteString) . fromInRule

-- | Write Aeson to user 
writeAeson :: ToInRule a => a -> Application ()
writeAeson = writeLBS . toAeson . toInRule

-- | Write an error to the http client
writeError :: ToInRule a => a -> Application ()
writeError x = writeAeson $ S.fromList [("error" :: String, x)]

-- | Write a InRule to the http client  
writeResult :: ToInRule a => a -> Application ()
writeResult x = writeAeson $ S.fromList [("result" :: String, x)]

-- | Write a JSON to the http client  
writeResult' :: ToJSON a => a -> Application ()
writeResult' x = writeAeson' $ S.fromList [("result" :: String, x)]

-- | Write a mapable to the client 
writeMapable :: Mapable a => a -> Application ()
writeMapable = writeResult . toHashMap 

-- | Write multiple mapables as a json array 
writeMapables :: Mapable a => [a] -> Application ()
writeMapables = writeResult . fmap toHashMap 

-- | get the user id from the proxy 
getUserId :: Application Integer 
getUserId =  do 
        x <- getParam "userid"
        case x of 
                Just y -> return (read $ B.unpack y)
                Nothing -> internalError "No userid"

-- | get a GET param faults when param doesn't exist 
getOParam :: B.ByteString -> Application B.ByteString
getOParam x = do 
    p <- getParam x
    case p of 
        Nothing -> internalError $ "param: " `mappend` (B.unpack x) `mappend`  "must provided"
        Just a -> return a

type SqlMap = S.HashMap String SqlValue 
-- | get json in the form of a 'SqlMap'  
getJson :: Application  SqlMap 
getJson = do 
    t <- parse json <$> getRequestBody 
    case t of 
        (Done _ v)  -> return (fromInRule $ toInRule v)
        otherwise -> return S.empty --- internalError "No json provided" 
-- | Get multiple jsons as a 'SqlMap' 
getJsons :: Application [SqlMap]
getJsons = do 
    t <- parse json <$> getRequestBody 
    case t of 
        (Done _ v)  -> return (fromInRule $ toInRule v)
        otherwise -> return [] --- internalError "No json provided" 
-- | Generates a constraint and returns an (((limit, offset), Constraints),Orders)
getPagesWithDTDOrdered :: [String] -- ^ Allowed order fields 
            -> DTD  -- ^ search expression
            -> Application (((Integer, Integer), Constraints), Orders)
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
-- | Same as 'getPagsWithDTDOrdered', only then provide default values  
getPagesWithDTDOrderedAndParams :: 
        SqlMap -- ^ Default values 
        -> 
        [String] -- ^ Allowed ordered fields 
        -> 
        DTD -- ^ search expression, see 'Data.DatabaseTemplate' 
        -> 
        Application (((Integer, Integer), Constraints), Orders)
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



-- | Generate a constraint and a limit and offset 
getPagesWithDTD :: DTD -> Application ((Integer, Integer), Constraints)
getPagesWithDTD d = do 
        xs <- getJson 
        let b = S.lookupDefault (DB.SqlInteger 100) "limit" xs
        let o = S.lookupDefault (DB.SqlInteger 0) "offset" xs 
        return ((DB.fromSql b, DB.fromSql o),(dtd d $ convert xs ))



-- | Add a role to a user id 
addRole i k =  with nde $ do 
                    D.insert k i


-- | write an json error 
writeError' :: ToJSON a => a -> Application ()
writeError' x = writeAeson' $ S.fromList [("error" :: String, x)]


-- | Write an error to the client
writeAeson' :: ToJSON a => a -> Application ()
writeAeson' = writeLBS . Data.Aeson.encode



-- | Throws an internal error code 500
internalError :: String -> Application a 
internalError x = modifyResponse (setResponseCode 500) *> (CIO.throw $ UserErrorE (B.pack x))


-- | Run a composemonad in the SqlTransaction monad 
runCompose m = do
            l <- getLock 
            with db $ withConnection $ \c -> do 
                frp <- runComposeMonad l m error c
                frp `seq` return frp 

-- | Do an SqlTransaction action with a non blocking lock 
withLockBlock n a m =  do 
            l <- getLock 
            with slock $ do
                L.withLockBlock l n a m 

-- | Do a SqlTransaction with a blocking lock 
withLockNonBlock n a m = do  
            l <- getLock 
            with slock $ do
                L.withLockNonBlock l n a m  
-- | Retrieve the lock manager
getLock :: Application L.Lock 
getLock = with slock $ L.getLock  
