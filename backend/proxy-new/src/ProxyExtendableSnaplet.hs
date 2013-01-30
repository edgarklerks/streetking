{-# LANGUAGE TemplateHaskell, OverloadedStrings, FlexibleContexts, FlexibleInstances, ViewPatterns, NoMonomorphismRestriction, RankNTypes, ScopedTypeVariables, ImplicitParams #-}
module ProxyExtendableSnaplet (
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
import           Control.Lens
import qualified Data.Text as T 
import qualified Data.ByteString as B
import qualified Data.ByteString.Char8 as C 
import           Data.Maybe
import           Control.Arrow
import qualified Data.Map as M 

import           Control.Concurrent 
import           Control.Monad.Fix 
import           Control.Concurrent.Chan

import           Config.ConfigFileParser 
import           System.Random 
import           Data.Array.Base
import           Data.Array.MArray
import           System.IO.Unsafe
import           Network.HTTP.Enumerator as HE
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
import           NodeSnaplet 
import           Network.HTTP.Types (QueryItem)
import qualified Snap.Iteratee as I 
import           Control.Concurrent.STM 
import qualified Data.HashMap.Strict as S 
import           Debug.Trace 


{-- I need a datastructure, which can dynamicly be:
-
-       grown,
-       remove elements,
-       be fast,
-       have a maximum size 
--}
-- ptr, array, max bound, empty places 
--
type AddressBox = Maybe (B.ByteString, Int)
newtype Addresses = Addresses {
            unAddresses :: (TVar Int, TArray Int AddressBox, TVar Int, TVar [Int])
    }

data ProxySnaplet = PS {
        _proxy :: Addresses 
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
initProxy :: FilePath -> SnapletInit b ProxySnaplet 
initProxy fp = makeSnaplet "ProxySnaplet" "Proxy sends requests to the other side" Nothing $ do 
                                xs <- liftIO $ readConfig fp 

                                let ps = lookupConfig "Heartbeat" xs >>= lookupVar "listener-address"
                                let (Just (StringC c)) = ps 

                                p <- liftIO $ emptyAddresses
                                liftIO $ initHeartBeat p c
                                return (PS p) 

initHeartBeat :: Addresses -> Address -> IO ThreadId   
initHeartBeat p c = do
                print "Starting heart beat proxy"
                forkIO $ hotelManager c $ \b -> do
                                            case b of 
                                                        Alive (parseAddress -> a) _ -> (atomically $ unlessAddress p a $ do 
                                                                                                              void $ addAddress p a  
                                                                                                              return ()) *> return (Right ())
                                                        otherwise -> return (Left "you sent me error") 


parseAddress :: String -> (B.ByteString, Int)
parseAddress s = let (nm,pt) = Prelude.break (==':') s 
                 in (C.pack nm, read $ Prelude.drop 1 pt)
                 
{-- Consumes a stream and put it into the channel --}

chanIterator :: Chan (Maybe [a]) -> Iteratee a IO ()
chanIterator f = continue go 
        where go  (Chunks xs) = do 
                        liftIO $ writeChan f (Just  xs)  
                        continue go
              go  EOF = liftIO (writeChan f Nothing) >> E.yield () EOF

{-- Reads a channel and produces a stream --}
chanEnum :: Chan (Maybe [a]) -> Enumerator a IO b 
chanEnum n f = do 
        p <- liftIO $ readChan n 
        case p of 
            Nothing -> case f of 
                        Continue g -> g EOF 
                        a -> returnI a 
            Just a -> case f of 
                        Continue g -> do 
                            step <- lift . runIteratee . g . Chunks $ a
                            chanEnum n step
                        a -> returnI a 

{-- Consumes a stream and couple http enumerator to the two channels --}
chanIteratorHttpManager :: HE.Request IO -> Chan (Maybe [B.ByteString]) -> Chan (Maybe [B.ByteString]) -> Iteratee B.ByteString IO ()
chanIteratorHttpManager rq s2 s1 = do 
                            liftIO $ forkIO  $ withManager (run_ . http (createRequest rq (chanEnum s1)) (const . const $ chanIterator s2))
                            chanIterator s1 
    where   createRequest :: HE.Request IO -> (forall a. Enumerator B.ByteString IO a) -> HE.Request IO
            createRequest r p =
                    let enum = mapEnum toByteString fromByteString p
                    in (r {requestBody = RequestBodyEnumChunked enum })


sendAbroad :: (MonadState ProxySnaplet m, MonadSnap m) => S.Request -> HE.Request IO -> m ()
sendAbroad r rq = do 
                    s1 <- liftIO newChan 
                    s2 <- liftIO newChan 

                    -- this function unfortunately reads the request body
                    -- first and then we can get to the point of forming
                    -- the response. Oh well.     
                    --
                    -- This can be fixed by expanding runRequestBody and
                    -- change it enough to make it asynchronously enough 
                    --
                    -- But this dependends heavily on internals. 
                    
                    runRequestBody (chanIteratorHttpManager rq s2 s1)

                    -- now we need to fork this to gain back previous
                    -- performance. 
                
                    resp <- getResponse 

                    finishWith $ 
                        setResponseBody (mapEnum toByteString fromByteString . chanEnum $ s2) resp

    
    where   createRequest :: HE.Request IO -> (forall a. Enumerator B.ByteString IO a) -> HE.Request IO
            createRequest r p =
                    let enum = mapEnum toByteString fromByteString p
                    in (r {requestBody = RequestBodyEnumChunked enum })


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
    let  params = fmap (second (Just . Prelude.head)) $ M.toList $ rqParams req
    let  request = HE.def {HE.method = C.pack . show $ method, HE.path = (?proxyTransform $ resource `B.append` subresource), HE.host = host, HE.port = port, HE.queryString = params ++ prs, HE.requestHeaders = [("Content-Type", ct)] }  

    -- send it away 
    sendAbroad req request 
    return ()

