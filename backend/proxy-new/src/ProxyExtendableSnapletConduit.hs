{-# LANGUAGE TemplateHaskell, OverloadedStrings, FlexibleContexts, FlexibleInstances, ViewPatterns, NoMonomorphismRestriction, RankNTypes, ScopedTypeVariables, ImplicitParams #-}
module ProxyExtendableSnapletConduit (
    initProxy,
    runProxy,
    ProxySnaplet
 ) where 

import           Control.Monad
import           Control.Applicative
import           Control.Monad.Trans
import           Control.Monad.State 
import           Data.Word 
import           Snap.Snaplet 
import           Snap.Core 
import           Data.Conduit
import           Control.Lens
import qualified Data.Text as T 
import qualified Data.ByteString as B
import qualified Data.ByteString.Char8 as C 
import           Data.Maybe
import           Control.Arrow
import qualified Data.Map as M 

import           Control.Concurrent 
import           Control.Monad.Fix 

import           Config.ConfigFileParser 
import           System.Random 
import           Data.Array.Base
import           Data.Array.MArray
import           System.IO.Unsafe
import qualified Network.HTTP.Conduit as CE
import           Data.Enumerator as E 
import qualified Data.Enumerator.List as L
import           Data.List (genericLength)
import           Data.Char 
import           Data.IORef 
import           Data.HeartBeat
import           Snap.Internal.Http.Types as S
import           Blaze.ByteString.Builder
import           Blaze.ByteString.Builder.ByteString
import           Snap.Iteratee
import           Data.Monoid
import           NodeSnapletTest
import           Network.HTTP.Types (QueryItem, renderQuery)
import qualified Snap.Iteratee as I 
import           Control.Concurrent.STM 
import qualified Data.HashMap.Strict as S 
import           Debug.Trace 
import           Data.ExternalLog (Cycle, reportCycle) 
import           Data.ConduitTransformer


{-- I need a datastructure, which can dynamicly be:
-
-       grown,
-       remove elements,
-       be fast,
-       have a maximum size 
--}

-- ptr, array, max bound, empty places 


type AddressBox = Maybe (B.ByteString, Int)

newtype Addresses = Addresses {
            unAddresses :: (TVar Int, TArray Int AddressBox, TVar Int, TVar [Int])
    }

data ProxySnaplet = PS {
        _proxy :: Addresses,
        _cycle_logr :: Cycle 
    } 

emptyAddresses :: IO Addresses 
emptyAddresses = do 
            x <- newTVarIO 0 
            y <- atomically $ newArray (0,100) Nothing
            z <- newTVarIO 0
            q <- newTVarIO []
            return $ Addresses (x,y,z,q)


unsafeGetPointer :: Addresses -> TVar Int 
unsafeGetPointer (unAddresses -> (ptr, arr, mb, _)) = ptr 

unsafeGetArray :: Addresses -> TArray Int AddressBox  
unsafeGetArray (unAddresses -> (ptr, arr, mb, _)) = arr 

unsafeGetBound :: Addresses -> TVar Int 
unsafeGetBound (unAddresses -> (ptr, arr, mb, _)) = mb 

unsafeGetEmpties :: Addresses -> TVar [Int]
unsafeGetEmpties (unAddresses -> (ptr, arr, mb, a)) = a 

getNextEmpty :: Addresses -> STM (Maybe Int)
getNextEmpty a = do 
            let b = (unsafeGetEmpties a)
            xs <- readTVar b
            case xs of 
                (x:xs) -> writeTVar b xs *> return (Just x)
                [] -> do 
                mb <- getMaxBound a
                b <- getBound a 
                if b >= mb then return Nothing 
                           else unsafeSuccBound a *> return (Just $ b)
                           

unlessAddress :: Addresses -> (B.ByteString, Int) -> STM () -> STM () 
unlessAddress a p m = do 
                xs <- getElems (unsafeGetArray a)
                if any ((Just p)==) xs then return () else m 

getBound :: Addresses -> STM Int 
getBound  a = readTVar (unsafeGetBound a)

getMaxBound :: Addresses -> STM Int 
getMaxBound a = snd <$> getBounds (unsafeGetArray a)

getPointer :: Addresses -> STM Int 
getPointer a = do
           (u) <- getBound a
           when (0 == u) $ error "u is null gotohel"
           p <- readTVar ptr 
           modifyTVar ptr (\x -> (x + 1) `mod` u)
           return p
    where arr = unsafeGetArray a
          ptr = unsafeGetPointer a 

unsafeSuccBound :: Addresses -> STM () 
unsafeSuccBound a = do 
            let bnds = unsafeGetBound a
            modifyTVar bnds (\x -> (x + 1))


unsafeGetAddress :: Addresses -> Int -> STM (B.ByteString, Int) 
unsafeGetAddress a n = do 
                p <- readArray (unsafeGetArray a) n
                return (fromJust p)

showAll :: Addresses -> STM ()
showAll a = do 
        xs <- getAssocs (unsafeGetArray a) 
        traceShow xs $ return () 


testAddress =  do undefined  


getAddress :: Addresses -> STM (B.ByteString, Int)
getAddress a = getPointer a >>=  unsafeGetAddress a

addAddress :: Addresses -> (B.ByteString, Int) -> STM Bool 
addAddress a c = do 
            p <- getNextEmpty a
            case p of 
                Nothing -> return False 
                Just b -> do 
                    writeArray (unsafeGetArray a) b (Just c)
                    return True 
    where arr = unsafeGetArray a 


removeAddress :: Addresses -> (B.ByteString, Int) -> STM ()
removeAddress a p = filterAddress a (==p)

-- | filter an address out of Addresses 
filterAddress :: Addresses -> ((B.ByteString, Int) -> Bool) -> STM ()
filterAddress a f = do 
                xs <- getAssocs arr 
                forM_ xs $ \(i,e) -> do 
                            case e of 
                                Just (f -> True) -> do
                                        modifyTVar emps (i:)
                                        writeArray arr i Nothing 
                                otherwise -> return ()
    where arr = unsafeGetArray a 
          emps = unsafeGetEmpties a 


{-- Initializes mini heartbeat handler and proxy server --}
initProxy :: Cycle -> FilePath -> SnapletInit b ProxySnaplet 
initProxy cl fp = makeSnaplet "ProxySnaplet" "Proxy sends requests to the other side" Nothing $ do 
                                xs <- liftIO $ readConfig fp 

                                let ps = lookupConfig "Heartbeat" xs >>= lookupVar "listener-address"
                                let (Just (StringC c)) = ps 

                                p <- liftIO $ emptyAddresses
                                liftIO $ initHeartBeat cl p c
                                return (PS p cl) 

initHeartBeat :: Cycle -> Addresses -> Address -> IO ThreadId   
initHeartBeat cl p c = do
                print "Starting heart beat proxy"
                forkIO $ hotelManager cl c $ \b -> do
                                            case b of 
                                                        Alive (parseAddress -> a) _ -> (atomically $ unlessAddress p a $ do 
                                                                                                              void $ addAddress p a  
                                                                                                              return ()) *> return (Right ())
                                                        otherwise -> return (Left "you sent me error") 


parseAddress :: String -> (B.ByteString, Int)
parseAddress s = let (nm,pt) = Prelude.break (==':') s 
                 in (C.pack nm, read $ Prelude.drop 1 pt)
                 
-- 
-- source -> pipe -> pipe -> sink 
--     /|\                   /|\ 
--      | pseudo isomorphic   |    
--      |                     |
--     \|/                   \|/
-- enumerator -> enumeratee -> enumeratee -> iteratee 
--
-- sink -> iteratee \ cannot catch exceptions here 
-- iteratee -> sink /
--
-- sink -> tqueue 
--        /
--       /
--      /
--     / <- opaque
--    /
--   /
--  /
-- tqueue -> iteratee 
-- 
-- Diagram:
--              f
--    sink -----------------> tqueue 
--      /|\                      |
--       | g?                    | g
--       |                       |
--       |             f?        \ /        f-
--      tqueue <-------------- iteratee ---------> tqueue 
--
--                                                      |
--                                                      | g-
--                                                      |
--                                                     \ /
--                                                    sink* 
--
--      sink <> sink* 
--
--      because exceptions are not catched  
--
-- I would like this law:
--
-- g . f = g? . f? 
--
-- But at this moment this is not possible. It is true if I ignore
-- exceptions.
--
-- This is due a state machine:
--
-- Maybe a -> Nothing 
--         -> Just a 
--
-- Maybe [B.ByteString] -> Nothing -> EOT 
--                      -> Just xs -> I got a chunk -> send to http   
--
--
--  Which we need to change into:
--
-- Either Exception [B.ByteString] -> Left e {
--                                      EOT -> ok
--                                      Error e -> take some action
--                                          }
--                                    Right xs -> I got chunk -> send to http 
--
--  But even this doesn't save us from asynchronous exceptions.
--
-- This stays: sink <> sink*, but it is at least limited to special
-- exceptions (which mean the place turned into a hellhole anyway).
--
-- (Request, source) -> http (Conduit) -> iteratee
--
-- iteratee -> snap -> IO   
--
-- TODO:
--  first implement new interface
--  then turn over statemachine
--  then pray to the programming gods and goddesses and hope it works. 
--
-- --}


