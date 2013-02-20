{-# LANGUAGE ViewPatterns, RankNTypes, TemplateHaskell, QuasiQuotes, GADTs, GeneralizedNewtypeDeriving #-}
module Main where 


import Control.Comonad
import Control.Applicative
import Language.Haskell.Codo
import qualified Data.List.NonEmpty as D 
import Data.Foldable 
import Prelude hiding (foldr, foldl)
import Data.Function (fix)
import Data.List hiding (foldr, foldl') 
import System.Environment 


newtype Obj s a = Obj a 
        deriving (Num,  Show, Read, Eq, Ord, Enum, Floating, Fractional,Real)
newtype Unique s a = UN {
                unUn :: a
            }

instance Functor (Unique s) where 
        fmap f (UN a) = UN (f a)

instance Monad (Unique s) where 
        return a = UN a 
        (>>=) (UN a) f = f a 

runUn :: (forall s. Unique s a) -> a 
runUn (UN x) = x  

mkObj :: a -> Unique s (Obj s a)
mkObj = return . Obj 

can = do 
    obj <- mkObj (2 :: Int)
    obj2 <- mkObj (1 :: Int)
    s <- cannot 
    return 1 
cannot :: Unique Integer (Obj Integer Int)
cannot = do 
        obj <- mkObj (1 :: Int)
        obj2 <- mkObj (2 :: Int)
        return $ obj + obj2


cvt :: Unique t (Obj t a) -> Unique s (Obj s a)
cvt (UN o) = UN o 

data Lazy b = forall a. Lazy (a -> b) a 
        

instance Functor Lazy where 
        fmap f (Lazy g a) = Lazy (f.g) a


instance Applicative Lazy where 
        pure a = Lazy id a 
        (<*>) (Lazy s g) (Lazy t n) = Lazy (s g . t) n

instance Comonad Lazy where 
        extract = eval 
        extend f (Lazy g a) = Lazy (f . pure . g) a 


testn = [codo| x => 
                z <- eval x * 2 
                z
        |]

testl :: Lazy Int 
testl = pure (+) <*> pure 1 <*> pure 2 

eval :: Lazy b -> b
eval (Lazy g a) = g a

fib = 0 : 1 : zipWith (+) fib (tail fib)

nefib = D.fromList fib 


test = [codo| x => 
        s <- foldr (+) 0 (D.take 2 x)
        s
        |]


f :: Monad m => a -> m a
f x = return x



hamm xs = 1 : foldr (\n s -> fix (merge s.(n:) . map (n*))) [] xs
merge a@(x:xs) b@(y:ys) | x < y = x : merge xs b 
                        | otherwise = y : merge a ys 

merge [] b = b 
merge a [] = a 


testhamm = 1 : [y * z | z <- testhamm, y <- [2,3,5] ]

main = do 
        x <- head <$> getArgs   
        print (last $ take (10^8) $  hammTill (read x))

hammTill n = let ts = [ x * y * z |  x <- takeWhile (<=n) xs, y <- takeWhile (<=n) ys, z <- takeWhile (<=n) zs ] in takeWhile (<=n) $ foldr (insert) [] ts  
    where xs = (2^) <$> [0..] 
          ys = (3^) <$> [0..]
          zs = (5^) <$> [0..]
