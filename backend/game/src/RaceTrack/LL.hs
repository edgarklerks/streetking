{-# LANGUAGE TupleSections #-}
module LL where 


import Data.STRef 
import Control.Monad.State 
import Control.Monad 
import Control.Monad.ST
import Control.Applicative 

data LL s a = LL {
        prev :: Node s a,
        next :: Node s a,
        current :: a 
    } 

liftST a = StateT $ \s -> (,s) <$>  a

type Node s a = STRef s (LL s a)



-- buildLL :: [a] -> StateT (Node s a) (ST s) (LL s a)
buildLL (x:xs) = runST $ (`evalStateT` undefined) $ do 
                s <- liftST $ newSTRef (LL undefined undefined x)  
                put s 
                worker xs s 
                l <- liftST $ readSTRef s 
                return l
    where -- worker :: [a] -> Node s a -> StateT  (Node s a) (ST s) (Node s a)
worker [x] s = do 
            f <- get 
            (LL p n v) <- liftST $ readSTRef s 
            s' <- liftST $ newSTRef (LL s f x)
            liftST $ writeSTRef s (LL p s' v)
            (LL q r a) <- liftST $ readSTRef f
            liftST $ writeSTRef f (LL s' r a) 

            return ()

worker (x:xs) s = do
                    -- read previous version 
                    (LL p n v) <- liftST $ readSTRef s 
                    -- mk new stref 
                    q <- liftST $ newSTRef undefined 
                    -- set old to prev 
                    r <- liftST $ newSTRef (LL s undefined x) 
                    -- set new to next 
                    liftST $ writeSTRef s (LL p r v)
                    worker xs r  

                
