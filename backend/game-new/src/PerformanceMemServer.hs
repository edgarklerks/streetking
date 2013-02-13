{-# LANGUAGE ViewPatterns #-}
module Main where 

import MemServerAsync 
import Control.Monad 
import Proto
import Control.Applicative
import Control.Concurrent 
import System.Random 
import qualified Data.ByteString.Char8 as B
import System.IO 
import System.IO.Unsafe 
import Control.Exception 
import Criterion.Main 

main = do 
        cs <- setupNodes 10 "tcp://127.0.0.1" 7001 6001
        xs <- take 1000 <$> generateData 0 1000000
        connectNodes cs 
        let ps = unsort cs 
        putStrLn "all nodes setup, starting tests" 
        threadDelay 100000
        defaultMain $ [
                          bench "strut" (whnfIO $ benchInsert (cycle ps  `zip` xs))
                      ]

        

benchInsert cs =  forM_ cs $ \(j,i) -> do 
                        runCommand j (insert (B.pack $ show i)  (B.pack $ show i))


unsort :: [a] -> [a] 
unsort (x:xs) = unsafePerformIO $ worker x xs 
    where worker x [] = return $ [x] 
          worker x (y:xs) = do 
                    b <- randomIO 
                    case b of 
                        True -> do 
                                rest <- worker x xs 
                                return $ y : rest  
                        False -> do
                                rest <- worker y xs 
                                return $ x : rest 


runCommand m c = silentCommand "tcp://127.0.0.1:23456"  (self m) c


fillingNodes :: [ProtoConfig] -> IO ()        
fillingNodes xs@(length -> n) = do 
                ns <- generateData 1 (fromIntegral n * 1000000)
                let bs = take (fromIntegral n * 10000) ns
                forM_ (bs `zip` cycle xs) $ \(n,i) -> do 
                            let ia = self i
                            let pr = 20012 + (3 * n) `mod` 10000 
                            silentCommand ("tcp://127.0.0.1:" ++ (show $ pr )) ia (insert (B.pack $ show n) (B.pack $ show n)) 


forkLimit :: (Eq a, Enum a, Num a) => MVar a -> IO () -> IO ()
forkLimit m a = do 
            x <- readMVar m 
            case x of 
                0 -> threadDelay 10000 >> forkLimit m a
                n -> modifyMVar m (\n -> return (pred n,())) >> void (forkIO $ do 
                                       s <- a `finally` releaseResource m
                                       s `seq` return ()
                               )    


releaseResource :: (Eq a, Enum a, Num a) => MVar a -> IO ()
releaseResource m = void $ modifyMVar_ m (return . succ) 
                              
    

sequencePar :: Int -> [IO ()] -> IO ()
sequencePar n xs = do 
                    s <- newMVar n
                    forM_ xs (forkLimit s)

forManyPar :: [a] -> (a -> IO ()) -> [IO ()]
forManyPar xs f = foldr step [] xs 
    where step x z = f x : z 

generateData :: Integer -> Integer -> IO [Integer]
generateData p n = do 
                s <- newStdGen 
                return $ randomRs (p,n) s
            



-- we set up a topology of N nodes with beginning port Control and Data 
--
setupNodes :: Integer -> String -> Integer  -> Integer -> IO [ProtoConfig] 
setupNodes n lc cp dp = 
        forM [0,2..2*(n - 1)] $ \i ->  do 
                putStrLn $  "connecting " ++ show i
                startNode (lc ++ ":" ++ show (cp + i)) (lc ++ ":" ++ show (dp + i)) $ "dump-" ++ show i 
                
   
-- connect them topological 
connectNodes :: [ProtoConfig] -> IO () 
connectNodes xs = forM_ cs $ \(i,j) -> do 
                            let ia = self i 
                            let ib = self j 
                            let ob = selfPull j 
                            p' <- randomRIO (10000,12000) :: IO Int  
                            let p = "tcp://127.0.0.1:" ++ show p'  
                            clientCommand p ia (advertise ib)
                            clientCommand p ib (advertise ia)
                            clientCommand p ia (dumpInfo)
                            clientCommand p ia (dumpInfo)


        where cs = (,) <$> xs <*> xs 
