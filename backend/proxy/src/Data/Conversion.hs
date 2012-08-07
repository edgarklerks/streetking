
{-# Language TypeSynonymInstances, FlexibleInstances, IncoherentInstances #-}
module Data.Conversion where


import Data.List
import qualified Data.Map as Map
import Data.Ratio 

import Data.InRules

import Data.Object
import Data.Object.Yaml
import Control.Monad

-- 
import qualified Data.ByteString as B
-- import Network.ByteString
--
import Database.HDBC.SqlValue

import Data.Time.Calendar
import Data.Time.Clock 
import Data.Time.LocalTime


type YAML = Object String String 


stringLike ::  String -> String
stringLike text = "%" ++ text ++ "%" 

--TODO: limit the hour, min & second to normal time +leap second/minute 
timeStamp y m d h min s = LocalTime (fromGregorian y m d) (TimeOfDay h min s )



convYaml :: InRule -> B.ByteString  
convYaml  = encode . preConvYaml 

typedScalarMapping :: key -> val -> Object key val 
typedScalarMapping k v = Mapping [(k, Scalar v)]

typedMapping :: key -> Object key val -> Object key val 
typedMapping k v = Mapping [(k, v)]

preConvYaml :: InRule -> YAML 
preConvYaml (InNumber r) =  typedScalarMapping "rational" $ show $ InNumber $ r
preConvYaml (InInteger r) =  typedScalarMapping "integer" $ show r
preConvYaml (InDouble r) = typedScalarMapping "double" $ show r
preConvYaml (InBool True) =  typedScalarMapping "bool" $ "t"
preConvYaml (InBool False) =  typedScalarMapping "bool" $ "f"
preConvYaml InNull = typedScalarMapping "null" $ "null"
preConvYaml (InString s) = typedScalarMapping "string" $  s
preConvYaml (InArray vs) = typedMapping "array" $ numberedArray vs 
preConvYaml (InObject xs) = typedMapping "object" $ Mapping $ Map.foldrWithKey step [] xs
                where step k v z =  (k, preConvYaml v):z 

numberedArray :: [InRule] -> YAML
numberedArray xs = Mapping $ fmap show [0..] `zip` fmap preConvYaml xs 



convFromSql :: SqlValue -> InRule  
convFromSql (SqlString s) = toInRule s
convFromSql (SqlByteString  s) = toInRule s
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



convFromSqlA :: [SqlValue] -> InRule
convFromSqlA xs = InArray (fmap convFromSql xs)

convFromSqlAA :: [[SqlValue]] -> InRule
convFromSqlAA xs = InArray (fmap convFromSqlA xs)
  


{-- --}
convSql ::  InRule -> SqlValue
convSql = conv2Sql
 

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
conv2Sql (InObject s) =  toSql (fromInRule (InObject s)::LocalTime) 


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

testConv (InObject xs) = Map.foldrWithKey step [] xs
                where step k v z =  (k, preConvYaml v):z  


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
