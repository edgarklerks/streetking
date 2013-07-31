module Data.ConnectionPool where 

import Control.Monad
import Database.HDBC.PostgreSQL
import Database.HDBC 
import Control.Concurrent.STM 
import Control.Concurrent.STM.TArray
import Control.Concurrent 
import Data.Array.MArray
import Data.Time.Clock
import Data.Time.Clock.POSIX

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
data ConnectionBucket = Empty Connection Int  
                      | Filled Connection

instance Show ConnectionBucket where 
        show (Empty _ _) = " |_| "
        show (Filled _) = " |*| "
                        
newtype ConnectionPool = ConnectionPool {
        unConnectionPool :: (TQueue Pointer, TArray Int ConnectionBucket) 
    }

initConnectionPool :: Int -> (IO Connection) -> IO ConnectionPool 
initConnectionPool n c = do 
            x <- newTQueueIO 
            (xs, s) <- foldM step ([],x) [0..n]
            at <- atomically $ newListArray (0,n) xs :: IO (TArray Int ConnectionBucket)
            let cp = ConnectionPool (s, at)
            initConnectionReclaimer cp undefined
            return cp 
    where step (z,s) a = do 
                x <- c
                atomically $ writeTQueue s a
                return (((Filled x) : z), s)

emptyConnectionBucket :: ConnectionPool -> Int -> Int -> STM ()
emptyConnectionBucket (ConnectionPool (x,a)) i n = do 
                        x <- readArray a i 
                        case x of 
                            (Filled c) -> writeArray a i (Empty c n)
                            _ -> error "Empty connection bucket" 

fillConnectionBucket :: ConnectionPool -> Int -> STM ()
fillConnectionBucket (ConnectionPool (x,a)) i = do 
                    x <- readArray a i
                    case x of 
                        (Empty c _) -> writeArray a i (Filled c)
                        (Filled c) -> writeArray a i (Filled c)

--                        error "Filled connection bucket"

reviveConnection :: ConnectionPool -> ConnectionContext -> IO ConnectionContext
reviveConnection p t@(ConnectionContext (i, c)) = catchSql (commit c >> return t) $ \e -> do 
                x <- clone c
                forkIO $ do 
                    disconnect c
                    atomically $ putConnection p i x 
                commit x
                return (ConnectionContext (i, x))

putConnection :: ConnectionPool -> Int -> Connection -> STM ()
putConnection (ConnectionPool (_,ta)) i c = writeArray ta i (Filled c) 


getConnection :: ConnectionPool -> IO ConnectionContext
getConnection x = do 
            e <- (fmap truncate getPOSIXTime) :: IO Int
            c <- atomically $ unsafeGetConnection x e
            reviveConnection x c

returnConnection :: ConnectionPool -> ConnectionContext -> IO ()
returnConnection t@(ConnectionPool (pt, ta)) (ConnectionContext (i,c)) = do 
    commit c
    atomically $ (writeTQueue pt i >> fillConnectionBucket t i)
                    

unwrapContext :: ConnectionContext -> Connection
unwrapContext (ConnectionContext (i,c)) = c

unsafeGetConnection :: ConnectionPool -> Int -> STM ConnectionContext  
unsafeGetConnection t@(ConnectionPool (pt, ta)) e = do 
                p <- readTQueue pt
                (Filled x) <- readArray ta p  
                emptyConnectionBucket t p e
                return $ ConnectionContext (p, x) 

initConnectionReclaimer :: ConnectionPool -> Int -> IO ThreadId
initConnectionReclaimer pl i = forkIO $ forever $ do 
        threadDelay (1000 * 100 * 1)

