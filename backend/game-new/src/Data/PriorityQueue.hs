{-# LANGUAGE NoMonomorphismRestriction, ViewPatterns #-}
module Data.PriorityQueue (
        Prio,
        view,
        ViewMin(..),
        fromList,
        extractMin,
        headMin,
        tailMin,
        insert,
        singleton,
        extractTill,
        extractTillWithKey
    ) where 

import Data.Monoid 
import Test.QuickCheck 
import Data.Foldable 
import Data.Traversable 
import Prelude hiding (foldr, foldl)
import Control.Applicative 
import qualified Data.List as L 
import Debug.Trace 
import Data.Maybe 

data Prio q a = Empty | PairNode q a [Prio q a]
        deriving Show 


data ViewMin q a = a :> Prio q a 
                 | Nil 

data ViewPrioMin q a = (q,a) ::> Prio q a 
                     | NilPrio  

extractTillWithKey :: Ord q => q -> Prio q a -> ([(q,a)], Prio q a)
extractTillWithKey  q xs = worker q xs [] 
        where worker q (viewPrio -> (q',a) ::> xs) z | q >= q' = worker q xs ((q,a):z)
                                                     | q < q' = (z,xs)
              worker q (viewPrio -> NilPrio) z = (z, mempty)

extractTill :: Ord q =>  q -> Prio q a -> ([a], Prio q a)
extractTill q xs = worker q xs [] 
        where worker q (viewPrio -> (q',a) ::> xs) z | q >= q' = worker q xs (a : z) 
                                                     | q < q' = (z, xs) 
              worker q (viewPrio -> NilPrio) z = (z, mempty)

viewPrio :: Ord q => Prio q a -> ViewPrioMin q a 
viewPrio x = case extractMinPrio x of 
                    Nothing -> NilPrio 
                    Just (x,xs) -> x ::> xs  

view :: Ord q => Prio q a -> ViewMin q a 
view x = case extractMin x of 
            Nothing -> Nil 
            Just (x,xs) -> x :> xs 

instance Ord q => Monoid (Prio q a) where 
        mempty = Empty 
        mappend h Empty = h 
        mappend Empty h = h 
        mappend h1@(PairNode qa a as) h2@(PairNode qb b bs)             
             | qa <= qb = PairNode qa a (h2 : as)
             | otherwise = PairNode qb b (h1 : bs) 

instance Functor (Prio q) where 
        fmap f (PairNode q a rs) = PairNode q (f a) $ (fmap . fmap ) f rs 
        fmap f (Empty) = Empty 

instance Ord q => Foldable (Prio q) where 
    fold (PairNode _ a rs) = a <> rest rs
        where rest (x:xs) = fold x <> rest xs 
              rest [] = mempty 
    fold Empty = mempty 
    foldMap f (PairNode _ a rs) = f a <> rest rs 
        where rest (x:xs) = foldMap f x <> rest xs 
              rest [] = mempty 
    foldr f z (PairNode _ a rs) = a `f` (rest rs z)
            where rest (x:xs) z = (foldr f (rest xs z) x)
                  rest [] z = z 
    foldr f z (Empty) = z 
    foldl f z Empty = z
    foldl f z (PairNode _ a rs) = rest rs $ f z a
        where rest (x:xs) z = rest xs $ foldl f z x  
              rest [] z = z 
    foldr1 f xs = case extractMin xs of
                        Nothing -> error "foldr1: empty prio list" 
                        Just (x,xs) -> foldr f x xs 
    foldl1 f xs = case extractMin xs of 
                        Nothing -> error "foldl1: empty prio list"
                        Just (x,xs) -> foldl f x xs 

instance Ord q => Traversable (Prio q) where 
    traverse f (PairNode q a rs) = (<>) <$> (singleton q <$> f a) <*> rest rs 
        where rest (x:xs) = (<>) <$> traverse f x <*> rest xs 
              rest [] = pure mempty 
    sequenceA (PairNode q a rs) =  (<>) <$> (singleton q <$> a) <*> rest rs 
        where rest (x:xs) = (<>) <$> sequenceA x <*> rest xs 
              rest [] = pure mempty 
singleton :: q -> a -> Prio q a 
singleton q a  = PairNode q a []

extractMin (PairNode qa a xs) = Just (a, meld xs)
    where meld (t1 : t2 : ts) = (t1 <> t2) <> meld ts 
          meld [t] = t 
          meld [] = Empty 
extractMin _ = Nothing 

extractMinPrio (PairNode qa a xs) = Just ((qa,a), meld xs)
    where meld (t1 : t2 : ts) = (t1 <> t2) <> meld ts  
          meld [t] = t 
          meld [] = Empty 
extractMinPrio _ = Nothing 

fromList :: Ord q => [(q,a)] -> Prio q a
fromList  = foldr (\(q,a) z -> insert q a z) mempty 

headMin :: Ord q => Prio q a -> Maybe a
headMin x = fst <$> extractMin x 
tailMin :: Ord q => Prio q a -> Maybe (Prio q a)
tailMin x = snd <$> extractMin x 

testInsert = insert 1 2 $ insert 3 4 $ insert 4 5 $ mempty 

insert :: Ord q => q -> a -> Prio q a -> Prio q a 
insert q a l = singleton q a <> l

safeHead (x:xs) = Just x
safeHead _ = Nothing 
test_prio_minimal = property test 
    where test :: [(Int, Int)] -> Bool 
          test xs = fmap snd ( safeHead (L.sortBy (\x y -> compare (fst x) (fst y)) xs)) == headMin (fromList xs)

test_prio_foldl = property test 
    where test :: [Int] -> Bool 
          test xs = let ys = [1..] `zip` xs 
                    in foldl (-) 0 xs == foldl (-) 0 (fromList ys)
test_prio_foldr = property test 
    where test :: [Int] -> Bool 
          test xs = let ys = [1..] `zip` xs 
                    in foldr (-) 0 xs == foldr (-) 0 (fromList ys)

