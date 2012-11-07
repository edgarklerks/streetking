{-# LANGUAGE OverloadedStrings #-}
module Main where 

import System.ZMQ3 
import Control.Concurrent 
import System.Environment 
import qualified Data.ByteString.Char8 as B 
import Control.Monad 
import Data.Monoid 
uriCtrl = "tcp://*:9006"
uriData = "tcp://*:9105"


main = do
    forkIO $ receiveEvents 

    forkIO $ startUri >> print "done sending"

    forever $ threadDelay 100000


receiveEvents = withContext 1 $ \c -> 
                    withSocket c Rep $ \s -> do
                            bind s uriData 
                            print "Waiting on lines"
                            keepReceiving s
        where keepReceiving s = do 
                        xs <- receive s 
                        print "recv line"
                        appendFile "data.csv" (B.unpack xs <> "\n") 
                        send s [] "stored"
                        keepReceiving s 




startUri = do 
        [xs,method,dat] <- getArgs 
        print (xs,method,dat)
        sendUri xs method dat
                

sendUri uri m d= withContext 1 $ \c -> 
                  withSocket c Push $ \s -> do 
                            bind s uriCtrl
                            replicateM_ 10 $ do
                                    threadDelay 100000
                                    send s [] ((B.pack $ show (uri, m, uri)))

       
