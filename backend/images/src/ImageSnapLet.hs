{-# LANGUAGE TemplateHaskell, OverloadedStrings, NoMonomorphismRestriction #-}
module ImageSnapLet (
    ImageConfig(..),
    HasImageSnapLet(..),
    dumpdir,
    servdir,
    allowedTypes,
    uploadImage,
    serveImage, 
    initImage

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
import Magic.Data 
import qualified Data.Text as T
import Data.List 
import qualified SqlTransactionSnaplet as S


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

uploadImage e h = do 
    at <- gets _allowedTypes 
    dd <- gets _dumpdir
    sd <- gets _servdir
    m <- gets _magicctx
    handleFileUploads dd (setMaximumFormInputSize (1024 * 200) $ defaultUploadPolicy) (const $ allowWithMaximumSize (1024 * 200)) $ \xs -> do
        when (null xs) $ e "no file uploaded"
        case snd $ head xs of 
            Left x -> e (T.unpack $ policyViolationExceptionReason x)
            Right f -> do 
                mt <- liftIO $ magicFile m f
                when (not $ anyAllowed mt at) $ e "wrong mimetype"
                h sd f mt  
                
    return undefined 

anyAllowed mt = or . foldr step [] 
    where step x z = x `isInfixOf` mt : z

serveImage e h = do 
    sd <- gets _servdir 
    at <- gets _allowedTypes
    fp <- h
    m <- gets _magicctx
    b <- liftIO $ doesFileExist (joinPath [sd,fp])
    when (not b) $ e "file doesn't exist"
    mt <- liftIO $ magicFile m (joinPath [sd, fp])
    liftIO $ print (head at)
    when (not $ anyAllowed mt at) $ e $ "wrong mimetype" ++ (show mt)
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

