module Data.LimitList where 

import qualified Data.Sequence as S
import Prelude hiding (head, foldr, foldl, foldr1, foldl1, head)
import Data.Monoid 
import Data.Foldable 
import Data.Traversable 
import Control.Applicative 


data LimitList a = LL !Int !Int (S.Seq a)
    deriving Show 

new :: Int -> LimitList a 
new n = LL n 0 mempty 

size :: LimitList a -> Int 
size (LL _ s _) = s

maxsize :: LimitList a -> Int 
maxsize (LL m _ _) = m  

insert :: a -> LimitList a -> LimitList a 
insert a t@(LL m s i) | m == s = case S.viewr i of 
                                  (ps S.:> _) -> LL m s (a S.<| ps)
                                  S.EmptyR -> LL m s mempty 
                      | m > s  = LL m (s + 1) (a S.<| i)
                      | m < s = insert a (remove t) 


singleton :: a -> LimitList a 
singleton a = LL 1 1 (S.singleton a) 

remove :: LimitList a -> LimitList a 
remove t@(LL m s i) | m < s = remove $ LL m (s - 1) $ case S.viewr i of 
                                                           (ps S.:> _) -> ps 
                                                           S.EmptyR -> mempty 
                    | m >= s =  t

instance Monoid (LimitList a) where 
        mempty = LL 0 0 mempty 
        mappend (LL n s xs) (LL p t ys) = remove $ LL (max n p) (s + t) (xs <> ys)


test = insert 1 $ insert 2 $ insert 3 $ new 4
test2 = insert 9 $ insert 1 $ insert 2 $ insert 3 $ new 20

instance Foldable (LimitList) where 
        fold (LL n s xs) = fold xs  
        foldMap f (LL n s xs) = foldMap f xs 
        foldr f z (LL n s xs) = foldr f z xs 
        foldl f z (LL n s xs) = foldl f z xs 
        foldr1 f (LL n s xs) = foldr1 f xs 
        foldl1 f (LL n s xs) = foldl1 f xs 

instance Functor LimitList where 
        fmap f (LL n s xs) = LL n s (f <$>  xs)

instance Traversable LimitList where 
        traverse f (LL n s xs) = LL n s <$> traverse f xs         
        sequenceA (LL n s xs) = LL n s <$> sequenceA xs 

head :: LimitList a -> Maybe a 
head (LL n s xs) = case S.viewl xs of 
                        (p S.:< _) -> Just p 
                        S.EmptyL -> Nothing 


tail :: LimitList a -> Maybe (LimitList a)
tail (LL n s xs) = case S.viewl xs of 
                        (_ S.:< xs) -> Just (LL n (s - 1) xs)
                        S.EmptyL -> Nothing 

(|>) :: a -> LimitList a -> LimitList a 
(|>) = insert 

infixr 5 |> 

catMaybes :: LimitList (Maybe a) -> LimitList a 
catMaybes (LL n s xs) = foldr step (new n) xs 
        where step (Just a) z = insert a z 
              step Nothing z = z 