chanIteratorHttpManager :: CE.Request (ResourceT IO) -> TQueue (Maybe [B.ByteString]) -> TQueue (Maybe [B.ByteString]) -> Iteratee B.ByteString IO ()
chanIteratorHttpManager rq s2 s1 = do 
                        liftIO $ forkIO $ do 
                                resp <- CE.withManager $ \m ->  
                                        CE.http (createRequest rq (tqueueSource s2)) m >>= \resp ->
                                        handleResumableSource s1 (CE.responseBody resp)
                                return ()


                        tqueueIterator s2
    where 
          createRequest :: CE.Request (ResourceT IO) -> (Source (ResourceT IO) B.ByteString) -> CE.Request (ResourceT IO) 
          createRequest req src =  req {
                                CE.requestBody = CE.RequestBodySourceChunked $ mapOutput fromByteString src           
                            }
            -- xs is a resumable source $$+- sinks the source and finalize
            -- the other shit 
          handleResumableSource s1 xs = xs $$+- tqueueSink s1




sendAbroad :: (MonadState ProxySnaplet m, MonadSnap m) => S.Request -> CE.Request (ResourceT IO) -> m ()
sendAbroad r rq = do 
                s1 <- liftIO $ newTQueueIO
                s2 <- liftIO $ newTQueueIO
                
                runRequestBody (chanIteratorHttpManager rq s2 s1)
                cl <- gets _cycle_logr
                liftIO $ reportCycle cl "proxy_snaplet" "sendAbroad"
                resp <- getResponse 

                finishWith $ 
                    setResponseBody (mapEnum toByteString fromByteString . tqueueEnumerator $ s1) resp

runProxy :: (?proxyTransform :: B.ByteString -> B.ByteString, MonadState ProxySnaplet m, MonadSnap m) => 
            [Network.HTTP.Types.QueryItem] -> m ()  
runProxy prs = do 

    -- gets proxy 
    

    ps <- gets _proxy
    (host,port) <- liftIO $ atomically $ getAddress ps 
    
    -- Building outgoing request 

    req <- getRequest 

    let  accept = fromMaybe "application/json" $ getHeader "Accept" req
    let  method = rqMethod req  
    let  uri = rqURI req 
    let  resource = rqContextPath req 
    let  subresource = rqPathInfo req 
    let  (Just ct) = getHeader "Content-Type" req <|> (Just "text/plain")   
    let  params = fmap (second listToMaybe) $ M.toList $ rqParams req
    let  request = CE.def {CE.method = C.pack . show $ method, CE.path = (?proxyTransform $ resource `B.append` subresource), CE.host = host, CE.port = port, CE.queryString =  renderQuery True $ params ++ prs, CE.requestHeaders = [("Content-Type", ct)] }  

    -- send it away 
    sendAbroad req request 
    return ()

