{-# LANGUAGE GeneralizedNewtypeDeriving, ViewPatterns, NamedFieldPuns, TypeSynonymInstances, FlexibleInstances #-}
module MemServerAsyncTest where 

import Control.Applicative
import Data.Monoid 
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
import System.IO 

import ProtoExtended  

import qualified Data.HashMap.Strict as H 
{-- CHANGES:
-
- Edgar: Forgot receiving shit when upstream sending.
-
---}


{-- This network is split up in three sections:
-   * RequestEngine 
-           -> handles new requests and handles them 
-                   -> if a answer is found send it to the updateEngine 
-                   -> if a answer is !found send it upstream
-   * UpdateEngine 
-           -> send found from the requestEngine answers back to the requester
-   * IncomingEngine 
-           -> handles incoming answers of other nodes, sends it to the
-              updateEngine
-
- RequestEngine -----> UpdateEngine <----------  IncomingEngine 
-       |                                               / \
-       | UpStream                                       |
-      \|/                                               |
- RequestEngine -----------------------------------------|
-}


{-- This is the base monad for all three engines --}

newtype ProtoMonad c a = ProtoMonad {
                     unProtoMonad :: ReaderT c IO a 
            } deriving (Functor,Applicative,Monad,MonadReader c, MonadPlus, MonadIO, Alternative, CIO.MonadCatchIO)

runProtoMonad :: c -> ProtoMonad c a -> IO a 
runProtoMonad c m = runReaderT (unProtoMonad m) c 
{- This is an orphan instance, can poison future code, instances can travel
- between modules and cannot be excluded -}

instance Alternative IO where 
        (<|>) = mplus 
        empty = mzero

{-| Request engine,
-   accepts incoming requests and processes them
|-} 

type RequestMonad = ProtoMonad RequestConfig 

startNode :: ConfigParameters -> IO (RequestConfig, IncomingConfig, UpdateConfig)
startNode (RP ppull preq pc_memstate debug) = do  
            tq <- newTQueueIO 
            log <- newTQueueIO 

            -- first construct request config 
            pc_context <- context 
            pc_request <- socket pc_context Rep 
            bind pc_request preq 
            pc_upstream_map <- newTVarIO mempty
            let pc_config = PC {
                    pc_context,
                    pc_request,
                    pc_memstate,
                    pc_upstream_map,
                    pc_request_answer_chan = tq,
                    pc_address = Addr preq,
                    pc_incoming = Addr ppull,
                    pc_debug = debug,
                    pc_log = log 
                }

            -- construct update config 
            uc_context <- context 
            uc_updates_map <- newTVarIO mempty 
            let uc_config = UC {
                    uc_context,
                    uc_updates_map,
                    uc_request_answer_chan = tq,
                    uc_debug = debug,
                    uc_log = log 
                }
            -- construct incoming context 
            ic_context <- context 
            ic_incoming <- socket ic_context Pull
            bind ic_incoming ppull  

            let ic_config = IC {
                    ic_context,
                    ic_incoming,
                    ic_request_answer_chan = tq,
                    ic_debug = debug,
                    ic_log = log
                    }
            forkIO $ withFile "p2p.log" AppendMode $ \x ->  forever $ do
                    s <- atomically $ readTQueue log 
                    hPutStrLn x s 

            forkIO $ runProtoMonad ic_config incomingEngine
            forkIO $ runProtoMonad uc_config updateEngine
            forkIO $ runProtoMonad pc_config requestEngine
            return (pc_config, ic_config, uc_config) 



data ConfigParameters = RP {
            -- receive incoming answers
            param_pull :: String,
            -- receive incoming request  
            param_req :: String,
            -- query chan 
            param_qc :: QueryChan,
            debug :: Bool  

        }



data RequestConfig = PC {
            pc_context :: Context,
            pc_memstate :: QueryChan,
            pc_request :: RequestSocket,
            pc_upstream_map :: UpstreamMap,
            pc_request_answer_chan :: TQueue (NodeAddr, Proto),
            pc_address :: NodeAddr,
            pc_incoming :: NodeAddr,
            pc_debug :: Bool,
            pc_log :: TQueue String 
    }

type UpstreamMap = TVar (H.HashMap NodeAddr UpstreamSocket)
type RequestSocket = Socket Rep  
type UpstreamSocket = Socket Req


requestEngine :: RequestMonad ()
requestEngine = do
            rq <- asks pc_request 
            printDebug "first request cycle"
            forever $ do 
                printDebug "receiveProto start"
                s <- receiveProto rq 
                printDebug "receiveProto finished"
                -- a request is a query or a command 
                casePayload 
                            (const $ return ()) -- results are not handled here 
                            (handleQuery rq) -- query handling
                            (handleCommand rq)  -- command handling 
                            s
                printDebug "sanding shit"
                printDebug "handle payload"

{-- Non blocking operations --}
handleQuery :: RequestSocket -> Proto -> RequestMonad ()
handleQuery s p =  
                 let (Just rt) = headRoute p
                     (Just query) = getQuery p
                     (maybe 0 id -> ttl) = getTTL p 
                 in case query of 
                        Query b -> do
                                sendProto s (result Empty)
                                printDebug "got query"
                                printDebug b  
                                n <- runMemQuery (Query b)
                                case n of 
                                    NotFound -> do 
                                            printDebug "query not found"
                                            case ttl of 
                                                0 -> printDebug "ttl dead" *> return ()
                                                -- cannot be found here
                                                -- send upstream and 
                                                -- check if we are circular
                                                _ -> printDebug "toNodes" *> toNodes p
                                    b -> case tailRoute p of 
                                            -- oh well we have the last bit 
                                            Nothing -> printDebug "end route, send last result" *> sendAnswer rt (result b)
                                            -- begin the route back 
                                            Just r -> printDebug "next routes , add to results" *> sendAnswer rt (addRoutes r $ result b)
                        x -> sendProto s (result Empty) *> void (runMemQuery x)
sendAnswer :: NodeAddr -> Proto -> RequestMonad ()
sendAnswer xs p = asks pc_request_answer_chan >>= \c -> liftSTM (writeTQueue c (xs,p))




handleCommand :: Sender a => Socket a -> Proto -> RequestMonad ()
handleCommand s p =  case (fromJust . getCommand $ p) of 
                    Sync -> H.keys <$> asksTVar pc_upstream_map >>= sendProto s . nodeList 
                    DumpInfo -> H.keys <$> asksTVar pc_upstream_map >>= sendProto s . nodeList 
                    NodeList xs -> forM_ xs connectToNode *> sendProto s (result Empty) 
                    StartSync -> sendUpstream sync *> sendProto s (result Empty) 
                    Advertisement n -> connectToNode n *> sendProto s (result Empty) 

connectToNode :: NodeAddr -> RequestMonad ()
connectToNode t@(Addr n) = do 
                        ps <- asksTVar pc_upstream_map 
                        slef <- asks pc_address
                        unless (H.member t ps || slef == Addr n) $ do 
                            c <- asks pc_context
                            s <- liftIO $ socket c Req 
                            liftIO $ connect s n 
                            modifysTVar pc_upstream_map $ H.insert t s 



runMemQuery :: Query -> RequestMonad Result 
runMemQuery t@(Query a) = do 
                    ms <- asks pc_memstate 
                    n <- liftIO $ runQuery ms t
                    case n of 
                        NotFound -> return NotFound 
                        Value v -> return (KeyVal a v)
runMemQuery q = asks pc_memstate >>= liftIO . flip runQuery q

toNodes :: Proto -> RequestMonad ()
toNodes pr = do 
        rt <- asks pc_incoming 
        unless (rt `inRoute` pr) $ sendUpstream pr 

sendUpstream :: Proto -> RequestMonad ()
sendUpstream p = do 
            pum <- asksTVar pc_upstream_map
            -- add our incoming route  
            rt <- asks pc_incoming
            let p' = addRoute rt $ predTTL p 
            let xs = H.elems pum 
            forM_ xs $ \x -> sendProto x p' *> receiveProto x  

 

{-| Update engine,
-   accepts a local update and processes them 
|-}
-- receives update 
-- store into own node
-- send futher 

type UpdateMonad = ProtoMonad UpdateConfig

data UpdateConfig = UC {
                  uc_context :: Context,
                  uc_updates_map :: UpdatesMap, 
                  uc_request_answer_chan :: TQueue (NodeAddr, Proto),
                  uc_debug :: Bool,
                  uc_log :: TQueue String 
                  }

type UpdatesMap = TVar (H.HashMap NodeAddr UpdatesSocket) 
type UpdatesSocket = Socket Push 

updateEngine :: UpdateMonad ()
updateEngine = do
                s <- asks uc_request_answer_chan  
                forever $ do 
                   p <- liftSTM $ readTQueue s                    
                   uncurry toClient p 
{--
ue
requestEngine  \_______/___ ue 
 incomingEngine /      \
                        \ ue 
--}
--
toClient :: NodeAddr -> Proto -> UpdateMonad ()
toClient (Local _) pr = undefined 
toClient t@(Addr na) pr = do 
        uu <- asksTVar uc_updates_map 
        -- find node or add node to UpdateMap  
        s <- maybe (do
                p <- asks uc_context 
                s <- liftIO $ socket p Push 
                liftIO $ connect s na 
                modifysTVar uc_updates_map $ H.insert t s 
                return s 
              ) return 
              (H.lookup t uu)
        sendProto s pr 



{-- Incoming engine,
-   accepts a remote update and processes them 
--}
--
data IncomingConfig = IC {
            ic_context :: Context,
            ic_incoming :: Incoming,
            ic_request_answer_chan :: TQueue (NodeAddr, Proto),
            ic_debug :: Bool,
            ic_log :: TQueue String 
    }

type Incoming = Socket Pull  

type IncomingMonad = ProtoMonad IncomingConfig

incomingEngine :: IncomingMonad ()
incomingEngine = do
                s <- asks ic_request_answer_chan 
                sp <- asks ic_incoming 
                forever $ do 
                    rp <- CIO.try (receiveProto sp)
                    case rp of 
                        Left (SomeException e) -> printDebug ("error " ++ (show e))
                        Right rp -> case headRoute rp of 
                                        Nothing -> fail "incomingEngine: incoming message without route"
                                        Just rt -> liftSTM $ writeTQueue s (rt, fromJust $ tailRoute rp)

{-| Some tools |-}
receiveProto :: (MonadIO m, Receiver a, PrintDebug m) => Socket a -> m Proto   
receiveProto s  = do 
                    printDebug "receiveProto"
                    x <- liftIO $ receive s 
                    printDebug $ " received ->" ++ (show x)
                    case S.decode x of 
                            Left s -> fail $ "receiveProto: " ++ s
                            Right a -> return a


sendProto :: (PrintDebug m, MonadIO m, Sender a) => Socket a -> Proto -> m ()
sendProto s p = do 
    printDebug "send proto"
    printDebug p 
    p <- liftIO $ CIO.try (send s [] (S.encode p))
    case p of 
        Left (SomeException e) -> printDebug ("sendProto:  " ++ show e)
        Right _ -> printDebug "end send proto"


asksTVar :: (c -> TVar a) -> ProtoMonad c a
asksTVar f = asks f >>= \x -> liftSTM (readTVar x)

modifysTVar :: (c -> TVar a) -> (a -> a) -> ProtoMonad c ()
modifysTVar f g = asks f >>= \x -> liftSTM (modifyTVar x g)

liftSTM :: STM a -> ProtoMonad c a 
liftSTM = liftIO . atomically 


queryNode :: QueryChan -> Socket Pull -> Socket Req -> String -> Proto -> IO Proto 
queryNode pc p r n req = 
        case getQuery req of
            Nothing -> client' p r n req 
            Just t@(Query a) -> do 
                s <- runQuery pc t
                case s of 
                  NotFound -> client' p r n req      
                  Value v -> return $ result (KeyVal a v)
            Just a -> void $ client' p r n req *> return (result Empty)



get_ic_config (a,b,c) = b 
get_pc_config (a,b,c) = a 
get_uc_config (a,b,c) = c 


client' :: Socket Pull -> Socket Req -> String -> Proto -> IO Proto 
client' dta req n pr = do 
        sendProto req (addRoute (Addr n) $ pr)
        s <- newEmptyMVar
        x <- receiveProto req 
        l <- forkIO $ do
            t <- receiveProto dta
            putMVar s t  
        n <- tryTakeMVarT 1000 s
        return n 

tryTakeMVarT  ::  Int -> MVar Proto -> IO Proto 
tryTakeMVarT 0 _ = return (result Empty)
tryTakeMVarT n m = do 
            c <- tryTakeMVar m 
            case c of 
                Nothing -> threadDelay 1000 *> tryTakeMVarT (n - 1) m
                Just a -> return a


class PrintDebug m where 
        printDebug :: Show a => a  -> m ()

instance PrintDebug (RequestMonad) where 
        printDebug s = do 
                t <- asks pc_debug 
                when t $ do 
                    x <- asks pc_log 
                    liftSTM $ writeTQueue x ("requestMonad: " ++ (show s))  


instance PrintDebug (UpdateMonad) where 
        printDebug s = do 
                t <- asks uc_debug 
                when t $ do 
                    x <- asks uc_log 
                    liftSTM $ writeTQueue x ("updateMonad: " ++ (show $ s)) 

instance PrintDebug IncomingMonad where 
        printDebug s = do 
                t <- asks ic_debug 
                when t $ do 
                    x <- asks ic_log 
                    liftSTM $ writeTQueue x  ("incomingMonad: " ++ (show s))


instance PrintDebug IO where 
    printDebug s = return () --  putStrLn ("IO: " ++ (show s))
    

clientCommand :: String -> String -> Proto -> IO ()
clientCommand n1 n2 p = withContext  $ \c -> 
         withSocket c Req $ \r -> 
         withSocket c Pull $ \d -> 
            do 
                ds <- bind d n1 
                connect r n2 
                sendProto r p
                x <- receiveProto r
                print x

