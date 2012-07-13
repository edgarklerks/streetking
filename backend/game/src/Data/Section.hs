
module Data.Section where 

import Data.Matrix 
import Data.Maybe
import qualified Model.TrackDetails as TD

data Section = Section {
        section_id :: Integer,
        radius :: Maybe Double,     -- section curve radius
        arclength :: Double         -- section length
    } deriving Show

section :: Integer -> Double -> Double -> Section
section i r = case (r < 0.01) of
    True -> Section i Nothing
    False -> Section i (Just r)

trackDetailsSection :: TD.TrackDetails -> Section
trackDetailsSection t = section (TD.track_id t) (TD.radius t) (TD.length t)

radius' :: Section -> Double
radius' = fromJust . radius

-- section curve angle (length = angle * radius)
angle :: Section -> Maybe Double
angle s = case (radius s) of
    Nothing -> Nothing
    Just r -> Just $ (arclength s) / r

angle' :: Section -> Double
angle' = fromJust . angle

-- section curve curvature is 1 / (curve radius)
curvature :: Section -> Maybe Double
curvature s = case (radius s) of
    Nothing -> Nothing
    Just r -> Just $ 1 / r


{-

instance Show Cell where 
    show (Cell b e c r a) = "\n[\nbounds: \n" ++ (pmatrix b ++ "\n" ++ pmatrix e) ++ "\ncurvature: " ++ (show c) ++ "\narclength: " ++ (show a) ++ "\nradius:" ++ (show r) ++ "\n]"

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
-}
