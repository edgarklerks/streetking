{-# LANGUAGE MultiParamTypeClasses, TupleSections, RankNTypes, GeneralizedNewtypeDeriving, FlexibleInstances, UndecidableInstances, BangPatterns #-}
module Main where 

import Data.List
import Control.Applicative
import Control.Monad
import Control.Monad.Reader 
import Control.Arrow
import Codec.Image.DevIL
import Data.Vector.Unboxed.Mutable as V hiding (swap) 
import Data.Array.Unboxed
import Data.Array.Base
import Data.Word
import Control.Monad.ST.Strict
import Data.Maybe
import Data.STRef.Strict
import Data.Bits 
import Test.QuickCheck hiding ((.&.)) 
import Data.Semigroup
import Debug.Trace
import System.Directory
import System.Environment
import System.Process
import Data.Binary
import Color 
import Image
import qualified Data.ByteString.Lazy as B




type Image s = STVector s Word32 




storePos :: (Word16,Word16) -> Int 
storePos (x,y) = ((fromIntegral x) `shiftL` 16) `xor` (fromIntegral y)

retrievePos :: Int -> (Word16, Word16)
retrievePos x = ((fromIntegral $ x `shiftR` 16), (fromIntegral $ x .&. 65535))

posBitBijective = property step 
    where step :: (Word16, Word16) -> Bool 
          step (x,y) = (retrievePos $ storePos (x,y)) == (x,y)

hashArray :: Int -> Int -> UArray (Int, Int) Int 
hashArray rows cols = array ((0,0), (rows, cols)) (genPosList rows cols) 

hashPos :: Int -> Int -> ((Int,Int) -> Int)
hashPos rows cols  = ((hashArray rows cols) !)

genPosList :: Int -> Int -> [((Int, Int) ,Int)]
genPosList rows cols = (concatMap (step [0.. rows]) [0..cols]) `Prelude.zip` [0..]
    where step rows x = fmap (\y -> (fromIntegral y, fromIntegral x) ) rows 

unHashArray :: Int -> Int -> Array Int (Int, Int)
unHashArray rows cols = array (0, (rows + 1) * (cols + 1)) $ fmap Main.swap $   genPosList rows cols
unhashPos :: Int -> Int -> (Int -> (Int, Int))
unhashPos rows cols = ((unHashArray rows cols) !) 

data Direction = U
               | UR
               | R
               | DR 
               | D
               | DL
               | L 
               | UL
        deriving (Eq, Show,Enum,Read)

instance Semigroup Direction where 
    (<>) U U = U 
    (<>) U R = UR
    (<>) U L = UL 
    (<>) UR U = UR
    (<>) UR R = R
    (<>) UR L = U
    (<>) R L = UR 
    (<>) R U = R 
    (<>) R R = DR
    (<>) DR L = R
    (<>) DR U = DR
    (<>) DR R = D
    (<>) D L = DR
    (<>) D U = D 
    (<>) D R = DL
    (<>) DL L = D
    (<>) DL U = DL 
    (<>) DL R = L
    (<>) L L = DL
    (<>) L U = L 
    (<>) L R = UL
    (<>) UL L = L
    (<>) UL U = UL
    (<>) UL R = U
    (<>) U D = D 
    (<>) R D = L 
    (<>) DR D = UL
    (<>) D D = U 
    (<>) DL D = UR
    (<>) L D = R
    (<>) UL D = DR
    (<>) UR D = DL
    (<>) x y = error $ "cannot add: " ++ (show x) ++ " "  ++ (show y)

data AntEnv s = AE {
        image :: Image s, 
        imagebounds :: !(Int, Int),
        direction :: STRef s Direction,
        pos :: STRef s (Int, Int),
        hist :: STRef s [Point],
        sprayed :: STRef s [(Int, Int)],
        scanned :: STRef s [(Int, Int)],
        unhashArray :: Array Int (Int, Int),
        hasharray ::  UArray (Int, Int) Int,
        prevdir :: Direction
    }

data Point = Mark !(Int, Int) | Path !(Int, Int)
    deriving Show

newtype Ant s a = Ant {
        unAnt ::  ReaderT (AntEnv s) (ST s) a
    } 
    deriving (Functor, Applicative, Monad, MonadReader (AntEnv s))

{-- algorithmic stuff --}


walkImage :: Ant s ()
walkImage = do 
    p <- getPos 
    xs <- scanFront 
    case sniff Black xs of 
                Nothing ->  return ()
                Just a -> do  
                        a `seq` gotoDir a 
                        sprayBack 
                        walkImage


mkList :: (Int, Int) -> (Int, Int) -> [(Int, Int)]
mkList (x1,y1) (x2, y2) = xn `Data.List.zip` yn 
    where xn |  x1 > x2 = reverse [x2 .. x1]
             |  x1 < x2 = [x1 .. x2] 
             | x1 == x2 = [x1..]
          yn | y1 > y2 = reverse [y2 .. y1]
             | y1 < y2 = [y1 .. y2]
             | y1 == y2 = [y1..]



foldCenter :: Show a => ((Int, Int) -> RGB -> Maybe a) -> Direction -> Ant s [a] 
foldCenter f d = do 
        i <- asks image 
        let (xp,yp) = toPos d
        let (xm,ym) = toPos (d <> D)

        let count (!x',!y') (!x,!y) = do 
                    c <- getColor (x,y)
                    let ma = f (x,y) c
                    let z = (x' + x, y' + y)
                    case ma of 
                        Nothing -> return Nothing
                        Just a -> return (Just (a,z))
        (x,y) <- getPos 
        -- one half 
        xs <- unfoldrM (count (xp,yp)) (x + xp,y +yp)
        -- two half 
        ys <- unfoldrM (count (xm, ym)) (x + xm,y + ym)
        c <- getColor (x,y)
        case f (x,y) c of 
            Nothing -> return (ys ++ xs)
            Just a -> return (ys ++ (a : xs))
   
foldSide :: Show a => ((Int, Int) -> RGB -> Maybe a) -> Direction -> Ant s [a] 
foldSide f d = do 
        i <- asks image 
        let (xp,yp) = toPos d
        let count (!x',!y') (!x,!y) = do 
                    c <- getColor (x,y)
                    let ma = f (x,y) c
                    let z = (x' + x, y' + y)
                    case ma of 
                        Nothing -> return Nothing
                        Just a -> return (Just (a,z))
        (x,y) <- getPos 
        -- one half 
        xs <- unfoldrM (count (xp,yp)) (x + xp,y +yp)
        -- two half 
        c <- getColor (x,y)
        case f (x,y) c of 
            Nothing -> return (xs)
            Just a -> return (a : xs)
   


unfoldrM :: Monad m => (a -> m (Maybe (b,a))) -> a -> m [b]
unfoldrM f !a = do 
            b <- f a
            case b of 
                Nothing -> return []
                Just (b,a') -> do 
                    xs <- unfoldrM f a'
                    return (b : xs)
                    

dirLength :: Direction -> Double
dirLength a | a `elem` [U,R,L,D] = 1
            | otherwise = sqrt 2

findAllLengthFrom :: Direction -> Ant s [(Direction, Double)]
findAllLengthFrom (fromEnum -> d) = filter (\x -> fromEnum (fst x) `elem` [mod (d - 1) mx, mod d mx, mod (d + 1) mx]) <$> findAllLength
    where mx = fromEnum UL + 1 

findAllLength :: Ant s [(Direction, Double)]
findAllLength = do 
        xs <- forM  [U .. UL] $ \i -> do
                xs <- foldSide (\y x -> case x of 
                                    Black -> Just (dirLength i)
                                    otherwise -> Nothing) i  
                return (sum xs)
        return ([U .. UL] `Data.List.zip` xs)

findAllCells :: Ant s [(Direction, [(Int,Int)])]
findAllCells = do 
        xs <- forM [U .. UL] $ \i -> do 
                xs <- foldCenter (\y x -> case x of 
                                        Black -> Just y
                                        otherwise -> Nothing 
                                    ) i
                return xs 
        return ([U .. UL] `Data.List.zip` xs)


findOrtogonal :: Ant s Direction
findOrtogonal = do 
                xs <- forM  [U .. UL] $ \i -> do
                            xs <- foldCenter (\y x -> case x of 
                                                    Black -> Just (dirLength i)
                                                    otherwise -> Nothing) i  
                            return (sum xs)

                return $ snd (minimumBy (\x y -> compare (fst x) (fst y)) $ xs `Data.List.zip` [U,R,UR,DR,L,UL,D])

findOrthogonalPathWidth :: Ant s ([(Int,Int)], Int)
findOrthogonalPathWidth = do 
        d <- findOrtogonal 
        xs <- foldCenter step d 
        return (xs, Data.List.length xs)
    where step (x,y) Black = Just (x,y)
          step _ _ = Nothing  

findCenterPointWidth :: Ant s (Maybe ((Int, Int), Int))
findCenterPointWidth = do   
                (xs, p) <- findOrthogonalPathWidth
                let step (x,y) (x',y') = (x' + x, y' + y)
                let (s,t) = foldr step (0,0) xs 
                if p == 0 then 
                        return Nothing 
                    else 
                        return $ Just ((s `div` p , t `div` p ), p)

lookahead :: Int -> Ant s [(Direction, RGB)]
lookahead n = do 
        i <- asks image 
        sc <- asks scanned 
        d <- getDir 
        (x,y) <- getPos 
        let xs = [L,R,D,U]
        forM xs $ \i-> 
                      let (dx, dy) = toPos (d <> i) 
                      in do 
                        liftST $ do 
                            z <- readSTRef sc
                            writeSTRef sc ((x + n * dx, y + n * dy):z)
                        c <- getColor (n * dx + x, n * dy + y)
                        return $ (i,c)


sniff :: RGB -> [(Direction, RGB)] -> Maybe Direction 
sniff r xs = case filter (\(x,y) -> y==r) xs of 
                    [] -> Nothing 
                    ((x,y):_) -> Just x 

sprayBack :: Ant s () 
sprayBack = do 
        i <- asks image 
        d <- getDir 
        sb <- asks sprayed 
        (x,y) <- getPos 
        let xs = [D]
        forM xs $ \j -> let (dx,dy) = toPos (d <> j)
                       in do
                            liftST $ do 
                                z <- readSTRef sb 
                                writeSTRef sb ((x + dx, y) : (x,y + dy) : (x + dx, y + dy):z)
                            setColor (x + dx, y + dy) Red 
        return ()

scanFront :: Ant s [(Direction, RGB)]
scanFront = do 
        i <- asks image 
        sc <- asks scanned 
        d <- getDir 
        (x,y) <- getPos 
        let xs = [U,L,R,D]
        forM xs $ \i-> let (dx, dy) = toPos (d <> i) 
                      in do 
                        liftST $ do 
                            z <- readSTRef sc
                            writeSTRef sc ((x + dx, y + dy):z)
                        c <- getColor (dx + x, dy + y)
                        return $ (i,c)

        

gotoDir :: Direction -> Ant s ()
gotoDir d' = do 
    d <- getDir 
    dn <- findOrtogonal
    
    ps <- findAllLengthFrom d  
    let p = fst $ maximumBy (\x y -> compare (snd x) (snd y)) ps 
    
    let (x,y) = toPos p 
    (x',y') <- getPos 
                       
    setDir p
    setPos (x' + x, y' + y)
    xs <- findAllCells  
    mark
    {--
    case fromJust $ lookup (turn p) xs of 
        [] -> mark 
        cells -> do 
            markPos (gtSum cells)
    --}

gtSum :: [(Int,Int)] -> (Int, Int)
gtSum (x:xs) = let (fromIntegral -> p, fromIntegral -> s) = foldr step x xs 
               in (round (p / ss), round (s / ss))
    where step (x,y) (x',y') = (x + x',y + y')
          ss = fromIntegral $ Data.List.length (x:xs)



{-- Ant operations --}


{-- To Pos:
 -           (0,1)
 -            U
 -     
 - (-1,0) L       R (1,0)
 -
 -           D
 -         (0,-1) 
--}

splitDir :: Direction -> [Direction]
splitDir UR = [U,R]
splitDir UL = [U, L]
splitDir DR = [D,R]
splitDir DL = [D,L]
splitDir a = [a]

unsplitDir :: [Direction] -> Direction 
unsplitDir [U,R] = UR 
unsplitDir [U,L] = UL 
unsplitDir [D,R] = DR
unsplitDir [D,L] = DL 
unsplitDir [L,D] = DL
unsplitDir [R,D] = DR
unsplitDir [L,U] = UL
unsplitDir [R,U] = UR



turn U = R
turn UR = DR 
turn R = D 
turn DR = DL
turn D = L 
turn DL = UL
turn L = U
turn UL = UR 

orth' :: Direction -> Direction -> Direction 
orth' DR b | b `elem` [UR,U,R] = UR 
           | b `elem` [DL,L,D] = DL 
orth' DL b | b `elem` [UL,U,L] = UL
           | b `elem` [D,DR,D] = DR 
orth' UR b | b `elem` [UL,U,L] = UL
           | b `elem` [D,DR,R] = DR
orth' UL b | b `elem` [UR,U,R] = UR 
           | b `elem` [DL,L,D] = DL 
orth' U (splitDir -> b) | (L `elem` b) = L
                       | (R `elem` b) = R
orth' D (splitDir -> b) | (L `elem` b) = L
                       | (R `elem` b) = R
orth' R (splitDir -> b) | (U `elem` b) = U 
                       | (D `elem` b) = D 
orth' L (splitDir -> b) | (U `elem` b) = U 
                       | (D `elem` b) = D 
orth' a b = a 

-- first is the normal direction, second is the current ant direction
orth :: Direction -> Direction -> Direction
orth a b = orth' a b



toPos dir = 
    case dir of 
        U -> (0,1)
        D -> (0,-1)
        L -> (-1,0)
        R -> (1,0)
        UL -> (-1,1)
        UR -> (1,1)
        DL -> (-1,-1)
        DR -> (1, -1)

asPos _ (0,1) = U
asPos _ (0,-1) = D 
asPos _ (-1,0) = L 
asPos _ (1,0) = R 
asPos _ (-1,1) = UL
asPos _ (1,1) = UR 
asPos _ (-1,-1) = DL 
asPos _ (1,-1) = DR
asPos _ x = error (show x)

markPos :: (Int,Int) -> Ant s ()
markPos (x,y) = asks hist >>= \h -> liftST (readSTRef h) >>= \u -> liftST (writeSTRef h (Mark (x,y):u))

mark :: Ant s ()
mark = do 
    dir <- getPos 
    h <- asks hist 
    p <- liftST $ readSTRef h
    liftST $ writeSTRef h (Mark dir:p)

point :: Ant s ()
point = do 
    dir <- getPos 
    h <- asks hist 
    p <- liftST $ readSTRef h 
    liftST $ writeSTRef h (Path dir:p)

rewind :: Ant s ()
rewind = do 
    h <- asks hist 
    p <- liftST $ readSTRef h 
    let (rw, hist) = gotoMark p 
    when (Prelude.null hist) $ error "No futher path can be found" 
    liftST $ writeSTRef h hist 
    forM_ rw $ \(Path i) -> setColor i White
    return ()
    

getColor :: (Int, Int) -> Ant s RGB
getColor x = do 
        i <- asks image 
        (r,c) <- getIBounds 
        xy <- encPos x 
        w <- liftST $ V.read i xy
        return (decodeColor w)



setColor :: (Int,Int) -> RGB -> Ant s ()
setColor x y = do 
        let (r,g,b) = asColor y
        i <- asks image 
        (rs,c) <- getIBounds 
        xy <- encPos x 
        liftST $ V.write i xy $ 
               storeColor b 2 $  storeColor g 1 $ 
                (storeColor r 0 0)

gotoMark :: [Point] -> ([Point], [Point]) 
gotoMark xs = (takeWhile (not . ismark) xs, dropWhile (not . ismark) xs)
    where ismark (Mark _) = True 
          ismark _ = False 


forward :: Ant s ()
forward = do 
    dir <- getDir  
    let (dx, dy) = toPos dir 
    (x,y) <- getPos 
    setPos (x + dx, y + dy)
--     p <- findCenterPointWidth 
--    d <- findOrtogonal
--  case p of 
--      Just ((nx,ny),tl) -> do 
--              setPos (nx,ny)
--              trace (show d) $ setDir (turn d <> D)
--      Nothing -> return ()



rgb :: Ant s RGB 
rgb = do 
    w <- focus 
    return $ closestColor (retrieveColor w 0, retrieveColor w 1, retrieveColor w 2)

focus :: Ant s Word32 
focus = do 
    pos <- getPos 
    (x,y) <- getIBounds 
    i <- getImage 
    xy <- encPos pos 
    liftST $ V.read i xy


{-- Accessors --}

getImage :: Ant s (Image s)
getImage = asks image

getIBounds :: Ant s (Int, Int)
getIBounds = asks imagebounds 

getDir :: Ant s Direction
getDir = do 
        d <- asks direction
        liftST $ readSTRef d 


setDir :: Direction -> Ant s ()
setDir d = do
        ref <- asks direction
        liftST $ writeSTRef ref d

modDir :: (Direction -> Direction) -> Ant s ()
modDir f = do 
    d <- getDir 
    setDir (f d)
        

modPos :: ((Int, Int) -> (Int, Int)) -> Ant s ()
modPos f = do 
        p <- getPos 
        setPos (f p)

setPos :: (Int, Int) -> Ant s ()
setPos x = do 
    ref <- asks pos
    liftST $ writeSTRef ref x

getPos :: Ant s (Int, Int)
getPos = do 
        x <- asks pos 
        liftST $ readSTRef x

liftST :: ST s a -> Ant s a
liftST = Ant . lift

{-- 
 - trAnt :: Ant s a -> (forall s. Ant s a)
trAnt (Ant m) = Ant m
--}
runAnt :: (forall s.  Ant s a) -> (Int, Int) -> Direction -> ImageCH -> (a, [Point], [(Int, Int)], [(Int, Int)])
runAnt m p d i = runST $ do 
                s <- newSTRef (d)
                l' <- newSTRef p
                l <- newSTRef []
                t <- newSTRef []
                sc <- newSTRef []
                i' <- fort i  
                let (r,c,_) = snd $ bounds i
                let ha = hashArray c r 
                let uh = unHashArray c r 
                a <- runReaderT (unAnt m) (AE i' (c,r) s l' l t sc uh ha d)
                ls <- readSTRef l
                ts <- readSTRef t
                scs <- readSTRef sc
                return (a, ls, ts, scs)

main :: IO ()
main = do 
    c <- getArgs     
    case c of 
        [d,sp,f, a] -> analyzeImage (Prelude.read d) (Prelude.read sp) f (Prelude.read a) 
        otherwise -> putStrLn "usage: prog <Direction> (X,Y) file animate<1|0>"


analyzeImage :: Direction -> (Int, Int) -> FilePath -> Int -> IO ()
analyzeImage sd sp fp an = do 
    ilInit
    xs <- loadImage fp
    putStrLn "Tracing path..."
    let (res, path, sprays, scans) = runAnt walkImage sp sd xs 
    let ys = flipVertImage xs
    let path'  = colorPath path xs
    let spray' = colorSpray sprays xs
    let scan'  = colorScan scans xs
    let itype = "bmp"
    let f n = n ++ "." ++ itype
    putStrLn "Writing: " 
    putStrLn "dump..."
    sb <- doesFileExist "dump.bin"
    when sb $ removeFile "dump.bin"

    B.writeFile "dump.bin" (encode (fromEnum sd :: Int,fromPoint <$> path))

    putStrLn  "images..."
    forM_ (f <$> ["scan", "spray", "path","last"]) $ \i -> do 
        sb <- doesFileExist i
        when sb $ removeFile i
    writeImage (f "last") $ flipVertImage (colorLast (Data.List.take 20 path) xs)
    writeImage (f "scan") $ flipVertImage scan' 
    writeImage (f "spray") $ flipVertImage spray' 
    writeImage (f "path") $ flipVertImage (drawColorPoints path' (255,255,0) [fromPoint $ head path])

    system("rm -f gif/*.bmp")
    when (an == 1) $ do 
        putStrLn "animations.."
        forM_ (mkGif (fromPoint <$> path) (255,0,0) xs) $ \(k,i) -> do 
            let file = "gif/path_" ++ (show i) ++ ".bmp"
            sb <- doesFileExist file
            when sb $ removeFile file 
            writeImage file (flipVertImage k)
        system("cd gif/; perl animate.pl")
        void $ system("rm -f gif/*.bmp");
    return ()


fromPoint (Mark t) = t
fromPoint (Path t) = t

colorLast :: [Point] -> ImageCH -> ImageCH 
colorLast xs i = drawColorPoints' i  (255,255,255) (\(r,g,b) -> ( (r - 10)  `mod` 255,g, b)) xs

drawColorPoints' :: ImageCH -> (Word8, Word8, Word8) -> ((Word8, Word8, Word8) -> (Word8, Word8, Word8)) -> [Point] -> ImageCH
drawColorPoints' i (r,g,b) f pts = i // (foldr step [] ((fromPoint <$> pts) `Data.List.zip`  colorvals))
    where colorvals = iterate f (r,g,b)
          step ((y,x),(r,g,b)) z = [((x,y,0),r),((x,y,1),g),((x,y,2),b)] ++ z


-- pts = let fp ((y,x),t) = [((x,y,0), r), ((x,y,1),g), ((x,y,2),b), ((x,y,3),255)]


colorSpray :: [(Int, Int)] -> ImageCH -> ImageCH 
colorSpray xs z = drawColorPoints z (255,0,0) xs

colorScan :: [(Int, Int)] -> ImageCH -> ImageCH 
colorScan xs z = drawColorPoints z (0,255,0) xs

colorPath :: [Point] -> ImageCH -> ImageCH 
colorPath xs z = marked (fromPoint <$> filter (ismark) xs) (path (fromPoint <$> filter (not.ismark) xs) z)
    where marked xs z = drawColorPoints z (255,0,255) xs 
          path xs z = drawColorPoints z (0,0,255) xs 
          ismark (Mark _) = True 
          ismark _ = False 
          fromPoint (Mark (x,y)) = (x,y)
          fromPoint (Path (x,y)) = (x,y)

swap (a,b) = (b,a)
-- instance Iso ImageCH (Image s) where 
    
fort m = do 
            let (rows, cols, ch) = snd $ bounds m
            a <- V.replicate ((cols + 1) * (rows + 1)) (0 :: Word32) :: ST s (STVector s Word32) 
            let posf = hashArray cols rows 
            forM_ (assocs m) $ \((i,j,k), e) -> do 
               let pos = posf ! (j,i)
               v <- V.read a pos 
               write a pos (storeColor e k v)
            return a 

testImages :: IO () 
testImages = do 
    ilInit
    s168 <- loadImage "test168.bmp"
    let (a,_,_,_) = runAnt test168 (16,8) R s168
    print "Test168"
    print a
    let (a,_,_,_) = runAnt test257 (25,7) UR s168
    print "Test257"
    print a
    let (a,_,_,_) = runAnt test2519 (25,19) DL s168
    print "Test2519"
    print a
    print "Test475"
    let (a,_,_,_) = runAnt test516 (53,4) DR s168 
    print a
-- (47,6) with direction UR we should get R and (47,5)
--
test516 = do 
    d <- findOrtogonal
    (Just (xs,p)) <- findCenterPointWidth
    return (d,xs,p)

-- at (25,19) there should be length 1 with direction up left 
test2519 = do 
    d <- findOrtogonal
    (Just (xs,p)) <- findCenterPointWidth
    return (d,xs,p)

-- at (25,7) there should be length 1 with direction up right
test257 = do 
    d <- findOrtogonal 
    (Just (xs,p)) <- findCenterPointWidth 
    return (d,xs,p)

-- at (16,8) there should be length 1 with direction up
test168 = do 
       d <- findOrtogonal 
       (Just (xs,p)) <- findCenterPointWidth 
       return (d,xs,p)

decPos p = do 
   a <- asks unhashArray 
   return (a ! p)

encPos p = do 
    a <- asks hasharray
    return (a ! p)
