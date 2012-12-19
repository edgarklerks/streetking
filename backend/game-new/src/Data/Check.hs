{-# LANGUAGE OverloadedStrings, MultiParamTypeClasses, TypeSynonymInstances, FlexibleInstances, FunctionalDependencies, FlexibleContexts, RankNTypes, DeriveDataTypeable #-}
module Data.Check (
    CheckWrapper,
    CheckException(..),
    checkMany,
    check,
    Check,
    email,
    latitude,
    longitude
) where 

import Text.Regex.TDFA.ByteString
import Text.Regex.TDFA.String 
import Text.Regex.TDFA
import Text.Regex.Base
import Data.String
import Data.Typeable
import qualified Data.ByteString as B
import Control.Monad
import Control.Monad.CatchIO
import Control.Applicative
import Snap.Types 
import Prelude hiding (catch)

data CheckException = CheckException String 
    deriving (Show, Typeable)

instance Exception CheckException
    
newtype CheckWrapper a = CW {
            unCW :: (a -> Either String ())
        }

class Check f t a m | f -> t, t -> a where 
    -- | Check will throw an CheckException 
    check :: f -> t -> m 

instance (MonadCatchIO m) => Check (CheckWrapper a) a a (m t) where 
    check (CW f) x = case f x of 
                                Left xs -> throw (CheckException xs)
                                Right x -> return undefined

-- | checkMany checks eg: checkMany [check email "test", check latitude 99] 
checkMany :: MonadCatchIO m => [m a] -> m ()
checkMany xs = foldM step "" xs >>= \x -> case x of 
                                            [] -> return ()
                                            xs -> throw $ CheckException ((tail.tail) xs)
        where step z m = do 
                        x <- catch (m >> return "") (\(CheckException e) -> return e)
                        case x of 
                            [] -> return z
                            xs -> return (z ++ ", " ++ xs)
                        
-- | mkCheck accepts a predicate and a failure message 
mkCheck :: (a -> Bool) -> String -> CheckWrapper a 
mkCheck f xs = CW (\x -> if not (f x) then Left xs else Right ())


latitude :: (Ord a, Num a) => CheckWrapper a 
latitude = mkCheck latitude' "latitude must be between -90 and 90"
    where latitude' :: (Ord a, Num a) => a -> Bool 
          latitude' x =  x <= 90 && x >= -90

longitude :: (Ord a, Num a) => CheckWrapper a 
longitude = mkCheck longitude' "longitude must be between -180 and 180"
    where longitude' :: (Ord a, Num a) => a -> Bool 
          longitude' x =  x <= 180 && x >= -180


email :: CheckWrapper String 
email = mkCheck (matchTest email') "email address is not correct"
    where 
        email' :: Regex
        email' = makeRegexOpts (defaultCompOpt {caseSensitive = False }) (defaultExecOpt {captureGroups = False}) ("\\b[A-Z0-9._%-]+@[A-Z0-9.-]+\\.[A-Z]{2,6}\\b" :: String)

