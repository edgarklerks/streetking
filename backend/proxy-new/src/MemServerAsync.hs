{-# LANGUAGE DeriveDataTypeable, GeneralizedNewtypeDeriving, RankNTypes,StandaloneDeriving, MultiParamTypeClasses, TypeSynonymInstances, ViewPatterns, LiberalTypeSynonyms, FunctionalDependencies, FlexibleContexts, FlexibleInstances, ExistentialQuantification, RankNTypes #-}
module MemServerAsync where 

import Data.MemTimeState 
import System.ZMQ3 hiding (version, context)

import Control.Monad
import Control.Applicative
import qualified Data.HashMap.Strict as H 
import qualified Data.Serialize as S 
import Data.Word 

import Control.Monad.CC 
import Control.Monad.Reader 
import Control.Monad.Trans 

import qualified Control.Monad.CatchIO as CIO 

import Control.Concurrent 
import Control.Concurrent.STM 
import Control.Arrow 

import qualified Data.ByteString as B 
import qualified Data.ByteString.Char8 as C

import Data.List ((\\)) 
import Data.DVars

import Data.Typeable 
import GHC.Exception (SomeException)
import Proto 
import Data.Maybe 
import Unsafe.Coerce 
import Control.Monad.Error 
import Data.IORef 
import qualified Data.ExternalLog as E

data ProtoConfig = PC {
        version :: Int,
        self :: NodeAddr,
        selfPull :: NodeAddr, 
        incoming :: Incoming,
        outgoing :: TVar (H.HashMap NodeAddr Outgoing),
        memstate :: QueryChan, 
        context :: Context,
        updates :: Update, 
        answers :: TVar (H.HashMap NodeAddr Answer),
        outgoingchannel :: OutgoingChannel,
        cycler :: E.Cycle,
--         listeners :: TVar (H.HashMap B.ByteString NodeAddr)
        inDebug :: Bool 
    }

type OutgoingChannel = TQueue Proto
type Outgoing = Socket Req 
type Answer = Socket Push 
type Update = Socket Pull 
type Incoming = Socket Rep

logCycleProto :: String -> String -> ProtoMonad p ()
logCycleProto n m = asks cycler >>= \x -> liftIO (E.reportCycle x n m)

-- | Handles outgoing requests to other nodes 
outgoingManager :: ProtoMonad p ()
outgoingManager = void  $ forkProto $ do 
                sl <- asks selfPull 
                forever $ do 
                    logCycleProto "p2p" "outgoingManager"
                    ps <- takesDVar outgoingchannel
                    -- prevent circular packets 
                    unless (sl `inRoute` ps) $ toNodes (addRoute sl ps)


handleRequest :: (forall p. ProtoMonad p ())
handleRequest = do 
            inc <- asks incoming 
            forever $ do 
                logCycleProto "p2p" "handleRequest"
                x <- receiveProto inc
                logCycleProto "p2p" "handleRequest-proto"
                casePayload (\x -> sendProto inc (result $ Empty))  (handleQuery inc) (handleCommand inc) x 

handleUpdates :: ProtoMonad p ()
handleUpdates = do 
        upd <- asks updates 
        forever $ 
            logCycleProto "p2p" "handleUpdates" >>
            receiveProto upd >>= handleResult

handleCommand :: Sender a => Socket a -> Proto -> ProtoMonad p ()
handleCommand s (fromJust . getCommand -> p) = do 
            logCycleProto "p2p" "handleCommand"
            case p of 
               Sync -> do 
                          H.keys <$> readsDVar outgoing  >>= \xs -> liftIO (print xs) *> (sendProto s . nodeList) xs
               NodeList xs -> forM_ xs connectToNode *> sendProto s (result Empty)
               StartSync -> sendUpstream sync *> sendProto s (result Empty) 
               DumpInfo -> do 
                        ps <- H.keys <$> readsDVar outgoing 
                        ns <- H.keys <$> readsDVar answers  
                        sendProto s . result . Value . C.pack . show $ (ps,ns)
               Advertisement n -> connectToNode n *> sendProto s ( result Empty)

debug :: Show a => a  -> ProtoMonad p ()
debug p = do 
    s <- asks inDebug         
    when s $ (liftIO . print) p

connectToNode :: NodeAddr -> ProtoMonad p ()
connectToNode ad = do 
            ps <- readsDVar outgoing 
            logCycleProto "p2p" "connectToNode"
            unless (H.member ad ps) $ do 
                        s <- newConnectedSocket Req ad 
                        modifysDVar outgoing (H.insert ad s)




sendUpstream :: Proto -> ProtoMonad p ()
sendUpstream  = putsDVar outgoingchannel


handleQuery :: Sender a => Socket a -> Proto -> ProtoMonad p () 
handleQuery s p = do 
            let (Just rt) = headRoute p 
            let (Just query) = getQuery p 
            case query of 
               Query b -> do 
                    n <- runMemQuery (Query b)
                    case n of 
                        NotFound -> do 
                                case getTTL p of 
                                    Just 0 -> return ()
                                    Nothing -> return () 
                                    _ -> sendUpstream (predTTL p)
                        b -> case tailRoute p of 
                                Nothing -> sendAnswer rt (result b)
                                Just p -> sendAnswer rt (addRoutes p $ result b)
                    sendProto s (result Empty)

               x -> runMemQuery x >>= sendProto s . result 

runMemQuery :: Query -> ProtoMonad r Result 
runMemQuery (Query a) = do 
                ms <- asks memstate 
                n <- liftIO (runQuery ms (Query a))
                case n of 
                    NotFound -> return NotFound 
                    (Value v) -> return (KeyVal a v)
runMemQuery q = do 
                ms <- asks memstate
                liftIO $ runQuery ms q


sendAnswer :: NodeAddr -> Proto -> ProtoMonad p ()
sendAnswer a pr = do 
            ps <- readsDVar answers 
            case H.lookup a ps of 
                Just s -> forkTimeout 100000 $ sendProto s pr 
                Nothing -> do 
                    s <- newConnectedSocket Push a 
                    modifysDVar answers (H.insert a s)
                    forkTimeout 100000 $ sendProto s pr 

newConnectedSocket :: SocketType a => a -> NodeAddr -> ProtoMonad p (Socket a)
newConnectedSocket a addr = do 
                ctx <- asks context 
                s <- liftIO $ socket ctx a
                liftIO $ connect s addr 
                return s

newBindedSocket :: SocketType a => a -> NodeAddr -> ProtoMonad p (Socket a)
newBindedSocket a addr = do 
                ctx <- asks context 
                s <- liftIO $ socket ctx a 
                liftIO $ bind s addr 
                return s

handleResult ::  Proto -> ProtoMonad p ()
handleResult p = do 
                s <- asks self 
                case headRoute p of 
                        Nothing -> let (Just res) = getResult p 
                                   in case res of 
                                            KeyVal k v -> void $ runMemQuery (Insert k v)
                                            _ -> pure ()

                        Just rt -> let (Just res) = getResult p 
                                   in do case res of 
                                            KeyVal k v -> void $ runMemQuery (Insert k v) 
                                            _ -> pure  ()
                                         case tailRoute p of 
                                                Just l -> sendAnswer rt l
                                                Nothing -> pure ()





outgoingNodes :: ProtoMonad p [Outgoing]
outgoingNodes = H.elems <$> readsDVar outgoing 

toNodes :: Proto -> ProtoMonad p ()
toNodes p = do 
            xs <- outgoingNodes 
            forM_ xs $ \s -> do 
                    sendProto s p
                    receiveProto s 




sendProto :: (Sender a, MonadIO m) => Socket a -> Proto -> m ()
sendProto s = liftIO . send s [] . S.encode

receiveProto :: (MonadIO m, Receiver a) => Socket a -> m Proto   
receiveProto s  = do 
                    x <- liftIO $ receive s 
                    case S.decode x of 
                            Left s -> error $ "problem decoding" ++ s
                            Right a -> return a


addAnswers :: NodeAddr -> Answer -> ProtoMonad p ()
addAnswers n = modifysDVar answers . H.insert n

rankProto :: ProtoMonad p a -> (forall p. ProtoMonad p a)
rankProto = unsafeCoerce   


instance MonadError ProtoException (ProtoMonad p) where 
                throwError  = PM . lift . lift . ErrorT . return . Left 
                -- Potentially unsafe !! 
                catchError m f = do 
                            g <- ask
                            x <- liftIO $ runProtoMonad (rankProto m) g  
                            case x of 
                                Left a -> f a
                                Right a -> return a



catchProtoError :: (forall p. ProtoMonad p b) -> (ProtoException -> ProtoMonad p b) -> ProtoMonad p b
catchProtoError m f = do 
                        g <- ask
                        x <- liftIO $ runProtoMonad m g  
                        case x of 
                            Left a -> f a
                            Right a -> return a


newtype ProtoMonad p a = PM {
                unPM :: CCT p (ReaderT ProtoConfig (ErrorT ProtoException IO)) a 
            } deriving (Functor, Applicative, Monad, MonadDelimitedCont (Prompt p) (SubCont p (ReaderT ProtoConfig (ErrorT ProtoException IO))), MonadReader ProtoConfig, MonadIO) 


runProtoMonad :: (forall p. ProtoMonad p a) -> ProtoConfig -> IO (Either ProtoException a)
runProtoMonad m = runErrorT . runReaderT (runCCT (unPM m)) 

forkTimeout :: Int -> (forall p. ProtoMonad p ()) -> ProtoMonad p ()
forkTimeout n m = do 
                    s <- liftIO $ newMVar ()
                    x <- forkProto (m <* liftIO (takeMVar s))
                    forkProto $ liftIO $ do 
                        threadDelay n 
                        b <- isEmptyMVar s 
                        unless b $ do 
                                killThread x 
                                print "server Thread killed"
                    return ()

forkProto ::  (forall p. ProtoMonad p ()) -> ProtoMonad p ThreadId 
forkProto m = (liftIO . forkIO . void . runProtoMonad m) =<< ask 

newProtoConfig :: NodeAddr -> NodeAddr -> FilePath -> E.Cycle -> IO ProtoConfig 
newProtoConfig addrs addr fp ls = do 
                ctx <- System.ZMQ3.init 1
                is <- socket ctx Rep 
                bind is addrs
                ps <- newDVar H.empty 
                l <- newMemState ls (60 * 1000 * 1000 * 30) (6000 * 1000) fp  
                s <- newEmptyDVar  
                ans <- newDVar H.empty 
                pl <- socket ctx Pull 
                bind pl addr 
                forkIO $ queryManager fp l s  
                outc <- newEmptyDVar 
                return $ PC {
                            version = versionConst,
                            self = addrs,
                            selfPull = addr,
                            incoming = is,
                            outgoing = ps,
                            memstate = s,
                            context = ctx,
                            updates = pl,
                            answers = ans,
                            outgoingchannel = outc,
                            inDebug = True,
                            cycler = ls 
                        }


topError :: (forall p. ProtoMonad p a) -> ProtoMonad p a
topError m = catchProtoError m throwError


startNode :: E.Cycle -> NodeAddr -> NodeAddr -> FilePath  -> IO ProtoConfig  
startNode cl f g fp = let step = do 
                            forkProto handleRequest 
                            outgoingManager 
                            handleUpdates
                    in do 
                        c <- newProtoConfig f g fp cl
                        forkIO $ runProtoMonad step c *> pure ()
                        return c



checkVersion :: Int -> ProtoMonad p () 
checkVersion n = do 
            v <- asks version 
            when (v /= n) $ versionMismatch v n 

queryNode :: ProtoConfig -> Socket Pull -> Socket Req -> NodeAddr ->  Proto -> IO Proto 
queryNode pc p r n req = do 
            case getQuery req of 
                Nothing -> client' p r n req  
                Just t@(Query a) -> do 
                    s <- runQuery (memstate pc) t
                    case s of 
                        NotFound -> client' p r n req  
                        Value v -> return $ result (KeyVal a v)
                        KeyVal a v -> return $ result (KeyVal a v)
                        Empty -> client' p r n req  
                Just a -> forkIO (void $ client' p  r n req) *> return (result Empty)


client' :: Socket Pull -> Socket Req -> NodeAddr -> Proto -> IO Proto 
client' p r n req = do 
                sendProto r (addRoute n $ req) 
                x <- receiveProto r 
                s <- newEmptyMVar 
                l <- forkIO $ do 
                        t <- receiveProto p 
                        s =$ t 
                n <- waitOnResult l s 
                return n 


-- waitOnResult :: ThreadId -> MVar Proto -> IO Proto 
waitOnResult l m = runCCT $ reset $ \p -> do 
                                            forM_ [1..10] $ \x -> do 
                                                a <- liftIO $ isEmptyMVar m
                                                if a then liftIO $ do
                                                     when (x == 10) $ killThread l 
                                                     threadDelay 10000
                                                     return (result NotFound)
                                                 else do 
                                                    shift0 p $ \k ->  liftIO $ takeMVar m 
                                            liftIO $ killThread l 
                                            return (result NotFound)

                                        

clientCommand :: NodeAddr -> NodeAddr -> Proto -> IO ()
clientCommand n1 n2 p = withContext $ \c -> 
         withSocket c Req $ \r -> 
         withSocket c Pull $ \d -> 
            do 
                ds <- bind d n1 
                connect r n2 
                sendProto r p
                x <- receiveProto r
                print x 

silentCommand :: NodeAddr -> NodeAddr -> Proto -> IO ()
silentCommand n1 n2 p = withContext $ \c -> 
         withSocket c Req $ \r -> 
         withSocket c Pull $ \d -> 
            do 
                ds <- bind d n1 
                connect r n2 
                sendProto r p
                void $  receiveProto r




modifysDVar :: (MonadGetter m s, MonadIO m, ModifyDVar m f) => (s -> f b) -> (b -> b) -> m ()
modifysDVar f p = do 
                s <- getter f
                modifyDVar s p 

putsDVar :: (MonadGetter m s, MonadIO m, PutDVar m f) => (s -> f b) -> b -> m ()
putsDVar f p = do 
            s <- getter f 
            putDVar s p 

readsDVar :: (MonadGetter m s, MonadIO m, ReadDVar m f) => (s -> f b) -> m b
readsDVar f = getterM (readDVar . f) 

takesDVar :: (MonadGetter m s, MonadIO m, TakeDVar m f) => (s -> f b) -> m b
takesDVar f = getterM (takeDVar . f)

instance MonadGetter (ProtoMonad p) ProtoConfig where 
        getter = asks
