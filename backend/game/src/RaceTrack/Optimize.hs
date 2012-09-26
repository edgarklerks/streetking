module Main where 

import Vector
import Cell 
import qualified Data.ByteString.Lazy as B
import qualified Data.ByteString as C
import Data.Binary 
import System.Environment
import Control.Applicative
import Data.List 
import Data.Maybe
import Data.Semigroup
import qualified Data.List.NonEmpty as N
import Control.DeepSeq
import Control.Monad
import Debug.Trace
import Control.Monad.Fix 

main :: IO ()
main = do 
        xs <- getArgs 
        ss <- C.readFile (xs !! 0)
        let ml = read (xs !! 1) :: Double
        let rl = read (xs !! 2) :: Double 
        let cell = decode (B.fromChunks [ss]) 
        let ps = mergeCells ml rl $ mergeCells ml rl cell 
        encodeFile (xs !! 0) ps  


mergeCells :: Double -> Double -> [Cell] -> [Cell] 
mergeCells ml rl xs = (sconcat . N.fromList) <$> groupCells xs  

removeSmall :: Double -> [Cell] -> [Cell]
removeSmall ml = filter (\c -> arclength c > ml && (fromMaybe 0 $ radius c) /= 0) 

groupCells :: [Cell] -> [[Cell]]
groupCells = groupBy groupd 
    where groupd a b = ra == rb -- || abs ( 1 - (rb / ra) ) < 0.3
            where ra = fromMaybe 0 (radius a)
                  rb = fromMaybe 0 (radius b)


newtype CC r a = CC {
            runCC :: (a -> r) -> r
        }

instance Functor (CC r) where 
    fmap f m = CC $ \k -> runCC m (k . f)

instance Monad (CC r) where 
    return a = CC $ \k -> k a
    (>>=) m f = CC $ \k -> runCC m (\a -> runCC (f a) k)

-- callCC :: ((a -> CC r b) -> CC r a) -> CC r a
-- f :: (a -> m b) -> m a
-- k :: a
--
callCC f = CC $ \h -> runCC (f $ \k -> CC $ \l -> h k) h


abort :: s -> CC s a 
abort s = CC $ const s

teststate = do 
        callCC $ \exit -> contain $ do
                a <- rp 
                forM_ [1..100] $ \i -> do
                        traceShow i $ when (i == 50) $ abort "alles is kapu"
                        rp 

fixFold g = fix step 
    where step f z (x:xs) = g (f z xs) x
          step f z [] = z

fixLength = fix step 
    where   step f [] = 0 
            step f (x:xs) = 1 + f xs 

rp = CC $ \k -> fix k

contain m = CC $ \k -> runCC (CC $ \_ -> runCC m k) k 
forM' [] f = return []
forM' (x:xs) f = do 
                a <- f x
                rest <- forM' xs f 
                return (a : rest)

b = do 
        x <- [1..1000]
        y <- [1..1000]
        guard ((x*y) `mod` 3 == 0 && x `mod` 7 == 0 && y `mod` 5 == 0)
        [x,y]

-- data PauseMonad dda = Yield a | Pause (PauseMonad a)
                
test = do 
    callCC $ \exit -> do 
            forM' [1..100] $ \i ->
                do
                        if (i == 50) 
                            then exit i 
                            else return 1
            return 2 


-- m :: CC r a => ((a -> r) -> r)
-- h :: (a -> r) 
-- runCC :: CC r a -> (a -> r) -> r 
-- f :: a -> CC r a 
-- (a -> r)

ccid :: CC r a -> CC r a 
ccid m = CC $ \k -> (runCC m k)



