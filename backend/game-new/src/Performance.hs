module Main where 


import Criterion.Main
import Data.MemTimeState 
import qualified Data.ByteString.Char8 as B 
import Control.Concurrent.STM 
import Control.Concurrent 
import Control.Monad 
import Control.Applicative 
import System.Random 
import Criterion.Main 
import Data.SqlTransaction
import Model.General 
import qualified Model.Account as A 
import Data.Maybe 


main = do
    xs <- fmap (fromJust . A.id) <$> getAccountIds 
    defaultMain [
        bench "sql query account " (whnfIO $ sqlQueryAccount xs)
        ]

getAccountIds :: IO [A.Account]
getAccountIds = runTestDb $ search [] [] 1000 0 :: IO [A.Account]

sqlQueryAccount :: [Integer] -> IO ()
sqlQueryAccount xs = runTestDb $ do 
                forM_ xs $ \i -> do 
                        load i :: SqlTransaction Connection (Maybe A.Account)
            
mainP2P = do 
    qc <- init_query 'a'
    let ps = take 10000 $ ((B.pack . show <$> [0..]) `zip` (B.pack . show <$> [0..]))
    defaultMain $ [
                        bench "search performance 10000 queries empty" (search_query qc ps),
                        bench "insert performance 10000 inserts" (insert_query qc ps),
                        bench "search performance 10000 queries" (search_query qc ps)
                  ]

insert_query qc ps = forM_ ps $ \(key,v) -> do 
                res <- runQuery qc (Insert key v)
--                rus <- runQuery qc (Query key)
                return ()


search_query qc ps = forM_ ps $ \(key, v) -> do 
                            res <- runQuery qc (Query key) 
                            when (Value v /= res && res /= NotFound) $ error $ show res 
                            return ()

init_query c = do 
        ms <- newMemState (1000 * 1000 * 1000 * 60 * 60) (6000 * 1000 * 1000) (c : "testshitas")
        qc  <- newTChanIO
        forkIO $ queryManager (c : "testshitas") ms qc
        return qc 
