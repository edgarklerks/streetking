{-# Language TypeSynonymInstances, FlexibleInstances, IncoherentInstances, ViewPatterns #-}
module Data.Conversion where

-- Change: removed Json 

import Data.List
import qualified Data.HashMap.Strict as Map
import Data.Ratio 

import Data.InRules

import Data.Object
import Control.Monad
import qualified Data.Aeson as A
import qualified Data.Aeson.Parser as A
import qualified Data.Attoparsec.Number as A
import Data.Attoparsec
import qualified Data.Text as T 
import qualified Data.Text.Encoding as T
import qualified Data.Vector as V
import Test.QuickCheck
import Data.Convertible
import Control.Monad.State
import qualified Data.Serialize as S

-- 
import qualified Data.ByteString.Char8 as B
-- import Network.ByteString
--
import Database.HDBC

import Data.Time.Calendar
import Data.Time.Clock 
import Data.Time.LocalTime
import Data.Fixed
--import Codec.Compression.GZip
import Data.ByteString.Base64



stringLike ::  String -> String
stringLike text = "%" ++ text ++ "%" 


--TODO: limit the hour, min & second to normal time +leap second/minute 

timeStamp' :: Integer  -> Int -> Int -> Int -> Int -> Data.Fixed.Pico -> LocalTime
timeStamp' y m d h min s = LocalTime (fromGregorian y m d) (TimeOfDay h min s )


timeStamp :: Integer  -> Int -> Int -> Int -> Int -> Data.Fixed.Pico -> Integer
timeStamp y m d h mi s = floor (localTimeToUnixTimeStamp (timeStamp' y m d h mi s))

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


startd :: Day
startd = (fromGregorian 1970 1 1)

daysecs :: Double
daysecs = (24 * 60 * 60)

days :: Day -> Double
days x = daysecs * (fromInteger (diffDays x startd) )

timywimy :: TimeOfDay -> Double
timywimy y = daysecs * (fromRational $ timeOfDayToDayFraction y )

localTimeToUnixTimeStamp :: LocalTime -> Double
localTimeToUnixTimeStamp (LocalTime x y) = (days x) + (timywimy y)
{--
  
   --}      
    


typedScalarMapping :: key -> val -> Object key val 
typedScalarMapping k v = Mapping [(k, Scalar v)]

typedMapping :: key -> Object key val -> Object key val 
typedMapping k v = Mapping [(k, v)]



convFromSql :: SqlValue -> InRule  
convFromSql (SqlString s) = toInRule s
convFromSql (SqlByteString  s) = case (S.decode <=< decode) s of 
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


conv2Sql ::  InRule -> SqlValue
conv2Sql (InNumber r) 
    | denominator r == 1 = toSql (numerator r)
    | otherwise          = toSql (fromRational r :: Double)
conv2Sql (InDouble dd) =  toSql dd
conv2Sql (InInteger dd) =  toSql  dd
conv2Sql (InBool True) =  toSql  True
conv2Sql (InBool False) = toSql  False
conv2Sql InNull = SqlNull
conv2Sql (InString s) =  toSql s
conv2Sql (InByteString s) = toSql s
conv2Sql r = SqlByteString (encode $ S.encode r)  


convFromSqlA :: [SqlValue] -> InRule
convFromSqlA xs = InArray (fmap convFromSql xs)

convFromSqlAA :: [[SqlValue]] -> InRule
convFromSqlAA xs = InArray (fmap convFromSqlA xs)
  


{-- --}
convSql ::  InRule -> SqlValue
convSql = conv2Sql
 


conv2SqlArray :: InRule -> [SqlValue]
conv2SqlArray (InArray xs) = fmap conv2Sql xs 
conv2SqlArray _ = error "conv2SqlArray: Not an array"  

-- optional trailing comma is allowed in SQL for hstores. (So no problem there)
toHstoreString :: InRule -> String  
toHstoreString (InObject xs) = Map.foldrWithKey step [] xs
                where step k v z =  ( "\"" ++ k ++ "\"=>" ++ (show ( v) )) ++ " , "++ z 
toHstoreString _ = error "Need an object to map to an hstore string"
 



---------------Test ----------------------

 
testConv2SqlArray ::  [SqlValue]
testConv2SqlArray = conv2SqlArray (InArray [ toInRule (timeStamp 2001 8 11 52 45 23), toInRule (timeStamp 2011 8 12 20 45 23)  ])



testConv2 ::  FromInRule b => InRule -> ([String], [b])
testConv2 (InObject xs) = unzip $ toList (InObject xs)
--                where step k v z =  (k, preConvYaml v):z
--                      stap 

testConv3 (_,b) =  stap b 
    where stap (y:m:d:h:mi:s:[]) = fromGregorian (fromInRule y) (fromInRule m) (fromInRule d)  


p :: Object String Integer
p = Mapping [("key1", 
                Mapping [("key1a", Scalar 1)]
                ), ("key2", Scalar 1)]

test :: InRule 
test = InObject (Map.fromList [("a", InInteger 1)])

testConversion = do
    let tijdTest = timeStamp 1983 03 31 01 00 00
    print tijdTest 

{-- 
 - Tests for some guarantees we want to make about the code.
 -  * There should be a mapping between the number types 
 -  * A subset of InRule must be isomorphic to Value and Json2,
 -    that means, we do not lose type information. 
 -  * Different strings types must isomorph
 -
 -    | InByteString B.ByteString
	  | InInteger Integer
	  | InDouble Double
	  | InNumber Rational
	  | InBool Bool
	  | InNull
	  | InArray [InRule]
	  | InObject (Map.Map String InRule) 

 ---}


newtype InRational = InRational {
        unInRational :: InRule 
    } deriving Show
newtype InInteger = RInInteger {
        unInInteger :: InRule 
    } deriving Show
newtype InDouble = RInDouble {
        unInDouble :: InRule 
    } deriving Show 

prop_always_convert_to_rational :: Property 
prop_always_convert_to_rational = property $ prop_always_convert_to_rational'
    where 
        prop_always_convert_to_rational' :: InRational -> Bool  
        prop_always_convert_to_rational' x = (fromInRule (unInRational x) :: Rational) `seq` True

prop_always_convert_to_integer :: Property 
prop_always_convert_to_integer = property $ prop_always_convert_to_integer'
    where 
        prop_always_convert_to_integer' :: InInteger -> Bool  
        prop_always_convert_to_integer' x = (fromInRule (unInInteger x) :: Integer) `seq` True

prop_always_convert_to_double :: Property 
prop_always_convert_to_double = property $ prop_always_convert_to_integer'
    where 
        prop_always_convert_to_integer' :: InDouble -> Bool  
        prop_always_convert_to_integer' x = (fromInRule (unInDouble x) :: Double) `seq` True
-- | Test should always pass 
prop_always_convert_to_number :: Property 
prop_always_convert_to_number = prop_always_convert_to_rational .&&. prop_always_convert_to_double .&&.prop_always_convert_to_integer 


newtype StringToByteString = SBS {
        unSBS :: InRule 
    } deriving Show 

instance Arbitrary StringToByteString where 
    arbitrary = do 
          x  <- arbitrary :: Gen String 
          return $ SBS (InString x)

prop_convert_bytestring_string :: Property 
prop_convert_bytestring_string = property prop_convert_bytestring_string' 
    where
        prop_convert_bytestring_string' :: StringToByteString -> Bool 
        prop_convert_bytestring_string' (unSBS -> t@(InString s)) = s == ((fromInRule :: InRule -> String) . (toInRule :: B.ByteString -> InRule ) . (fromInRule :: InRule -> B.ByteString))  t
-- ideally this should be valid:
-- | f = fromInRule :: InRule -> Json
--   g = fromInRule :: Json -> InRule 
--   f . g = Idj 
--   g . f = Idi
-- Unfortunately, Json2 only knows number, so this only counts for a smaller category

newtype IsomorphT = IsomorphT {
        unIsomorphT :: InRule 
    } deriving Show
{-- 
 - The bijective map  of a subset of InRule with Value is: 
 - InInteger Integer            <->      Number (I Integer)
 - InDouble  Double             <->      Number (D Double)
 - InByteString B.ByteString    <->      String (Text) 
 - InArray  [InRule]            <->      Array (Vector Value)  
 - InObject M.Map String InRule <->      Object M.Map Text Value  
 - InBool Bool                  <->      Bool Bool
 - InNull                       <->      Null
 -
 ---}
 --
prop_isomorph_value_inrule :: Property 
prop_isomorph_value_inrule = property prop_isomorph_value_inrule'
    where 
        prop_isomorph_value_inrule' :: IsomorphT -> Bool 
        prop_isomorph_value_inrule' x =  (unIsomorphT x) == toInRule ((fromInRule :: InRule -> A.Value) (unIsomorphT x))

smallArgs = Args {
        replay = Nothing,
        maxSuccess = 100000,
        maxSize = 40,
        chatty = True,
        maxDiscardRatio = 10 
    }

instance Arbitrary IsomorphT where 
    arbitrary = do 
        let int = arbitrary :: Gen Integer
        let dbl = arbitrary :: Gen Double 
        let str = arbitrary :: Gen String
        let arr = listOf arbitrary :: Gen [IsomorphT]
        let obj = listOf arbitrary :: Gen [(String, IsomorphT)]
        let bl = arbitrary :: Gen Bool 
        let ps = [(1900,fmap InDouble dbl), (1900, fmap InInteger int), (1900, fmap (InByteString . B.pack) $ str), (250, fmap (InObject . Map.fromList . fmap (\(x,y) -> (x,unIsomorphT y))) obj), (250, fmap (InArray . fmap unIsomorphT) arr), (1900, fmap InBool bl), (1900,return InNull)]
        fmap IsomorphT $ frequency ps


prop_test_complex_sql = property prop_complex_sql 
    where prop_complex_sql :: IsomorphT -> Bool 
          prop_complex_sql (IsomorphT u) = u == fromSql (toSql u)
    
instance Arbitrary InDouble where 
    arbitrary = do  
      dbl <- arbitrary :: Gen Double 
      int <- arbitrary :: Gen Integer 
      rat <- arbitrary :: Gen Rational 
      elements $ fmap RInDouble $ [InInteger int, InDouble dbl, InNumber rat]

instance Arbitrary InInteger where 
    arbitrary = do  
      dbl <- arbitrary :: Gen Double 
      int <- arbitrary :: Gen Integer 
      rat <- arbitrary :: Gen Rational 
      elements $ fmap RInInteger $ [InInteger int, InDouble dbl, InNumber rat]

instance Arbitrary InRational where 
    arbitrary = do 
      dbl <- arbitrary :: Gen Double 
      int <- arbitrary :: Gen Integer 
      rat <- arbitrary :: Gen Rational 
      elements $ fmap InRational $ [InInteger int, InDouble dbl, InNumber rat]


instance Arbitrary InRule where  
   arbitrary = do 
      dbl <- arbitrary :: Gen Double 
      int <- arbitrary :: Gen Integer 
      rat <- arbitrary :: Gen Rational 
      bl <- arbitrary :: Gen Bool 
      xs <- listOf arbitrary :: Gen [InRule]
      ns <- listOf arbitrary :: Gen [(String, InRule)] 
      s <- arbitrary :: Gen String
      let ps = [InByteString (B.pack s), InInteger int, InDouble dbl, InNumber rat, InBool bl, InNull, InArray xs, InObject $ Map.fromList ns]
      elements ps 

cArgs = Args {
        replay = Nothing,
        maxSuccess = 10000,
        maxSize = 10000,
        chatty = True,
        maxDiscardRatio = 10 
    }
prop_find_all = property prop_find_all'

prop_find_all' ::  String -> [(String, Int)] ->  Bool 
prop_find_all' x xs = lhs x xs  ==  rhs x xs 
        where lhs x = fmap snd . filter (\(x',_) -> x == x') 
              rhs x xs = fmap convert (fromList xs .>> x)


