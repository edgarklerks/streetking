{-# LANGUAGE TemplateHaskell #-}

------------------------------------------------------------------------------
-- | This module defines our application's state type and an alias for its
-- handler monad.
module Application where

------------------------------------------------------------------------------
import Data.Lens.Template
import Snap.Snaplet
import NodeSnaplet 
import ProxySnaplet  
import RandomSnaplet 
import SqlTransactionSnaplet
import RoleSnaplet 

------------------------------------------------------------------------------
data App = App
    { 
      _proxy :: Snaplet (ProxySnaplet)
    , _node :: Snaplet (DHTConfig)
    , _sql :: Snaplet (SqlTransactionConfig)
    , _rnd :: Snaplet (RandomConfig)
    , _roles :: Snaplet (RoleSnaplet)
    }

makeLens ''App

instance HasProxy App where 
    proxyLens = subSnaplet proxy 

instance HasDHT App where 
    dhtLens = subSnaplet node 

instance HasSqlTransaction App where 
    sqlLens = subSnaplet sql 

instance HasRandom App where 
    randomLens = subSnaplet rnd 
    
instance HasRoleSnaplet App where 
    roleLens = subSnaplet roles 

------------------------------------------------------------------------------
type AppHandler = Handler App App

type Application = AppHandler
