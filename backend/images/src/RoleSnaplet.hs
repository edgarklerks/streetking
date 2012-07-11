{-# LANGUAGE OverloadedStrings, FlexibleContexts, FlexibleInstances, NoMonomorphismRestriction, ScopedTypeVariables #-}
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
import Data.Lens.Common
import Data.Lens.Template
import qualified Data.ByteString as B
import qualified Data.ByteString.Char8 as C
import Config.ConfigFileParser

import Control.Concurrent
import qualified Data.Role as R 
import qualified Data.Text as T 

import Control.Monad.STM
import Control.Concurrent.STM

import System.Random
import qualified Crypto.Hash.Tiger as H

data RoleSnaplet = RoleSnaplet {
        runRS :: R.RolePair B.ByteString,
        seed :: TVar [Word8]
    }

class HasRoleSnaplet b where 
    roleLens :: Lens (Snaplet b) (Snaplet RoleSnaplet)

may :: (MonadState RoleSnaplet m, MonadSnap m) =>  R.Resource -> R.RestRight -> m Bool 
may rs rr = do 
    ct <- getCookie "user_token"
    at <- getCookie "application_token"
    ct' <- getParam "user_token"
    at' <- getParam "application_token"
    xs <- gets runRS
    let ls = cookieValue <$> catMaybes [at, ct]
    let ls' = catMaybes [at', ct']
    ts <- foldM (getRoles xs) [R.All] (ls ++ ls')
    b <- foldM (getPerms xs rr rs) False ts 
    return b
 where getRoles xs zs x = do 
            z <- R.getRoles xs x 
            return (z ++ zs)
       getPerms xs rr rs zs x = do 
            b <- R.may xs rs x rr 
            return (b || zs)

getRoles :: (MonadState RoleSnaplet m, MonadSnap m) => C.ByteString -> m [R.Role]      
getRoles k = do 
    xs <- gets runRS 
    ct <- fmap cookieValue <$> getCookie k
    ct' <- getParam k 
    case (ct' <|> ct) of 
        Nothing -> return []
        Just x -> R.getRoles xs x

dropRoles :: (MonadState RoleSnaplet m, MonadSnap m) => C.ByteString -> m ()
dropRoles s = do 
    xs <- gets runRS 
    ct <- fmap cookieValue <$> getCookie s 
    ct' <- getParam s 
    case (ct' <|> ct) of 
        Nothing -> return ()
        Just x -> R.dropRoles xs x *> return ()

addRole :: (MonadState RoleSnaplet m, MonadSnap m) => C.ByteString -> R.Role -> m () 
addRole s r = do 
    xs <- gets runRS 
    h <- getUniqueKey 
    let ck = Cookie s h Nothing Nothing (Just "/") False False
    R.addRole xs h r
    modifyResponse . addResponseCookie $ ck 
    modifyRequest $ \r -> r { rqCookies = ck : rqCookies r }
    writeBS $ "{\"result\"}\"" `C.append` h `C.append` "\"}\"}"
    return () 

withRoleState :: (MonadState RoleSnaplet m) => (R.RolePair B.ByteString -> m a)  -> m a
withRoleState f = f =<< gets runRS

getUniqueKey :: (MonadState RoleSnaplet m, MonadIO m) =>  m B.ByteString
getUniqueKey = do 
    s <- gets seed 
    liftIO $ atomically $ do 
        s' <- readTVar s
        writeTVar s (drop 64 s')
        return (H.hash $ B.pack (take 64 s'))

initRoleSnaplet = makeSnaplet "RoleSnaplet" "User/Application role manager" Nothing $ do 
  rso <- R.initRP "resources/roleSet.cfg" 
  liftIO $ R.runRestore rso (R.fileRestore "resources/dump")
  tc <- liftIO $ R.initCleanup rso (60 * 60 * 24 * 7)
  ts <- liftIO $ R.initStore rso (R.fileStore "resources/dump")
  std <- liftIO $ newStdGen >>=  newTVarIO . randoms 

  return (RoleSnaplet rso std)

 
