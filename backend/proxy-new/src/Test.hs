{-# LANGUAGE TypeOperators, ScopedTypeVariables, RankNTypes, ViewPatterns #-}
module Main where 

import MemServerAsync
import System.ZMQ
import Control.Monad hiding (forM_)
import Data.ExternalLog 
import Control.Applicative 
import Data.Monoid
import Data.Foldable
import Proto
import Data.Functor.Compose
import Control.Concurrent 
import qualified System.ZMQ as Z
import qualified Data.ByteString.Char8 as B 
import System.IO.Unsafe 
import System.Random 


data ConfigShit = ConfigShit {
        _ctx :: Context,
        _addr :: NodeAddr,
        _pull :: Z.Socket Z.Pull,
        _req :: Z.Socket Z.Req,
        _pc :: ProtoConfig 
    }   

sendQuery :: ConfigShit -> Proto -> IO Proto 
sendQuery c r = do 
        let a =  _addr c
        let p = _pull c 
        let rq = _req c 
        let pc = _pc c 
        res <- queryNode pc p rq a r 
        return res 

createQueryNode :: NodeAddr -> NodeAddr -> NodeAddr -> IO ConfigShit 
createQueryNode ctr dta localaddr = do 
                ls <- initCycle "ipc://asdfasdasdsad"
                s <- startNode ls ctr dta "test-dump-test.hs"  
                ctx <- Z.init 1 

                pu <- Z.socket ctx Pull 
                Z.bind pu localaddr 

                req <- Z.socket ctx Req 
                Z.connect req ctr 
                return $ ConfigShit ctx localaddr  pu req s  


createNode :: Cycle -> FilePath -> Address -> Address -> IO ProtoConfig 
createNode cyc fp ctrl dta = startNode cyc ctrl dta fp 



createNodes :: [Cycle] -> Int -> Int -> FilePath -> Address -> IO [ProtoConfig]
createNodes cyc ct dt fp a = forM (cyc `zip` [ct..] `zip` [dt..]) $ \((x,p),d) -> do 
                        let ctr = show p 
                        let dta = show d

                        createNode x (fp ++ "_" ++ ctr) (a ++ ":" ++ ctr) (a ++ ":" ++ dta)



testP2P :: Int -> IO [(Cycle, ProtoConfig)]
testP2P n | n > 1000 = error "only thousand instances allowed"
          | otherwise = do 
               let listener = 4000
               let ctrl = 5000
               let dts = 6000
               let tcp = "tcp://192.168.4.9"
               let fp = "test_dump"
                
               xs <- forM [listener .. (listener + n)] $ \x -> 
                        initCycle (tcp ++ ":" ++ (show x))
               ys <- createNodes xs ctrl dts fp tcp 
               
               return $ xs `zip` ys
-- ctrl = addres 
-- dta = addr 
-- addrs = self
-- add = selfPull 
-- self = incoming 
-- selfPull = outgoing 


chainNodes :: [(Cycle, ProtoConfig)] -> IO ()
chainNodes cps = void $ flip circularM cps $ \(cycle1,config1) (cycle2, config2) -> do 
                            let ctrl1 = self config1 
                            let dta1 = selfPull config1
                            let ctrl2 = self config2
                            let dta2 = selfPull config2
                            putStrLn $ "chaining " <> ctrl1 <> " <==> " <> ctrl2
                            silentCommand "tcp://192.168.4.9:3242" ctrl2 (advertise ctrl1) 
                            clientCommand "tcp://192.168.4.9:3242" ctrl2 (dumpInfo) 
                            silentCommand "tcp://192.168.4.9:3242" ctrl1 (advertise ctrl2) 
                            clientCommand "tcp://192.168.4.9:3242" ctrl1 (dumpInfo) 

densifyNetwork :: [(Cycle, ProtoConfig)] -> IO ()
densifyNetwork xs = forM_ xs $ \(_, c) -> let ctrl = self c 
                                          in silentCommand "tcp://192.168.4.9:3242" ctrl (sync)


unsort :: [a] -> [a] 
unsort = unsafePerformIO . unsort' 

unsort' :: [a] -> IO [a] 
unsort' xs = unsortPlc [] xs 
    where unsortPlc ls [] = return ls  
          unsortPlc ls (r:rs) = do 
                            x <- randomRIO (0,1 :: Int)
                            case x of 
                                0 -> unsortPlc (r:ls) rs 
                                1 -> unsortPlc ls (rs ++ [r])

showNetwork :: [(Cycle, ProtoConfig)] -> IO ()
showNetwork xs = forM_ xs $ \(_, c) -> let ctrl = self c in 
                    do 
                        putStrLn $ "dumping node " <> ctrl  
                        clientCommand "tcp://192.168.4.9:3242" ctrl (dumpInfo)

setupNetwork :: Int -> Int -> [ConfigShit] -> IO [(Cycle, ProtoConfig)]
setupNetwork p n cs = do 
            xs <- testP2P n 
            putStrLn "Setup nodes"
            let mps = fmap (\x -> (undefined, _pc x)) cs 
            chainNodes (mps ++ xs ++ mps) 
            chainNodes (unsort $ mps ++ xs ++ mps) 
            chainNodes (unsort $ mps ++ xs ++ mps) 
            putStrLn "Chained nodes"
            replicateM_ p $ densifyNetwork xs 
            putStrLn "Densify network"
            pushingData 1000 xs 
            putStrLn "pushing data"
            showNetwork xs 
            putStrLn "shown network"
            putStrLn "done setup"
            putStrLn "setting up node"

            return xs


main :: IO ()
main = do 
    x <- createQueryNode "tcp://192.168.4.9:4244" "tcp://192.168.4.9:5231" "tcp://192.168.4.9:6234"
    y <- createQueryNode "tcp://192.168.4.9:4245" "tcp://192.168.4.9:5232" "tcp://192.168.4.9:6235"
    z <- createQueryNode "tcp://192.168.4.9:4246" "tcp://192.168.4.9:5233" "tcp://192.168.4.9:6236"
    (xs) <- setupNetwork 10 20 [x,y,z] 
    clientCommand "tcp://192.168.4.9:3212" "tcp://192.168.4.9:5010" (advertise "tcp://192.168.4.9:4244")
    clientCommand "tcp://192.168.4.9:3212" "tcp://192.168.4.9:5011" (advertise "tcp://192.168.4.9:4245")
    clientCommand "tcp://192.168.4.9:3212" "tcp://192.168.4.9:5012" (advertise "tcp://192.168.4.9:4246")
    forkIO $ startQueries undefined  x 1000 xs 
    forkIO $ startQueries undefined y 1000 xs 
    forkIO $ startQueries undefined z 1000 xs 
    threadDelay 100000000
    print "Done"
    


pushingData :: Int -> [(Cycle, ProtoConfig)] -> IO [B.ByteString]
pushingData n xs = forM (cycle xs `zip` [0..n]) $ \(self . snd -> n, (B.pack . show -> x)) -> do 
                                                            silentCommand "tcp://192.168.4.9:3242" n (insert x x)
                                                            return x 

                                    
                              
-- runs a cross product of all the queryable keys with the configs  
startQueries :: MVar () -> ConfigShit -> Int -> [(Cycle, ProtoConfig)] -> IO ()
startQueries _ cfs n xs = let cs = (snd <$> (xs `zip` [0..n])) in  do
                        forever $ 
                            forM_ cs $ \(B.pack . show -> p) -> do
                                    sendQuery cfs (query 100 p)
                                        
                                                  

chain :: (a -> a -> b) -> [a] -> [b]
chain f [] = []
chain f [a] = [] 
chain f [x,y] = [f x y]
chain f (x:y:xs) = f x y : chain f (y:xs)

circular :: (a -> a -> b) -> [a] -> [b] 
circular f [] = [] 
circular f [a] = [] 
circular f (x:xs) = circular' x xs 
    where circular' n (x:y:xs) = f x y : circular' n (y:xs)
          circular' n [x] = [f n x]
          circular' n [] = [] 


chainA :: (Applicative m) => (a -> a -> m b) -> [a] -> m [b]
chainA f [] = pure mempty 
chainA f [a] = pure mempty 
chainA f [x,y] = pure <$> f x y
chainA f (x:y:xs) = (:) <$> f x y <*> chainA f (y:xs) 

circularA :: (Applicative f) => (a -> a -> f b) -> [a] -> f [b]
circularA f [] = pure [] 
circularA f [a] = pure [] 
circularA f (x:xs) = circularA' x xs 
    where circularA' n (x:y:xs) = (:) <$> f x y <*> circularA' n (y:xs)
          circularA' n [x] = pure <$> f n x 
          circularA' n [] = pure [] 

type AppList f a = Compose f [] a 

crossM :: Monad m => (a -> a -> m b) -> [a] -> m [b] 
crossM f xs = sequence $ f `liftM` xs `ap` xs 

chainM :: Monad m => (a -> a -> m b) -> [a] -> m [b] 
chainM f [] = return mempty 
chainM f [a] = return mempty 
chainM f [x,y] = do 
            a <- f x y 
            return [a] 
chainM f (x:y:xs) = do 
            rest <- chainM f (y:xs) 
            a <- f x y 
            return (a : rest)

circularM :: Monad m => (a -> a -> m b) -> [a] -> m [b]
circularM f [] = return [] 
circularM f [x] = return [] 
circularM f (x:xs) =  circularM' x (x:xs)
        where circularM' n (x:y:xs) = do 
                                rest <- circularM' n (y:xs)
                                a <- f x y 
                                return (a:rest)
              circularM' n [x] = do 
                        a <- f n x 
                        return [a]
              circularM' n [] = return []

    
    
        



