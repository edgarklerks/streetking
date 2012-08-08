{-# LANGUAGE TypeSynonymInstances, FlexibleInstances, OverlappingInstances, MultiParamTypeClasses, IncoherentInstances, RankNTypes, FlexibleContexts, ViewPatterns, ScopedTypeVariables #-}
module Data.InRules where



import Data.List
import qualified Data.HashMap.Strict as Map

import Data.Ratio  
import Data.Word
import Data.Int

import qualified Data.ByteString.Char8 as B

import Data.Time.Calendar
import Data.Time.Clock 
import Data.Time.LocalTime
import Data.Convertible
import Data.Maybe
import Control.Applicative
import Data.Monoid -- hiding ((<>))
import Control.Monad
import Data.Pointed
import Data.Copointed
import Data.Semigroup
import qualified Data.List.NonEmpty as N
infixr 6 ==>
infixr 6 .>
infixl 6 .>>
infixr 6 ..>

hmapKeys f xs = Map.foldrWithKey step Map.empty xs
    where step k v a = Map.insert (f k) v a 
hmapWithKey f xs = Map.foldrWithKey step Map.empty xs 
    where step k v a = Map.insert k (f k v) a
-- * Data types and classes
-- think about adding timestamp without timezone as some kind of double
-- with pretty print... 

data InRule = InString String
      | InByteString B.ByteString
	  | InInteger Integer
	  | InDouble Double
	  | InNumber Rational
	  | InBool Bool
	  | InNull
	  | InArray [InRule]
	  | InObject (Map.HashMap String InRule) 
    deriving (Eq)

newtype Readable = Readable {
        unReadable :: String 
    } deriving Show

 

-- | Setters, getters, folds, unfolds and maps. 

data InKey = Index Int 
           | None
           | Assoc String 
    deriving Show

instance Monoid InKey where 
    None `mappend` x = x
    x `mappend` None = x 
    x `mappend` y = y 
    mempty = None

newtype IdentityMonoid a = IM { unIM :: a }

instance Monoid a => Monoid (IdentityMonoid a) where 
    mempty = IM (mempty)
    mappend (IM a) (IM b) = IM $ mappend a b 
instance Functor (IdentityMonoid) where 
    fmap f (IM a) = IM (f a)
instance Pointed (IdentityMonoid) where 
    point a = IM a
instance Copointed (IdentityMonoid) where 
    copoint (IM a) = a

-- | Simple automaton for rejecting or accepting paths 
data PathState = Accept | Reject
    deriving Show 

data PathStep a = Next (PathAcceptor a) | Final PathState

newtype PathAcceptor a = PM {
        unPM :: a -> PathStep a 
    }

instance Semigroup (PathAcceptor a) where 
    (<>) (PM f) (PM g) = PM $ \a -> 
                case f a of 
                    Final Accept -> Next (PM g)
                    Final Reject -> reject 
                    Next t -> Next t 
accept :: PathStep a
accept = Final Accept 

reject :: PathStep a
reject = Final Reject 

-- | Always accept the input 
acceptor = PM $ \a -> accept
-- | Always reject the input 
rejector = PM $ \a -> reject 
-- |  Always accept the complete input stream (will always be false for finite streams and true for infinite ones) 
continue = PM $ \a -> Next continue 

alter :: PathAcceptor a -> PathAcceptor a -> PathAcceptor a
alter (PM g) (PM f) = PM $ \a -> 
            case g a of 
                Next t -> Next t 
                Final Accept -> accept 
                Final Reject -> case f a of 
                        Next t -> Next t 
                        Final Accept -> accept 
                        Final Reject -> reject 


apoint a = PM $ \s -> if s == a then accept else reject 



runPath :: Eq a => PathAcceptor a -> [a] -> Bool 
runPath x [] = False
runPath x a = case unPM x (head a) of 
                    Final Accept -> True
                    Final Reject -> False 
                    Next t -> runPath t (tail a)


data KindView = TScalar 
             | TArray 
             | TObject 
             | TNone 
    deriving Show

viewKind :: InRule -> KindView 
viewKind (InArray _) = TArray
viewKind (InObject _) = TObject
viewKind (InNull) = TNone
viewKind _ = TScalar


-- | Maps through the structure 
kmap :: (InKey -> InRule -> InRule) -> InRule -> InRule 
kmap f = pmap f' 
    where f' (k :: IdentityMonoid InKey) v = f (copoint k) v


-- | Maps trough the structure with a history of the path kept in a monoid
pmap :: (Monoid (f InKey), Pointed f) => (f InKey -> InRule -> InRule) -> InRule -> InRule 
pmap f = pmap' f mempty 
    where 
          pmap' f ks t@(viewKind -> TScalar) = f (ks `mappend` mempty) t 
          pmap' f ks t@(viewKind -> TNone) = f (ks `mappend` mempty) t
          pmap' f ks (InArray xs) = InArray (gs nmb)
                where 
                      nmb = fmap (mappend ks . point . Index) [0..] `zip` xs
                      gs xs = uncurry (pmap' f) <$> xs
          pmap' f ks (InObject xs) = InObject $ hmapWithKey (f' ks) xs
                where f' p k v = pmap' f nk v 
                        where nk = p `mappend` (point (Assoc k)) 

-- | Fold trough a structure with a history of the path kept in a monoid  
pfold :: (Monoid (f InKey), Pointed f) => (f InKey -> InRule -> b -> b) -> InRule -> b -> b
pfold f x z = pfold' f mempty x z 
    where pfold' f ks t@(viewKind -> TScalar) z = f (ks `mappend` point None) t z
          pfold' f ks t@(viewKind -> TNone) z = f (ks `mappend` point None) t z 
          pfold' f ks (InArray xs) z = foldr step z ([0..] `zip` xs) 
              where step (i,x) z = pfold' f (ks `mappend` point (Index i)) x z
          pfold' f ks (InObject xs) z = Map.foldrWithKey step z xs 
              where step k x z = pfold' f (ks `mappend` point (Assoc k)) x z 

-- | Fold through the structure 
kfold :: (InKey -> InRule -> b -> b) -> InRule -> b -> b
kfold f x z = pfold f' x z 
    where f' k x z = f (copoint (k :: IdentityMonoid InKey)) x z 

-- | Find top level matching keyword 
(.>) :: InRule -> String -> Maybe InRule
(.>) (InObject xs) lbl = Map.lookup lbl xs
(.>) _ _ = Nothing

-- | Find top level value and convert to normal value 
(..>) :: FromInRule a => InRule -> String -> Maybe a  
(..>) a b = fmap fromInRule $ (.>) a b

-- | Search all occuring keywords recursively  
(.>>) :: InRule -> String -> [InRule] 
(.>>) t@(InObject xs) lbl = (catMaybes [t .> lbl]) ++ (Map.foldr walk [] xs)
        where walk xs z = xs .>> lbl ++ z
(.>>) _ _ = []



readable :: String -> Readable 
readable a = Readable a

{-- Dirty fix --}
viaReadable :: Read a => InRule -> a 
viaReadable x = let (Readable r) = asReadable x
                in read r 

asReadable :: InRule -> Readable 
asReadable (InNumber x) = readable (show x)
asReadable (InInteger x) = readable (show x)
asReadable (InString x) = readable x 
asReadable (InByteString x) = readable (B.unpack x)
asReadable (InBool x) = readable (show x)
asReadable _ = error "Not an readable object"

instance Show InRule where 
    show = toString 
-- Just InRules :P
type InRules = [InRule]
 
instance (FromInRule b) => Convertible InRule b where
	safeConvert = Right . fromInRule 

instance (ToInRule b)  => Convertible b InRule where
	safeConvert = Right . toInRule 

class ToInRule a where
    toInRule :: a -> InRule
    toInRule = error "No Inrule for conversion"

class FromInRule a where
    fromInRule :: InRule -> a
    fromInRule = error "No Inrule for conversion"

toCompatible :: InRule -> InRule 
toCompatible (InNumber r) 
    | denominator r == 1 = InInteger (numerator r)
    | otherwise          = InDouble (fromRational r :: Double)
toCompatible (InByteString bs) = (InString (B.unpack bs))
toCompatible a = a
validObject :: InRule -> Bool 
validObject (InObject _ ) = True 
validObject _ = False

emptyObj :: InRule
emptyObj = InObject (Map.empty)

-- | Create single InRule object.
singleObj :: ToInRule a => String -> a -> InRule
singleObj k v = InObject (Map.singleton k (toInRule v))

-- | @(`==>`)@ Eq @`singleObj`@ .
(==>) :: ToInRule a => String -> a -> InRule
(==>) = singleObj

infixr 2 `orM`

orM :: Maybe a -> a -> Maybe a
orM = flip withDefault 

withDefault :: a -> Maybe a -> Maybe a
withDefault a (Just b) = Just b
withDefault a (Nothing) = Just a


-- | Create InRule object from list.
fromList :: ToInRule a => [(String, a)] -> InRule
fromList xs = InObject $ Map.fromList (map (\(k,v) -> (k, toInRule v)) xs)


-- | Create InRule object from list.
toList :: FromInRule a => InRule -> [(String, a)] 
toList (InObject xs) = Map.toList (Map.map fromInRule xs)

toListString :: InRule -> [(String, String)]
toListString (InObject xs) = Map.foldrWithKey step [] xs
                where step k v z =  (k, (show ( v))):z 


unionObj :: InRule -> InRule -> InRule
unionObj (InObject x ) (InObject y)  = InObject $ Map.union x y
unionObj  _  _ = error "unionObj: Not an object"

-- | Merge InRule objects from list.
unionsObj :: [InRule] -> InRule
unionsObj xs = foldl' unionObj emptyObj xs


unionRecObj :: InRule -> InRule -> InRule
unionRecObj (InObject x) (InObject y) = InObject $
                 Map.unionWith (\v1 v2 -> unionRecObj v1 v2) x y
unionRecObj  _  _  = error "unionRecObj: Not an object"


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

{--
instance ToInRule Fractional where
    toInRule x = InDouble x
instance FromInRule Fractional where
    fromInRule (InDouble i) =  i 

instance ToInRule Num where
    toInRule x = InInteger x
instance FromInRule Num where
    fromInRule (InInteger i) =  i 
    --}

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
{----}



-- | Renders InRule to String.
toString :: InRule -> String
toString (InNumber r) 
    | denominator r == 1 = show (numerator r)
    | otherwise          = show (fromRational r :: Double)
toString (InDouble dd) = show (dd)
toString (InInteger dd) = show (dd)
toString (InBool True) = "true"
toString (InBool False) = "false"
toString InNull = "null"
toString (InByteString bs) = toString (InString (B.unpack bs))
toString (InString s) = "\"" ++ escInStr s ++ "\""
toString (InArray vs) = "[" ++ (intercalate ", " $ map (toString) vs) ++ "]"
toString (InObject l) = "{" ++ (intercalate ", " $ map (\(k, v) -> toString (InString k) ++ ": " ++ toString v) (Map.toList l)) ++ "}"



-- * Pretty print

-- | Pretty-prints InRule.
pprint :: InRule -> IO ()
pprint = putStrLn . pprint' "  " 0 

pprint' :: String -> Integer -> InRule -> String

pprint' indenter levels (InArray xs) = "[" ++ (intercalate ", " $ map (pprint' indenter levels) xs) ++ "]"

pprint' indenter levels (InObject mp) = let
	currentIndent = (concat (genericReplicate levels indenter))
		in intercalate "\n" $ ["{", intercalate ",\n" (map (((currentIndent ++ indenter) ++) . (\(key, value) -> pprint' indenter levels (InString key) ++ ": " ++ pprint' indenter (levels + 1) value)) $ Map.toList mp), currentIndent ++ "}"]
pprint' _ _ a = toString a

-- | Pretty-prints InRules.
pprints :: [InRule] -> IO ()
pprints js = putStrLn $
    "[\n  " ++ ( intercalate "," $ map (\j -> (pprint' "  " 1 ) j) js)  ++ "\n]"

------------- private function
escInStr :: String -> String
escInStr = concat . map (escInChar)

escInChar :: Char -> String 
escInChar c = case c of
    '\n' -> "\\n"
    '\b' -> "\\b"
    '\f' -> "\\f"
    '\t' -> "\\t"
    '\r' -> "\\r"
    '\\' -> "\\\\"
    '\"' -> "\\\""
    _    -> [c]
-- Dirty fallback strategy
instance FromInRule (Readable) where 
    fromInRule = asReadable


