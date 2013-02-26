{-# LANGUAGE GeneralizedNewtypeDeriving, ViewPatterns #-}
module MemServerTest where 

import Control.Applicative
import Control.Monad
import Control.Monad.Reader 
import Control.Monad.Trans
import System.ZMQ3 
import Data.MemTimeState 
import Control.Concurrent
import Control.Concurrent.STM 
import qualified Data.Serialize as S 
import GHC.Exception
import qualified Control.Monad.CatchIO as CIO 
import Data.Maybe 

import ProtoExtended  

import qualified Data.HashMap.Strict as H 

data RequestConfig = PC {
            pc_context :: Context,
            pc_memstate :: QueryChan,
            pc_request :: RequestSocket,
            pc_upstream_map :: UpstreamMap,
            pc_request_answer_chan :: TQueue (NodeAddr, Proto)
    }

data IncomingConfig = IC {
            ic_context :: Context,
            ic_incoming :: Incoming,
            ic_request_answer_chan :: TQueue (NodeAddr, Proto) 
    }

data UpdateConfig = UC {
                  uc_context :: Context,
                  uc_updates_map :: UpdatesMap, 
                  uc_incoming :: Incoming,
                  uc_request_answer_chan :: TQueue (NodeAddr, Proto)
                  }

type UpdatesMap = TVar (H.HashMap NodeAddr UpdatesSocket) 

type UpdatesSocket = Socket Push 
type Incoming = Socket Pull  


type UpstreamMap = TVar (H.HashMap NodeAddr UpstreamSocket)
type RequestSocket = Socket Rep  
type UpstreamSocket = Socket Req


type RequestMonad = ProtoMonad RequestConfig 
type UpdateMonad = ProtoMonad UpdateConfig
type IncomingMonad = ProtoMonad IncomingConfig

newtype ProtoMonad c a = ProtoMonad {
                     unProtoMonad :: ReaderT c IO a 
            } deriving (Functor,Applicative,Monad,MonadReader c, MonadPlus, MonadIO, Alternative, CIO.MonadCatchIO)

{- This is an orphan instance, can poison future code, instances can travel
- between modules and cannot be excluded -}

instance Alternative IO where 
        (<|>) = mplus 
        empty = mzero

{-| Request engine,
-   accepts incoming requests and processes them
|-} 

requestEngine :: RequestMonad ()
requestEngine = do
            rq <- asks pc_request 

            forever $ do 
                s <- receiveProto rq 
                casePayload 
                            (const $ return ()) -- results are not handled here 
                            (handleQuery rq) -- query handling
                            handleCommand s -- command handling 

{-- Non blocking operations --}
handleQuery :: RequestSocket -> Proto -> RequestMonad ()
handleQuery s p =  
                 let (Just rt) = headRoute p
                     (Just query) = getQuery p
                     (maybe 0 id -> ttl) = getTTL p 
                 in case query of 
                        Query b -> do
                                n <- runMemQuery (Query b)
                                case n of 
                                    NotFound -> do 
                                            case ttl of 
                                                0 -> return ()
                                                -- cannot be found here
                                                _ -> sendUpstream (predTTL p)
                                    b -> case tailRoute p of 
                                            -- oh well we have the last bit 
                                            Nothing -> sendAnswer rt (result b)
                                            -- begin the route back 
                                            Just r -> sendAnswer rt (addRoutes r $ result b)
                                sendProto s (result Empty)

                        x -> runMemQuery x *> sendProto s (result Empty) 

sendAnswer :: NodeAddr -> Proto -> RequestMonad ()
sendAnswer xs p = asks pc_request_answer_chan >>= \c -> liftSTM (writeTQueue c (xs,p))


liftSTM :: STM a -> ProtoMonad c a 
liftSTM = liftIO . atomically 

{-- Blocking operations --}

handleCommand :: Proto -> RequestMonad ()
handleCommand p =  case (fromJust . getCommand $ p) of 
                    Sync -> undefined 
                    NodeList xs -> undefined 
                    StartSync -> undefined 
                    DumpInfo -> undefined 
                    Advertisement n -> undefined 


{-| Update engine,
-   accepts a local update and processes them 
|-}
-- receives update 
-- store into own node
-- send futher 
updateEngine :: UpdateMonad ()
updateEngine = do
                s <- asks uc_request_answer_chan  
                forever $ do 
                   p <- liftSTM $ readTQueue s
                   return ()
{-- Incoming engine,
-   accepts a remote update and processes them 
--}
incomingEngine :: IncomingMonad ()
incomingEngine = do
                s <- asks ic_request_answer_chan 
                sp <- asks ic_incoming 
                forever $ do 
                    rp <- receiveProto sp 
                    case headRoute rp of 
                            Nothing -> fail "incoming message without route"
                            Just rt -> liftSTM $ writeTQueue s (rt, fromJust $ tailRoute rp)


                    
{-| Some tools |-}
receiveProto :: (MonadIO m, Receiver a) => Socket a -> m Proto   
receiveProto s  = do 
                    x <- liftIO $ receive s 
                    case S.decode x of 
                            Left s -> fail $ "problem decoding" ++ s
                            Right a -> return a


sendProto :: (MonadIO m, Sender a) => Socket a -> Proto -> m ()
sendProto s p = liftIO $ send s [] (S.encode p) 


runMemQuery :: Query -> RequestMonad Result 
runMemQuery t@(Query a) = do 
                    ms <- asks pc_memstate 
                    n <- liftIO $ runQuery ms t
                    case n of 
                        NotFound -> return NotFound 
                        Value v -> return (KeyVal a v)
runMemQuery q = asks pc_memstate >>= liftIO . flip runQuery q

sendUpstream :: Proto -> RequestMonad ()
sendUpstream = undefined 

