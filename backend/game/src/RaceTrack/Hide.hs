module Main where 

import Image
import Color 
import Codec.Image.DevIL
import Data.Complex
import Data.Char
import Vector 
import System.Environment 
import qualified Data.ByteString as B 

main :: IO ()
main = do 
    [x,y] <- getArgs 
    ps <- B.readFile x
    writeBytes y ps 

writeBytes fp xs = ilInit >> 
    (saveImage fp . colorCutImage . vectorToImage . transformBytes) xs

writeText fp xs = ilInit >> dumpText fp xs 

dumpText :: FilePath -> String -> IO () 
dumpText fp = saveImage fp . colorCutImage .  vectorToImage . transformText 

bakeImage :: [Vector (Complex Double)] -> VectorImage 
bakeImage xs = mkVector n n $ let x | odd n' = xs ++ [(mk41 (0,0,0,0))]
                                    | even n' = xs 
                              in x ++ replicate (n * n - 2 * n) (mk41 (0,0,0,0)) 
        where   n' = length xs 
                n | even n' = n' `div` 2 
                  | odd n' = (n' + 1) `div` 2 

transformBytes :: B.ByteString -> VectorImage 
transformBytes = bakeImage . mk4VectorW8 . B.unpack 

transformText :: String -> VectorImage 
transformText = bakeImage . mk4Vector  

mk4Vector :: String -> [Vector (Complex Double)]
mk4Vector = fmap (mkVector 4 1) . groupFour . fmap (fromIntegral . ord)

mk4VectorW8 :: [Word8] -> [Vector (Complex Double)]
mk4VectorW8  = fmap (mkVector 4 1) . groupFour . fmap fromIntegral 


groupFour :: Num a => [a] -> [[a]]
groupFour [] = []
groupFour [x] = [[x,0,0,0]]
groupFour [x,y] = [[x,y,0,0]]
groupFour [x,y,z] = [[x,y,z,0]]
groupFour xs = take 4 xs : groupFour (drop 4 xs)
