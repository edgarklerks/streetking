{-# LANGUAGE ViewPatterns #-}
module Main where 

import Data.Array.Base
import Data.Array.Unboxed
import Data.Array.IArray
import Data.Array.MArray
import Data.Array.ST
import Control.Monad.ST
import Control.Applicative
import Data.Word
import Codec.Image.DevIL
import qualified Data.Foldable as F
import Data.Maybe
import Control.Applicative
import Debug.Trace 
import Control.Monad
import Control.Monad.Cont
import Data.List
import Data.Monoid

-- (row, column, color-channel) value 
-- transform
-- (row, column) (r,g,b)


type ImageCH = UArray (Int, Int, Int) Word8
type Image = Array (Int, Int) (Word8, Word8, Word8) 

data RGB = Red -- Start point  
         | Green -- Scale measurement
         | Blue 
         | Black -- Track  
         | White -- Nothing  
         | ErrorColor
    deriving (Show, Eq, Ord, Enum)

type RGBs = UArray Int Word32

type ColorMap = UArray (Int, Int) Int 

data Collection = Collection {
            points :: [(Int, Int)],
            cl :: RGB,
            center :: (Int, Int)
    } deriving Show 

sortByApproximity :: [((Int, Int), RGB)] -> [((Int, Int), RGB)]
sortByApproximity = undefined


drawPoints :: FilePath -> FilePath -> [(Int, Int)] -> IO ()
drawPoints i out pts = do x <- readImage i 
                          let fp (y,x) = [((x,y,0), 255), ((x,y,1),0), ((x,y,2),0)]
                          let n = foldl' (\z x -> z // x) x (fmap fp pts)
                          writeImage out n

drawColorPoints :: ImageCH -> (Word8, Word8, Word8) -> [(Int, Int)] -> ImageCH
drawColorPoints i (r,g,b) pts = let fp (y,x) = [((x,y,0), r), ((x,y,1),g), ((x,y,2),b)]
                                in foldl' (\z x -> z // x) i (fmap fp pts)



testRun :: IO ()
testRun = do 
    ilInit
    y <- testRacemap 
    p <- readImage "racemap.bmp"
    let x = getColorMap y
    when (not $ completeColorSet x) $ error "map doesn't have complete color set"
    let ct =  (findRGB Red x)
    writeImage "test.png" $ colorSearches p x 

colorSearches :: ImageCH -> ColorMap ->ImageCH 
colorSearches i cm = let ct = findRGB Red cm 
                         step yield  (i,[ct]) c  = case findOnCircle ct 2 Black cm of
                                            Nothing -> yield (i,[ct]) >> return (i,[ct])
                                            Just n -> return (i,[n,ct])
                         step yield  (i,t@(p1:p2:xs)) (color -> c)  = case aconcat $ map (\n -> findOnCircleSection p1 n (theta p1 p2) (pi) Black cm) [10] of
                                            Nothing -> yield (i,t) >> return (i,t)
                                            Just p -> return (drawColorPoints i c (generateCirclePoints' p1 (theta p1 p2) pi 10 3000) , (p : t)) 
                         (z, xs) = (`runCont` id) $ callCC $ \yield -> foldM (step yield) (i, [ct]) [1..3000]
                  in drawColorPoints z (0,255,0) xs  

color x = case mod x 3 of 
                2 -> (0,0,255)
                1 -> (0,255,0)
                0 -> (255,0,0)
aconcat (x:xs) = foldr (<|>) x xs 

testPoints :: IO ()
testPoints = do 
    ilInit
    let p1 = (10,10)
    let p2 = (17,10)
    let ps = generateCirclePoints p2 (theta p2 p1) (pi) 10 200
    print $ p1 : p2 :  ps 
    t <- readImage "racemap.bmp"
    writeImage "out.png" $ drawColorPoints (drawColorPoints (drawColorPoints t (255,0,0) [p1]) (0,255,0) [p2]) (0,0,255) ps




{-- search methods --}

findOnCircle :: (Int, Int) -> Int -> RGB -> ColorMap -> Maybe (Int, Int)
findOnCircle pnt r g cm = searchPnts pnts g cm  
      where pnts = generateCirclePoints pnt 0 (2 * pi) r 3000   

searchPnts :: [(Int, Int)] -> RGB -> ColorMap -> Maybe (Int, Int)
searchPnts pnts g cm = (`runCont` id) $ callCC $ \yield -> 
                let c = forM_ pnts $ \i ->  case cm ! i == (fromEnum g) of
                                                True -> yield (Just i)
                                                False -> return Nothing
                in c >> return Nothing



-- (x,y) -> radius -> tauoffset -> tauwidth -> n -> ...
findOnCircleSection :: (Int, Int) -> Int -> Double -> Double -> RGB -> ColorMap -> Maybe (Int, Int) 
findOnCircleSection pnt r s w g cm = searchPnts pnts g cm  
                where pnts = generateCirclePoints' pnt s w r 3000 


-- x = a + r * cos (2 * pi / n * t)
-- y = b + r * sin (2 * pi / n * t)
-- t [0 .. n]
-- (x,y) -> radius -> n -> 

generateCirclePoints :: (Int, Int) -> Double -> Double -> Int -> Int -> [(Int, Int)]
generateCirclePoints pt offs width r n = generateCirclePoints' pt offs width r n 

generateCirclePoints' :: (Int, Int) -> Double -> Double -> Int -> Int -> [(Int, Int)]
generateCirclePoints' (fromIntegral -> x, fromIntegral -> y) offset width (fromIntegral -> r) n = nub $ concatMap (\t -> 
    [
        (round $ x + r * cos t, round $ y - r * sin t) 
        ]
    ) taus
        where taus = generateTau offset width n 

interleave :: [a] -> [a] -> [a]
interleave [] ys = ys 
interleave xs [] = xs 
interleave (x:xs) (y:ys) = [x,y] ++ interleave xs ys 

generateTau :: Double -> Double -> Int -> [Double]
generateTau offset ((/2) -> width) n  = map step [0..n]
                where stepsize = delta / (fromIntegral n)
                      begin = offset - width
                      end = offset + width 
                      delta = end - begin 
                      step (fromIntegral -> x) = begin + x * stepsize  


 
{-- Find a specific color --}
findRGB :: RGB -> ColorMap -> (Int, Int)
findRGB (fromEnum -> rgb) cm = (`runCont` id) $ callCC $ \yield ->  mapM_ (step yield) (assocs cm) >> return (0,0)
        where step yield (i, e) | e == rgb = yield i
                                | otherwise = return () 



{-- Check prequisites --}

completeColorSet :: ColorMap -> Bool 
completeColorSet (getColors -> i) = i ! (fromEnum Red) /= 0 && i ! (fromEnum Green) /= 0 && i ! (fromEnum Black) /= 0 && i ! (fromEnum White) /= 0

{-- Normalized color map --}


getColorMap :: Image -> ColorMap 
getColorMap i@(bounds -> bnd) = listArray bnd . fmap (fromEnum . closestColor) . elems $ i

swap :: (a,b) -> (b,a)
swap (a,b) = (b,a)

{-- Color Frequency determination --}


getColors :: ColorMap -> RGBs 
getColors i = runSTUArray $ do 
            a <- newArray (fromEnum Red, fromEnum White) 0 :: ST s (STUArray s Int Word32)
            forM_ (elems i) $ \e -> modifyArray a e (+1)
            return a

{-- Based on color channel dominance --}
closestColor :: (Word8, Word8, Word8) -> RGB 
closestColor (255,255,255) = White
closestColor (0,0,0) = Black 
closestColor (r,g,b) | (g >= r && g > b) || (g > r && g >= b) = Green 
                     | (r >= g && r > b) || (r > g && r >= b) = Red
                     | (b >= g && b > r) || (b > g && b >= r) = Blue 
                     | (b == g && r == g) = case r >= 128 of
                                            True -> White 
                                            False -> Black 
                     | otherwise = ErrorColor

modifyArray :: (MArray a e m, Ix i) => a i e -> i -> (e -> e) -> m ()
modifyArray a i f = do 
            e <- readArray a i 
            writeArray a i (f e)

getImage :: ImageCH -> Image 
getImage ich = runSTArray $ do 
        a <- newArray ((0,0),(cols,rows)) (Nothing, Nothing, Nothing) :: ST s (STArray s (Int, Int) (Maybe Word8, Maybe Word8, Maybe Word8))
        mapM_ (step a)  (assocs ich) 
        let rtp (a,b,c) = (fromJust a, fromJust b, fromJust c)
        (mapArray rtp a)
            where step z ((i,j,k),v) = case k of 
                                0 -> modifyArray z (j,i) (in1 (Just v))
                                1 -> modifyArray z (j,i) (in2 (Just v))
                                2 -> modifyArray z (j,i) (in3 (Just v))
                                3 -> return ()
                  bnd = bounds ich
                  rows = case snd bnd of 
                    (r,c,cc) -> r
                  cols = case snd bnd of 
                    (r,c,cc) -> c


testRacemap :: IO Image
testRacemap = getImage <$> readImage "racemap.bmp"

{-- Differential --}

data FloatNumber = Infinite | Nr Double 
    deriving Show 


theta :: (Int, Int) -> (Int, Int) -> Double
theta p q | p == q = error "Singularity"
          | otherwise = asin (pq / dist p q) * t 
                    where pq = fromIntegral $ snd q - snd p 
                          t = case signum pq of 
                                    1 -> 1 
                                    (-1) -> 1 
                                    0 -> 1 

dist :: (Int, Int) -> (Int, Int) -> Double 
dist (fromIntegral -> p1, fromIntegral -> p2) (fromIntegral -> q1, fromIntegral -> q2) = sqrt $ (q1 - p1)^2 + (q2 - p2)^2

main = testRun 

in1,in2,in3 :: a -> (a,a,a) -> (a,a,a) 
in1 a (_,b,c) = (a,b,c)
in2 b (a,_,c) = (a,b,c)
in3 c (a,b,_) = (a,b,c)

out1, out2, out3 :: (a,a,a) -> a
out1 (a,b,c) = a
out2 (a,b,c) = b
out3 (a,b,c) = c
