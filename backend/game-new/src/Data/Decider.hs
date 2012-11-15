{-# LANGUAGE GADTs, TypeOperators, MultiParamTypeClasses, FlexibleInstances, NoMonomorphismRestriction #-}
module Data.Decider where 

import Data.Monoid hiding (Any, All) 

data Expr g a where
    Any :: [Expr g a] -> Expr g a
    All :: [Expr g a] -> Expr g a 
    FromTo :: Integer -> Integer -> Expr g a -> Expr g a
    One :: a -> Expr g a 
    From :: Integer -> Expr g a -> Expr g a
    To :: Integer -> Expr g a -> Expr g a
        deriving Show 
    {--
    Module :: Expr g a -> Expr (M :+: g) a 
    Destructive :: Expr g a -> Expr (D :+: g) a
    Once :: Expr g a -> Expr (O :+: g) a 
    --}

data a :+: b
data M
data D 
data O 

class Evaluate a b where 
    match :: a -> b -> Bool 



-- | Every expression gives rise to function 


equalDecider = buildDecider (==) 

-- The underlying arrow is Machine a b = [a] -> ([b], Bool) 

newtype Decider a = Decider {
            runDecider :: [a] -> ([a], Bool)          
        }

instance Monoid (Decider a) where 
        mempty = Decider $ \xs -> (xs, True) 
        mappend (Decider f) (Decider g) = Decider $ \xs -> let (xs', b) = f xs 
                                                           in case b of
                                                                True -> runDecider (Decider g) xs'
                                                                False -> (xs, b)

buildDecider :: (a -> b -> Bool) -> Expr g b -> Decider a 
buildDecider f (From from p) = Decider $ \xs -> 
                                      let (xs',b) = step xs 0
                                      in if b >= from 
                                            then (xs', True)
                                            else (xs, False)
        where step xs n = let (xs', b) = runDecider (buildDecider f p) xs 
                          in case b of 
                                False -> (xs, n) 
                                True ->  step xs' (n + 1)
buildDecider f (To to p) = Decider $ \xs -> 
                                  let (xs',b) = step xs 0
                                  in if b <= to
                                            then (xs, True)
                                            else (xs, False)
        where step xs n = let (xs', b) = runDecider (buildDecider f p) xs 
                          in case b of 
                                False -> (xs, n) 
                                True ->  step xs' (n + 1)
buildDecider f (FromTo from to p) = Decider $ \xs -> 
                                           let (xs', b) = runDecider (buildDecider f (From from p)) xs 
                                           in case b of 
                                                False -> (xs, False)
                                                True -> let (_,b) = runDecider (buildDecider f (To to p)) xs 
                                                        in case b of 
                                                            False -> (xs, False) 
                                                            True -> (xs', True)
buildDecider f (One p)  = Decider $ \xs -> member f p xs
buildDecider f (All ps) = Decider $ \xs -> 
                                 let (xs', b) = step ps xs 
                                 in case b of 
                                        True -> (xs', b)
                                        False -> (xs, b)
        where step [] xs = (xs, True)
              step (p:ps) xs  = let (xs', b) = runDecider (buildDecider f p) xs 
                                in case b of 
                                        True -> step ps xs'   
                                        False -> (xs, False) 
buildDecider f (Any ps) = Decider $ \xs -> step ps xs
        where step [] xs = (xs, False)
              step (p:ps) xs = let (xs', b) =  runDecider (buildDecider f p) xs  
                               in case b of
                                        True -> (xs',True)
                                        False -> step ps xs 


-- The most primitive building block. This is satisfy, when you build
-- a parser. We use member, because we need to allow all permutations  
member :: (a -> b -> Bool) -> b -> [a] -> ([a],Bool)
member f x [] = ([], False)
member f x (y:xs) | f y x = (xs, True)
                  | otherwise = let (ns,t) = member f x xs 
                                in (y:ns,t)

accept :: (a -> b -> Bool) -> b -> [a] -> Bool
accept f x [] = False
accept f x (y:xs) | f y x = True
                  | otherwise = accept f x xs  
