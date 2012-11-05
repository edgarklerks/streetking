{-# LANGUAGE OverloadedStrings #-}
module Main where 

import System.ZMQ3 
import Control.Concurrent 
import System.Environment 
import qualified Data.ByteString.Char8 as B 
import Control.Monad 
import Data.Monoid 
uriCtrl = "tcp://172.20.0.10:9006"
uriData = "tcp://172.20.0.10:9005"


main = do
    forkIO $ receiveEvents 

    forkIO $ startUri >> print "done sending"

    forever $ threadDelay 10000


receiveEvents = withContext 1 $ \c -> 
                    withSocket c Pull $ \s -> do
                            bind s uriData 
                            keepReceiving s
        where keepReceiving s = do 
                        xs <- receive s 
                        appendFile "data.csv" (B.unpack xs <> "\n") 
                        keepReceiving s 



startUri = do 
        [xs] <- getArgs 
        print xs 
        sendUri xs
                

sendUri uri = withContext 1 $ \c -> 
                withSocket c Pub $ \s -> do 
                            bind s uriCtrl
                            threadDelay 100000

                            replicateM_ 10000 $ do
                                    threadDelay 100
                                    send s [] ("uri " <> (B.pack uri))

       
