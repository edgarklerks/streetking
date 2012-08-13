module Color where

import Data.Word 
import Data.Bits
import Test.QuickCheck

data RGB = Red -- Start point  
         | Green -- Scale measurement
         | Blue -- End point 
         | Black -- Track  
         | White -- Nothing  
         | ErrorColor
    deriving (Show, Eq, Ord, Enum)

asColor :: RGB -> (Word8, Word8, Word8)
asColor Red = (255,0,0)
asColor Green = (0,255,0)
asColor Blue = (0,0,255)
asColor Black = (0,0,0)
asColor White = (255,255,255)
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

decodeColor :: Word32 -> RGB 
decodeColor w = closestColor (retrieveColor w 0, retrieveColor w 1, retrieveColor w 2)

colorChannels :: Word32 -> (Word8,Word8,Word8)
colorChannels w = (,,) (retrieveColor w 0) (retrieveColor w 1) (retrieveColor w 2)

channelColors :: (Word8, Word8, Word8) -> Word32 
channelColors (r,g,b) = storeColor r 0 $ storeColor g 1 $ storeColor b 2 0


{-- Based on color channel dominance --}
closestColor :: (Word8, Word8, Word8) -> RGB 
closestColor (255,255,255) = White
closestColor (0,0,0) = Black 
closestColor (r,g,b) | (g >= r && g > b) || (g > r && g >= b) = Green 
                     | (r >= g && r > b) || (r > g && r >= b) = Red
                     | (b >= g && b > r) || (b > g && b >= r) = Blue 
                     | (b == g && r == g) = case r >= 200 of
                                            True -> White 
                                            False -> Black 
                     | otherwise = ErrorColor



