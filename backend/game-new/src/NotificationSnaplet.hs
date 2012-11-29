{-# LANGUAGE TemplateHaskell, OverloadedStrings, FlexibleContexts, FlexibleInstances, DeriveDataTypeable, NoMonomorphismRestriction #-}
module NotificationSnaplet ( 
        sendLetter, 
        checkMailBox,
        setArchive, 
        setRead,
        initNotificationSnaplet,
        NotificationConfig,
        NotificationError(..),
        getPostOffice,
        _po 
    ) where 

import qualified Data.Notifications as N  
import Control.Monad
import Control.Applicative 
import Data.SqlTransaction 
import qualified SqlTransactionSnaplet as S 
import Snap.Core 
import Snap.Snaplet 
import Data.Lens.Common
import Data.Lens.Template 
import Control.Concurrent 
import Config.ConfigFileParser
import qualified Data.ByteString.Char8 as B 
import qualified Control.Monad.CatchIO as CIO 
import Data.Typeable 
import Control.Monad.Trans 
import Control.Monad.State 

data NotificationError = NE B.ByteString 
            deriving (Typeable, Show)

instance CIO.Exception NotificationError 

data NotificationConfig = NC {
        _sql :: Snaplet (S.SqlTransactionConfig),
        _po :: N.PostOffice 
    }
$(makeLenses [''NotificationConfig])

getPostOffice = gets _po 

class HasNotifications b where 
    notificationLens :: Lens (Snaplet b) (Snaplet NotificationConfig) 

instance S.HasSqlTransaction NotificationConfig where 
        sqlLens = subSnaplet sql 

runDb xs = do
        with sql $ S.runDb (error "no lock in notification system") internalError xs 
sendLetter uid letter = do 
                        po <- gets _po 
                        runDb $ N.sendLetter po uid letter 

openPostOffice = liftIO $ N.openPostOffice 

internalError x = modifyResponse (setResponseCode 500) *> (CIO.throw $ NE (B.pack x))

checkMailBox uid = do 
                po <- gets _po      
                runDb $ N.checkMailBox po uid 


initNotificationSnaplet s x = makeSnaplet "NotificationSnaplet" 
                                        "notification manager" Nothing $ do 
                                                    po <- openPostOffice 
                                                    liftIO $ forkIO $ forever $ N.goin'Postal po >> threadDelay 10000000 
                                                    case x of 
                                                        Just a -> liftIO $ putMVar a po 
                                                        Nothing -> return ()
                                                    return (NC s po)


setRead  uid id = do 
        po <- gets _po
        runDb $ N.setRead po uid id 


setArchive uid id = do 
        po <- gets _po 
        runDb $ N.setArchive po uid id 


