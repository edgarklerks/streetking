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

main :: IO ()
main = do 
        xs <- getArgs 
        ss <- C.readFile (xs !! 0)
        let ml = read (xs !! 1) :: Double
        let cell = (C.last ss) `deepseq` decode (B.fromChunks [ss]) 
        let ps = mergeCells ml $ mergeCells ml cell 
        last ps `seq` encodeFile (xs !! 0) ps  


mergeCells :: Double -> [Cell] -> [Cell] 
mergeCells ml xs = removeSmall ml $  (sconcat . N.fromList) <$> groupCells xs  

removeSmall :: Double -> [Cell] -> [Cell]
removeSmall ml = filter (\c -> arclength c > ml && (fromMaybe 0 $ radius c) /= 0) 

groupCells :: [Cell] -> [[Cell]]
groupCells = groupBy groupd 
    where groupd a b = ra == rb || abs ( 1 - (rb / ra) ) < 0.3
            where ra = fromMaybe 0 (radius a)
                  rb = fromMaybe 0 (radius b)





