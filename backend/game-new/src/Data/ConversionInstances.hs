{-# LANGUAGE TypeSynonymInstances, FlexibleInstances, OverlappingInstances, MultiParamTypeClasses, IncoherentInstances, RankNTypes, FlexibleContexts, ViewPatterns, ScopedTypeVariables #-}
-- | Instances for conversions 
module Data.ConversionInstances where 
{-- Changelog
- Edgar - added gzip to the object encode / decoding instances 
--}
import Data.InRules
import qualified Data.Aeson as A
import qualified Data.Aeson.Parser as A
import qualified Data.Attoparsec.Number as A
import qualified Data.Text as T 
import qualified Data.Text.Encoding as T
import qualified Data.ByteString as BB 
import qualified Data.ByteString.Lazy as BL 
import qualified Data.ByteString.Char8 as B
import qualified Data.ByteString.Lazy.Char8 as L 
import Database.HDBC.SqlValue 
import qualified Data.Serialize as S
import Control.Monad 
import Data.ByteString.Base64
import qualified Data.Vector as V
import Data.Time.Calendar
import Data.Time.Clock 
import Data.Time.LocalTime
import Data.Ratio
import Data.Default 
import qualified Data.HashMap.Strict as Map
import Data.Hashable 
import Data.Convertible 
import Data.Word 
import Data.Int 
import Control.Applicative 
import Codec.Compression.QuickLZ
import qualified Data.Binary as B 

instance ToInRule Rational where
    toInRule x = InNumber x
instance FromInRule Rational where
    fromInRule (InNumber i) =  i
    fromInRule (InInteger i) = fromIntegral i
    fromInRule (InDouble i) =  toRational i
    fromInRule x = viaReadable x 

instance (ToInRule a) => ToInRule (Map.HashMap String a) where
    toInRule = InObject .  Map.map toInRule
instance (FromInRule a) => FromInRule (Map.HashMap String a) where
    fromInRule (InObject m) = Map.map fromInRule m
    fromInRule _ = error "You gave not an object"

instance (ToInRule a) => ToInRule [a] where
    toInRule = InArray . map toInRule
instance (FromInRule a) => FromInRule [a] where
    fromInRule (InArray xs) = map fromInRule xs
    fromInRule _ = [] 

instance (ToInRule t1, ToInRule t2) => ToInRule (t1, t2) where
    toInRule (x1, x2) = InArray [toInRule x1, toInRule x2]
instance (FromInRule t1, FromInRule t2) => FromInRule (t1, t2) where
    fromInRule (InArray [x, y]) = (fromInRule x, fromInRule y)

instance (ToInRule t1, ToInRule t2, ToInRule t3) => ToInRule (t1, t2, t3) where
    toInRule (x1, x2, x3) = InArray [toInRule x1, toInRule x2, toInRule x3]
instance (FromInRule t1, FromInRule t2, FromInRule t3) => FromInRule (t1, t2, t3) where
    fromInRule (InArray [x1, x2, x3]) = (fromInRule x1, fromInRule x2, fromInRule x3)

instance (ToInRule t1, ToInRule t2, ToInRule t3, ToInRule t4) => ToInRule (t1, t2, t3, t4) where
    toInRule (x1, x2, x3, x4) = InArray [toInRule x1, toInRule x2, toInRule x3, toInRule x4]
instance (FromInRule t1, FromInRule t2, FromInRule t3, FromInRule t4) => FromInRule (t1, t2, t3, t4) where
    fromInRule (InArray [x1, x2, x3, x4]) = (fromInRule x1, fromInRule x2, fromInRule x3, fromInRule x4)

instance (ToInRule t1, ToInRule t2, ToInRule t3, ToInRule t4, ToInRule t5) => ToInRule (t1, t2, t3, t4, t5) where
    toInRule (x1, x2, x3, x4, x5) = InArray [toInRule x1, toInRule x2, toInRule x3, toInRule x4, toInRule x5]
instance (FromInRule t1, FromInRule t2, FromInRule t3, FromInRule t4, FromInRule t5) => FromInRule (t1, t2, t3, t4, t5) where
    fromInRule (InArray [x1, x2, x3, x4, x5]) = (fromInRule x1, fromInRule x2, fromInRule x3, fromInRule x4, fromInRule x5)




instance ToInRule Day where
    toInRule a =  (\(y,m,d) ->  InObject (Map.fromList [("y", toInRule y ),("m", toInRule m ),("d", toInRule d )])) (toGregorian a )
instance FromInRule Day where
    fromInRule xs =  case tod xs of 
                        Just x -> x 
                        Nothing -> error "From Day convert fail. y, m, d do not exist"
        where tod xs = do y <- xs .> "y"
                          m <- xs .> "m"
                          d <- xs .> "d" 
                          return ( fromGregorian (fromInRule y) (fromInRule m) (fromInRule d ) )

instance ToInRule TimeOfDay where
    toInRule (TimeOfDay h m s ) =  InObject (Map.fromList [("h", toInRule h ),("min", toInRule m ),("s", toInRule (toRational s) )])
instance FromInRule TimeOfDay where
    fromInRule xs =  case tod xs of 
                        Just x -> x 
                        Nothing -> error "From TimeOfDay convert fail. h, min, s do not exist "
        where tod xs = do h <- xs .> "h"
                          mi <- xs .> "min"
                          s <- xs .> "s" 
                          return ( TimeOfDay (fromInRule h) (fromInRule mi) (fromRational (fromInRule s )) )


instance ToInRule LocalTime where
    toInRule (LocalTime x y) = unionObj (toInRule x) $ toInRule y

instance FromInRule LocalTime where
    fromInRule (InObject xs)= LocalTime ((fromInRule (InObject xs))::Day) ((fromInRule (InObject xs))::TimeOfDay)



instance ToInRule UTCTime where
    toInRule (UTCTime x y) = toInRule (utcToLocalTime utc (UTCTime x y))
instance FromInRule UTCTime where
    fromInRule (InObject xs)= localTimeToUTC utc ((fromInRule (InObject xs)) ::LocalTime)
    fromInRule x = viaReadable x 

instance (Read a) => Convertible (Readable) a where 
    safeConvert (Readable a) = read a

instance  ToInRule () where
    toInRule () = InArray []

instance  ToInRule Char where
    toInRule x = InString [x]

instance ToInRule InRule where
    toInRule = id
instance FromInRule InRule where
    fromInRule = id

instance ToInRule a => ToInRule (Maybe a) where
    toInRule = maybe InNull toInRule
instance FromInRule a => FromInRule (Maybe a) where
    fromInRule x = if x == InNull then Nothing else Just (fromInRule x)

instance ToInRule Bool where
    toInRule x = InBool x
instance FromInRule Bool where
    fromInRule (InBool x) = x
    fromInRule x = viaReadable x


instance ToInRule String where
    toInRule x = InString x
instance FromInRule String where
    fromInRule (InString x) = x
    fromInRule (InByteString x) = B.unpack x
    fromInRule x = viaReadable x

instance ToInRule L.ByteString where 
    toInRule x = InByteString $ B.concat $ L.toChunks x

instance FromInRule L.ByteString where 
    fromInRule (InByteString x) = L.fromChunks [x]
    fromInRule (InString x) = L.pack x 
    fromInRule x = viaReadable x 

instance ToInRule B.ByteString where
    toInRule x = InByteString x


instance FromInRule B.ByteString where
    fromInRule (InByteString x) = x
    fromInRule (InString x) = B.pack x
    fromInRule x = viaReadable x 


instance ToInRule Integer where
    toInRule x = InInteger x
instance FromInRule Integer where
    fromInRule (InInteger i) = i
    fromInRule (InNumber x) = toInteger $ floor x
    fromInRule (InDouble x) = toInteger $ floor x
    fromInRule x = viaReadable x 


instance ToInRule Int where
    toInRule x = InInteger $ toInteger x
instance FromInRule Int where
    fromInRule (InInteger i) = fromInteger i
    fromInRule (InNumber x) = floor x
    fromInRule (InDouble x) = floor x
    fromInRule x = viaReadable x 

{----}

instance ToInRule Word32 where
    toInRule x = InInteger $ toInteger x
instance FromInRule Word32 where
    fromInRule (InInteger i) = fromInteger i
    fromInRule (InNumber x) = floor x
    fromInRule (InDouble x) = floor x

    fromInRule x = viaReadable x 



instance ToInRule Word64 where
    toInRule x = InInteger $ toInteger x
instance FromInRule Word64 where
    fromInRule (InInteger i) = fromInteger i
    fromInRule (InNumber x) = floor x
    fromInRule (InDouble x) = floor x
    fromInRule x = viaReadable x 


instance ToInRule Int32 where
    toInRule x = InInteger $ toInteger x
instance FromInRule Int32 where
    fromInRule (InInteger i) = fromInteger i
    fromInRule (InNumber x) = floor x
    fromInRule (InDouble x) = floor x
    fromInRule x = viaReadable x 

instance ToInRule Int64 where
    toInRule x = InInteger $ toInteger x
instance FromInRule Int64 where
    fromInRule (InInteger i) = fromInteger i
    fromInRule (InNumber x) = floor x
    fromInRule (InDouble x) = floor x
    fromInRule x = viaReadable x 



instance ToInRule Double where
    toInRule x = InDouble x
instance FromInRule Double where
    fromInRule (InDouble i) = i
    fromInRule (InNumber x) = fromRational x
    fromInRule (InInteger x) = fromIntegral x
    fromInRule x = viaReadable x 

double2Float :: Double -> Float 
double2Float  = fromRational . toRational

float2Double :: Float -> Double 
float2Double  = fromRational . toRational



instance ToInRule Float where
    toInRule x = InDouble $ float2Double x
instance FromInRule Float where
    fromInRule (InDouble i) = double2Float i
    fromInRule (InNumber x) = fromRational x
    fromInRule (InInteger x) = fromIntegral x
    fromInRule x = viaReadable x 


-- | Renders InRule to String.
instance ToInRule SqlValue where 
    toInRule = convFromSql 
instance FromInRule SqlValue where 
    fromInRule = convSql
-- Instances for Aeson 
instance ToInRule A.Value where 
    toInRule (A.Object xs) = InObject $ fmap step $ hmapKeys T.unpack xs
        where step a = toInRule a 
    toInRule (A.Array xs) = InArray $  V.toList $ fmap toInRule xs 
    toInRule (A.Bool a) = InBool a 
    toInRule (A.Number (A.I a)) = InInteger a 
    toInRule (A.Number (A.D a)) = InDouble a 
    toInRule (A.Null) = InNull 
    toInRule (A.String xs) = InByteString (B.pack $ T.unpack xs) 

instance FromInRule A.Value where 
    fromInRule (InObject xs) = A.Object $ fmap step $ hmapKeys T.pack xs 
            where step = fromInRule  
    fromInRule (InArray xs) = A.Array $ V.fromList $ fmap fromInRule xs
    fromInRule (InBool a) = A.Bool a 
    fromInRule (InInteger xs) = A.Number (A.I xs)
    fromInRule (InDouble xs) = A.Number (A.D xs)
    fromInRule (InNumber xs) = A.Number (A.D $ fromRational xs)
    fromInRule (InNull) = A.Null
    fromInRule (InString xs) = A.String $ T.pack xs 
    fromInRule (InByteString xs) = A.String $ T.pack $ B.unpack xs
instance (ToInRule k, ToInRule v) => ToInRule (Map.HashMap k v) where 
                toInRule = toInRule . fmap (\(k,v) -> (toInRule k, toInRule v)) . Map.toList 

instance (Eq k, Hashable k, FromInRule k, FromInRule v) => FromInRule (Map.HashMap k v) where 
                fromInRule (InArray xs) = Map.fromList $ fmap (\(InArray [k,v]) -> (fromInRule k, fromInRule v)) xs

instance (A.ToJSON v, A.ToJSON k) => A.ToJSON (Map.HashMap k v) where 
            
            toJSON xs = A.Array $ V.fromList $ fmap A.toJSON $ Map.toList xs 


instance (Hashable k, Eq k, A.FromJSON v, A.FromJSON k) => A.FromJSON (Map.HashMap k v) where 
            parseJSON value = case value of 
                                    A.Array xs -> do 
                                                     xs <- forM (fmap A.fromJSON $ V.toList xs) $ \i -> do 
                                                                        case i of 
                                                                            A.Success a -> return a
                                                                            A.Error s -> fail s 
                                                     return $ Map.fromList xs  




instance Default (Map.HashMap k v) where 
            def = Map.empty 
-- decode :: (SqlValue -> Either error B.ByteString)
-- S.decode :: (B.ByteString -> Either error InRule)
-- base64
--  |
-- \ / 
-- decode
--  | binary gzip data 
-- \|/
-- quicklz 
--  | serialized data 
-- \/
-- S.decode 
--   |
--  \|/
--  InRule 


convFromSql :: SqlValue -> InRule  
convFromSql (SqlString s) = toInRule s
convFromSql (SqlByteString  s) = case (S.decode <=< (fmap decompress . decode)) s of 
                                    Left _ -> InByteString s
                                    Right a -> a
convFromSql (SqlWord32  s) = toInRule s
convFromSql (SqlWord64   s) = toInRule s
convFromSql (SqlInt32  s) = toInRule s
convFromSql (SqlInt64  s) = toInRule s
convFromSql (SqlInteger   s) = toInRule s
convFromSql (SqlChar  s) = toInRule s
convFromSql (SqlBool  s) = toInRule s
convFromSql (SqlDouble   s) = toInRule s
convFromSql (SqlRational  s) = toInRule s
convFromSql (SqlLocalDate  s) =  toInRule s
convFromSql (SqlLocalTimeOfDay  s) = toInRule (s ::TimeOfDay )
convFromSql (SqlLocalTime  s) =  toInRule ( s::LocalTime ) 
convFromSql (SqlUTCTime  s) = toInRule s
convFromSql SqlNull = InNull


convSql ::  InRule -> SqlValue
convSql (InNumber r) 
    | denominator r == 1 = toSql (numerator r)
    | otherwise          = toSql (fromRational r :: Double)
convSql (InDouble dd) =  toSql dd
convSql (InInteger dd) =  toSql  dd
convSql (InBool True) =  toSql  True
convSql (InBool False) = toSql  False
convSql InNull = SqlNull
convSql (InString s) =  toSql s
convSql (InByteString s) = toSql s
convSql r = SqlByteString (encode $ compress $ S.encode r)  


put8 :: Word8 -> S.Put 
put8 = S.put 

toWord64 :: Int -> Word64 
toWord64 = fromIntegral

put8b :: Word8 -> B.Put 
put8b = B.put 

instance B.Binary InRule where 
    put x = B.put (B.pack "*1*-%*1*") *> put' x
        where 
            put' (InByteString b) = put8b 0  *> B.put b
            put' (InInteger b) = put8b 1 *> B.put b
            put' (InDouble b) = put8b 2 *> B.put b
            put' (InNumber b) = put8b 3 *> B.put b 
            put' (InBool b) = put8b 4 *> B.put b
            put' (InNull) = put8b 5
            put' (InArray xs) = put8b 6 *> B.put (toWord64 $ length xs) *> void (forM_ xs B.put)
            put' (InObject xs) = put8b 7 *> serializeHashMapb xs
            put' (InString x) = put8b 8 *> B.put x 

    get = get' 
        where get' = do 
                 p <- B.get :: B.Get B.ByteString 
                 unless (p == B.pack "*1*-%*1*") $ fail "fali"
                 c <- B.get :: B.Get Word8 
                 case c of 
                    0 -> InByteString <$> B.get 
                    1 -> InInteger <$> B.get 
                    2 -> InDouble <$> B.get 
                    3 -> InNumber <$> B.get 
                    4 -> InBool <$> B.get 
                    5 -> pure InNull 
                    6 -> do 
                        lt <- B.get :: B.Get Word64 
                        xs <- replicateM (fromIntegral lt) $ B.get 
                        return (InArray xs)
                    7 -> do
                        lt <- B.get :: B.Get Word64 
                        xs <- replicateM (fromIntegral lt) $ (,) <$> B.get <*> B.get 
                        return (InObject $ Map.fromList xs)
                    8 -> InString <$> B.get
                    n -> fail (show n)
                



serializeHashMapb xs = let ys = Map.toList xs
                      in B.put (toWord64 $ length ys) *> 
                            forM_ ys (\(k,v) -> 
                                B.put k *> B.put v)

instance S.Serialize InRule where 
    put x = S.put (B.pack "*1*-%*1*") *> put' x
        where 
            put' (InByteString b) = put8 0  *> S.put b
            put' (InInteger b) = put8 1 *> S.put b
            put' (InDouble b) = put8 2 *> S.put b
            put' (InNumber b) = put8 3 *> S.put b 
            put' (InBool b) = put8 4 *> S.put b
            put' (InNull) = put8 5
            put' (InArray xs) = put8 6 *> S.put (toWord64 $ length xs) *> void (forM_ xs S.put)
            put' (InObject xs) = put8 7 *> serializeHashMap xs
            put' (InString x) = put8 8 *> S.put x 

    get = get' 
        where get' = do 
                 p <- S.get :: S.Get B.ByteString 
                 unless (p == B.pack "*1*-%*1*") $ fail "fali"
                 c <- S.get :: S.Get Word8 
                 case c of 
                    0 -> InByteString <$> S.get 
                    1 -> InInteger <$> S.get 
                    2 -> InDouble <$> S.get 
                    3 -> InNumber <$> S.get 
                    4 -> InBool <$> S.get 
                    5 -> pure InNull 
                    6 -> do 
                        lt <- S.get :: S.Get Word64 
                        xs <- replicateM (fromIntegral lt) $ S.get 
                        return (InArray xs)
                    7 -> do
                        lt <- S.get :: S.Get Word64 
                        xs <- replicateM (fromIntegral lt) $ (,) <$> S.get <*> S.get 
                        return (InObject $ Map.fromList xs)
                    8 -> InString <$> S.get
                    n -> fail (show n)
                



serializeHashMap xs = let ys = Map.toList xs
                      in S.put (toWord64 $ length ys) *> 
                            forM_ ys (\(k,v) -> 
                                S.put k *> S.put v)
-- Dirty fallback strategy
instance FromInRule (Readable) where 
    fromInRule = asReadable


