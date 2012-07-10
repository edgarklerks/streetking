module Main where 

import Color 
import Image 
import Vector 
import Cell 

import Data.List 
import Data.Binary 
import Data.Maybe 
import Control.Monad.Fix
import qualified Data.ByteString.Lazy as B 
import Control.Applicative
import Control.Applicative

main :: IO ()
main = do 
    xs <- calculateCells "segments.bin"
    B.writeFile "cells.bin" (encode xs)

instance Show Cell where 
    show (Cell b e c r a) = "\n[\nbounds: \n" ++ (pmatrix b ++ "\n" ++ pmatrix e) ++ "\ncurvature: " ++ (show c) ++ "\narclength: " ++ (show a) ++ "\nradius:" ++ (show r) ++ "\n]"
loadSegments :: FilePath -> IO [[Vector Double]]
loadSegments = fmap decode . B.readFile  

calculateCells = fmap getCellParameters . loadSegments 

-- calcCurvatures :: [[Vector Double]] -> [(Vector Double, Maybe Double)]
calcCurvatures xs = fmap (\x -> averageCurvature x) xs

calcArcLengths xs = fmap (\x -> arcLength x) xs 


getCellParameters :: [[Vector Double]] -> [Cell] 
getCellParameters xs = zipWith5 Cell begins  ends  curv ((fmap.fmap) (1/) curv)  arcl
        where arcl = calcArcLengths  xs
              curv = calcCurvatures  xs
              begins = head <$> xs 
              ends = last <$> xs 

average [] = Nothing 
average xs = Just $ sum xs / genericLength xs  


averageCurvature :: [Vector Double] -> Maybe Double 
averageCurvature = average . catMaybes . curvatures


curvatures :: [Vector Double] -> [Maybe Double]
curvatures (x1:x2:x3:x4:x5:xs) = ((fromScalar . magnitude) <$> secondStepDifferenceVector ([x1,x2,x3,x4,x5]))  : curvatures (x2:x3:x4:x5:xs)
curvatures xs = replicate (length xs) Nothing

arcLength :: [Vector Double] -> Double 
arcLength [] = 0
arcLength [a] = 1
arcLength (x:y:xs) = (fromScalar $ magnitude (y - x)) + arcLength (y:xs)
