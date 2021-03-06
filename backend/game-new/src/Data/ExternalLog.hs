-- | Small module for logging to an external party 
module Data.ExternalLog where 

import System.ZMQ3
import Control.Concurrent.STM 
import Control.Concurrent 
import Control.Monad
import Data.Monoid 
import Data.ByteString.Char8 (pack)


type Address = String 
type Name = String 
data Cycle = Cycle {
        cycleChannel :: TQueue (String, String),
        threadId :: ThreadId 
    }

reportCycle :: Cycle -> String -> String -> IO ()
reportCycle a group component = atomically $ writeTQueue (cycleChannel a) (group, component) 


initCycle :: Address -> IO Cycle 
initCycle a = do 
        q <- newTQueueIO 
        tid <- forkIO $ withContext $ \c -> withSocket c Pub $ \s -> do 
                bind s a  
                forever $ do 
                    (g, p) <- atomically $ readTQueue q
                    send s [] (pack $ g <> " " <> p)
        return $ Cycle q tid 

