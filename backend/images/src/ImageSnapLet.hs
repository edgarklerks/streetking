{-# LANGUAGE TemplateHaskell, OverloadedStrings, NoMonomorphismRestriction, OverloadedStrings, ViewPatterns #-}
module ImageSnapLet (
    ImageConfig(..),
    HasImageSnapLet(..),
    dumpdir,
    servdir,
    allowedTypes,
    uploadImage,
    serveImage, 
    initImage,
    getServDir 

) where 

import Control.Monad
import Control.Monad.Trans
import Control.Monad.State
import Control.Applicative
import Snap.Snaplet
import Snap.Core
import Snap.Util.FileUploads
import Snap.Util.FileServe
import Data.Lens.Common 
import Data.Lens.Template
import Config.ConfigFileParser
import System.Directory
import          System.FilePath.Posix
import Magic
import qualified Data.ByteString as B 
import qualified Data.ByteString.Char8 as C 
import Magic.Data 
import qualified Data.Text as T
import Data.List 
import qualified SqlTransactionSnaplet as S
import System.Posix.Files 
import System.Posix.Types 
import Data.Digest.Murmur32
import Data.ByteString.Base64
import Data.Word
import Data.Bits 
import Data.Array 



data ImageConfig = IC {
        _dumpdir :: String,
        _servdir :: String,
        _allowedTypes :: [String],
        _magicctx :: Magic 
    } deriving (Show)

class HasImageSnapLet b where 
    imageLens :: Lens (Snaplet b) (Snaplet ImageConfig)

makeLenses [''ImageConfig]

testConfig = IC "swup" "fnuk" ["test","test22"] 

getServDir = gets _servdir 

uploadImage e h = do 
    at <- gets _allowedTypes 
    dd <- gets _dumpdir
    sd <- gets _servdir
    m <- gets _magicctx
    liftIO (print "uploading file")
    handleFileUploads dd (setMaximumFormInputSize (1024 * 200 * 200 * 200) $ defaultUploadPolicy) (const $ allowWithMaximumSize (1024 * 200 * 200)) $ \xs -> do
        liftIO (print xs)
        when (null xs) $ e "no file uploaded"
        case snd $ head xs of 
            Left x -> liftIO (print "policy violation") *> e (T.unpack $ policyViolationExceptionReason x)
            Right f -> do 
                liftIO (print "Right shit")
                mt <- liftIO $ magicFile m f
                liftIO (print mt)
                when (not $ anyAllowed mt at) $ e "wrong mimetype"
                liftIO (print f)
                h sd f mt  
                
    writeText "{\"result\": true}"

anyAllowed mt = or . foldr step [] 
    where step x z = x `isPrefixOf` mt : z

serveImage e h = do 
    sd <- gets _servdir 
    at <- gets _allowedTypes
    fp <- h
    m <- gets _magicctx
    liftIO (print $ joinPath [sd,fp])
    b <- liftIO $ doesFileExist (joinPath [sd,fp])
    when (not b) $ e "file doesn't exist"
    mt <- liftIO $ magicFile m (joinPath [sd, fp])
    liftIO $ print (head at)
    liftIO $ print "mimetypes"
    liftIO $ print at 
    liftIO $ print "detected type"
    liftIO $ print mt 
    when (not $ anyAllowed mt at) $ e $ "wrong mimetype" ++ (show mt)
    r <- getResponse 
    let s = getHeader "If-None-Match" r  
    case s of 
        Nothing -> serveFile' sd fp 
        Just e -> do 
                etag <- liftIO $ C.pack <$> getEtag (joinPath [sd,fp])
                if (etag == e) then modifyResponse (\r -> setResponseCode 304 $ r)
                               else serveFile' sd fp 


serveFile' sd fp = do 
                etag <- liftIO $ getEtag (joinPath [sd,fp])
                modifyResponse (\r -> addHeader "ETag" (C.pack etag) r)
                serveFile (joinPath [sd,fp])

initImage :: FilePath -> SnapletInit b ImageConfig 
initImage fp = makeSnaplet "ImageSnapLet" "Image manager" Nothing $  do 
    xs <- liftIO $ readConfig fp 
    let (Just (StringC fn)) = lookupConfig "images" xs >>= lookupVar  "dumpdir"
    let (Just (StringC sn)) = lookupConfig "images" xs >>= lookupVar  "servdir"
    let (Just (ArrayC ys)) = lookupConfig "images" xs >>= lookupVar  "types"
    printInfo (T.pack $ show ys)
    liftIO $ createDirectoryIfMissing True fn  
    liftIO $ createDirectoryIfMissing True sn  
    x <- liftIO $ do 
            x <- magicOpen [MagicMime]
            magicLoadDefault x 
            return x
    return $ IC  fn sn ((\(StringC x) -> x) <$> ys) x



getEtag :: FilePath -> IO String 
getEtag fp = do 
        ss <- getFileStatus fp
        let w = fromEnum (modificationTime ss) :: Int  
        return $ hashToString $ (addHash (hashBytestring "myhupslysalt") (fromIntegral w))

{-- 
-
--}
--

splitHash :: Word64 -> [Word8]
splitHash w = selectN w <$> [0..7] 

selectN :: Word64 -> Int -> Word8 
selectN w x = fromIntegral $ (w .&. (255 `shiftL` (x * 8))) `shiftR` (x * 8)

addN :: Word64 -> Word8 -> Int -> Word64 
addN w (fromIntegral -> s) x = w `xor` (s `shiftL` (x * 8))

joinHash :: [Word8] -> Word64 
joinHash xs = foldr step 0  ((fmap fromIntegral xs) `zip` [0..7])
    where step (x,n) z = addN z x n 

hashBytestring :: B.ByteString -> Word64 
hashBytestring = B.foldr hash 98123  

addHash :: Word64 -> Word64 -> Word64 
addHash xs ys = foldr hash ys (splitHash xs)

hashToString :: Word64 -> String 
hashToString xs = do 
            s <- splitHash xs
            word8ToString s

hash :: Word8 -> Word64 -> Word64
hash x h = let hb = h `shiftR` 48 
               hs = h `shiftR` 1 
               ls = hb `shiftL` 63
           in randomLookup x `xor` (ls `xor` hs)
-- 
--
--                
-- 2^7 + 2^6 + 2^5 + 2^4 + 2^3 + 2^2 + 2 + 1 
--
word8ToString :: Word8 -> String 
word8ToString x = charLookup (x .&. 15) : charLookup ( (x `shiftR` 4) .&. 15) : []
randomLookup :: Word8 -> Word64 
randomLookup n = randomTable ! n 

randomTable :: Array Word8 Word64 
randomTable = listArray (0,255) (unfoldr step 5) 
    where step s = Just (s `rotateR` 3, (s `rotateR` 3 + 1 ) `xor` s)

charLookup :: Word8 -> Char
charLookup n = charTable ! (n `mod` 16)  
             
charTable :: Array Word8 Char 
charTable = listArray (0,15) [
         'a','b','c','d'
        ,'e','f','g','h'
        ,'i','j','k','l'
        ,'m','n','q','r'
    ] 
testUnique :: [Word64]
testUnique = hashBytestring <$> (nub  $  [ B.pack [t,s] | t <- [0..255], s <- [0..255] ])

