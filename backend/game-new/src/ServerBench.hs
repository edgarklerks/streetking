module Main where 


import Data.Time.Clock.POSIX 
import Control.Applicative 
import System.CPUTime 
import Network.TCP 
import Network.HTTP 
import qualified Data.ByteString.Lazy as B
import Control.Concurrent.STM 
import Control.Concurrent 
import Data.Conversion  
import Data.Monoid 
import Network.URI 
import Data.Maybe 
import System.IO 
import System.Environment
import Data.Aeson 
import qualified Data.HashMap.Strict as S
import System.ZMQ3
import Control.Monad 


serverPort = 9003
serverAdd = "localhost" 
main = do 
     s <- server serverAdd serverPort
     x <- asInRule $ sendPost "token=demodemodemo" s "Application/identify" InNull
     let dev = fromInRule $ fromJust $ (x .> "result")
     n <- asInRule $ sendPost ("application_token=" <> dev) s "User/login" $ 
                    params $ [
                               ("email", "edgar.klerks@gmail.com"),
                               ("password", "wetwetwet")]
     let usr = fromInRule $ fromJust (n .> "result")
     print (usr :: String)
     p <- newTChanIO  
     btime <- getMicros
     replicateM_ 50 $ forkIO $ forever $ do 
            s <- server serverAdd serverPort
            x <- measure $ benchUserMe ("user_token=" <> usr)  s 
            atomically $ writeTChan p x 
     r <- newTVarIO (0,0) 

     forkIO $ forever $ do 
        (p,q) <- atomically $ do 
            n <- readTChan p 
            modifyTVar r (\(x,y) -> (x+1,y + n))
            readTVar r 
        case floor p `mod` 100 == 0 && p > 0 of 
            True -> do  
                print $ "time per request: " ++ (show $ (q / p :: Double))
                print $ "total time: " ++ (show q)
                print $ "requests done: " ++ (show $ p)
                etime <- getMicros 
                print $ "Time lapsed: " ++ (show $ (etime - btime))


            otherwise -> return ()
     forever $ threadDelay 10000 





        

     return () 

        
benchUserMe q s = do 
            sendGet q s "User/me" (params [])

mkTokens u d = "user_token=" <> u  <> "&application_token=" <> d

params :: [(String, String)] -> InRule  
params xs = toInRule $ S.fromList xs
asInRule f = do 
        a <- f 
        return $ toInRule $ (decode a :: Maybe Value) 
-- | Open the connection to the server 

sendGet ur s u o = do 
                let bs = encode $ (fromInRule o :: Value) 
                let y = parseURI $ "http://" <> serverAdd <> ":" <> (show serverPort) <> "/" <> u <> "?" <> ur 
                r <- sendHTTP s (Request {
                                    rqMethod = GET,
                                    rqHeaders = [
                                                mkHeader HdrContentLength (show $ 0),
                                                mkHeader HdrConnection "close"
                                                ],
                                    rqBody = B.pack [],
                                    rqURI = fromJust $ y 
                                         })
                case r of
                    Left e -> error (show e)
                    Right a -> return (rspBody a)
                

sendPost ur s u o = do 
                let bs = encode $ (fromInRule o :: Value) 
                let y = parseURI $ "http://" <> serverAdd <> ":" <> (show serverPort) <> "/" <> u <> "?" <> ur 
                r <- sendHTTP s (Request {
                                    rqMethod = POST,
                                    rqHeaders = [
                                                mkHeader HdrContentLength (show $ B.length bs),
                                                mkHeader HdrConnection "keep-alive"
                                                ],
                                    rqBody = encode $ (fromInRule o :: Value),
                                    rqURI = fromJust $ y 
                                         })
                case r of
                    Left e -> error (show e)
                    Right a -> return (rspBody a)
                

server :: String -> Int -> IO (HandleStream B.ByteString)
server x p = openTCPConnection x p 

-- | Measure the time of an operation in milliseconds 
measure :: IO t -> IO Double 
measure f = do 
        s <- getMicros 
        f 
        t <- getMicros
        return (t - s)

-- microseconds time 
getMicros :: IO Double  
getMicros = do 
        s <- getPOSIXTime 
        return (realToFrac s)
