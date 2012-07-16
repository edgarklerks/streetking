{-# LANGUAGE DeriveDataTypeable, GeneralizedNewtypeDeriving, RankNTypes,StandaloneDeriving, MultiParamTypeClasses, TypeSynonymInstances, LiberalTypeSynonyms, FunctionalDependencies, FlexibleContexts, FlexibleInstances, ExistentialQuantification #-}
module MemServerAsync where 

import Data.MemState 
import System.ZMQ3 hiding (version)

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

import qualified Data.ByteString as B 
import qualified Data.ByteString.Char8 as C

import Data.List ((\\)) 

import Data.Typeable 
import GHC.Exception (SomeException)
import Proto 
import Data.Maybe 
import Unsafe.Coerce 
import Control.Monad.Error 

data ProtoConfig = PC {
        version :: Int,
        self :: NodeAddr,
        selfPull :: NodeAddr, 
        incoming :: Socket Rep,
        outgoing :: TVar (H.HashMap NodeAddr (Socket Req)),
        memstate :: QueryChan, 
        context :: Context,
        updates :: Socket Pull, 
        answers :: TVar (H.HashMap NodeAddr (Socket Push)),
        outgoingchannel :: OutgoingChannel 
    }

type OutgoingChannel = TChan (Proto)

outgoingManager :: ProtoMonad p ()
outgoingManager = void  $ forkProto $ do 
                g <- ask 
                sl <- asks selfPull 
                let p = outgoingchannel g 
                forever $ do 
                    p <- runSTM $ readTChan p 
                    let rq = addRoute sl p 
                    toNodes rq  


handleRequest :: (forall p. ProtoMonad p ())
handleRequest = do 
            inc <- asks incoming 
            forever $ do 
                x <- receiveProto inc
                liftIO $ print x
                casePayload (\x -> sendProto inc (result $ Empty))  (handleQuery inc) (handleCommand inc) x 
handleUpdates :: ProtoMonad p ()
handleUpdates = do 
        upd <- asks updates 
        forever $ do 
            x <- receiveProto upd 
            debug "in updates"
            debug "handle result"
            debug x
            handleResult  x 

handleCommand :: Sender a => Socket a -> Proto -> ProtoMonad p ()
handleCommand s p = do 
            liftIO $ print "Handle command"
            liftIO $ print (getCommand p) 
            case fromJust $ getCommand p of 
               Sync -> do 
                        lst <- asks outgoing
                        xs <- runSTM $ H.keys <$> readTVar lst 
                        sendProto s (nodeList xs)
               NodeList xs -> forM_ xs connectToNode *> sendProto s (result Empty)
               StartSync -> sendUpstream sync *> sendProto s (result Empty) 
               DumpInfo -> do 
                        os <- asks outgoing 
                        as <- asks answers 
                        ps <- runSTM $ H.keys <$> readTVar os  
                        ns <- runSTM $ H.keys <$> readTVar as 
                        sendProto s (result . Value $ C.pack $ show (ps,ns))


               Advertisement n -> do 
                    debug $ "Connecting to node " ++ n
                    connectToNode n 
                    debug  "Sending back result"
                    sendProto s (result Empty)
                    debug "next"

debug :: Show a => a  -> ProtoMonad p ()
debug = liftIO . print 
connectToNode :: NodeAddr -> ProtoMonad p ()
connectToNode ad = do 
            p <- asks outgoing 
            ps <- runSTM $ readTVar p 
            case H.lookup ad ps of 
                    Just a -> return ()
                    Nothing -> do 
                        ctx <- asks context 
                        s <- liftIO $ socket ctx Req 
                        liftIO $ connect s ad 
                        runSTM $ modifyTVar p (H.insert ad s)





            



sendUpstream :: Proto -> ProtoMonad p ()
sendUpstream p = do  
            s <- asks outgoingchannel
            runSTM $ writeTChan s p 


handleQuery :: Sender a => Socket a -> Proto -> ProtoMonad p () 
handleQuery s p = do 
            let (Just rt) = headRoute p 
            let (Just query) = getQuery p 
            debug (listRoute p)
            case query of 

               Insert k v -> do 
                        debug "running insert"
                        n <- runMemQuery (Insert k v)
                        sendProto s (result n)

               Query b -> do 
                    debug "running query"
                    n <- runMemQuery (Query b)
                    case n of 
                        NotFound -> do 
                                case getTTL p of 
                                    Just 0 -> debug "end of packet life" >> return ()
                                    Just _ -> sendUpstream (predTTL p)
                                    Nothing -> debug "package without ttl"
                        b -> case tailRoute p of 
                                Nothing -> do 
                                        debug b
                                              
                                        debug "Sending answer"
                                        debug rt
                                        sendAnswer rt (result b)
                                Just p -> do 
                                    debug b
                                    debug "Sending answer"
                                    debug rt
                                    sendAnswer rt (addRoutes p $ result b)
                    sendProto s (result Empty)

               Delete b -> do 
                        ms <- asks memstate 
                        n <- runMemQuery (Delete b) 
                        sendProto s (result n) 

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
            ptvar <- asks answers 
            ps <- runSTM $ readTVar ptvar 
            case H.lookup a ps of 
                Just s -> do 
                    debug "sendAnswer directly"
                    sendProto s pr 
                Nothing -> do 
                    ctx <- asks context
                    s <- liftIO $ socket ctx Push  
                    debug "connect and send answer"
                    debug $ "address" ++ a
                    liftIO $ connect s a 
                    runSTM $ modifyTVar ptvar (H.insert a s)
                    sendProto s pr 
                    debug "Send answer"


handleResult ::  Proto -> ProtoMonad p ()
handleResult p = do 
                s <- asks self 
                debug s 
                debug p 
                debug "in result"
                case headRoute p of 
                        Nothing -> let (Just res) = getResult p 
                                   in do case res of 
                                            NotFound -> return () 
                                            KeyVal k v -> runMemQuery (Insert k v) >> return ()
                                            Empty -> return ()

                        Just rt -> let (Just res) = getResult p 
                                   in do case res of 
                                            NotFound -> return ()
                                            KeyVal k v -> runMemQuery (Insert k v) >> return ()
                                            Empty -> return ()
                                         case tailRoute p of 
                                                Nothing -> return ()
                                                Just l -> sendAnswer rt l





outgoingNodes :: ProtoMonad p [Socket Req]
outgoingNodes = do 
            x <- asks outgoing 
            runSTM $ H.elems <$> readTVar x

toNodes :: Proto -> ProtoMonad p ()
toNodes p = do 
            xs <- outgoingNodes 
            forM_ xs $ \s -> do 
                    sendProto s p
                    receiveProto s 




sendProto :: (Sender a, MonadIO m) => Socket a -> Proto -> m ()
sendProto s p = liftIO $ send s [] (S.encode p) 

receiveProto :: (MonadIO m, Receiver a) => Socket a -> m Proto   
receiveProto s  = do 
                    x <- liftIO $ receive s 
                    case S.decode x of 
                            Left s -> error "problem decoding"
                            Right a -> return a


addAnswers :: NodeAddr -> Socket Push -> ProtoMonad p ()
addAnswers n sp = do 
                ts <- asks answers 
                runSTM $ modifyTVar ts (H.insert n sp)

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


runSTM :: STM a -> ProtoMonad r a 
runSTM = liftIO . atomically 

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

testProto :: ProtoMonad p () 
testProto = reset $ \p -> catchError (step p) (\x -> liftIO $ print x *> return ())
    where step p = do 
                liftIO $ print "forked"
                shift p $ \k -> k (return 10) 
                return ()

forkProto ::  (forall p. ProtoMonad p ()) -> ProtoMonad p ThreadId 
forkProto m = (liftIO . forkIO . void . runProtoMonad m) =<< ask 

newProtoConfig :: NodeAddr -> NodeAddr -> FilePath -> IO ProtoConfig 
newProtoConfig addrs addr fp = do 
                ctx <- System.ZMQ3.init 1
                is <- socket ctx Rep 
                bind is addrs
                ps <- newTVarIO H.empty 
                l <- newMemState fp 
                s <- newTChanIO 
                ans <- newTVarIO H.empty 
                pl <- socket ctx Pull 
                bind pl addr 
                forkIO $ queryManager fp l s  
                outc <- newTChanIO 
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
                            outgoingchannel = outc
                        }


topError :: (forall p. ProtoMonad p a) -> ProtoMonad p a
topError m = catchProtoError m throwError


checkVersion :: Int -> ProtoMonad p () 
checkVersion n = do 
            v <- asks version 
            when (v /= n) $ versionMismatch v n 


client :: NodeAddr -> NodeAddr -> Proto -> IO ()
client n1 n2 p = withContext 1 $ \c -> 
         withSocket c Req $ \r -> 
         withSocket c Pull $ \d -> 
            do 
                ds <- bind d n1 
                connect r n2 
                
                sendProto r (addRoute n1 $ p) 
                x <- receiveProto r
                print x
                y <- receiveProto d 
                print y
clientCommand :: NodeAddr -> NodeAddr -> Proto -> IO ()
clientCommand n1 n2 p = withContext 1 $ \c -> 
         withSocket c Req $ \r -> 
         withSocket c Pull $ \d -> 
            do 
                ds <- bind d n1 
                connect r n2 
                print "sending" 
                sendProto r p
                print "waiting"
                x <- receiveProto r
                print "received"
                print x
                


            
