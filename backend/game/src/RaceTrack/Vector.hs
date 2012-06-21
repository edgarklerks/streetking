{-# LANGUAGE BangPatterns #-}
module Vector where 

import Data.Array.Base
import Data.Array.IArray
import Data.Array.MArray
import Data.Array.ST
import Data.Monoid 
import Control.Applicative 
import Control.Monad hiding (forM_)
import Control.Monad.ST
import Data.Foldable as F 
import Prelude hiding (foldr, foldl, foldl1, sum)
import Data.List (permutations)
import Debug.Trace
import Data.Binary 

-- rows x cols  
data Vector a = Vector !Int !Int !(Array (Int,Int) a)
    deriving (Show, Eq)

instance Binary a =>  Binary (Vector a) where 
    put (Vector x y a) = put x *> put y *> put a
    get = Vector <$> get <*> get <*> get 

instance Foldable (Vector) where 
    fold = foldr mappend mempty . elems . getInner 
    foldMap f = foldr (\x -> mappend (f x)) mempty . elems . getInner 

        

instance Functor Vector where 
    fmap f (Vector q r a) = Vector q r $ fmap f a

instance (Show a, Eq a, Num a) => Num (Vector a) where 
        (+) = zipVec (+)
        (*) = multVec (*) 
        (-) = zipVec (-)
        abs a = mk11 $ let b =  F.foldr (\x z -> x * x + z) 0  a
                       in  b
        signum a = abs a -- `scalarDiv` abs a  
        fromInteger = mk11 . fromInteger 

magnitude :: (Num a, Floating a) => Vector a -> Vector a
magnitude v = sqrt $ abs v 

normalize :: (Num a, Floating a) => Vector a -> Vector a
normalize v = v / magnitude v 

theta21 v@(Vector 2 1 n)  = mk21 (fromScalar $ magnitude v, atan2 (n ! (2,1)) (n ! (1,1)))

instance Floating a => Floating (Vector a) where 
    sin = fmap sin 
    asin = fmap asin 
    cos = fmap cos 
    acos = fmap acos 
    cosh = fmap cosh 
    pi = mk11 pi
    exp = fmap exp
    log = fmap log 
    atan = fmap atan 
    sinh = fmap sinh 
    asinh = fmap asinh
    atanh = fmap atanh 
    acosh = fmap acosh
{-- Elementary Row operations --}

swap :: Int -> Int -> Vector a -> Vector a 
swap i j (Vector r c vec1) = Vector r c $ runSTArray $ do 
                            a <- thaw vec1 
                            swap' c i j a
                            return a

swap' :: Int -> Int -> Int -> STArray s (Int, Int) a -> ST s ()
swap' c i j a = do    forM_ [1 .. c] $ \k -> do 
                            p <- readArray a (i,k)
                            q <- readArray a (j,k)
                            writeArray a (i,k) q
                            writeArray a (j,k) p
                      return ()

 
scale :: Num a => Int -> a -> Vector a -> Vector a 
scale i s (Vector r c vec1) = Vector r c $ runSTArray $ do 
                                    a <- thaw vec1 
                                    scale' c i s a
                                    return a

scale' :: Num a => Int -> Int -> a  -> STArray s (Int, Int) a -> ST s ()
scale' c i s a =  forM_ [1..c] $ \k -> readArray a (i,k) >>= writeArray a (i,k) . (*s)


addRow :: Num a => Int -> Int -> a -> Vector a -> Vector a 
addRow i j s (Vector r c vec1) = Vector r c $ runSTArray $ do 
                                    a <- thaw vec1 
                                    addRow' c i j s a
                                    return a

addRow' :: Num a => Int -> Int -> Int -> a -> STArray s (Int,Int) a -> ST s ()
addRow' c i j s a =  forM_ [1..c] $ \k -> do 
                                p <- readArray a (i,k)
                                q <- readArray a (j,k)
                                writeArray a (j,k) (s * p + q)
                            


findPivot :: (Num a, Ord a) => Int -> Vector a -> (a, (Int,Int))
findPivot k (Vector r c vec1) | r == c = maximumBy (\x y -> compare (fst x) (fst y)) $ (\i -> (abs $ vec1 ! (i,k), (i,k))) <$>  [k .. r]
                              | otherwise = error "cannot find pivot for a non square matrix"


gaussianElim :: (Ord a, Fractional b, Real a) => Vector a -> Vector a -> Vector b 
gaussianElim v res | square v = slice (getCols v + 1) (getCols v + getCols res) b  
                   | otherwise = error "Matrix is not square"
    where b = Vector (getRows v) (getCols v + getCols res) $ fmap fromRational $ runSTArray $ do 
                        when (getRows v /= getRows res) $ error "Cannot create augmented matrix"
                        let aug = append v res 
                        let caug = getCols aug 
                        let cv = getCols v 
                        a <-  thaw (getVec (fmap toRational aug))
                        forM_ [1 .. cv] $ \k -> do 
                                let (pv, (imax,j)) = findPivot k v 

                                when (pv == 0) $ error "matrix is not singular"

                                swap' caug k imax a

                                forM_ [(k + 1) .. cv] $ \i -> do 
                                    
                                    fc <- readArray a (i,k)
                                    fu <- readArray a (k,k)
                                    addRow' caug k i ( -1 * fc / fu) a

                        forM_ ([1..cv]) $ \k -> do 
                                   kk <- readArray a (k,k) 
                                   scale' caug k (1 / kk) a
                                   forM_ [1..(k - 1)] $ \i -> do
                                        fi <- readArray a (i,k) 
                                        addRow' caug k i (-1 * fi) a

                        return a 
        

getX :: Vector a -> a 
getX (Vector 2 1 n) = n ! (1,1) 
getX (Vector 1 2 n) = n ! (1,1)

getY :: Vector a -> a
getY (Vector 2 1 n) = n ! (2,1)
getY (Vector 1 2 n) = n ! (1,2)

firstCentralDifference :: (Fractional a, Num a) =>  [Vector a] -> Maybe a
firstCentralDifference [] = Nothing 
firstCentralDifference (x1:x2:x3:xs) =  Just $ (getY x3 - getY x1) / h
    where h = getX x3 - getX x1


secondCentralDifference :: (Fractional a, Num a) => [Vector a] -> Maybe a
secondCentralDifference [] = Nothing 
secondCentralDifference (x1:x2:x3:x4:x5:xs) = Just $ (getY x5 - getY x3) / (hf * hc) - (getY x3 - getY x1) / (hc * hb)
    where hf = getX x5 - getX x3
          hc = getX x4 - getX x2 
          hb = getX x3 - getX x1
firstStepDifferenceVector :: (Floating a) => [Vector a] -> Maybe (Vector a)
firstStepDifferenceVector (x1:x2:x3:xs) = Just $ (x3 - x1) `scalarDiv` 2
firstStepDifferenceVector otherwise = Nothing  


-- Five points 
-- xn - 2, xn - 1, xn , xn + 1, xn + 2
-- x1    , x2    , x3 , x4    , x5
secondStepDifferenceVector :: (Floating a) => [Vector a] -> Maybe (Vector a)
secondStepDifferenceVector (x1:x2:x3:x4:x5:xs) = Just $ (x5 - x3 + x1) `scalarDiv` 4
secondStepDifferenceVector otherwise = Nothing  

testSecondStepDifference = secondStepDifferenceRate [
        mk21 (1,2),
        mk21 (2,1),
        mk21 (3,4),
        mk21 (3,4),
        mk21 (4,6)
    ]

secondStepDifferenceRate :: (RealFloat a, Floating a) => [Vector a] -> Maybe a
secondStepDifferenceRate =  fmap (fromScalar . magnitude ) . secondStepDifferenceVector


thirdStepDifferenceVector :: (Floating a) => [Vector a] -> Maybe (Vector a)
thirdStepDifferenceVector (x1:x2:x3:x4:x5:x6:x7:xs) = Just $ (x7 - (x5 + x5 + x5) + (x3 + x3 + x3) - x1) 
thirdStepDifferenceVector otherwise = Nothing 


thirdStepDifferenceRate :: (RealFloat a, Floating a) => [Vector a] -> Maybe a
thirdStepDifferenceRate = fmap (fromScalar . magnitude) . thirdStepDifferenceVector 

inverse v | square v = gaussianElim  v (identityMatrix (getRows v))
          | otherwise  = error "Matrix doesn't have an inverse"


slice :: (Show a) => Int -> Int -> Vector a -> Vector a 
slice i j (Vector r1 c1 vec1) = Vector  r1 (j - i + 1) $ runSTArray $ do
                                        a <- newArray ((1,1),(r1, j - i + 1)) undefined  
                                        forM_ [i .. j] $ \k -> do 
                                            forM_ [1 .. r1] $ \l -> do 
                                                let val = vec1 ! (l, k)
                                                writeArray a (l,k - i + 1) val 
                                        return a
                    
append :: Vector a -> Vector a -> Vector a 
append (Vector r1 c1 vec1) (Vector r2 c2 vec2) | r1 == r2 = Vector r1 (c1 + c2) $  runSTArray $ do 
                                                            a <- newArray ((1,1),(r1, c1+c2)) undefined 
                                                            forM_ (range ((1,1),(r1,c1))) $ \(i,j) -> do 
                                                                    writeArray a (i,j) (vec1 ! (i,j))
                                                            forM_ (range ((1,1), (r2,c2))) $ \(i, j) -> do 
                                                                    writeArray a (i, j + c1) (vec2 ! (i,j))
                                                            return a
                                         | otherwise = error "cannot append matrices"

instance (Floating a, Fractional a) => Fractional (Vector a) where 
        fromRational = mk11 . fromRational
        (/) a b = multVec (*) a (recip b)
--        recip (Vector k l vec1) =  


scalarDiv :: Fractional a => Vector a -> Vector a -> Vector a 
scalarDiv a@(Vector r1 c1 vec1) b@(Vector r2 c2 vec2) | (1,1) == (r1,c1) = fmap (/(vec1 ! (1,1))) b
                                                      | (1,1) == (r2,c2) = fmap ((vec2 ! (1,1)/)) a
                                                      | otherwise = error "Cannot scalar divided with no scalars"
                            

transpose :: Vector a -> Vector a 
transpose (Vector row col vec1) = Vector col row $ runSTArray $ do 
                        a <- newArray ((1,1),(col, row)) undefined
                        forM_ (range ((1,1),(row,col))) $ \(i,j) -> writeArray a (j,i) (vec1 !(i,j))
                        return a

pmatrix :: Show a => Vector a -> String 
pmatrix (Vector row col vec1) = snd $ foldr step (1,[]) (range ((1,1),(row,col)))
                where step (x,y) (p,z) = case p /= x of 
                                            True -> (x, (show (vec1 ! (x,y))) ++ "\n" ++ z) 
                                            False -> (x, (show (vec1 ! (x,y))) ++ "    " ++ z)


printMatrix :: Show a => Vector a -> IO ()
printMatrix = putStrLn . pmatrix

square :: Vector a -> Bool 
square (Vector row col _) = row == col

getRows :: Vector a -> Int 
getRows (Vector row _ _) = row

getCols :: Vector a -> Int 
getCols (Vector _ col _) = col 

getVec :: Vector a -> Array (Int, Int) a
getVec (Vector _ _ v) = v

identityMatrix :: Num a => Int -> Vector a 
identityMatrix x = Vector x x $ runSTArray $ do 
                           a <- newArray ((1,1),(x,x)) 0 
                           forM_ [1..x] $ \i -> writeArray a (i,i) 1
                           return a

nulVector :: (Num a) => Int -> Int -> Vector a 
nulVector x y = mkVector x y (repeat 0) 


--     | e1 e2 e3 |
--     | a1 a2 a3 | = Sum {i,j,k = 1, 3} Eijk * ei * aj * bk
--     | b1 b2 b3 |
--
det :: (Integral b, Integral a) => Vector a -> b 
det a | square a = let (Vector (fromIntegral -> row) (fromIntegral -> col) vec1) = a 
                       ps = permutations [1..row]
                       step (fromIntegral -> a,xs) z = a * fst (foldr mult (1,1) xs) + z
                       mult x (z,n) = ((vec1 ! (x,n + 1)) * z, (n + 1) `mod` (row - 1))
                   in  fromIntegral $ foldr step 0 ((levic <$> ps) `zip` ps)
      | otherwise = error "Matrix is not square"


levic :: Num a => [a] -> a 
levic xs = signum $ F.product $ [( (xs !! j) - (xs !! i) ) | i <- [0 .. (n - 1)], j <- [(i + 1) .. n]] 
            where n = fromIntegral $ length xs - 1
            

getInner :: Vector a -> Array (Int,Int) a 
getInner (Vector _ _ xs) = xs 

scalarOp :: (a -> a -> b) -> Vector a -> Vector a -> Vector b
scalarOp f a@(Vector k l vec1) b@(Vector r s vec2) | (k == 1 && l == 1) = Vector r s (fmap (f $ head $ elems vec1) vec2)
                                                   | (r == 1 && s == 1) = Vector k l (fmap (flip f $ head $ elems vec2) vec1)
                                                   | otherwise = error "scalar operation" 
                                                                            

zipVec :: (a -> a -> b) -> Vector a -> Vector a -> Vector b
zipVec f a@(Vector k l !vec1) b@(Vector r s !vec2) | sameRank a b = Vector k l (listArray ((1,1),(k,l)) $ zipWith f (elems vec1) (elems vec2))
                                                 | otherwise = error "cannot zip"
multVec :: Num b => (a -> a -> b) -> Vector a -> Vector a -> Vector b
multVec f a b | multiple a b = Vector ra cb $ runSTArray $ do
                        let (Vector _ _ vec1) = a
                        let (Vector _ _ vec2) = b 
                        c <- newArray ((1,1),(ra, cb)) undefined  
                        forM_ (range ((1,1),(ra, cb))) $ \(j,k) -> do 
                                let xs = fmap (\n -> f (vec1 ! (j,n))  (vec2 ! (n,k))) [1..nmax] 
                                writeArray c (j,k) $ sum xs
                        return c
         | otherwise = error $ "cannot multiply vector"
            where nmax = unSizeMultiple a b 
                  (ra, cb) = sizeMultiple a b 

sameRank :: Vector a -> Vector a -> Bool 
sameRank (Vector r q a) (Vector s t b) = s == r && q == t


multiple :: Vector a -> Vector a -> Bool 
multiple (Vector r q a) (Vector s t b) = s == q

sizeMultiple :: Vector a -> Vector a -> (Int,Int)
sizeMultiple (Vector r q a) (Vector s t b) = (r,t) 

unSizeMultiple :: Vector a -> Vector a -> Int
unSizeMultiple (Vector r q a) (Vector s t b) = s 

mkVector :: Int -> Int -> [a] -> Vector a 
mkVector r c xs = Vector r c (listArray ((1,1),(r,c)) xs)

mk11 :: a -> Vector a
mk11 a = mkVector 1 1 [a]

mk12 :: (a,a) -> Vector a 
mk12 (x,y) = mkVector 1 2 [x,y]

mk21 :: (a,a) -> Vector a 
mk21 (x,y) = mkVector 2 1 [x,y] 

mk13 :: (a,a,a) -> Vector a 
mk13 (x,y,z) = mkVector 1 3 [x,y,z]

mk31 :: (a,a,a) -> Vector a
mk31 (x,y,z) = mkVector 3 1 [x,y,z]

mk2n :: [(a,a)] -> Vector a
mk2n xs = mkVector 2 (length xs) $ do 
                        (a,b) <- xs 
                        [a,b]

mkn2 :: [(a,a)] -> Vector a 
mkn2 xs = mkVector (length xs) 2 $do 
                (a,b) <- xs 
                [a,b]

mk3n :: [(a,a,a)] -> Vector a 
mk3n xs = mkVector 3 (length xs) $ do 
            (a,b,c) <- xs 
            [a,b,c]
mkn3 :: [(a,a,a)] -> Vector a 
mkn3 xs = mkVector (length xs) 3 $ do 
            (a,b,c) <- xs 
            [a,b,c]

mk41 :: (a,a,a,a) -> Vector a 
mk41 (a,b,c,d) = mkVector 4 1 [a,b,c,d]

fromScalar (Vector 1 1 n) = n ! (1,1)

-- Sum{i=1..mi - m + 1, j=1..ni - n + 1} (Sum{k = 1..m, l=1..n} I(i + k - 1, j + l - 1) * K(k,l)
convolute :: Num a => Vector a -> Vector a -> Vector a 
convolute (Vector mi ni im) (Vector m n kr) = Vector mi ni $ runSTArray $ do
                                a <- thaw im 
                                forM_ [1..mi - m + 1] $ \i -> 
                                    forM_ [1..ni - n + 1] $ \j -> 
                                    forM_ [1..m]  $ \k -> 
                                    forM_ [1..n] $ \l -> do 
                                        px <- readArray a (i + k - 1, j + l - 1)
                                        writeArray a (i,j) $ (kr ! (k,l)) * px
                                return a

scalarMult = scalarOp (*)

