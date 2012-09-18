{-# LANGUAGE OverloadedStrings #-}
module Main where 

import Control.Applicative 
import Control.Monad 
import Data.Enumerator hiding (head) 
import qualified Data.Enumerator.List as L
import qualified Network.Socket.ByteString as NB
import qualified Network.Socket as NS  
import Network.Socket.Enumerator
import Control.Monad.Trans
import qualified Data.ByteString.Char8 as B 
import Data.String

mkSocket ::  NS.HostName -> String -> IO NS.Socket 
mkSocket xs p = do 
                 x <- NS.getAddrInfo (Just NS.defaultHints) (Just xs) (Just p)  
                 if not $ null x 
                    then do sck <- NS.socket NS.AF_INET NS.Stream NS.defaultProtocol
                            NS.connect sck (NS.addrAddress $ head x) 
                            printSocketStats sck 
                            return sck
                    else error $ "Cannot lookup hostname" ++ xs

sumI :: Monad m => Step Int m Int 
sumI = Continue $ go 0 
    where go :: Monad m => Int -> Stream Int -> Iteratee Int m Int 
          go z (Chunks xs) = continue . go $ z + sum  xs
          go z EOF = yield z EOF 

sumIM :: Monad m => Iteratee Int m Int 
sumIM = do 
    maybeNum <- L.head 
    case maybeNum of 
        Nothing -> return 0
        Just i -> do 
            rest <- sumIM
            return $ i + rest

printSocketStats :: MonadIO m => NS.Socket -> m ()
printSocketStats sck = liftIO $ do 
            pr <- NS.sIsWritable sck 
            pn <- NS.sIsReadable sck
            p <- NS.socketPort sck
            ts <- NS.getPeerName sck
            ds <- NS.getSocketName sck
            print (pr, pn, p, ts, ds)



writeSocket :: Monad m => Enumerator a m b -> Iteratee a m b -> Iteratee a m b 
writeSocket enum iter = Iteratee $ do 
    step <- runIteratee iter 
    runIteratee $ enum step 

req (Continue k) = k $ Chunks ["GET /index.html HTTP/1.1\n", "Connection: close\n", "\n\n"]
req step = returnI step

main :: IO ()
main = do 
    x <- mkSocket "example.org" "80" 
    z <- run (req $$ iterSocket x)
    y <- run (socketRecv x  $$ consumeDebug)
    print z
    print y
    print "asdsaddsa"

