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
import Debug.Trace 
import Debug.Trace.Helpers 

main :: IO ()
main = do 
    xs <- calculateCells "segments.bin"
    print "hello"
    B.writeFile "cells.bin" (encode xs)

instance Show Cell where 
    show (Cell b e xs c r a) = "\n[\nbounds: \n" ++ (pmatrix b ++ "\n" ++ pmatrix e) ++ "\ncurvature: " ++ (show c) ++ "\narclength: " ++ (show a) ++ "\nradius:" ++ (show r) ++ "\n]"

arc :: Cell -> Double
arc c = f (radius c) (arclength c)
    where
        f Nothing _ = 0
        f (Just r) a = a/r

loadSegments :: FilePath -> IO [[Vector Double]]
loadSegments = fmap decode . B.readFile  

calculateCells = fmap getCellParameters . loadSegments 

-- calcCurvatures :: [[Vector Double]] -> [(Vector Double, Maybe Double)]
calcCurvatures xs = fmap (\x -> traceShow x $ averageCurvature x) xs

calcArcLengths xs = fmap (\x -> arcLength x) xs 

invert :: (Eq a, Ord a, Fractional a) => a -> a
invert 0 = 0
invert a = 1 / a

getCellParameters :: [[Vector Double]] -> [Cell] 
getCellParameters xs = zipWith6 Cell begins  ends xs  curv ((fmap.fmap) (invert) curv)  arcl
        where arcl = calcArcLengths  xs
              curv = calcCurvatures  xs
              begins = head <$> xs 
              ends = last <$> xs 

safeDiv a 0 = 0
safeDiv a b = a / b

average [] = Nothing 
average xs = traceShow xs $ Just $ sum  xs / genericLength xs  

averageCurvature :: [Vector Double] -> Maybe Double 
averageCurvature = average . catMaybes . curvatures

arcl [] = [] 
arcl (x1:x2:x3:x4:x5:x6:x7:xs) = ((fromScalar . magnitude) <$> thirdStepDifferenceVector [x1,x2,x3,x4,x5,x6,x7]) : arcl xs 
arcl xs = replicate (length xs) Nothing 

-- curvatures :: [Vector Double] -> [Maybe Double]
curvatures (x1:x2:x3:x4:x5:x6:x7:xs) = (invert <$> firstStepDifferenceRate ([x1,x2,x3,x4,x5,x6,x7]))  : curvatures (x2:x3:x4:x5:x6:x7:xs)
curvatures xs = replicate (length xs) Nothing

arcLength :: [Vector Double] -> Double 
arcLength [] = 0
arcLength [a] = 1
arcLength (x:y:xs) = (fromScalar $ magnitude (y - x)) + arcLength (y:xs)
