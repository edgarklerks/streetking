{-# LANGUAGE BangPatterns #-}
module Main where 


import Control.Monad.Cont 
import Control.Monad
import System.Random 
-- import Criterion.Main 
import Test.QuickCheck
import Data.List 
import Control.Monad.CC


{--
test = callCC $ \error -> 
        callCC $ \exit -> do 
            forM_ [0..1000] $  \i -> do 
                    if i == 500 then exit (Right "found") else return () 
                    error  (Left "kaput")
                    return ()
            return (Left "not found")
--}
--
main = return ()
mergeSort [] = []
mergeSort [!x] = [x]
mergeSort [!x,!y] | x <= y = [x,y]
                | otherwise = [y,x]
mergeSort xs = let (ls,rs) = split xs 
               in merge (mergeSort ls) (mergeSort rs)
    where split :: [a] -> ([a], [a])
          split !(!x:(!y):xs) = let (!ls, !rs) = split xs 
                           in (x:ls, y:rs)
          split [!x] = ([x],[])
          split [] = ([],[]) 
          merge :: Ord a => [a] -> [a] -> [a] 
          merge (!x:xs) (!y:ys) | x <= y = x : merge xs (y:ys)
                              | otherwise = y : merge (x:xs) ys
          merge [] ys = ys 
          merge xs [] = xs
{--
main = do 
    quickCheck testProp 
    quickCheck testMerge 
    g <- newStdGen 
    let rs = randoms g :: [Int] 
    let gs = drop 1000 $ rs :: [Int] 
    let ts = drop 2000 $ gs :: [Int]
    let cs = [1..100000]
    let ds = reverse cs 
    let es = take 10000 $ repeat 5


    defaultMain [bgroup "insertSort" [
                    bench "10" (whnf insertSort $ take 10 rs),
                    bench "100" (whnf insertSort $ take 100 rs),
                    bench "1000" (whnf insertSort $ take 1000 gs),
                    bench "10000" (whnf insertSort $ take 10000 gs),
                    bench "100000" (whnf insertSort $ take 100000 gs),
                    bench "1000000" (whnf insertSort $ take 1000000 ts),
                    bench "correct" (whnf insertSort $ ds),
                    bench "reverse" (whnf insertSort $ cs),
                    bench "same" (whnf insertSort $ es)
                    ],
                    bgroup "sort" [
                    bench "10" (whnf sort $ take 10 rs),
                    bench "100" (whnf sort $ take 100 rs),
                    bench "1000" (whnf sort $ take 1000 gs),
                    bench "10000" (whnf sort $ take 10000 gs),
                    bench "100000" (whnf sort $ take 100000 gs),
                    bench "1000000" (whnf sort $ take 1000000 ts),
                    bench "correct" (whnf sort $ ds),
                    bench "reverse" (whnf sort $ cs),
                    bench "same" (whnf sort $ es)


                    ],
                    bgroup "mergesort" [ 
                    bench "10" (whnf mergeSort $ take 10 rs),
                    bench "100" (whnf mergeSort $ take 100 rs),
                    bench "1000" (whnf mergeSort $ take 1000 gs),
                    bench "10000" (whnf mergeSort $ take 10000 gs),
                    bench "100000" (whnf mergeSort $ take 100000 gs),
                    bench "1000000" (whnf mergeSort $ take 1000000 ts),
                    bench "correct" (whnf mergeSort $ ds),
                    bench "reverse" (whnf mergeSort $ cs),
                    bench "same" (whnf mergeSort $ es)

                    ]
                ]



testProp = property $ \xs -> 
        insertSort xs == sort (xs :: [Int]) 

testMerge = property $ \ys -> 
        sort ys == mergeSort (ys :: [Int])

insertSort =  {-# SCC insertSort #-} foldr insertH []

insertH :: Ord a => a -> [a] -> [a]
insertH (!a) [] = [a] 
insertH (!a) !(!x:xs) =  {-# SCC insertH #-} 
                case (compare a x) of 
                            EQ -> a:x:xs
                            GT -> x : insertH a xs
                            LT -> a:x:xs
                            --}
