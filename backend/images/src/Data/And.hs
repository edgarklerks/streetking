module Data.And where 

import qualified Data.Sequence as S
import Data.Monoid 
import Control.Applicative
import Control.Monad 
import Data.Foldable 
import Data.Traversable


data And a = Nil 
           | One a 
           | List (S.Seq a)
    deriving (Eq, Show, Read)


instance Monoid (And a) where 
    mempty = Nil 
    mappend Nil a = Nil 
    mappend a Nil = Nil
    mappend (One a) (One b) = List (S.fromList [a,b])
    mappend (One a) (List xs) = List (a S.<| xs) 
    mappend (List xs) (One a) = List (xs S.|> a)

instance Functor And where 
    fmap f Nil = Nil 
    fmap f (One a) = One (f a)
    fmap f (List xs) = List $ fmap f xs

instance Applicative And where 
    pure = One 
    (<*>) Nil a = Nil 
    (<*>) a Nil = Nil
    (<*>) (One f) (One a) = One (f a)
    (<*>) (List xs) (List ys) = List (xs `ap` ys)
    (<*>) (One f) (List xs) = List (f <$> xs)
    (<*>) (List fs) (One xs) = List (fs `ap` S.singleton xs)

instance Traversable And where 
    traverse f Nil = pure Nil    
    traverse f (One a) = pure <$> f a
    traverse f (List xs) = List <$> traverse f xs  

instance Foldable And where 
    foldMap f Nil = mempty  
    foldMap f (One a) = f a  
    foldMap f (List xs) = foldMap f xs 
    fold Nil = mempty 
    fold (One a) = a 
    fold (List xs) = fold xs 

isNil :: And a -> Bool 
isNil Nil = True 
isNil _ = False 

singleton :: a -> And a
singleton = One 

(|>) :: a -> And a -> And a 
(|>) x (List xs) = List (x S.<| xs)
(|>) x (One y) = List (S.fromList [x,y])
(|>) x (Nil) = Nil 

(<|) :: And a -> a -> And a
(<|) (List xs) x = List (xs S.|> x) 
(<|) (One y) x = List (S.fromList [y,x])
(<|) Nil x = Nil 

fromList :: [a] -> And a 
fromList [] = Nil 
fromList [a] = One a
fromList xs = List (S.fromList xs)

testMonad :: And Int 
testMonad = (*) <$> fromList [1,2,3,4,5] <*> fromList [9,8..1]
