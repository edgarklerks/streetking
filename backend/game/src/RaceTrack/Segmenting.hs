{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses #-}
module Main where 

import System.Environment
import Control.Arrow
import Control.Applicative
import Control.Monad
import Control.Monad.ST
import Data.Binary
import qualified Data.ByteString.Lazy as B
import Data.Array.IArray
import Data.Array.ST
import Data.Array.MArray
import Data.Array.Base
import Data.Array.Unboxed
import Vector 
import Color 
import Image 
import Codec.Image.DevIL
import qualified Data.Foldable as F
import Data.Complex
import Debug.Trace 


data Path = Path {
        start :: Vector Double,
        path :: Array Int (Vector Double) 
    } deriving Show 

{-- Dump segmentation --}


calculateFirstDifference :: SegmentMonad [Double]
calculateFirstDifference = do
    -- Start condition 
    setPointer 2 

    let b = do 
        s <- getPointer 
        p <- takeFirstDifference s
        case p of 
            Just a -> do 
                advPointer 
                ps <- b 
                return (a : ps)
            Nothing -> return []
    b 

calculateSecondDifference :: SegmentMonad [Double]
calculateSecondDifference = do
    -- Start condition 
    setPointer 3 

    let b = do 
        s <- getPointer 
        p <- takeSecondDifference s
        case p of 
            Just a -> do 
                advPointer 
                ps <- b 
                return (a : ps)
            Nothing -> return []
    b 
calculateSecondStepDifferenceRate :: SegmentMonad [(Vector Double,Double)]
calculateSecondStepDifferenceRate = do
    -- Start condition 
    setPointer 3 

    let b = do 
        s <- getPointer 
        p <- takeSecondDifferenceRate s
        case p of 
            Just a -> do 
                p' <- head <$> takeAround s 0
                advPointer 
                ps <- b 
                return ((p',a) : ps)
            Nothing -> return []
    b 
calculateSecondStepDifferenceVector :: SegmentMonad [(Vector Double,Vector Double)]
calculateSecondStepDifferenceVector = do
    -- Start condition 
    setPointer 3 

    let b = do 
        s <- getPointer 
        p <- takeSecondDifferenceVector s
        case p of 
            Just a -> do 
                p' <- head <$> takeAround s 0
                advPointer 
                ps <- b 
                return ((p',a) : ps)
            Nothing -> return []
    b 


calculateThirdStepDifferenceRate :: SegmentMonad [(Vector Double,Double)]
calculateThirdStepDifferenceRate = do
    -- Start condition 
    setPointer 4 

    let b = do 
        s <- getPointer 
        p <- takeThirdDifferenceRate s
        case p of 
            Just a -> do 
                p' <- head <$> takeAround s 0
                advPointer 
                ps <- b 
                return ((p',a) : ps)
            Nothing -> return []
    b 

writeThirdStepDifferenceRate = do 
    ilInit
    p <- loadPath "dump.bin"    
    forM_ (elems $ path p) printMatrix
    let (a, b) = runSegmentMonad calculateThirdStepDifferenceRate p 
    v <- loadVector "track_7.bmp"
    let colorf (        x) | x == 0 = mk41 (255,0,0,0)
                           | x == 1 = mk41 (0,255,0,0)
                           | x == 2 = mk41 (0,0,255,0)
                           | x == 3 = mk41 (255,0,255,0)
                           | otherwise = mk41 (255,255,0,mkPolar x 0)
    let weigh = weightedAverage (reverse [0.05,0.05,0.1,0.1,0.2,0.2,0.3])
    let v' = labeledVectorToImage colorf p (liftSnd (fmap (fromIntegral . round) . weigh) b) v 

    saveImage "segmenting.bmp" (normalizeImage . vectorToImage $ v')


calculateThirdStepDifferenceVector :: SegmentMonad [(Vector Double,Vector Double)]
calculateThirdStepDifferenceVector = do
    -- Start condition 
    setPointer 4 

    let b = do 
        s <- getPointer 
        p <- takeThirdDifferenceVector s
        case p of 
            Just a -> do 
                p' <- head <$> drop 3 <$> takeAround s 3
                advPointer 
                ps <- b 
                return ((p',a) : ps)
            Nothing -> return []
    b 


print21 :: [(Vector Double, Double)] -> IO ()
print21 = mapM_ (\(x,y) -> putStrLn (x ++ " " ++ y)) . fmap (first pmatrix . second show)


{-- Monadic operations --}

askPath :: SegmentMonad Path
askPath = SegmentMonad $ \(s,p) -> (s, [], p)

takeA :: (Int, Int) -> Array Int a -> [a]
takeA (x,y) p = fmap (p!)  [x..y] 


takeAround :: Int -> Int -> SegmentMonad [Vector Double]
takeAround n l = do 
        ps <- path <$> askPath 
        let (b,e) = bounds ps 
        if b <= (n - l) && (n + l) <= e 
            then do 
                return (takeA (n - l, n + l) ps) 
            else do  
                return []


setPointer :: Int -> SegmentMonad ()
setPointer n = SegmentMonad $ \(s,p) -> (n, [],())

advPointer :: SegmentMonad ()
advPointer = SegmentMonad $ \(s,p) -> (succ s, [], ())

getPointer :: SegmentMonad Int 
getPointer = SegmentMonad $ \(s,p) -> (s, [], s)

takeFirstDifference :: Int -> SegmentMonad (Maybe Double)
takeFirstDifference p = do 
        ps <- takeAround p 1
        return (firstCentralDifference ps)

takeSecondDifference :: Int -> SegmentMonad (Maybe Double)
takeSecondDifference p = do 
        ps <- takeAround p 2 
        return (secondCentralDifference ps)
        
takeSecondDifferenceRate :: Int -> SegmentMonad (Maybe Double)
takeSecondDifferenceRate p = do 
        ps <- takeAround p 2
        return (secondStepDifferenceRate ps)
takeSecondDifferenceVector :: Int -> SegmentMonad (Maybe (Vector Double))
takeSecondDifferenceVector p = do 
        ps <- takeAround p 2
        return (secondStepDifferenceVector ps)


takeThirdDifferenceRate :: Int -> SegmentMonad (Maybe Double)
takeThirdDifferenceRate p = do 
        ps <- takeAround p 3 
        return (thirdStepDifferenceRate ps)

takeThirdDifferenceVector :: Int -> SegmentMonad (Maybe (Vector Double))
takeThirdDifferenceVector p = do 
        ps <- takeAround p 3 
        return (thirdStepDifferenceVector ps)

{-- Specialized monad, plumbing ahead! --}

newtype SegmentMonad a = SegmentMonad {
            unSegmentMonad :: (Int, Path) -> (Int, [Int], a)
    }

instance Functor SegmentMonad where 
    fmap f m = SegmentMonad $ \s -> 
                    let (x,y,z) = (unSegmentMonad m s)
                    in (x,y,f z)

instance Applicative SegmentMonad where 
    pure a = SegmentMonad $ \(s,_) -> (s, [], a)
    (<*>) fs as = SegmentMonad $ \n -> 
                        let (s,ps,f) = unSegmentMonad fs n 
                            (s',ps',a) = unSegmentMonad as (s,snd n)
                        in (s',ps' ++ ps, f a)

instance Monad SegmentMonad where 
    return = pure 
    (>>=) m f = SegmentMonad $ \n -> 
                    let (s,ps,a) = unSegmentMonad m n 
                        (s',ps',b) = unSegmentMonad (f a) (s, snd n)
                    in (s', ps ++ ps', b)

runSegmentMonad :: SegmentMonad a -> Path -> ([Int], a) 
runSegmentMonad m p = let (x,y,z) = unSegmentMonad m (1, p)
                      in (y,z)

-- | Second parameter is only a type witness 
loadDump :: Binary a => FilePath -> a -> IO (Vector a, [Vector a])
loadDump fp _ = do (s,xs) <- decode <$> B.readFile fp  
                   return (mk11 s, mk21 <$> xs) 
                   

_L :: a
_L = undefined 

loadPath :: FilePath -> IO Path 
loadPath fp = do 
            (st, ds) <- loadDump fp  (_L :: Int)  
            let n = length ds 
            return $ Path (fromIntegral <$> st) (array (1, n) $ [1..n] `zip` (
                 ((fmap fromIntegral)) <$> ds
                ))


getBoundingBox :: Path -> ((Int,Int),(Int,Int))
getBoundingBox (Path x p) = F.foldr step ((100000000,10000000),(1,1)) p 
    where   unstep (i,j) ((imin,jmin),(imax,jmax)) = ((uncmp i imin, uncmp j jmin), (cmp imax i, cmp jmax j))
            cmp i j | i > j = i
                    | otherwise = j
            uncmp i j | i < j = i 
                      | otherwise = j 
            step x z = unstep (round $ getX x, round $ getY x) z 

labeledVectorToImage :: (b -> Vector (Complex Double)) -> Path -> [(Vector Double,b)] -> VectorImage -> VectorImage  
labeledVectorToImage f p xs im@(Vector m n _) = addImage im np 
    where t = path p  
          np = Vector m n $ runSTArray $ do 
                        a <- newArray ((1,1),(m,n)) (mk41 (0,0,0,0))
                        forM_ (elems t) $ \e -> do
                            let b = lookup e xs 
                            let x = truncate $ getX e 
                            let y = truncate $ getY e
                            case b of 
                                Just b -> writeArray a (y,x) (f b)
                                Nothing -> return ()
                        return a
                            



            

{--
pathToImage' :: Path -> Vector Word32 
pathToImage' p = Vector (1,1) e $ runSTArray $ do 
        xs <- newArray ((1,1),e) 0 :: ST s (STArray s (Int,Int) Word32)
        forM_ (elems $ path p) $ \j -> do 
                let x = getX j
                let y = getY j 
                writeArray xs (x,y) 255 
        return xs 
    where (b,e) = getBoundingBox p 
--}
        

