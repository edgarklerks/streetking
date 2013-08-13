{-# Language TypeSynonymInstances, FlexibleInstances, IncoherentInstances, ViewPatterns #-}
-- | Tests for some guarantees we want to make about the code.
--
--      * There should be a mapping between the number types 
--
--      * A subset of InRule must be isomorphic to Value and Json2,  that means, we do not lose type information. 
--
--      * Different strings types must isomorph
--
-- The bijective map  of a subset of InRule with Value is: 
--
-- @
--
-- InInteger Integer            <->      Number (I Integer)
--
-- InDouble  Double             <->      Number (D Double)
--
-- InByteString B.ByteString    <->      String (Text) 
--
-- InArray  [InRule]            <->      Array (Vector Value)  
--
-- InObject M.Map String InRule <->      Object M.Map Text Value  
--
-- InBool Bool                  <->      Bool Bool
--
-- InNull                       <->      Null
-- @
--
-- By the way, this is the file you want to import to get the whole
-- interface 


module Data.Conversion (
       (.>),
       (.>>),
       (Data.InRules.==>),
       (..>),
       hmapKeys,
       hmapWithKey,
       InRule(..),
       Readable(..),
       InKey(..),
       IdentityMonoid(..),
       PathState(..),
       PathStep(..),
       PathAcceptor(..),
       accept,
       reject,
       acceptor,
       continue,
       alter,
       apoint,
       runPath,
       KindView(..),
       viewKind,
       kmap,
       pmap,
       pfold,
       kfold,
       readable,
       viaReadable,
       asReadable,
       ToInRule(..),
       FromInRule(..),
       validObject,
       emptyObj,
       singleObj,
       fromList,
       toList,
       toListString,
       unionObj,
       unionsObj,
       toString,
       pprint,
       pprints,
       object,
       list,
       project,
       keyFilter



    ) where

-- Change: removed Json 

import Data.List
import qualified Data.HashMap.Strict as Map
import Data.Ratio 

import Data.InRules

import Data.Hashable 
import Data.Object
import Control.Monad
import qualified Data.Aeson as A
import qualified Data.Aeson.Parser as A
import qualified Data.Attoparsec.Number as A
import Data.Attoparsec
import qualified Data.Text as T 
import qualified Data.Text.Encoding as T
import Test.QuickCheck hiding ((==>))
import Data.Convertible
import Control.Monad.State
import qualified Data.Serialize as S
import Data.ConversionInstances 

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
import Data.Default 
import Data.Monoid


{-- Main file for loading all the instances + inrule tool --}



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
{- * 
 - The bijective map  of a subset of InRule with Value is: 
 - InInteger Integer            <->      Number (I Integer)
 - InDouble  Double             <->      Number (D Double)
 - InByteString B.ByteString    <->      String (Text) 
 - InArray  [InRule]            <->      Array (Vector Value)  
 - InObject M.Map String InRule <->      Object M.Map Text Value  
 - InBool Bool                  <->      Bool Bool
 - InNull                       <->      Null
 -
 * -}
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
        chatty = True
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
        chatty = True
    }
prop_find_all = property prop_find_all'

prop_find_all' ::  String -> [(String, Int)] ->  Bool 
prop_find_all' x xs = lhs x xs  ==  rhs x xs 
        where lhs x = fmap snd . filter (\(x',_) -> x == x') 
              rhs x xs = fmap convert (fromList xs .>> x)




keyFilter :: (String -> Bool) -> InRule -> InRule 
keyFilter f xs = kfold step xs mempty 
    where step k@(Assoc t) x z | f t = (t ==> x) `mappend` z
                               | otherwise = z 
          step k x z = x `mappend` z


grumpyObject = 
            ("test" ==> (1 :: Int)) <>
            ("test2" ==> (2 :: Int)) <> 
            ("test3" ==> (3 :: Int)) <>
            (InArray [toInRule "a", toInRule "b"])
