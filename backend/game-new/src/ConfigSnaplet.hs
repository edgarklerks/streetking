{-# LANGUAGE TemplateHaskell, OverloadedStrings, FlexibleContexts, FlexibleInstances #-}
module ConfigSnaplet (
    initConfig,
    lookupConfig,
    lookupVar,
    lookupVal,
    C.Config(..),
    C.Sections,
    C.Section,
    ConfigSnaplet(..),
    configDir,
    configData
    ) where 

import Control.Monad
import Control.Applicative
import Control.Monad.Trans
import Control.Monad.State 
import Snap.Snaplet
import Snap.Core 
import Control.Lens
import Data.Text
import qualified Config.ConfigFileParser as C

data ConfigSnaplet = ConfigSnaplet { 
       _configDir :: String,
       _configData :: C.Sections 
 } deriving Show 

makeLenses ''ConfigSnaplet


initConfig :: FilePath -> SnapletInit b ConfigSnaplet 
initConfig fp = makeSnaplet "Configuration" "configuration manager" Nothing $ do 
    c <- liftIO $ C.readConfig fp  
    return $ ConfigSnaplet fp c


lookupConfig :: MonadState ConfigSnaplet m => String -> m (Maybe [C.Config]) 
lookupConfig x = do 
        cf <- gets _configData
        return $ C.lookupConfig x cf

lookupVar k c = return $ C.lookupVar k c

lookupVal s c = do 
        cf <- gets _configData 
        return (C.lookupConfig s cf >>= C.lookupVar c)
