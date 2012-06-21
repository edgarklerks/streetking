{-# LANGUAGE ViewPatterns, BangPatterns #-}
module Image where 
import Control.Applicative
import Control.Monad
import Control.Monad.ST 
import Data.Word 
import Color 
import Data.Array.Base
import Data.Array.IArray
import Data.Array.MArray
import Data.Array.ST
import Codec.Image.DevIL
import Data.List 
import Vector 
import Debug.Trace
import System.Directory
import Data.Complex as C

type ImageCH = UArray (Int, Int, Int) Word8
type ImageUN = UArray (Int,Int,Int) Double

type VectorImage = Vector (Vector (Complex Double))
type Kernel = Vector (Complex Double )

flipVertImage :: ImageCH -> ImageCH 
flipVertImage ch = array (bounds ch) [e `seq` ((rows - x,y,c),e) | ((x,y,c),e) <- assocs ch]
    where (rows,cols,c) = snd $ bounds ch 


mkGif :: [(Int, Int)] -> (Word8, Word8, Word8) -> ImageCH -> [(ImageCH, Int)]
mkGif (reverse . tails -> xs) c ic = foldr step [] xs `zip` [1..] 
    where step x z = drawColorPoints ic c x : z 


drawColorPoints :: ImageCH -> (Word8, Word8, Word8) -> [(Int, Int)] -> ImageCH
drawColorPoints i (r,g,b) pts = let fp ((y,x),t) = [((x,y,0), r), ((x,y,1),g), ((x,y,2),b), ((x,y,3),255)]
                                in foldl' (\z x -> z // x) i (fmap fp (pts `Data.List.zip` [1..]))


liftSnd :: ([b] -> [b]) -> [(a,b)] -> [(a,b)]
liftSnd f xs = let (as,bs) = unzip xs
               in zip as  (f bs)
liftFst :: ([b] -> [b]) -> [(b,a)] -> [(b,a)]
liftFst f xs = let (bs,as) = unzip xs
               in zip (f bs)  as


difference :: Num a => [a] -> [a] 
difference [] = []
difference (x:[]) = [x] 
difference (x:y:xs) = y - x : difference (y : xs)


mergeSingle [x] = [0]
mergeSingle (1:1:0:xs) = 0 : 1 : 0 : mergeSingle xs
mergeSingle (x:xs) = x : mergeSingle xs 


stepDetect [] = []
stepDetect [x] = [0]
stepDetect [x,y] = [0,0]
stepDetect (x:y:z:xs) | x == y && x /= z = 0 : 0 : 1 : stepDetect xs 
                       | y == z && x /= z = 1 : 0 : 0 : stepDetect xs
                       | y == z && x == y = 0 : 0 : 0 : stepDetect xs
                       | x /= y && y /= z = 0 : 1 : 0 : stepDetect xs

slider :: Int -> ([b] -> b) -> [b] -> [b] 
slider n f [] = []
slider n f xs@(x:ys) = let ns = take n xs 
                           a = f ns
                in a `seq` a : slider n f ys 

filterOnes :: Eq a => [a] -> [a] 
filterOnes [] = []
filterOnes [x] = [x]
filterOnes [x,y] = [x,y]
filterOnes (x:y:z:xs) | x == z = x:(filterOnes $ x:z:xs)
                      | otherwise = x : (filterOnes $ y:z:xs)

-- 0.1 0.1 0.2 0.2 0.3 0.3 
weightedAverage :: Num a => [a] -> [a] -> [a]
weightedAverage w = slider (length w) (\xs -> sum (zipWith (*) w xs))

loadImage :: FilePath -> IO ImageCH 
loadImage = fmap flipVertImage . readImage  

loadVector :: FilePath -> IO VectorImage
loadVector = fmap imageToVector . readImage

imageToVector :: ImageCH -> VectorImage 

imageToVector im = let (rows, cols, ch) = snd $ bounds im in 
    Vector rows cols $ runSTArray $ do 
        a <-  newArray ((1,1),(rows+1, cols+1)) (mk41 (0,0,0,0))
        forM_ (assocs im) $ \((i,j,k),e) -> do 
            r <- readArray a (i+1,j+1)
            let p 0 k = mk41 (k,0,0,0) 
                p 1 k = mk41 (0,k,0,0)
                p 2 k = mk41 (0,0,k,0)
                p 3 k = mk41 (0,0,0,k)
            writeArray a (i+1,j+1) (r + p k (fromIntegral e)) 
        return a

{--
convoluteImage :: VectorImage -> Double -> Kernel -> VectorImage 
convoluteImage (Vector mi ni im) s (Vector m n kr) = Vector mi ni $ runSTArray $ do 
        a <- thaw im 
        forM_ [1..mi - m + 1] $ \i -> 
            forM_ [1..ni - n + 1] $ \j -> 
            forM_ [1..m]  $ \k -> 
            forM_ [1..n] $ \l -> do 
              sx <- readArray a (i,j) 
              px <- readArray a (i + k - 1, j + l - 1)
              writeArray a (i,j) $ fmap ((*s).((kr ! (k,l))*))  px

        return a       
--}
-- convoluteImage :: VectorImage -> Double -> Kernel -> VectorImage 
convoluteImage (Vector mi ni im) s (Vector m n kr) = Vector mi ni $ runSTArray $ do 
                a <- thaw im 
                forM_ [1..mi - m + 1] $ \i -> 
                    forM_ [1..ni - n + 1] $ \j -> do  
                        p <- convolutePixel s m n i j kr a  
                        p `seq` writeArray a (i,j) p
                return a

convolutePixel s m n i j kr px = foldM step (mk41 (0,0,0,0)) [1..m]
            where step z !k = foldM (step2 k) z [1..n]
                    where step2 !k z !l = do 
                            x <- readArray px (i + k - 1, j + l - 1)
                            x `seq` return (z + fmap  ((*s).((kr ! (k,l))*)) x)

vectorToImage :: VectorImage -> ImageUN
vectorToImage (Vector rows cols m) = runSTUArray $ do 
                a <- newArray ((0,0,0),(rows,cols,3)) 0 
                forM_ (assocs m) $ \((pred -> i,pred -> j),e) -> case e of 
                            (Vector 4 1 p) -> do 
                                let r = p ! (1,1)
                                let g = p ! (2,1)
                                let b = p ! (3,1) 
                                let t = p ! (4,1)
                                writeArray a (i,j,0) (C.realPart r)
                                writeArray a (i,j,1) (C.realPart g) 
                                writeArray a (i,j,2) (C.realPart b) 
                                writeArray a (i,j,3) (C.realPart t) 
                            otherwise -> error "not an image" 
                return a

ivectorToImage :: VectorImage -> ImageUN
ivectorToImage (Vector rows cols m) = runSTUArray $ do 
                a <- newArray ((0,0,0),(rows,cols,3)) 0 
                forM_ (assocs m) $ \((pred -> i,pred -> j),e) -> case e of 
                            (Vector 4 1 p) -> do 
                                let r = p ! (1,1)
                                let g = p ! (2,1)
                                let b = p ! (3,1) 
                                let t = p ! (4,1)
                                writeArray a (i,j,0) (C.imagPart r)
                                writeArray a (i,j,1) (C.imagPart g) 
                                writeArray a (i,j,2) (C.imagPart b) 
                                writeArray a (i,j,3) (C.imagPart t) 
                            otherwise -> error "not an image" 
                return a

superImposeImage :: (Vector (Complex Double) -> Vector (Complex Double) -> Vector (Complex Double)) -> VectorImage -> VectorImage -> VectorImage 
superImposeImage f x y = zipVec f x y

addImage :: VectorImage -> VectorImage -> VectorImage 
addImage = superImposeImage (+)

multImage :: VectorImage -> VectorImage -> VectorImage 
multImage = superImposeImage (*)

subImage :: VectorImage -> VectorImage -> VectorImage 
subImage = superImposeImage (-)



colorCutImage :: ImageUN -> ImageCH 
colorCutImage xs = runSTUArray $ do 
                a <- newArray (bounds xs) 0  
                forM_ (assocs xs) $ \((i,j,c),e) -> do 
                            writeArray a (i,j,c) $ truncate $ max 0 (min 255 e) 
                return a



normalizeImage :: ImageUN -> ImageCH 
normalizeImage xs = let (r,g,b,t) = foldr step (0,0,0,0) (assocs xs) 
                        step ((i,j,k),p) (r,g,b,t) | k == 0 = (max r p,g,b,t)
                                                   | k == 1 = (r,max g p,b,t)
                                                   | k == 2 = (r,g,max b p,t)
                                                   | k == 3 = (r,g,b,max t p)
                    in runSTUArray $ do 
                            a <- newArray (bounds xs) 0  
                            forM_ (assocs xs) $ \((i,j,c),e) -> do 
                                        let p = case c of 
                                                    0 -> e / r
                                                    1 -> e / g
                                                    2 -> e / b 
                                                    3 -> e / t
                                        writeArray a (i,j,c) $ (round (255 * p)) 
                            return a


sobelOperator :: (Complex Double) -> VectorImage -> VectorImage 
sobelOperator s v = convoluteImage p s (mkn3 [(1,2,1),(0,0,0),(-1,-2,-1)])
    where p = convoluteImage v s (Vector.transpose $ mkn3 $ reverse [(1,2,1),(0,0,0),(-1,-2,-1)])

edgeOperator :: (Complex Double) -> VectorImage -> VectorImage 
edgeOperator s v = convoluteImage p s (mkn3 [(1,1,1),(0,0,0),(-1,-1,-1)])
    where p = convoluteImage v s (Vector.transpose $ mkn3 $ reverse [(1,1,1),(0,0,0),(-1,-1,-1)])

saveImage :: FilePath -> ImageCH -> IO ()
saveImage fp i = do 
    b <- doesFileExist fp 
    when b $ removeFile fp 
    writeImage fp i


testOperator :: (Complex Double) -> VectorImage -> VectorImage 
testOperator s v = convoluteImage v s (mkn3 [(-3,2,-3),(1,8,1),(-3,2,-3)])

testOperators = do 
    ilInit
    x <- loadVector "default.jpg"
    saveImage "test.bmp" (normalizeImage . vectorToImage . testOperator (1/2) $ x)

-- dft :: VectorImage -> VectorImage 
{--
dft (Vector n m xs) = runSTArray $ do 
                a <- newArray ((1,1),(n,m)) 0 
                forM_ [1..n] $ \i -> 
                    forM_ [1..m] $ \j -> do  
                        p <- dftPixel i j n m xs 
                        return ()
                return a
dftPixel i j n m xs = foldM step (0,0,0,0) 

    where f k l = 

--}
