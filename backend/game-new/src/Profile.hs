{-# LANGUAGE ViewPatterns #-}
module Main where 

import Data.Tournament 
import Data.RacingNew 
import Criterion.Main 
import qualified Codec.Compression.BZip as BZ 
import qualified Codec.Compression.GZip as GZ 
import qualified Codec.Compression.Zlib as ZL 
import qualified Codec.Compression.QuickLZ as QL 
import qualified Data.ByteString.Lazy as B
import qualified Data.ByteString as BS
import System.Random 
import Data.Word
import Control.Applicative 
import Control.Monad
import Data.Int 
import Data.Conversion 
import Model.TournamentReport 
import Model.General 
import Data.SqlTransaction 
import Data.ByteString.Base64
import qualified Data.Serialize as S  
import qualified Data.Binary as B 
import qualified Data.Aeson as A 

getEncodedDataTournament x = runTestDb $ do 
                tr <- load x :: SqlTransaction Connection (Maybe TournamentReport)
                let b = toInRule tr
                let (SqlByteString c) = fromInRule b :: SqlValue 
                case decode c of 
                        Left e -> error (show e)
                        Right c -> do 

                            let decgzip = GZ.decompress (B.fromChunks [c])
                            return decgzip 


loadTournament x = load x :: SqlTransaction Connection (Maybe TournamentReport)

compareBoth x = do 
        tr <- load x :: SqlTransaction Connection (Maybe TournamentReport)
        let b = toInRule tr 
        return $ (S.encode b, B.encode b)



main = do
        g <- newStdGen 
        let a = defaultObj g 
        let b = defaultObjStrict g 
        s <- B.readFile "Notifications.hs"
        t <- BS.readFile "Notifications.hs"

        compressionSize (10000) [
                    ("bzip rnd", (BZ.compress $ a))
                  , ("gzip rnd", (GZ.compress $ a))
                  , ("zlib rnd", (ZL.compress $ a))
                ]
        compressionSize (10000) [
                  ("qlz rnd", (QL.compress $ b))
                ]
        compressionSize (10000) [
                    ("bzip .hs", (BZ.compress $ s))
                  , ("gzip .hs", (GZ.compress $ s))
                  , ("zlib .hs", (ZL.compress $ s))
                ]
        compressionSize (10000) [
                  ("qlz .hs", (QL.compress $ t))
                ]
        let c = QL.compress t 
        let d = GZ.compress s 



        b `seq` a `seq` defaultMain [
            bench "bzip" (whnf (BZ.decompress . BZ.compress) s),
            bench "gzip" (whnf (GZ.decompress . GZ.compress) s),
            bench "zlib" (whnf (ZL.decompress . ZL.compress) s),
            bench "qlz"  (whnf (QL.decompress . QL.compress) t),
            bench "qlz decompress" (whnf (QL.decompress) c),
            bench "gzip decompress" (whnf (GZ.decompress) d)
            ]

class L a where 
    len :: a -> Int

instance L (B.ByteString) where 
    len b = fromIntegral $ B.length b 

instance L (BS.ByteString) where 
    len bs = BS.length bs 

compressionSize rat xs = forM_ xs worker 
    where worker (n, len -> b) = putStrLn $ n ++ ", start size: " ++ (show rat) ++ ", end size: " ++ (show b) ++ ", ratio: " ++ show (fromIntegral b / fromIntegral rat :: Double)

defaultObj = B.pack . take 10000 . randomRs (0,255 :: Word8)
                -- mainTournament 
defaultObjStrict = BS.pack . take 10000 . randomRs (0,255 :: Word8)
                -- mainTournament 

-- Profile races 
mainRace = defaultMain [
                   bench "testDefRace" testDefRace 
                ]
-- Tournament 
mainTournament = defaultMain [
                    bench "testTournament" testTournament 
                ]
