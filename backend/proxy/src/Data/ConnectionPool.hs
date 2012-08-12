module Data.ConnectionPool where 

import Control.Monad
import Database.HDBC.PostgreSQL
import Database.HDBC 
import Control.Concurrent.STM 
import Control.Concurrent.STM.TArray
import Control.Concurrent 
import Data.Array.MArray

c = connectPostgreSQL "host=192.168.1.66 password=wetwetwet dbname=deosx user=graffiti"

happyTest :: IO ()
happyTest = do 
    print "Connecting"
    pl <- initConnectionPool 1 c
    print "Connections ready"
    forM_ [1..100] $ \i -> forkIO $ do 
        r <- getConnection pl 
        print $ "Got connection" ++ (show i)
        threadDelay 1
        returnConnection pl r 
        print "Returned connection"

type Pointer = Int

newtype ConnectionContext = ConnectionContext {
        unConnectionContext :: (Int, Connection)
    }

newtype ConnectionPool = ConnectionPool {
        unConnectionPool :: (TChan Pointer, TArray Int Connection) 
    }

initConnectionPool :: Int -> (IO Connection) -> IO ConnectionPool 
initConnectionPool n c = do 
            x <- newTChanIO 
            (xs, s) <- foldM step ([],x) [0..n]
            at <- atomically $ newListArray (0,n) xs :: IO (TArray Int Connection)
            return $ ConnectionPool (s, at)
    where step (z,s) a = do 
                x <- c
                atomically $ writeTChan s a
                return ((x : z), s)

reviveConnection :: ConnectionPool -> ConnectionContext -> IO ConnectionContext
reviveConnection p t@(ConnectionContext (i, c)) = catchSql (commit c >> return t) $ \e -> do 
                x <- clone c
                disconnect c
                atomically $ putConnection p i x 
                return (ConnectionContext (i, x))

putConnection :: ConnectionPool -> Int -> Connection -> STM ()
putConnection (ConnectionPool (_,ta)) i c = writeArray ta i c 


getConnection :: ConnectionPool -> IO ConnectionContext
getConnection x = do 
            c <- atomically $ unsafeGetConnection x 
            reviveConnection x c

returnConnection :: ConnectionPool -> ConnectionContext -> IO ()
returnConnection (ConnectionPool (pt, ta)) (ConnectionContext (i,c)) = atomically $ writeTChan pt i 
                    

unwrapContext :: ConnectionContext -> Connection
unwrapContext (ConnectionContext (i,c)) = c

unsafeGetConnection :: ConnectionPool -> STM ConnectionContext  
unsafeGetConnection (ConnectionPool (pt, ta)) = do 
                p <- readTChan pt
                x <- readArray ta p  
                return $ ConnectionContext (p, x) 

