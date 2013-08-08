{-# LANGUAGE OverloadedStrings, FlexibleContexts, FlexibleInstances, MonomorphismRestriction, ScopedTypeVariables, TemplateHaskell #-}
module RoleSnaplet ( 
    may,
    addRole,
    withRoleState,
    R.dumpAll,
    R.Role(..),
    R.RestRight(..),
    R.Resource,
    dropRoles,
    getRoles,
    R.Id(..),
    RoleSnaplet(..),
    HasRoleSnaplet(..),
    initRoleSnaplet

) where 

import Control.Monad
import Control.Applicative
import Control.Monad.State

import Data.Maybe
import Data.Word


import Snap.Core
import Snap.Snaplet
import Control.Lens 
import qualified Data.ByteString as B
import qualified Data.ByteString.Char8 as C
import Config.ConfigFileParser

import Control.Concurrent
import qualified Data.Role as R 
import qualified Data.Text as T 

import Control.Monad.STM
import Control.Concurrent.STM

import qualified Crypto.Hash.Tiger as H

import NodeSnapletTest 
import RandomSnaplet 
import LogSnaplet 

data RoleSnaplet = RoleSnaplet {
        runRS :: R.RolePair B.ByteString,
        _random :: Snaplet (RandomConfig),
        _dht :: Snaplet (DHTConfig), 
        _log_cycler :: Snaplet Cycle 


    }

makeLenses ''RoleSnaplet

class HasRoleSnaplet b where 
    roleLens :: SnapletLens (Snaplet b) (Snaplet RoleSnaplet)


may rs rr = do 
    ct <- getCookie "user_token"
    at <- getCookie "application_token"
    st <- getCookie "server_token" 
    ct' <- getParam "user_token"
    at' <- getParam "application_token"
    st' <- getParam "server_token"
    with log_cycler $ logCycle "role_snaplet" "may"
    xs <- gets runRS
    let ls = cookieValue <$> catMaybes [ct, at,st]
    let ls' = catMaybes [ct', at',st']
    ts <- foldM (getRoles xs) [R.All] (ls ++ ls')
    b <- foldM (getPerms xs rr rs) False ts 
    return b
 where getRoles xs zs x = do 
            z <- getRoles' x 
            return (z ++ zs)
       getPerms xs rr rs zs x = do 
            b <- R.may xs rs x rr 
            return (b || zs)

getRoles k = do 
    ct <- fmap cookieValue <$> getCookie k
    with log_cycler $ logCycle "role_snaplet" "getRoles"
    ct' <- getParam k 
    case (ct' <|> ct) of 
        Nothing -> return []
        Just x -> getRoles' x

dropRoles :: (MonadState RoleSnaplet m, MonadSnap m) => C.ByteString -> m ()
dropRoles s = error "not implemented" 

-- addRole :: (MonadState RoleSnaplet m, MonadSnap m) => C.ByteString -> R.Role -> m () 
addRole s r = do 
    xs <- gets runRS 
    h <- with random $  getUniqueKey 

    with log_cycler $ logCycle "role_snaplet" "addRole"
    let ck = Cookie s h Nothing Nothing (Just "/") False False
    with dht $ insertBinary h r
    modifyResponse . addResponseCookie $ ck 
    modifyRequest $ \r -> r { rqCookies = ck : rqCookies r }
    writeBS $ "{\"result\":\"" `C.append` h `C.append` "\"}"
    return () 

withRoleState :: (MonadState RoleSnaplet m) => (R.RolePair B.ByteString -> m a)  -> m a
withRoleState f = f =<< gets runRS


initRoleSnaplet a s p = makeSnaplet "RoleSnaplet" "User/Application role manager" Nothing $ do 
  rso <- R.initRP "resources/roleSet.cfg" 
--   a' <- nestSnaplet "rnd" random $ a 
--   b <- nestSnaplet "nodesnaplet" dht $ s 
  return (RoleSnaplet rso a s p)



getRoles' k = do 
        (x :: Maybe R.Role) <- with dht $ lookupBinary k   
        case x  of 
            Nothing -> return []
            Just a -> return [a]

