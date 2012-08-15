{-# LANGUAGE TemplateHaskell, OverloadedStrings, FlexibleContexts, FlexibleInstances, ViewPatterns, NoMonomorphismRestriction, RankNTypes, ScopedTypeVariables, ImplicitParams #-}
module ProxySnaplet (
    initProxy,
    runProxy,
    ProxySnaplet,
    HasProxy(..)
 ) where 
import Control.Monad
import Control.Applicative
import Control.Monad.Trans
import Control.Monad.State 
import Data.Word 
import Snap.Snaplet 
import Snap.Core 
import Data.Lens.Common
import Data.Lens.Template 
import qualified Data.Text as T 
import qualified Data.ByteString as B
import qualified Data.ByteString.Char8 as C 
import Data.Maybe
import Control.Arrow
import qualified Data.Map as M 

import Control.Concurrent 
import Control.Monad.Fix 
import Control.Concurrent.Chan

import Config.ConfigFileParser 
import System.Random 
import Data.Array.Base
import Data.Array.IArray
import System.IO.Unsafe
import Network.HTTP.Enumerator as HE
import Data.Enumerator as E 
import qualified Data.Enumerator.List as L
import Data.List (genericLength)
import Data.Char 
import Data.IORef 
import Snap.Internal.Http.Types as S
import Blaze.ByteString.Builder
import Blaze.ByteString.Builder.ByteString
import Snap.Iteratee
import Data.Monoid
import NodeSnaplet 




data ProxySnaplet = PS {
        _proxy :: IO (B.ByteString, Int),
        _manager :: Manager 
    } 


$(makeLenses [''ProxySnaplet])

class HasProxy b where 
    proxyLens :: Lens (Snaplet b) (Snaplet ProxySnaplet)


-- tiemvar:: Array Int a -> IO (() -> IO a)
tiemvar f = do 
            g <- newStdGen 
            m <- newMVar g
            return $ do 
                g <- takeMVar m 
                let (a,g') = randomR (bounds f) g 
                putMVar m g' 
                return (f ! a)

                             
($>) a f = f a

arrayToString (fmap (\(StringC x) -> x) -> xs) = 
                                let ps = listArray (0,p) xs :: Array Int String  
                                in ps
                    where p = Prelude.length xs - 1 
-- Step a m b = Continue (Stream a -> Iteratee a m b)
-- Stream a = Chunks [a] | EOF 
-- Iteratee a m b = m (Step a m b)
-- Enumerator a m b = Step a m b -> Iteratee a m b 
-- Enumeratee ai ao m b = Step ai m b -> Iteratee ao m (Step ai m b)

listEnum :: Monad m => [a] -> Enumerator a m b
listEnum [] f = case f of 
                    Continue g -> g EOF 
                    a -> returnI a
listEnum (x:xs) f = case f of 
                    Continue g -> do 
                            step <- lift $ runIteratee $ g (Chunks [x])
                            listEnum xs step
                    a -> returnI a
-- continue :: (Stream a -> Iteratee a m b) -> Iteratee a m b 
-- checkDone :: ((Stream a -> Iteratee a m b) -> Iteratee a' m (Step a m b)) -> Enumeratee a' a m b  
-- Continue (Stream a -> Iteratee a m b)
-- f :: (Stream a -> Iteratee a m b) -> Step  

averageEnumeratee :: Monad m => Enumeratee Double Double m a 
averageEnumeratee = checkDone (continue . step (0,0))
    where 
        step s k EOF = E.yield (Continue k) EOF 
        step s k (Chunks xs) = loop s k xs 
        loop s k [] = continue (step s k)
        loop (w,a) k (x:xs) = k (Chunks [snd s']) >>== checkDoneEx (Chunks xs) (\f -> loop s' f xs)
                            where s' = (w + 1, (a * w + x) / (w + 1))

                                            

rot13 (Continue k) = do 
        x <- fmap ord <$> L.head
        case x of 
            Just a -> do 
                    if a <= 122 && a >= 97 then do
                            step <- lift $ runIteratee $ k $ Chunks [(chr ((a - 97 + 13) `mod` 26 + 97))]
                            rot13 step   
                        else if a >= 65 && a <= 90 then  do 
                            step <- lift $ runIteratee $ k $ Chunks [(chr ((a - 65 + 13) `mod` 26 + 65))]
                            rot13 step
                                else do 
                                    step <- lift $ runIteratee $ k $ Chunks [chr a]
                                    rot13 step
            Nothing -> return (Continue k)


duplicate :: Monad m => Enumeratee a a m b
duplicate = checkDone (continue . step)  
        where step k EOF = E.yield (Continue k) EOF 
              step k (Chunks xs) = loop k xs 
              loop k [] = continue (step k)
              loop k (x:xs) = k (Chunks [x,x]) >>== checkDoneEx (Chunks xs) (\f -> loop f xs)
                            

-- 3 * (3 / 8) + 4 * (5 / 8)

mapEnumeratee f = checkDone (continue . step)
        where step k EOF = E.yield (Continue k) EOF 
              step k (Chunks xs) = loop k xs 
              loop k (x:xs) = k (Chunks $ [f x]) >>== checkDoneEx (Chunks xs) (`loop` xs)
              

listEnumeratee f  = checkDone (continue . step f)
    where step f k EOF = E.yield (Continue k) EOF 
          step f k (Chunks xs) = loop f k xs 
          loop f k [] = continue (step f k)
          loop f k (x:xs) = do 
                fx <- lift $ f x
                k (Chunks fx) >>== checkDoneEx (Chunks xs) ( flip (loop f) xs)

mvarEnum :: MVar (Maybe [a]) -> Enumerator a IO b 
mvarEnum n f = do 
        p <- liftIO $ takeMVar n 
        case p of 
            Nothing -> case f of 
                        Continue g -> g EOF 
                        a -> returnI a
            Just a -> case f of 
                        Continue g -> do 
                            step <- lift $ runIteratee $ g $ Chunks a
                            mvarEnum n step 

chanEnum :: Chan (Maybe [a]) -> Enumerator a IO b 
chanEnum n f = do 
        p <- liftIO $ readChan n 
        case p of 
            Nothing -> case f of 
                        Continue g -> g EOF 
                        a -> returnI a 
            Just a -> case f of 
                        Continue g -> do 
                            step <- lift $ runIteratee $ g $ Chunks a
                            chanEnum n step
                        a -> returnI a 

iterPrint :: Show a => Iteratee a IO ()
iterPrint = continue (go [])
    where go z (Chunks xs) = continue (go (z ++ xs))
          go z (EOF) = liftIO (print z) >> E.yield () EOF

mvarIterator :: MVar (Maybe [a]) -> Iteratee a IO ()
mvarIterator f = continue go    
        where go (Chunks xs) = do 
                        liftIO $ putMVar f (Just xs)
                        continue go 
              go EOF = liftIO (putMVar f Nothing) >> E.yield () EOF 

chanIterator :: Chan (Maybe [a]) -> Iteratee a IO ()
chanIterator f = continue go 
        where go  (Chunks xs) = do 
                        liftIO $ writeChan f (Just  xs)  
                        continue go
              go  EOF = liftIO (writeChan f Nothing) >> E.yield () EOF

sendAbroad :: (MonadState ProxySnaplet m, MonadSnap m) => S.Request -> HE.Request IO -> m ()
sendAbroad r rq = do 
    (SomeEnumerator s) <- liftIO $ readIORef (rqBody r)
    let r' = t rq s
    liftIO $ writeIORef (rqBody r) (SomeEnumerator enumEOF)
    resp <- getResponse
    p <- liftIO $ newChan 
    liftIO $ forkIO $ withManager $ \m -> run_ $  http r' (\_ _ -> chanIterator p) m 
    finishWith (setResponseBody (mapEnum toByteString fromByteString $ chanEnum p) resp) 
    return ()
    where   t :: HE.Request IO -> (forall a. Enumerator B.ByteString IO a) -> HE.Request IO
            t r (p :: (forall a. Enumerator B.ByteString IO a)) =
                    let enum = mapEnum toByteString fromByteString p
                    in (r {requestBody = RequestBodyEnumChunked enum })
        
-- runProxy :: (?proxyTransform :: B.ByteString -> B.ByteString) =>  (MonadState ProxySnaplet m, MonadSnap m) => m () 
runProxy prs = do 
    ps <- gets _proxy
    (host,port) <- liftIO ps 
    req <- getRequest 
    let  accept = fromMaybe "application/json" $ getHeader "Accept" req
    let  method = req $> rqMethod
    let  uri = req $> rqURI
    let  resource = req $> rqContextPath 
    let  subresource = req $> rqPathInfo 
    let  params = fmap (second (Just . Prelude.head)) $ M.toList $ req $> rqParams 
    let  request = HE.def {HE.method = C.pack . show $ method, HE.path = (?proxyTransform $ resource `B.append` subresource), HE.host = host, HE.port = port, HE.queryString = params ++ prs}  
    sendAbroad req request 
    return ()

initProxy :: FilePath -> SnapletInit b ProxySnaplet
initProxy fp = makeSnaplet "ProxySnaplet" "Proxy sends requests to the other side" Nothing $ do 
        xs <- liftIO $ readConfig fp 
        let (Just (ArrayC c)) = lookupConfig "proxy" xs >>= lookupVar "pool"
        s <- liftIO $ tiemvar (fmap (first C.pack . second (read . tail) . Prelude.break (==':')) $ arrayToString c)  
        h <- liftIO $ newManager 
        return $ PS s h




