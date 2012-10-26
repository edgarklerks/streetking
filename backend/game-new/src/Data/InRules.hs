{-# LANGUAGE TypeSynonymInstances, FlexibleInstances, OverlappingInstances, MultiParamTypeClasses, IncoherentInstances, RankNTypes, FlexibleContexts, ViewPatterns, ScopedTypeVariables #-}
module Data.InRules where



import Data.List
import qualified Data.HashMap.Strict as Map

import Data.Ratio  
import Data.Word
import Data.Int

import qualified Data.ByteString.Char8 as B
import qualified Data.ByteString.Lazy as LB

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
import Data.Word 
import Data.Semigroup
import qualified Data.List.NonEmpty as N
import qualified Data.Serialize as S 
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

data InRule = 
        InString !String
      | InByteString !B.ByteString
	  | InInteger !Integer
	  | InDouble !Double
	  | InNumber !Rational
	  | InBool !Bool
	  | InNull
	  | InArray [InRule]
	  | InObject (Map.HashMap String InRule) 
    deriving (Eq)
               

instance Show InRule where 
        show a = pprint' "  " 0 a 

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

