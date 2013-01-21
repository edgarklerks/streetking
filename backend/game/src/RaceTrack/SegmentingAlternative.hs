module Main where  

import System.Environment 
import Control.Applicative 
import Vector 
import Color 
import Image 
import Codec.Image.DevIL
import Data.Complex 
import Path 
import Data.Binary
import qualified Data.ByteString.Lazy as B
import Data.Array.Base


main = do 
    ilInit
    [fp,s] <-  getArgs 

    p <- loadPath "dump.bin"
    v <- loadVector fp    
    B.writeFile "segments.bin" $ encode $ groupSizeOf (read s) $ elems $ path p  

    return ()

-- | Second parameter is only a type witness 
loadDump :: Binary a => FilePath -> a -> IO (Vector a, [Vector a])
loadDump fp _ = do (s,xs) <- decode <$> B.readFile fp  
                   return (mk11 s, mk21 <$> xs) 
    
groupSizeOf :: Int -> [a] -> [[a]]
groupSizeOf n [] = [] 
groupSizeOf n xs = take n xs : groupSizeOf n (drop n xs)

_L :: a
_L = undefined 

loadPath :: FilePath -> IO Path 
loadPath fp = do 
            (st, ds) <- loadDump fp  (_L :: Int)  
            let n = length ds 
            return $ Path (fromIntegral <$> st) (array (1, n) $ [1..n] `zip` (
                 ((fmap fromIntegral)) <$> ds
                ))


