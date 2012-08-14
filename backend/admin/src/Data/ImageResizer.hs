module Data.ImageResizer (
    
) where
{- type LMonad = IO (Maybe a)
-- liftIO :: MonadIO m => IO a -> m a
-- liftIO (a :: IO a) = do 
            ((a >>= \a' -> 
            f a') >>= \b -> 
            return (Just a') :: IO (Maybe a))
            (>>=) :: m a -> (a -> m b) -> m b 
-- reset (\p -> shift p (\k ->  forM_ [1..1000] $ \i -> if i `mod` 543 == 0 then return i 
--                             else k (return i)  
-- liftIO a = a >>= 
do 
 a <- f  :: IO (Maybe a)       
 b <- g a  => 
 (>>=) m f = do 
    a <- m 
    (f a)
    
 return b 
 -- (liftIO f) >>= \a -> g a >>= \b -> return b 
 -- (return (Just a')) >>= \a -> 
    -- liftIO :: IO a -> m a
    liftIO a = a >>= \a' -> return (Just a')
  -}                                     
import Control.Monad.Error
import Control.Monad.Error.Class
import Data.ByteString.Char8
--import Data.ByteString.Lazy.Char8
import Data.Magic
import Data.Tuple
--import Database.Upload
import Graphics.GD
import Graphics.Exif
import Prelude hiding (readFile, writeFile)

type Height = Int 
type Width = Int 

type ResizeMonad e a = ErrorT e IO a -- > IO (Either e a)

data ResizeError = WrongMimeType | ImageTooSmall deriving Show

instance Error ResizeError

main :: IO ( )
main = do oldImage <- readFile "Penguins.jpg"
          either <- runErrorT (scaleImage (Just 512) (Just 384) (Image "image/jpeg") oldImage)
          case either of
            Left error -> print error
            Right newImage -> writeFile "ResizedPenguins.jpg" newImage
          
          --print "bla"

scaleImage :: Maybe Height -> Maybe Width -> FileType -> ByteString -> ResizeMonad ResizeError ByteString 
scaleImage imageHeight imageWidth fileType fileContents = do 
    image <- loadImage fileType fileContents
    --angle <- liftIO $ getRotationAngle image
    --image <- liftIO $ rotateImage angle image
    newImage <- redimensionImage image imageHeight imageWidth
    newSize <- liftIO $ imageSize newImage
    testSize newSize
    liftIO (saveJpegByteString (-1) newImage)
    --liftIO $ fmap (pack . B.unpack) (saveJpegByteString (-1) newImage)

redimensionImage :: Error e => Image -> Maybe Height -> Maybe Width -> ResizeMonad e Image
redimensionImage image imageHeight imageWidth = do
    size <- liftIO $ imageSize image
    image2 <- liftIO $ newImage size
    case (imageHeight,imageWidth) of 
      (Just h, Just w) -> liftIO $ (copyRegion (round (fromIntegral (fst size - h) / 2),round (fromIntegral (snd size - w) / 2)) (h,w) image (0,0) image2) >> return image2
      (Just h, Nothing) -> liftIO $ resizeImage h (round (fromIntegral (snd size) / (fromIntegral $ fst size)) * h) image
      (Nothing, Just w) -> liftIO $ resizeImage (round (fromIntegral  (fst size) / (fromIntegral $ snd size)) * w) w image
    --(Nothing, Nothing) ->
    
testSize :: Size -> ResizeMonad ResizeError ()
testSize size = case fst size < 1 of
                     True -> throwError ImageTooSmall
                     False -> case snd size < 1 of
                                True -> throwError ImageTooSmall
                                False -> return ()
                                    

loadImage :: FileType -> ByteString -> ResizeMonad ResizeError Image
loadImage fileType fileContents = case fileType of
       Image "image/jpeg" -> liftIO $ loadJpegByteString fileContents
       Image "image/gif" -> liftIO $ loadGifByteString fileContents
       Image "image/png" -> liftIO $ loadPngByteString fileContents
       --Image "image/png" -> liftIO $ loadPngByteString (B.pack $ unpack fileContents)
       other -> throwError WrongMimeType

getRotationAngle :: Image -> IO (Int)
getRotationAngle image = do
    exifData <- fromFile "Penguins.jpg"
    tagData <- getTag exifData "Orientation"
    case tagData of 
      Just tD -> return $ exif2Haskell $ (read tD :: Int)
      Nothing -> return 0

--turnImage       
exif2Haskell :: (Num a) => a -> a
exif2Haskell 1 = 0
exif2Haskell 2 = 0
exif2Haskell 3 = 2
exif2Haskell 4 = 2
exif2Haskell 5 = 1
exif2Haskell 6 = 1
exif2Haskell 7 = 3
exif2Haskell 8 = 3

--fromFile :: FilePath -> IO Exif
--getTag :: Exif -> String -> IO (Maybe String)
--calculateRatio       