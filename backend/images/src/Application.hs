{-# LANGUAGE TemplateHaskell #-}

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

makeLenses ''App

runDb a = with sql $ ST.runDb (error "no locking buildin") error a




------------------------------------------------------------------------------
type AppHandler = Handler App App


