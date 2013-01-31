{-# Language GADTs, MultiParamTypeClasses, TypeSynonymInstances, FlexibleInstances, LiberalTypeSynonyms, TypeFamilies, FunctionalDependencies #-}


module Main where 

import Data.Monoid 
import Data.Foldable 
import Control.Applicative
import Control.Monad 
import Control.Concurrent
import System.IO.Unsafe
import Prelude hiding (foldr, foldl, foldl1, foldr1)

reducer :: Foldable f => (a -> b -> b) -> f a -> b -> b
reducer f x z = foldr f z x
reducel :: Foldable f => (b -> a -> b) -> b -> f a -> b
reducel f z x = foldl f z x 

newtype TreeT m a = TreeT {
            unTreeT :: Tree (m a)    
        }

data Tree a where 
        Zero :: a -> Tree a 
        Succ :: Tree (Node a) -> Tree a
    deriving Show 

data Node a where 
        Node2 :: a -> a -> Node a 
        Node3 :: a -> a -> a -> Node a 
    deriving Show 


instance Functor Node where 
        fmap f (Node2 a b) = Node2 (f a) (f b)
        fmap f (Node3 a b c) = Node3 (f a) (f b) (f c)

instance Functor Tree where
        fmap f (Zero a) = Zero $ f a 
        fmap f (Succ n) = Succ $ fmap f <$> n 

instance Functor m => Functor (TreeT m) where 
            fmap f = TreeT . (fmap.fmap) f . unTreeT 

instance Monad m => Monad (TreeT m) where 
            return = TreeT . Zero . return 
            (>>=) (TreeT (Zero a)) f = TreeT $ Zero $ do 
                                                s <- a
                                                let (TreeT (Zero b)) = f s 
                                                b
            (>>=) (TreeT (Succ n)) f = TreeT (Succ $ fmap (>>=g) <$> n)
                    where g a = let (TreeT (Zero b)) = f a 
                                in b 



data Promise a = Promise (IO (MVar a))

instance Functor Promise where 
        fmap f (Promise a) = Promise $ do 
                                s <- a
                                t <- takeMVar s
                                newMVar (f t)


instance Monad Promise where 
        return a = Promise $ newMVar a
        (>>=) (Promise a) f = Promise $ do 
                                s <- a 
                                t <- takeMVar s 
                                let (Promise n) = f t 
                                n

emptyPromise :: Promise a 
emptyPromise = Promise $ newEmptyMVar

forcePromise :: Promise a -> a
forcePromise (Promise a) = unsafePerformIO $ a >>= takeMVar 

modifyPromise :: (a -> a) -> Promise a -> Promise a 
modifyPromise f (Promise a) = Promise $ do 
                                s <- a 
                                t <- takeMVar s
                                putMVar s (f t)
                                return s


plc pr = do 
        a <- pr 
        return (a + 1)
main = return ()
future :: a -> a 
future m = unsafePerformIO $ do 
                    s <- newEmptyMVar 
                    forkIO $ m `seq` putMVar s m 
                    takeMVar s 

force :: a -> a 
force m = m `seq` m 

fibf 0 = 1 
fibf 1 = 1 
fibf ~n = future (fibf (n - 1)) + future (fibf (n - 2))

fib 0 = 1
fib 1 = 1
fib n = fib (n - 1) + fib (n - 2)

{--

main = defaultMain [
            bgroup "fib" [
                            bench "10" $ whnf fib 10
                         ,  bench "20" $ whnf fib 20
                         ,  bench "30" $ whnf fib 30 
            ],
            bgroup "fibf" [
                              bench "10" $ whnf fibf 10 
                            , bench "20" $ whnf fibf 20 
                            , bench "30" $ whnf fibf 30 
            ]
    ]

--}

data Lazy a = forall b. Lazy (b -> a) b
            | forall c. Lazier (c -> a) (Lazy c)

($~) :: (b -> a) -> b -> Lazy a
($~) f b = Lazy f b 

eval :: Lazy a -> a
eval (Lazy f a) = f a 
eval (Lazier f b) = f (eval b)

instance Functor Lazy where 
        fmap f (Lazy g a) = (Lazy (f . g) a)
        fmap f (Lazier g b) = (Lazier (f . g) b)

instance Applicative Lazy where 
        pure a = Lazy id a 
        (<*>) s (Lazy f b) = Lazy (eval s . f) b
        (<*>) s (Lazier f b) = Lazier (eval s . f) b



