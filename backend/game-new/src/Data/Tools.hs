{-# LANGUAGE OverloadedStrings, BangPatterns, FlexibleInstances, MultiParamTypeClasses, GADTs, ViewPatterns, FlexibleContexts, ExistentialQuantification, OverlappingInstances, IncoherentInstances, OverloadedStrings, DeriveDataTypeable #-}

module Data.Tools where

import Data.List
import Data.Convertible 
import Control.Monad
import Control.Applicative
import Control.Comonad
import qualified Control.Monad.CatchIO as CIO 
import Control.Arrow 
import Control.Monad.Error 
import Data.Maybe 
import Data.Monoid
import Text.Regex.TDFA.ByteString
import Text.Regex.TDFA.String 
import Text.Regex.TDFA
import Text.Regex.Base 
import Data.String 
import qualified Data.ByteString.Char8 as B
import qualified Data.ByteString.Lazy.Char8 as BL
import qualified Data.Text as T
import Data.Typeable
import Database.HDBC (SqlValue (SqlString))
import qualified Data.InRules as R
import System.Random 


import qualified Data.ByteString as C 
import qualified Data.HashMap.Strict as Map

import Data.Word
import Data.Hashable
import Data.List ((\\), transpose)

import qualified Text.PrettyPrint.Boxes as Box



instance Convertible a a where 
    safeConvert = Right . id

{-- Check filter --}

-- | CheckException signals a problem with user data verification 
data CheckException = CE [(String,[String])]
                    | CF String 
    deriving (Typeable, Show)

instance CIO.Exception CheckException where 

-- | A CFilter is a composable (by monoidic) user data verifier.  
newtype CFilter v = CFilter { 
            runCFilter :: v -> Maybe [String]
        }
-- | Create a new filter with a error message 
mkCFilter :: (v -> Bool) -> String -> CFilter v
mkCFilter p s = CFilter $ \v -> case p v of 
                                    True -> Nothing
                                    False -> return [s]

-- | Monoid instance for CFilter, to allow composable filters. 
-- | mappend is andcf, both filters must pass 
instance Monoid (CFilter v) where 
    mempty = CFilter $ \v -> Nothing 
    mappend = andcf

-- | Map the input type of the CFilter
cfmap :: (v'  -> v) -> CFilter v -> CFilter v'
cfmap f (CFilter g) = CFilter (g.f)
 
-- | A list must have certain keys 
must :: (CIO.MonadCatchIO m, Eq k) => [(k,v)] -> [k] -> m ()
must (fmap fst -> k) k' = if null (k' \\ k) 
                            then return ()
                            else CIO.throw $ CF $ "Not all required fields are filled" 



        
-- | Non pure version of cfilterPure, throws CheckException 
cfilter :: (StringLike v, Eq k, StringLike k, CIO.MonadCatchIO m) => [(k,v)] -> [(k, CFilter v)] -> m ()  
cfilter x a = case cfilterPure x a of 
                    [] -> return ()
                    xs -> do 
                        CIO.throw $ CE $ fmap (first toString) xs
                        
scfilter :: (Show k, Show v, StringLike v, Eq k, StringLike k, CIO.MonadCatchIO m) => Map.HashMap k v -> [(k, CFilter v)] -> m ()
scfilter x a = cfilter (toList x) a
    where toList = Map.foldrWithKey (\k v z -> (k, v) : z) [] 

infixr 3 `andcf`
infixr 2 `orcf`
-- | andcf composes two CFilters. Both should pass 
andcf :: CFilter v -> CFilter v -> CFilter v 
andcf (CFilter f) (CFilter g) = CFilter $ \v -> 
                        case f v of 
                            Nothing -> g v 
                            Just x -> case g v of 
                                    Nothing -> return x
                                    Just y -> return (x ++ y)
-- | orcf composes two CFilters. At least one should pass 
orcf :: CFilter v -> CFilter v -> CFilter v 
orcf (CFilter f) (CFilter g) = CFilter $ \v -> 
                        case f v of 
                            Nothing -> Nothing 
                            Just n -> case g v of
                                Nothing -> Nothing 
                                Just p -> return (p ++ n)
-- | Evaluate a list to a list of key-error string pairs specified by the provided CFilters
cfilterPure :: (Eq k) => [(k,v)] -> [(k, CFilter v)] -> [(k, [String])]
cfilterPure xs = catMaybes .  zipKeyWith step xs
    where step k a f = case runCFilter f a of 
                            Nothing -> Nothing 
                            Just s -> return (k, s)
-- | Many types are isomorph to Strings 
class IsString s => StringLike s where 
    toString :: s -> String 
    readS :: (Read a) => s -> Maybe a
    readS = fmap fst . listToMaybe . reads . toString


instance StringLike (BL.ByteString)  where 
    toString = BL.unpack 

instance StringLike (B.ByteString) where 
    toString = B.unpack 

instance StringLike String where 
    toString = id 

instance StringLike T.Text where
    toString = T.unpack 
instance IsString SqlValue where 
    fromString x = SqlString x
instance StringLike SqlValue where 
    toString = convert 
instance IsString R.InRule where 
    fromString = R.InString 
instance StringLike R.InRule where 
    toString = R.toString 

{-- Couple of filters --}

-- | Create a CFilter from a regex. First is the regex. Second is the error message.
mkCRegex :: (StringLike s) => String -> String -> CFilter s  
mkCRegex x = mkCFilter (matchTest r . toString) 
    where r = makeRegexOpts (defaultCompOpt {caseSensitive = False}) (defaultExecOpt {captureGroups = False}) x 

-- | An empty CFilter 

minl, maxl :: (StringLike s) => Int -> CFilter s 
minl n = mkCFilter (\x -> length (toString x) >= n) ("is too short, min length: " ++ show n)
maxl n = mkCFilter (\x -> length (toString x) <= n) ("is too short, max length: " ++ show n)

-- | An email CFilter 
email :: (StringLike s) => CFilter s
email = mkCRegex ("\\b[A-Z0-9._%-]+@[A-Z0-9.-]+\\.[A-Z]{2,6}\\b" :: String) "is not an email address"

-- | A number format CFilter (Double)
isNumber :: (StringLike s) => CFilter s
isNumber = mkCRegex "(-)?[0-9]+(\\.)?[0-9]*" "is not a number"

-- | A integer format CFilter (i > 0) 
natural :: (StringLike s) => CFilter s 
natural = mkCRegex "[0-9]*" "is not a natural"

-- | A number format CFilter. Test if value is between the borders. 
between :: (StringLike s) => (Double, Double) -> CFilter s
between (x,y) = mkCFilter n $ "should be between" ++ (show (x,y))
        where n = \v -> 
                    let a = readS v 
                    in case a of 
                        Nothing -> False 
                        Just a -> x <= a && y >= a

-- | Check if the number is a valid longitude (-180, 180)
longitude :: (StringLike s) => CFilter s
longitude = isNumber `andcf` between (-180, 180)

-- | Check if the number is a valid latitude (-90,90)
latitude :: (StringLike s) => CFilter s
latitude = isNumber `andcf` between (-90, 90)

-- | Haskell functors are strong functors. 
-- | Strong functors have the following property:
strength :: (Functor m) => (a, m b) -> m (a, b)
strength (a, m) = fmap (\b  -> (a, b)) m 

-- | ZipKeyWith zips two key-value lists together with a helper function if the keys matches
zipKeyWith :: Eq k => (k -> a -> b -> c) -> [(k,a)] -> [(k, b)] -> [c]
zipKeyWith f xs ys = [f k a b | (k, a) <- xs, (k',b) <- ys, k == k']

whenM :: (Monad m) => m Bool -> m a -> m () 
whenM m n = m >>= \a -> case a of 
                        True -> n >> return ()
                        False -> return ()

encWith :: a -> [a] -> [a]
encWith x xs = x : xs ++ [x]

enclose :: [a] -> [a] -> [a]
enclose xs ys = concat [xs, ys, xs]

join :: [a] -> [[a]] -> [a]
join xs ys = concat $ intersperse xs ys

alternate :: [a] -> [a] -> [a]
alternate [] xs = xs
alternate xs [] = xs
alternate (x:xs) (y:ys) = x:y:(alternate xs ys)

lfilter :: (Eq k) => [k] -> [(k, v)] -> [(k, v)]
lfilter ls m = filter (\(k, _) -> k `elem` ls) m

-- implodeMaybe :: Ord a => M.Map a (Maybe b) -> M.Map a b
-- implodeMaybe = (M.map fromJust) . (M.filter isJust)

lnub :: (Eq k) => [(k, v)] -> [(k, v)]
lnub = nubBy (\(a, _) (b, _) -> a == b)

ladd :: (Eq k) => [(k, v)] -> [(k, v)] -> [(k, v)]
ladd v d = lnub $ v ++ d

{-

dbconn ::  IO Connection
dbconn = connectPostgreSQL "host=192.168.1.66 port=5432 dbname=deosx user=graffiti password=wetwetwet"

doSql :: SqlTransaction Connection a -> IO a
doSql t = dbconn >>= (runSqlTransaction t error)

-}

{-- Cast anything --}

instance (R.ToInRule a, R.FromInRule b) => Convertible a b where 
        safeConvert a = Right . R.fromInRule $ R.toInRule a


sallowed :: (Data.Hashable.Hashable k, Eq k) => [k] -> Map.HashMap k v -> Map.HashMap k v
sallowed xs =  Map.foldrWithKey step Map.empty 
        where step k v z | k `elem` xs = Map.insert k v z 
                         | otherwise = z 
smust :: (Show k, CIO.MonadCatchIO m,Eq k) => [k] -> Map.HashMap k v -> m ()
smust xs (Map.keys -> z) | null (xs \\ z)  = return ()
                        | otherwise = CIO.throw (CF $ "fields are obligatory: " ++ show xs)

scheck :: (Show k, Data.Hashable.Hashable k, Eq k, CIO.MonadCatchIO m) => [k] -> Map.HashMap k v -> m (Map.HashMap k v)
scheck xs z = let p = sallowed xs z in smust xs p >> return p


assert :: (Error e, MonadError e m) => Bool -> String -> m ()
assert p e = unless p (throwError (strMsg e))


randomPick :: [a] -> IO a
randomPick [x] = return x 
randomPick (x:xs) = do 
            b <- randomRIO (0,1 :: Int) 
            if b == 1 then randomPick xs 
                     else return x 


randomPick' :: [a] -> IO (a, [a])
randomPick' [x] = return (x,[])
randomPick' (x:xs) = do 
            b <- randomRIO (0, 1 :: Int)
            if b == 1 
                    then do 
                        (t,ts) <- randomPick' xs 
                        return (t, x:ts) 
                    else return (x,xs)


showTable :: (Show a) => [[a]] -> String
showTable = showTable' . (map (map show))

showTable' :: [[String]] -> String
showTable' rss = renderTable $ map (map Box.text) rss

showTableWithHeader :: (Show a, Show b) => [a] -> [[b]] -> String
showTableWithHeader hs rss = showTableWithHeader' (map show hs) (map (map show) rss)

showTableWithHeader' :: [String] -> [[String]] -> String
showTableWithHeader' hs rss = let
                cs = map (Box.vsep 0 Box.top) $ transpose $ map (map Box.text) rss
                hs' = map Box.text hs
                ss = zipWith (\c h -> Box.text $ replicate (max (Box.cols c) (Box.cols h)) '-') cs hs' -- TODO: case empty cs
            in renderTable [ss, hs', ss, cs]

renderTable :: [[Box.Box]] -> String
renderTable rss = Box.render $ Box.hsep 1 Box.left $ map (Box.vsep 0 Box.top) $ transpose rss


