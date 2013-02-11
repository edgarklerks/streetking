{-# LANGUAGE GADTs #-}
module Data.HeartBeat where 

import System.ZMQ
import Data.Serialize
import Data.Word 
import Control.Applicative
import Control.Monad 
import Control.Concurrent 
import Control.Concurrent.STM 
import Control.Monad.Trans
import qualified Data.ByteString as B
import Data.ExternalLog (Cycle, reportCycle) 

{- | 
-
- We need to a way to let the proxy server know, that a client is:
-  * Still alive 
-  * Wants to be connected 
-  
- We can do this by a heartbeat. Send over a separate channel.
-
- The proxy server has a server running, which accepts new connections. 
- A backend server can connect to the proxy and announce itself. 
- The proxy can accept it or decline it. 
- In accept the backend server sends every n seconds a alive beat. 
-
- This can be extended by some statistics to make the load-balancing
- function more advanced. 
-
 | -}

type Address = String 

data Beat where
        Alive :: Address -> (Maybe B.ByteString) -> Beat 
        Error :: Beat 
    deriving (Show)

instance Serialize Beat where 
        put (Alive a x) = put (0x01 :: Word8) *> put a *> put x
        put (Error) = put (0x02 :: Word8)
        get = do  x <- get :: Get Word8
                  case x of
                    0x01 -> Alive <$> get <*> get 
                    0x02 -> pure Error 

type ClientC = Either String () -> IO (Maybe B.ByteString) 
type ServerC = Beat -> IO (Either String ()) 
-- 100000 microseconds -> 100 ms  
delay = 100000

-- | check your self into a proxy and start heartbeating 
checkin :: Address -> Address -> ClientC ->  IO  ()
checkin org cp callback = withContext 1 $ \c -> do 
                                 withSocket c Req $ \s -> do 
                                            connect s cp 

                                             -- fake a right response
                                             -- for the first time 
                                             --
                                             -- Fuck those left wing liberal 
                                             -- goddamn progressive
                                             -- socialist
                                             -- hippies. 
                                             --

                                            callback (Right ()) >>= keepTalking s 

                                            -- Afterwards the Right
                                            -- response keeps propagated
                                            -- until something fails.



        where keepTalking s x = do 
                            send s  (encode $ Alive org x) []
                            t <- receive s [] 
                            case decode t of 
                                    Left _ -> error "cannot decode answer"
                                    Right a -> callback a >>= (\x -> threadDelay delay *> keepTalking s x)



-- | handle authorizations  by binding to the address  
hotelManager :: Cycle -> Address -> ServerC -> IO ()
hotelManager cl lp callback = withContext 1 $ \c -> 
                           withSocket c Rep $ \s -> do 
                                        bind s lp 
                                        forever $ do 
                                            reportCycle cl "heartbeat" "hotelManager"
                                            a <- receive s [] 
                                            case (decode a) of 
                                                Left msh -> send s  (encode $ (Left msh :: Either String ())) []
                                                Right a -> do x <- callback a 
                                                              send s (encode x) []


testHeartBeat = do 
        forkIO 
            $ hotelManager undefined "tcp://*:2765" 
            $ \b -> case b of 
                        Alive who meta -> print who *> return (Right ()) 
                        Error -> print "error" *> return (Left "error received")
        forkIO 
            $ checkin "http://192.168.4.9:9001" "tcp://127.0.0.1:2765" 
            $ \c -> do 
                threadDelay 10000
                case c of 
                    Left e -> error e
                    Right () -> return Nothing

        checkin "http://192.168.4.9:9000" "tcp://127.0.0.1:2765" 
            $ \c -> do 
                threadDelay 10000
                case c of 
                    Left e -> error e
                    Right () -> return Nothing

    
        

