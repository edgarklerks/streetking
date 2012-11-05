{-# LANGUAGE TemplateHaskell #-}

------------------------------------------------------------------------------
-- | This module defines our application's state type and an alias for its
-- handler monad.
module Application where

------------------------------------------------------------------------------
import Data.Lens.Template
import Snap.Snaplet
import Snap.Snaplet.Heist
import Snap.Snaplet.Auth
import Snap.Snaplet.Session
import ConfigSnaplet
import SqlTransactionSnaplet hiding (runDb)
import qualified SqlTransactionSnaplet as ST 
import ImageSnapLet
import Control.Monad.State  


------------------------------------------------------------------------------
data App = App
    { _heist :: Snaplet (Heist App)
    , _config :: Snaplet ConfigSnaplet 
    , _sql :: Snaplet SqlTransactionConfig
    , _img :: Snaplet ImageConfig 
    }

makeLens ''App

runDb a = with sql $ ST.runDb error a


instance HasHeist App where
    heistLens = subSnaplet heist

instance HasConfig App where 
    configLens = subSnaplet config 

instance HasSqlTransaction App where 
    sqlLens = subSnaplet sql 

instance HasImageSnapLet App where 
    imageLens = subSnaplet img 


------------------------------------------------------------------------------
type AppHandler = Handler App App


