{-# LANGUAGE ScopedTypeVariables #-}
module HashServer where 

import qualified Data.HashStore as H 

import Control.Monad.STM 
import Control.Monad
import Control.Applicative
import Control.Concurrent
import System.ZMQ3 
import Data.HashQuery 
import qualified Data.ByteString as B 
import qualified Data.ByteString.Char8 as C
import Data.Serialize 
import Control.Monad.Trans
import Data.IORef
search :: Serialize b => b -> String -> B.ByteString -> IO (Maybe b)
search w add key = withContext 1 $ \c -> 
                withSocket c Req $ \b -> do 
                    connect b add 
                    send b [] (encode $ Search key `asTypeOf` Witness w )
                    p <- receive b 
                    case decode p of 
                        Left s -> error s
                        Right p -> return p

add :: Serialize b => String -> B.ByteString -> b -> IO (Maybe b)
add add key val = withContext 1 $ \c -> 
                    withSocket c Req $ \b -> do 
                        connect b add 
                        send b [] (encode $ Add key val)
                        p <- receive b 
                        case decode p of 
                            Left s  -> error s
                            Right p -> return p 

remove :: Serialize b => b -> String -> B.ByteString -> IO (Maybe b)
remove w add key = withContext 1 $ \c -> 
                        withSocket c Req $ \b -> do 
                                    connect b add 
                                    send b [] (encode $ Remove key `asTypeOf` Witness w)
                                    p <- receive b  
                                    case decode p of 
                                            Left s -> error s 
                                            Right p -> return p

initServer :: Serialize b => FilePath -> FilePath -> FilePath -> String -> b -> IO ()
initServer db idx tmp add w = withContext 1 $ \c -> 
            withSocket c Rep $ \b  -> do 
                 bind b add 
                 ctx <- newMVar 0 
                 void $ H.runHashMonad $ do 
                            H.newHashStore db idx tmp

                            forever $ do 
                                   p <- liftIO $ receive b 
                                   n <- liftIO $ takeMVar ctx 
                                   if n `mod` 1000 == 0 then H.writeHashStore *> liftIO (putMVar ctx 1) else liftIO $ putMVar ctx (n + 1) 
                                   case decode p of 
                                            Left s -> H.writeHashStore *> error s
                                            Right p -> do 
                                               t <- H.runQuery p
                                               liftIO $ send b [] (encode (t `asTypeOf` (Just w))) 
                                

testserver = do 
        forkIO $ initServer "test.db" "test.idx" "test.tmp" "tcp://127.0.0.1:5555" (1 :: Int)

        let addr = "tcp://127.0.0.1:5555"
        let w = 1 :: Int
        forkIO $ forM_ [1..1000] $ \(i :: Int) -> do 
                    add addr (C.pack $ show i) i 
        forkIO $ forM_ [1000..2000] $ \(i :: Int) -> do 
                    add addr (C.pack $ show i) i 
        forkIO $ forM_ [2000..3000] $ \(i :: Int) -> do 
                    add addr (C.pack $ show i) i 
        forkIO $ forM_ [3000..4000] $ \(i :: Int) -> do 
                    add addr (C.pack $ show i) i 
        forkIO $ forM_ [4000..5000] $ \(i :: Int) -> do 
                    add addr (C.pack $ show i) i 




testclient = do 
        let addr = "tcp://127.0.0.1:5555"
        let w = 1 :: Int
        forM_ [1..5000] $ \(i :: Int) -> do 
                    p <- search w addr (C.pack $ show i)
                    print p
