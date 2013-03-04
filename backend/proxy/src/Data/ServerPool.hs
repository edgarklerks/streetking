{-# LANGUAGE FunctionalDependencies, MultiParamTypeClasses, FlexibleInstances, FlexibleContexts, UndecidableInstances, GeneralizedNewtypeDeriving #-}
module Data.ServerPool where 
import Control.Monad.State
import Control.Monad.Reader.Class
import Control.Monad.Cont.Class
import Control.Monad.Error.Class
import Control.Monad.Writer.Class
import Control.Comonad 
import Control.Comonad.Trans.Class
import Control.Monad
import Control.Applicative
import Control.Monad.Identity
import Control.Arrow 
import Data.Array.IArray 
import Data.Word
import Data.Monoid
import Control.Monad.CatchIO
import Snap.Types 
-- import Control.Monad.

{-- Bit overenginered type, but it is actually pretty cool if 
 - you wrap it up in a State, which is the dual of Store.
 - Then it works like an iterator 
 --}

-- | w is the type of the comonad, for most uses Identity.
--   The list comonad is pretty cool for this, because 
--   we than have multiple worlds with a state, which we 
--   destroy and recreate for our pleasure.
--   m is the internal monad for more effects
--   s is the index type over a 
--   a is the value type of Store w s a
--   b is the result type of the monad 
newtype IteratorT s w a m b = IteratorT { 
     unIteratorT :: StateT (Store s w a) m b
    } deriving (Functor, Applicative, Monad, MonadState (Store s w a), MonadIO, MonadFix, MonadPlus, MonadReader r, MonadCont, MonadError e,  MonadWriter l, Alternative, MonadCatchIO, MonadSnap)

type Iterator  s w   a b = IteratorT s w a Identity b

type Pool a = Store ModInt [] a 


class IteratorMonad i s a | i -> s, i -> a where 
    left :: i ()
    right :: i ()
    focus :: i a  
    seek :: s -> i a
    pos :: i s
    seeks :: (s -> s) -> i a
    maps :: (s -> s) -> i ()

instance (Functor m, Monad m, Comonad w, Enum s) => IteratorMonad (IteratorT s w a m) s a where 
    left = maps pred
    right = maps succ  
    focus = seeks id 
    seek s = seeks (const s)
    pos = posS <$> get 
    seeks f = seeksS f <$> get
    maps s = modify (Store . fmap (first s) . runStore) 
    

newtype Store s w a = Store {
            runStore :: w (s, s -> a)
        } 

newtype ModInt = ModInt {
        runModInt :: (Int, Int)
    } 

instance Enum ModInt where 
    succ (ModInt (x,y)) = ModInt (x + 1 `mod` y, y)
    fromEnum (ModInt (x,y)) = x
    toEnum x = ModInt (0,x)

instance (Functor w) => Functor (Store s w) where 
    fmap f = Store . fmap (second (f.)) . runStore

instance Comonad w => Extend (Store s w) where 
    duplicate = let f w = extend (\t -> let (s, g) = extract t in (s, const w)) . runStore $ w in Store . f

instance Comonad w => Comonad (Store s w) where 
    extract = extract . lowerStore 

-- lowerStore = fmap (\s, ms -> ms s) 
-- extract | [] | = head
-- extract | Store [] |= head . fmap ap
-- ap (s, ms) -> ms s
--
-- law 1
-- extract . duplicate = id -> extract |Store []| = head . fmap ap  
-- head . fmap ap . duplicate $ w = id -> duplicate w = extend (\t -> (fst $ head t , const w))
-- head . fmap ap (\w -> extend | [] | (\t -> fst $ head t, const w) w ) $ w -> w = [(s, s -> a)]
-- head . fmap ap (extend (\t -> fst $ head t, \_ -> [(s, s -> a)]) [(s, s -> a)])
-- head . fmap ap (extend (\t -> fst $ head t, \_ -> 
-- Proof 
-- 
--
--

instance Applicative w => Applicative (Store s w) where 
    pure s = Store $ pure (undefined, \_ -> s) 
    (<*>) (Store fs) (Store as) = Store $ app' <$> fs <*>  as
        where app (a,ms) = ms a
              app' (_,g) (s, f) =  (s, \s -> g s $ f s)

instance Comonad [] where 
    extract = head 

instance MonadTrans (IteratorT s w a) where 
    lift = IteratorT . lift

instance ComonadTrans (Store s) where 
    lower = lowerStore 

-- | Run an iterator 
runIterator :: Iterator s w a b -> Store s w a -> (b, Store s w a)
runIterator m = runIdentity . runIteratorT m

-- | Run an iterator transformer
runIteratorT :: IteratorT s w a m b -> Store s w a -> m (b, Store s w a)
runIteratorT x s = flip runStateT s $ unIteratorT x

-- | Lower a comonad from the store 
lowerStore :: Functor w => Store s w a -> w a
lowerStore = let f (s, ms)  = ms s in fmap f . runStore 

-- | Lift a comonad in the store 
liftStore :: (Extend w, Functor w) => s -> (w a -> s -> b) -> w a -> Store s w b
liftStore s g = let f x = (s, x) in Store . fmap f .  extend g 

-- | Maps the pointer of the store 
mapS :: (Functor w) => (s -> s) -> Store s w a -> Store s w a 
mapS f = Store . fmap (first f) . runStore 

-- | Get the current pointer from the store
posS :: Comonad w => Store s w a -> s
posS = fst . extract . runStore

-- | Sets the pointer of the store and give the current focus
seekS :: Comonad w => s -> Store s w a -> a
seekS s = extract . mapS (const s) 

-- | maps the pointer of the store and give the current focus
seeksS :: Comonad w => (s -> s) -> Store s w a -> a
seeksS f = extract . mapS f 

-- | Bind a monadic action in the store 
bindStore :: (Comonad w, Monad m) => (a -> m b) -> Store s w (m a) -> Store s w (m b)
bindStore f = let g f (s, ms) = (s, \s -> ms s >>= f) in Store . extend (g f . extract) . runStore 

-- | lift a monadic action in the store 
toStore :: (Comonad w, Monad m, Extend w) => (a -> m b) -> Store s w a -> Store s w (m b) 
toStore f = let g f (s, ms) = (s, \s -> f $ ms s ) in Store . extend (g f . extract). runStore 

-- | succ the pointer of the store 
next :: (Functor w, Enum s) => Store s w a -> Store s w a
next = Store . fmap (first succ) . runStore

-- | pred the pointer of the store
prev :: (Functor w, Enum s) => Store s w a -> Store s w a
prev = Store . fmap (first pred) . runStore

-- | sets the pointer of the store 
sets :: Functor w => s -> Store s w a -> Store s w a
sets s = Store . fmap (first $ const s) . runStore 

-- | lift a monadic action in the store 
inStore2 :: (Comonad w, Functor m) => (a -> b -> m c) -> Store s w a -> Store s w (b -> m c)
inStore2 f = let g f (s, ms) = (s, \s -> f $ ms s) in Store . extend (g f . extract) . runStore

-- | makes a list infinite with f 
-- mkCycle id [1,2,3] -> [1,2,3,1,2,3,1,2,3]
-- mkCycle reverse [1,2,3] -> [1,2,3,3,2,1,1,2,3]
mkCycle :: ([a] -> [a]) -> [a] -> [a] 
mkCycle f xs = xs ++ mkCycle f (f xs )

-- | Creates a pool of type a. This will automatically cycle through the list 
mkPool :: [a] -> Pool a
mkPool [] = error "Pool cannot be empty"
mkPool xs = liftStore (toEnum ls) (\xs s -> xs !! fromEnum s)  (mkCycle id xs) 
        where ls = length xs 

{--
futu :: (a -> [b]) -> a -> [b]
futu h ts@(x:xs) = futu' ([h x (futu h ts)])  h xs
    where futu' z h ts@(x:xs) = futu' (h x (futu h ts):z) h xs
          futu' z h [] = z
--}

-- | Histomorphism, tear down a structure with the help of the previous results 
histo :: (a -> [b] -> b) -> [a] -> b
histo h = histo' [] (uncurry h)
    where 
        histo' z h [x] = h (x, z)
        histo' z h (x:xs) = histo' (h (x, z):z) h xs 

showHisto = histo (\a xs -> a + sum xs) [2,2,2] 
-- histo [] (\a xs -> a + sum xs) [2,2,2]
-- histo (h (2, []):[]) h [2,2]
-- histo ([2]) h [2,2]
-- histo (h (2, [2]):[2]) h [2]
-- histo ([4,2]) h [2]
-- h 2 ([4,2]) 
-- 8

-- | Paramorphism, tear down a structure with the rest of the list
para :: (a -> ([a], b) -> b) -> b -> [a] -> b
para h z [] = z
para h z (x:xs) = x `h` (xs, para h z xs)

tails  = para step [[]]
    where step x (xs,z) = (x:xs): z

retails = para step [[]]
    where step x (xs, z) = z ++ [(x:xs)]

zipl xs = tails xs `zip` retails (reverse xs)



