{-# LANGUAGE TupleSections #-}
module OAuth.OAuth1a where 


import System.Miniserver 
import OAuth.Types 
import Data.URLEncoded 
import System.Entropy
import qualified Data.ByteString.Char8 as B
import qualified Data.ByteString as BW

import Data.Time.Clock.POSIX
import Data.Time.Clock
import Data.List
import Control.Monad
import Control.Applicative
import Control.Monad.Split 
import Data.Maybe
import Data.HMAC
import Data.Char 
import Data.Word
import qualified Data.ByteString.Base64 as R

type Timestamp = Int 

oauth1aAuth m  = do 
    xs <- getEntropy 32
    t <- fromEnum <$> getPOSIXTime :: IO Timestamp
    let p =   signRequest (requestTokenMethod m) (request_token_uri m) xs t m [] 
    return p


main = do 
    n <- oauth1aAuth $ defaultTwitterOAuthPars "test" "test"
    print n

toBase64 :: String -> String 
toBase64 = fromOctet . BW.unpack . R.encode . BW.pack . toOctet

fromOctet :: [Word8] -> String 
fromOctet = fmap (chr . fromIntegral)
toOctet :: String -> [Word8]
toOctet = fmap (fromIntegral . ord)

signRequest :: Method -> String -> B.ByteString -> Timestamp -> OAuth1aLoginPars -> [(String, String)] -> String 
signRequest x y xs t m ts = let ps = presignRequest x y xs t m ts
                                cs = toOctet (consumer_key m)
                            in fromOctet $ BW.unpack $ R.encode $ BW.pack $ hmac_sha1 cs ps  

presignRequest :: Method -> String -> B.ByteString -> Timestamp -> OAuth1aLoginPars -> [(String, String)] -> [Word8]
presignRequest x y xs t m ps = toOctet $  prefix1a x y (zip1a fields)
    where
            fields = sort $ [("oauth_consumer_key", consumer_key m), ("oauth_callback", callback_uri m), ("oauth_nonce", B.unpack (R.encode xs)), ("oauth_signature_method", show (signature_method m)), ("oauth_timestamp", show t), ("oauth_version", (version m)) ] ++ ps 

zip1a :: [(String, String)] -> String
zip1a xs = rq $ mintercalate "&" $ mrezipWith (\x y -> return $ x ++ ("=" ++ y)) return xs
    where rq = tail . snd . break (=='=') . show . importList . (\x -> [x]) .  ("rem",)

prefix1a :: Method -> String -> String -> String 
prefix1a m p = (show m++). ("&"++).((rq p++ "&")++) 
    where rq = tail . snd . break (=='=') . show . importList . (\x -> [x]) .  ("rem",)
