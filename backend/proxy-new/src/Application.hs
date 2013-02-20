{-# LANGUAGE TemplateHaskell #-}

------------------------------------------------------------------------------
-- | This module defines our application's state type and an alias for its
-- handler monad.
module Application where

------------------------------------------------------------------------------
import Control.Lens
import Snap.Snaplet
import NodeSnaplet 
import ProxyExtendableSnapletConduit 
import RandomSnaplet 
import SqlTransactionSnaplet
import RoleSnaplet 
import LogSnaplet 

------------------------------------------------------------------------------
data App = App
    { 
      _proxy :: Snaplet (ProxySnaplet)
    , _node :: Snaplet (DHTConfig)
    , _sql :: Snaplet (SqlTransactionConfig)
    , _rnd :: Snaplet (RandomConfig)
    , _roles :: Snaplet (RoleSnaplet)
    , _logcycle :: Snaplet (Cycle)
    }

makeLenses ''App


------------------------------------------------------------------------------
type AppHandler = Handler App App

type Application = AppHandler
