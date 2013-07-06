{-# LANGUAGE NoMonomorphismRestriction, ViewPatterns, NoImplicitPrelude,
 MultiParamTypeClasses, FlexibleInstances #-}
-- | This is a reasonable implementation of a priority queue. It has O(1)
--   lookup and amortized delete min of O(log n) 
--   I am to lazy to calculate insert, but in practice it works quite well.
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
import Control.Comonad

-- | Priority heap, the priority is a parameter to the type
-- Prio q a can be ordered, is a functor, a foldable, a monoid and 
--  a traversable. 
--  There is also a monadic version. We should interpret this as
--  a computation on the objects in the priority heap, rendering a tree
--  of priority heaps and then merged into a consistent priority heap
--  again.
--
--  The monad has a problem, because it has a constraint. In the 
--  current version of ghc, it is not possible to make it a monad yet.
--
--
--  A comonad like instance could be useful, but is not possible, because
--  a comonad should always be safe to deconstruct. This thing is clearly
--  not safe to deconstruct. 
--
--  It could be empty 
data Prio q a = Empty | PairNode q a [Prio q a]
        deriving Show 

-- | List like view for the minimal element
data ViewMin q a = a :> Prio q a 
                 | Nil 
-- | Lits like view for the minimal element as tuple of value and priority 
data ViewPrioMin q a = (q,a) ::> Prio q a 
                     | NilPrio  

-- | Get all till priority as tuple
extractTillWithKey :: Ord q => q -> Prio q a -> ([(q,a)], Prio q a)
extractTillWithKey  q xs = worker q xs [] 
        where worker q (viewPrio -> (q',a) ::> xs) z | q >= q' = worker q xs ((q,a):z)
                                                     | q < q' = (z,xs)
              worker q (viewPrio -> NilPrio) z = (z, mempty)

-- | Get all till priority as value  
extractTill :: Ord q =>  q -> Prio q a -> ([a], Prio q a)
extractTill q xs = worker q xs [] 
        where worker q (viewPrio -> (q',a) ::> xs) z | q >= q' = worker q xs (a : z) 
                                                     | q < q' = (z, xs) 
              worker q (viewPrio -> NilPrio) z = (z, mempty)

-- | View pattern for list like perspective 
viewPrio :: Ord q => Prio q a -> ViewPrioMin q a 
viewPrio x = case extractMinPrio x of 
                    Nothing -> NilPrio 
                    Just (x,xs) -> x ::> xs 

-- | View pattern for list like perspective 
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

-- | Create an singleton prio queue 
singleton :: q -> a -> Prio q a 
singleton q a  = PairNode q a []

-- | Get the minimal value O(1)
extractMin (PairNode qa a xs) = Just (a, meld xs)
    where meld (t1 : t2 : ts) = (t1 <> t2) <> meld ts 
          meld [t] = t 
          meld [] = Empty 
extractMin _ = Nothing 

-- | Get the minimal value and priority O(1)
extractMinPrio (PairNode qa a xs) = Just ((qa,a), meld xs)
    where meld (t1 : t2 : ts) = (t1 <> t2) <> meld ts  
          meld [t] = t 
          meld [] = Empty 
extractMinPrio _ = Nothing 

-- | Build a prio heap from a list 
fromList :: Ord q => [(q,a)] -> Prio q a
fromList  = foldr (\(q,a) z -> insert q a z) mempty 

-- | Get the first element  
headMin :: Ord q => Prio q a -> Maybe a
headMin x = fst <$> extractMin x 

-- | Get the tail 
tailMin :: Ord q => Prio q a -> Maybe (Prio q a)
tailMin x = snd <$> extractMin x 

testInsert = insert 1 2 $ insert 3 4 $ insert 4 5 $ mempty 

-- | Insert a new element with priority
insert :: Ord q => q -> a -> Prio q a -> Prio q a 
insert q a l = singleton q a <> l

-- | Safely get the first element of a list, doesn't belong here ?
safeHead (x:xs) = Just x
safeHead _ = Nothing 


-- | Test if we can find the minimal value 
prop_prio_minimal = property test 
    where test :: [(Int, Int)] -> Bool 
          test xs = fmap snd ( safeHead (L.sortBy (\x y -> compare (fst x) (fst y)) xs)) == headMin (fromList xs)

-- | Test if foldl behaves nicely 
prop_prio_foldl = property test 
    where test :: [Int] -> Bool 
          test xs = let ys = [1..] `zip` xs 
                    in foldl (-) 0 xs == foldl (-) 0 (fromList ys)

-- | Test if foldr behaves nicely 
prop_prio_foldr = property test 
    where test :: [Int] -> Bool 
          test xs = let ys = [1..] `zip` xs 
                    in foldr (-) 0 xs == foldr (-) 0 (fromList ys)

newtype PrioMonad a = PrioMonad {
            unPrioMonad :: Prio a a 
    } deriving Show

-- | Attempt for functor for PrioMonad, ugly because of packing and
-- unpacking 
instance Functor PrioMonad where 
        fmap f (unPrioMonad -> PairNode a b rs) =  PrioMonad $ PairNode (f a) (f b) $ mapBoth rs 
                where mapBoth (x:xs) =  (unPrioMonad $ fmap f $ PrioMonad x) : mapBoth xs 
                      mapBoth [] = []
        fmap f (unPrioMonad -> Empty) = PrioMonad $ Empty 

instance Ord a => Monoid (PrioMonad a) where 
        mempty = PrioMonad mempty 
        mappend (PrioMonad a) (PrioMonad b) = PrioMonad (a <> b)
           
-- | We should interp the join operation as an operation on a tree of priority heaps,
-- which we should join such that the minimal element should be on top 
joinPrioMonad :: Ord a => PrioMonad (PrioMonad a) -> PrioMonad a
joinPrioMonad f = worker (unPrioMonad f) 
    where worker :: Ord a => Prio (PrioMonad a) (PrioMonad a) -> PrioMonad a 
          worker (Empty) = PrioMonad $ Empty 
          worker (PairNode a _ rs) = a <> mconcat (worker <$> rs)

bindPrioMonad :: (Ord a, Ord b) => PrioMonad a -> (a -> PrioMonad b) -> PrioMonad b
bindPrioMonad m f = joinPrioMonad $ fmap f m

returnPrioMonad :: Ord a => a -> PrioMonad a 
returnPrioMonad a = PrioMonad $ singleton a a
dup a = (a,a)
test = PrioMonad (fromList $ dup <$> [1..100]) `bindPrioMonad` (\x -> returnPrioMonad (x `mod` 3 + x) <> returnPrioMonad (x `mod` 5 + x))

prop_monadic_ok = property (uncurry (==) .  testa)
testa :: [Int] -> ([Int],[Int])
testa xs = let b = PrioMonad (fromList $ dup <$> xs) `bindPrioMonad` (\x -> returnPrioMonad( x `mod` 3 + x) <> returnPrioMonad (x `mod` 5 + x))
               c = do 
                               x <- xs
                               [x `mod` 3 + x, x `mod` 5 + x]
                    in (fst (extractTill (L.maximum c + 1) (unPrioMonad b)), reverse $ L.sort c)
