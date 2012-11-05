{-# LANGUAGE OverloadedStrings #-}
module Main where 

import System.ZMQ3 
import Control.Concurrent 
import System.Environment 
import qualified Data.ByteString.Char8 as B 
import Control.Monad 
import Data.Monoid 


main = do
    forkIO $ receiveEvents 

    forkIO $ startUri 
    forever $ threadDelay 10000


receiveEvents = withContext 1 $ \c -> 
                    withSocket c Pull $ \s -> do
                            bind s "tcp://r3.graffity.me:9005"
                            keepReceiving s
        where keepReceiving s = do 
                        xs <- receive s 
                        appendFile "data.csv" (B.unpack xs <> "\n") 
                        keepReceiving s 



startUri = do 
        [xs] <- getArgs 
        sendUri xs
                

sendUri uri = withContext 1 $ \c -> 
                withSocket c Pub $ \s -> do 
                            bind s "tcp://r3.graffity.me:9006"

                            replicateM_ 1000 $ do
                                    send s [] ("uri " <> (B.pack uri))

       
