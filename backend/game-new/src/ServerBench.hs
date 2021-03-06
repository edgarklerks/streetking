{-# LANGUAGE OverloadedStrings #-}
module Main where



import Data.Time.Clock.POSIX 
import Control.Applicative 
import System.CPUTime 
import Network.TCP 
import Network.HTTP 
import qualified Data.ByteString.Lazy.Char8 as B
import qualified Data.ByteString.Char8 as BL
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
import System.Process 
import GHC.IO.Exception


uriCtrl = "tcp://172.22.0.10:9006"
uriData = "tcp://172.22.0.10:9105"
serverPort = 9003
serverAdd = "r3.graffity.me" 

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
     forkIO $ forever $ do 
         print "Wait state, waiting on command"
         (uri, meth, quer, dat) <- waitOnPeer 
         print (uri, meth,quer, dat)
         print "starting"
         s <- floor <$> getPOSIXTime
         replicateM_ 10 $ forkIO $ do 
             x <- benchProg uri meth quer dat usr dev  
             case x of 
                Nothing -> return ()
                Just a -> sendToPeer (s,a)  
     forever $ threadDelay 10000 
     return () 

waitOnPeer = withContext 1 $ \c -> 
             withSocket c Pull $ \s -> do
                     connect s uriCtrl 
                     waitOnPeer s 
        where waitOnPeer s = do 
                    r <- receive s  
                    return $ read (BL.unpack r) :: IO (String, String, String, String)


sendToPeer out = withContext 1 $ \c -> 
             withSocket c Req $ \s -> do
                     print "Trying to connect"
                     connect s uriData  
                     print "Connected"
                     send s [] (BL.pack $ show out) 
                     print "sendt"
                     t <- receive s 
                     print t







        


data Output = OUT {
        successes :: Int,
        successesTime :: Int, 
        failures :: Int, 
        failuresTime :: Int 
    } deriving (Show, Read)

benchProg uri meth params dat usr dev = do 
        (exitcode, sout, serr) <- readProcessWithExitCode "./stress" [
                                                          "50"
                                                        , meth
                                                        , uri 
                                                                <> "?" 
                                                                <> "application_token=" 
                                                                <> urlEncode dev
                                                                <> "&user_token="
                                                                <> urlEncode usr
                                                                <> "&" 
                                                                <> params
                                                         , dat
                                                            ] "" 
        if exitcode == ExitSuccess  
                then do
                    print (parseOut sout) 
                    return (Just $ parseOut sout)
                else do
                    print "Error"
                    print serr 
                    return $ Nothing 
       



parseOut :: String -> Output 
parseOut xs = let bs = breaks ' ' xs 
              in case bs of 
                [n,p,q,r] -> OUT (read n) (read p) (read q) (read r)
                otherwise -> error "failure to parse"


breaks :: Char -> String -> [String]
breaks c [] = [] 
breaks c xs = let (n, (rest)) = break (==c) xs 
              in case rest of 
                    [] -> [n]
                    (_:rest) -> n : breaks c rest 

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
