{-# LANGUAGE DeriveGeneric #-}
module Data.Borg where 


import System.ZMQ 
import Data.Serialize  
import Data.Word
import Control.Monad
import GHC.Generics
import Control.Concurrent
import Control.Concurrent.Chan

{-- Proxy --}
type Port = Word32 
type Host = String 

data Solit = Solit {
       port :: Port,
       host :: Host,
       name :: String 
    } deriving (Generic, Show)

data CInfo = CInfo {
        datachannel :: Port,
        announce :: Port,
        heartbeat :: Port 

    } deriving (Generic, Show)


instance Serialize CInfo 
instance Serialize Solit 

data PortConfig = PortConfig {
       solitport :: Port,
       announceport :: Port,
       dataport :: Port,
       beatport :: Port,
       hostname :: String 
    }

data Proxy i o = Proxy {
        heartbeathandler :: String -> IO (),
        solithandler :: Solit -> IO (),
        announcegenerator :: IO o,
        datahandler :: i -> IO (),
        proxyconfig :: PortConfig 
    }

data App i o = App {
       appid :: String,
       announcehandler :: i -> IO (),
       datagenerator :: IO o,
       appconfig :: PortConfig 
    }

{-- p2p proxy, can send and receive --}

p2pData :: Serialize a => IO a -> (a -> IO ()) -> [Host] -> Port -> IO ()
p2pData g f hs p = do 
           return undefined    


{-- Heartbeat --}

heartbeatProxy :: (String -> IO ()) -> Host -> Port -> IO ()
heartbeatProxy = proxyData 

heartbeatApp :: String -> Host -> Port -> IO ()
heartbeatApp ch h p = withContext 1 $ \c -> 
                    withSocket c Push $ \s -> do 
                        connect s $ mkTcp h p 
                        let x = encode ch
                        send s x [] `every` 2



{-- Solicitation --}

proxySolit :: (Solit -> IO CInfo) -> Host -> Port -> IO ()
proxySolit f h p  = withContext 1 $ \c -> 
                    withSocket c Rep $ \s -> do 
                        bind s $ mkTcp h p 
                        forever $ do 
                            x <- receive s [] 
                            case (decode x) of 
                                Left e -> error e
                                Right p -> f p >>= \x -> send s (encode x) []
                            return ()



appSolit :: Host -> Port -> Solit -> IO ()
appSolit h p n = withContext 1 $ \c -> 
                withSocket c Req $ \s -> do
                    connect s $ mkTcp h p
                    send s (encode n) [] 
{-- Anouncements --}

proxyAnnounce :: Serialize a => IO a -> Host -> Port -> IO ()
proxyAnnounce f h p = withContext 1 $ \c ->     
                        withSocket c Pub $ \s -> do 
                            bind s $ mkTcp h p 
                            forever $ do 
                                a <- f
                                send s (encode a) [] 

appAnnounce :: Serialize a => (a -> IO a) -> Host -> Port -> IO ()
appAnnounce f h p = withContext 1 $ \c -> 
                    withSocket c Sub $ \s -> do 
                        bind s $ mkTcp h p 
                        forever $ do 
                            x <- receive s [] 
                            case (decode x) of 
                                Left e -> error e
                                Right p -> f p
                            return ()


                                

{-- Datachannel --}

proxyData :: Serialize a => (a -> IO ()) -> Host -> Port -> IO ()
proxyData f h p = withContext 1 $ \c -> 
                    withSocket c Pull $ \s -> do 
                        bind s $ mkTcp h p 
                        forever $ do 
                            x <- receive s [] 
                            case (decode x) of 
                                Left e -> error e
                                Right p -> f p
                            return ()

appData :: Serialize a => Host -> Port -> IO a -> IO ()
appData h p ch = withContext 1 $ \c -> 
                    withSocket c Push $ \s -> do 
                        connect s $ mkTcp h p 
                        forever $ do 
                            p <- ch 
                            send s (encode p) []


every f p = forever (f >> waitSeconds p)

waitSeconds = threadDelay . (*1000000)

mkTcp :: Host -> Port -> String 
mkTcp h p = "tcp://" ++ h ++ ":" ++ (show p)


