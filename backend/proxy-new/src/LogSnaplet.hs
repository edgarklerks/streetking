{-# LANGUAGE TemplateHaskell, OverloadedStrings, FlexibleContexts, NoMonomorphismRestriction #-}
module LogSnaplet (
        initLogSnaplet,
        logCycle,
        E.Cycle 
    ) where 

import qualified Data.ExternalLog as E 
import Config.ConfigFileParser
import Control.Monad.Trans 
import Control.Monad.State 
import Snap.Core 
import Snap.Snaplet
import Control.Concurrent 
import Control.Concurrent.STM 
import System.IO 

initLogSnaplet fp = makeSnaplet "Cycle logger" "logs component cycles" Nothing $ do 
    xs <- liftIO $ readConfig fp 
    let (Just (StringC address)) = lookupConfig "CycleLogger" xs >>= lookupVar "address" 
    let (Just (StringC logfile)) = lookupConfig "CycleLogger" xs >>= lookupVar "address" 
    x <- liftIO $ E.initCycle address
    return x 


logCycle :: (MonadIO m, MonadState E.Cycle m) => String -> String -> m ()
logCycle x y = do 
    c <- get 
    liftIO $ E.reportCycle c x y 

                    

