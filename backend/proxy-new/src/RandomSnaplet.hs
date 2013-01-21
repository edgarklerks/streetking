{-# LANGUAGE TemplateHaskell, FlexibleInstances, FlexibleContexts,OverloadedStrings, RankNTypes, ExistentialQuantification #-}
module RandomSnaplet(
    RandomConfig,
    HasRandom(..),
    Variate(..),
    getUniform,
    getUniformR,
    getUniqueKey,
    initRandomSnaplet,
    l8,
    l16,
    l32,
    l64
)where

import System.Random.MWC
import Control.Monad.Primitive
import qualified Data.ByteString as B 
import qualified Data.ByteString.Char8 as C 
import Data.String 
import Data.Word 
import Data.Char 
import Control.Monad
import Control.Applicative
import Control.Lens
import qualified Data.Vector as V
import Control.Monad.Trans
import Snap.Core 
import Snap.Snaplet
import Control.Monad.State 

newtype Base64 a = Base64 {
               unBase64 :: B.ByteString 
        }

data L = forall a. Variate (Base64 a) => L a

data RandomConfig = RC {
            _seed :: GenIO, 
            _length ::   L 
        }

makeLenses ''RandomConfig

class HasRandom b where 
    randomLens :: SnapletLens (Snaplet b) (Snaplet RandomConfig)


initRandomSnaplet :: (Variate (Base64 a)) => a ->  SnapletInit b (RandomConfig)
initRandomSnaplet l = makeSnaplet "RandomSnaplet" "fast seeded random generator" Nothing $ do 
                printInfo "generating seed"
                g <- liftIO gen

                return $ RC g (L l)


getUniqueKey :: (MonadState RandomConfig m, MonadIO m) => m (B.ByteString)
getUniqueKey = do 
            p <- gets _length
            s <- gets _seed
            case p of 
                (L a) -> liftIO $ _getUniqueKey a s 
getUniform :: (MonadState RandomConfig m, MonadIO m, Variate a) => m a
getUniform = do 
        p <- gets _seed 
        liftIO $ uniform p 

getUniformR :: (MonadState RandomConfig m, MonadIO m, Variate a) => (a,a) -> m a 
getUniformR r = do 
            p <- gets _seed
            liftIO $ uniformR r p

_getUniqueKey :: (Variate (Base64 a)) => a -> GenIO -> IO B.ByteString 
_getUniqueKey l g = fmap unpackB64 $ genUniqueKey l g 

genUniqueKey :: Variate (Base64 a) => a -> GenIO -> IO (Base64 a)
genUniqueKey _ = uniform 





instance Variate (Base64 L8) where 
        uniform g = do 
                xs <- forM [0..7] (const $ uniform g)
                return (packB64 (map64 <$> xs))

instance Variate (Base64 L16) where 
        uniform g = do 
                xs <- forM [0..15] (const $ uniform g)
                return (packB64 (map64 <$> xs))

instance Variate (Base64 L32) where 
        uniform g = do 
                xs <- forM [0..31] (const $ uniform g)
                return (packB64 (map64 <$> xs))

instance Variate (Base64 L64) where 
        uniform g = do 
                xs <- forM [0..63] (const $ uniform g)
                return (packB64 (map64 <$> xs))



packB64 :: [Word8] -> Base64 l 
packB64 = Base64 . B.pack

unpackB64 (Base64 xs) = xs
data L8 
data L16 
data L32 
data L64



instance Show (Base64 a) where 
        show (Base64 xs) = C.unpack xs

gen :: IO (GenIO)
gen = initialize =<< generateSeed 

generateSeed :: IO (V.Vector Word32)
generateSeed = withSystemRandom $ \g -> uniformVector g 100 :: IO (V.Vector Word32)



-- ascii 
-- A :: 65 
-- Z :: 90
-- a :: 97
-- z :: 122 
l = 90 - 65 + (122 - 97) 

map64 :: Word8 -> Word8 
map64 p | p >= 0 && p <= 25  = fromIntegral (65 + p)
map64 p | p > 25 && p <= 51 = fromIntegral (97 + (p - 26)) 
map64 p | p > 51 && p <= 61 = fromIntegral $ 48 + (p - 52) 
map64 62 = $([|fromIntegral . ord $ '.'|])
map64 63 = $([|fromIntegral . ord $ '='|]) 
map64 n = map64 (n `mod` 64)


l8 :: L8 
l8 = let h = h in h 
l16 :: L16
l16 = let h = h in h 
l32 :: L32
l32 = let h = h in h 
l64 :: L64 
l64 = let h = h in h 


