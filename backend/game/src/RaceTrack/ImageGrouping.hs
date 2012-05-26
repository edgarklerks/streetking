{-# LANGUAGE MultiParamTypeClasses, TupleSections, RankNTypes, GeneralizedNewtypeDeriving, FlexibleInstances, UndecidableInstances #-}
module Main where 

import Control.Applicative
import Control.Monad
import Control.Monad.Reader 
import Control.Arrow
import Codec.Image.DevIL
import Data.Vector.Unboxed.Mutable as V 
import Data.Array.Unboxed
import Data.Array.Base
import Data.Word
import Control.Monad.ST
import Data.STRef
import Data.Bits 
import Test.QuickCheck hiding ((.&.)) 




data RGB = Red -- Start point  
         | Green -- Scale measurement
         | Blue -- End point 
         | Black -- Track  
         | White -- Nothing  
         | ErrorColor
    deriving (Show, Eq, Ord, Enum)

type ImageCH = UArray (Int, Int, Int) Word8
type Image s = STVector s Word32 


loadImage :: FilePath -> IO ImageCH 
loadImage = readImage  



class Iso f g where 
    forth :: f -> g 
    back :: g -> f 



storeColor :: Word8 -> Int -> Word32 -> Word32
storeColor (fromIntegral -> v) 0 w = v `xor` w 
storeColor (fromIntegral -> v) 1 w = (shiftL v 8) `xor` w 
storeColor (fromIntegral -> v) 2 w = (shiftL v 16) `xor` w
storeColor (fromIntegral -> v) 3 w = (shiftL v 24) `xor` w 
storeColor v _ w = error "channel not supported"  

retrieveColor :: Word32 -> Int -> Word8 
retrieveColor w 0 =  fromIntegral w 
retrieveColor w 1 = fromIntegral (w `shiftR` 8) 
retrieveColor w 2 = fromIntegral (w `shiftR` 16)
retrieveColor w 3 = fromIntegral (w `shiftR` 24)
retrieveColor w _ = error "channel not supported"

colorBijective = property step 
    where step :: (Word8, Word8, Word8, Word8) -> Bool 
          step (r,g,b,t) = (retrieveColor pck 0, retrieveColor pck 1, retrieveColor pck 2, retrieveColor pck 3) == (r,g,b,t)
                where pck = storeColor t 3 (storeColor b 2 (storeColor g 1 (storeColor r 0 0)))


storePos :: (Word16,Word16) -> Int 
storePos (x,y) = ((fromIntegral x) `shiftL` 16) `xor` (fromIntegral y)

retrievePos :: Int -> (Word16, Word16)
retrievePos x = ((fromIntegral $ x `shiftR` 16), (fromIntegral $ x .&. 65535))

posBitBijective = property step 
    where step :: (Word16, Word16) -> Bool 
          step (x,y) = (retrievePos $ storePos (x,y)) == (x,y)

hashPos :: Int -> Int -> ((Int,Int) -> Int)
hashPos rows cols  = (ph!)
    where ph = array ((0,0), (rows, cols)) (genPosList rows cols) :: UArray (Int, Int) Int 

genPosList :: Int -> Int -> [((Int, Int) ,Int)]
genPosList rows cols = (concatMap (step [0.. rows]) [0..cols]) `Prelude.zip` [0..]
    where step rows x = fmap (\y -> (fromIntegral y, fromIntegral x) ) rows 

unhashPos :: Int -> Int -> (Int -> (Int, Int))
unhashPos rows cols = (ph!) 
    where ph = array (0, (rows + 1) * (cols + 1)) $ fmap Main.swap $   genPosList rows cols  :: Array Int (Int, Int)

data Direction = U 
               | D
               | L
               | R 
               | UL
               | UR 
               | DL
               | DR 
        deriving (Eq, Show)

data AntEnv s = AE {
        image :: Image s, 
        imagebounds :: (Int, Int),
        direction :: STRef s Direction,
        pos :: STRef s (Int, Int)
    }

newtype Ant s a = Ant {
        unAnt ::  ReaderT (AntEnv s) (ST s) a
    } 
    deriving (Functor, Applicative, Monad, MonadReader (AntEnv s))

{-- Ant operations --}
toPos dir = 
    case dir of 
        U -> (0,1)
        D -> (0,-1)
        L -> (1,0)
        R -> (-1,0)
        UL -> (-1,1)
        UR -> (-1,1)
        DL -> (1, -1)
        DR -> (-1, 1)


forward :: Ant s ()
forward = do 
    dir <- readSTRef <$>  asks direction 
       return ()



{-- 
 - trAnt :: Ant s a -> (forall s. Ant s a)
trAnt (Ant m) = Ant m
--}
runAnt :: (forall s.  Ant s a) -> (Int, Int) -> Direction -> ImageCH -> a
runAnt m p d i = runST $ do 
                s <- newSTRef d
                l' <- newSTRef p
                i' <- fort i  
                let (r,c,_) = snd $ bounds i
                runReaderT (unAnt m) (AE i' (r,c) s l')


swap (a,b) = (b,a)
-- instance Iso ImageCH (Image s) where 
    
fort m = do 
            let (rows, cols, ch) = snd $ bounds m
            a <- V.replicate ((cols + 1) * (rows + 1)) (0 :: Word32) :: ST s (STVector s Word32) 
            let posf = hashPos rows cols 
            forM_ (assocs m) $ \((i,j,k), e) -> do 
               let pos = posf (i, j)
               v <- V.read a pos 
               write a pos (storeColor e k v)
            return a 


