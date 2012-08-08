{-# LANGUAGE FlexibleInstances, OverloadedStrings, GADTs #-} 
module Main where 

import Network.HTTP.Enumerator
import Control.Concurrent.Chan
import Control.Concurrent
import Control.Monad 
import Control.Applicative
import Control.DeepSeq
import System.Random 
import Data.Aeson
import Network.HTTP.Types
import Network.HTTP.Enumerator
import qualified  Data.ByteString.Lazy.Char8 as C
import qualified  Data.ByteString.Char8 as B
import qualified Data.Map as M
import qualified Data.Text as T
import Data.CaseInsensitive hiding (map)
import Control.DeepSeq
import qualified System.Random as R
import Control.Monad.Operational
import Data.List.Stream
import Prelude hiding ((++), null, foldr, length, (!!), map, tail, head)
type Gen = R.StdGen

data RandomIns g a where     
    Uniform :: [a] -> RandomIns g a
    Split :: RandomIns g g
    Seed :: Int -> RandomIns g ()

data DrawPool s a where 
    Draw :: DrawPool s s


data Cards = Clubs SubType 
           | Diamonds SubType
           | Hearts SubType  
           | Spades SubType
    deriving (Show, Eq, Ord)


data SubType = Two 
             | Three 
             | Four 
             | Five 
             | Six 
             | Seven 
             | Eight 
             | Nine 
             | Ten
             | Jack 
             | Queen
             | King 
             | Ace 
    deriving (Show, Enum, Eq, Ord)

viewValue (Clubs x) = x
viewValue (Diamonds x) = x 
viewValue (Hearts x) = x
viewValue (Spades x) = x

blackjack :: Cards -> Cards -> Bool 
blackjack (viewValue -> Ace) (viewValue -> Ten) = True
blackjack (viewValue -> Ace) (viewValue -> Queen) = True
blackjack (viewValue -> Ace) (viewValue -> King) = True
blackjack (viewValue -> Ace) (viewValue -> Jack) = True
blackjack (viewValue -> Ace) (viewValue -> Ace) = False
blackjack x y@(viewValue -> Ace) = blackjack y x
blackjack x y = False


data Hand = Hand [Int]
    deriving (Ord, Eq, Show)

cardValue :: Cards -> Int 
cardValue (viewValue -> x) = case x of 
                                Ace -> error "Can be both" 
                                King -> 10 
                                Queen -> 10 
                                Jack -> 10 
                                Ten -> 10 
                                Nine -> 9 
                                Eight -> 8
                                Seven -> 7 
                                Six -> 6
                                Five -> 5
                                Four -> 4
                                Three -> 3
                                Two -> 2

emptyHand :: Hand 
emptyHand = Hand []
hand :: Cards -> Hand -> Hand
hand (viewValue -> Ace) (Hand []) = Hand [1,11]
hand (viewValue -> Ace) (Hand xs) = Hand [ x + y | x <- xs, y <- [1,11]]
hand (cardValue -> x) (Hand []) = Hand $ [x]
hand (cardValue -> x) (Hand xs) = Hand $ map (+x) xs


deck :: [Cards] 
deck = [f s | s <- [Two ..Ace], f <- [Clubs, Diamonds, Hearts, Spades]]

draw :: Draw s s
draw = singleton Draw 

uniform :: [a] -> RandomList g a
uniform = singleton . Uniform


split :: RandomList g g 
split = singleton Split

seed :: Int -> RandomList g ()
seed = singleton . Seed 

type RandomList g a = Program (RandomIns g) a
type Draw s a = Program (DrawPool s) a

sample :: RandomList Gen a -> Gen -> (a, Gen) 
sample xs = eval (view xs) 
    where eval :: ProgramView (RandomIns Gen) a -> Gen -> (a, Gen) 
          eval (Uniform xs :>>= ls ) s = let (k, g) = R.randomR (0, length xs - 1) s 
                                         in sample (ls $ xs !! k) g
          eval (Return a)            s = (a,s)
          eval (Split :>>= ls)       s = let (g,g') = R.split s
                                         in sample (ls g') g
          eval (Seed i :>>= ls)      s = let g = R.mkStdGen i
                                         in sample (ls ()) g


type Probability = Rational

runDistribution :: (Ord a, Eq a) => RandomList () a -> [(Probability, [a])]
runDistribution = concatDistribution . distribution

distribution :: (Ord a, Eq a) => RandomList () a -> [(Probability, a)] 
distribution = sortBy (\x y -> fst y `compare` fst x) . sumDist . eval . view 
    where eval :: (Ord a, Eq a) => ProgramView (RandomIns ()) a -> [(Probability, a)]
          eval (Return a) = [(1, a)]
          eval (Uniform xs :>>= ls) = [ (p / n, a) | x <- xs, (p, a) <- distribution (ls x)  ]
                    where n = fromIntegral $ length xs
          eval (Split :>>= ls) = distribution (ls ())
          eval (Seed i :>>= ls) = distribution (ls ())
          sumDist = map step . groupBy (\x y -> snd x == snd y) . sortBy (\x y -> snd x `compare` snd y)
                where step (x:xs) = foldr addProb x xs 
                        where addProb (p,_) (p',a) = (p + p', a)

concatDistribution ::  [(Probability, a)] -> [(Probability, [a])]
concatDistribution = map step . groupBy (\x y -> fst x == fst y)   . sortBy (\x y -> fst y `compare` fst x) 
                where step ((p, x):xs) = foldr addProb (p, [x]) xs
                        where addProb (_, a) (p, xs) =  (p,a:xs)

runPool :: (Eq s, Eq a, Ord a) => Draw s a -> [s] -> [(Probability, a)]
runPool xs = sumDist . eval (view xs)
    where eval :: (Eq s, Eq a, Ord a) => ProgramView (DrawPool s) a -> [s] -> [(Probability, a)]
          eval (Return a) xs = [(1, a)]
          eval (Draw :>>= ls) xs = do 
                                 x <- xs
                                 (p, a) <- runPool (ls x) (xs \\ [x])
                                 return (p / n, a) 
                where n = fromIntegral $ length xs
          sumDist = map step . groupBy (\x y -> snd x == snd y) . sortBy (\x y -> snd x `compare` snd y)
            where step xs = foldr addProb (head xs) (tail xs)
                    where addProb (p,_) (p', a) = (p + p', a)

drawCards h = do 
    x <- draw
    y <- draw
    z <- draw
    return $ z `hand` (x `hand` (y `hand` h))

throwDice = do 
      x <- uniform [1..6]
      y <- uniform [1..6]
      return (x + y)

instance Show (IO a) where 
        show _ = "<<Action>>"



type In a = Chan (TIn a)
type Out a = Chan (TOut a)

type Job a =  IO a
type Jobs a = [Job a]

data TIn a = Start !(Job a)
            | Wait  
            | Stop 
    deriving Show 

data TOut a = Result !Int !a
            | Exit !Int  
    deriving Show 

main :: IO ()
main = forever (manyRegister >> threadDelay 10000)


{-- Tests for the proxy --}

-- | register as many users a fast as possible 

manyEmail :: IO [String]
manyEmail = do 
    s <- newStdGen 
    let (p,_) = randomR (1,100000 :: Int) s
    let randoms = flip map [1..10] $ \i -> do 
            let es = show $ i * p
            let ts = show $ i * 7 * p
            return (es ++ "@" ++ ts ++ ".com") 
    startThreads 10 randoms 


manyRegister = do 
    es <- manyEmail
    req <- req
    m <- newManager
    token <- responseHeaders <$> (reqLogin >>= \x -> httpLbs x m )
    closeManager m
    let ck = findCookies token :: (CI B.ByteString, B.ByteString)
    forM_ (es) $ \e -> forkIO $ do 
            m <- newManager
            let body' = body e "foobar"
            catch (
                do
                   xs <- httpLbs   (req { requestBody = RequestBodyLBS (C.pack body'), method = "POST", requestHeaders =   ck : requestHeaders req}) m
                   return ()
                ) (\e ->  print e >> return ()) 
            closeManager m
            return ()
        where req = parseUrl "http://127.0.0.1:9124/User/register"
              body e p = C.unpack $ encode $ M.insert ("email" :: String) (e) $ M.insert ("password") (p) $  M.empty 
              reqLogin = parseUrl $ "http://localhost:9124/Application/identify?token="  ++ "JLQQT3OQAT2WBZNF6QAORQJRBMHUKN4MO5IHFFI="
              findCookies (("Set-Cookie", xs):ys) = (foldCase "cookie", xs)
              findCookies (x:xs) = findCookies xs


fib 0 = 1 
fib 1 = 1
fib n = fib (n - 1) + fib (n - 2)

-- | Concurrent calculate fibonacci
manyFibs :: IO [Integer] 
manyFibs = do 
   startThreads 3 $ (return.fib) <$> [10..20] ++ [10..30] 

-- | Compute joblist with N concurrent threads, give back results

startThreads :: (Show a) => Int -> Jobs a -> IO [a]
startThreads n xs = do 
            o <- newChan
            i <- newChan
            forM_ [0..n] (\n -> forkIO  (startThread i o n))
            startSupervisor xs [] i o  [0..n] 

-- | Starts the worker pool 

startSupervisor :: (Show a) => Jobs a -> [a] -> In a -> Out a -> [Int] -> IO [a]
startSupervisor [] rs i o ns = do 
            forM_ ns $ const (writeChan i Stop)
            waitOnDead o [] rs
    where waitOnDead o xs rs = do 
                   x <- readChan o 
                   case x of 
                    Result i r -> waitOnDead o xs (r:rs)  
                    Exit i -> do  
                            case null (ns \\ (i:xs)) of 
                                     True -> print (show $ length rs) >> return rs 
                                     False -> waitOnDead o (i:xs) rs 
startSupervisor (x:xs) rs i o ns = do 
                let j = Start x 
                writeChan i j   
                x <- readChan o 
                case x of 
                    Result p r -> startSupervisor xs (r:rs) i o ns 
        
            
        
-- | Starts the worker thread, accepting jobs from the supervisor 
startThread :: (Show a) => In a -> Out a -> Int -> IO ()  
startThread i o n = do 
           y <- readChan i  
           case y of 
                Start f -> do         
                        r <- f
                        writeChan o (Result n r)
                        startThread i o n 
                Wait -> threadDelay 100 >> startThread i o n
                Stop -> void $ writeChan o (Exit n)

