{-# LANGUAGE TypeOperators, TupleSections, GADTs, MultiParamTypeClasses,
 FlexibleInstances, NoMonomorphismRestriction #-}
module DStar where 

import qualified Data.HashMap.Strict as S
import Data.Monoid hiding (Any, All) 
import Data.Foldable 
import Prelude hiding (foldr, foldl, concat)
import Data.Maybe 
import Control.Applicative
import Data.Tuple 
import Data.List (unfoldr)
import qualified Data.Set as Set 
import Control.Monad.State 
import Control.Monad.Reader 
import Debug.Trace
import qualified Data.List as L  

type Edges = S.HashMap Int [Int]
type Nodes a = S.HashMap Int a

data Graph a = Graph {
            edges :: Edges,
            nodes :: Nodes a
        } deriving Show

instance Foldable (Either s) where 
            foldr f z (Right s) = f s z 
            foldr f z (Left a) = z
            foldl f z (Right a) = f z a 
            foldl f z (Left a) = z 
            fold (Right a) = a   
            fold (Left b) = mempty 
            foldMap f (Right a) = f a 
            foldMap _ (Left _) = mempty  

mkUndirectedGraph :: [(Int, Int)] -> [(Int,a)] -> Either String (Graph a)
mkUndirectedGraph xs ys = checkValid xs $ Graph (mkEdges xs) (mkNodes ys)
    where mkNodes :: [(Int, a)] -> Nodes a
          mkNodes xs = S.fromList xs 

          mkEdges :: [(Int, Int)] -> Edges 
          mkEdges xs = foldr step mempty (xs <> (filter (uncurry (/=)) $ swap <$> xs))
                where step (a,b) z = case S.lookup a z of 
                                    Nothing -> S.insert a [b] z 
                                    Just xs -> S.insert a (b:xs) z 

{-- 
-  1 - 2 
-   \ /  \
-    3 - 5
-    |
-    4   6
--}
testGraph = mkUndirectedGraph [
                    (1,2),
                    (2,3),
                    (3,1),
                    (3,4),
                    (2,5),
                    (5,3)
                ] [
                    (1,'h'),
                    (2,'h'),
                    (3,'x'),
                    (4,'t'),
                    (5,'s'),
                    (6,'q')
                ]


{-- simple graph 
-    1 - 2
-    | x |
-    3 - 4
- --}

simpGraph  = mkUndirectedGraph [
                (1,2),
                (1,3),
                (1,4),
                (2,3),
                (2,4)
            ] [
                (1,'h'),
                (2,'a'),
                (3,'b'),
                (4,'c')
            ]
-- genPaths :: Int -> Int -> Int -> Graph a -> [[(Int,Int)]]
-- | Find all possible paths from x to y with maximum length of depth
genPaths :: Int -> Int -> Int -> Graph a -> [[Int]]
genPaths x y 0 g = mzero 
genPaths x y depth g | x == y = return [x]
                     | otherwise = do 
                    x' <- getNodes x g
                    rest <- genPaths x' y (depth - 1) g 
                    return $ x : rest 

-- | Find all acyclic paths from x to y with maximum length of depth 
genPathsACyclic :: Int -> Int -> Int -> Graph a -> [[Int]]
genPathsACyclic x y depth g = evalStateT (runReaderT (worker x y depth) g) mempty
    where worker :: Int -> Int -> Int -> ReaderT (Graph s) (StateT (Set.Set Int) []) [Int]
          worker x y depth  | x == y = return [x] 
                            | depth == 0 = mzero
                            | otherwise = do 
                                g <- ask 
                                x' <- lift . lift $ getNodes x g 
                                xs <- get
                                put (Set.insert x xs)
                                if x' `Set.member` xs then mzero 
                                    else do 
                                        rest <- worker x' y (depth - 1) 
                                        return (x : rest) 


getEdges :: Int -> Graph a -> [(Int,Int)]
getEdges x g = (,x) <$> concat (maybeToList (S.lookup x (edges g))) 

getNodes :: Int -> Graph a -> [Int]
getNodes x g = concat (maybeToList (S.lookup x (edges g)))

checkValid :: [(Int,Int)] -> Graph a -> Either String (Graph a)
checkValid edges g@(Graph _ nodes) = case foldr (uncurry step) [] edges of 
                                            [] -> Right g 
                                            xs -> Left $ showErrors xs
    where step k v z = let lfts = (,v) <$> testnode k 
                           rgts = (k,) <$> testnode v 
                       in lfts <> rgts <> z 
          testnode k = case S.member k nodes of 
                                True -> [] 
                                False -> [k] 
               

showErrors :: [(Int,Int)] -> String 
showErrors = foldr step [] 
    where step (k,v) z = "edge ( " <> (show k) <> " , " <> (show v) <> " ) is not connected\n"

-- case and $ fmap step (S.keys edges) ++ fmap step (S.values nodes) of 
                                      --  True -> return g
                                       -- False -> 
                                       --
data Expr g a where
    Any :: [Expr g a] -> Expr g a
    All :: [Expr g a] -> Expr g a 
    FromTo :: Int -> Int -> Expr g a -> Expr g a
    One :: a -> Expr g a 
    From :: Int -> Expr g a -> Expr g a
    To :: Int -> Expr g a -> Expr g a
    Module :: Expr g a -> Expr (M :+: g) a 
    Destructive :: Expr g a -> Expr (D :+: g) a
    Once :: Expr g a -> Expr (O :+: g) a 

data a :+: b
data M
data D 
data O 



newtype Rule g = Rule {
            unRule :: Expr g Symbol 
        }


data Symbol where 
    TournamentS :: Integer -> Symbol 



class Evaluate g a b where 
    match :: [a] -> Expr g b -> Bool 

instance Evaluate g Event Symbol where 
    match xs fg = undefined 


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
data Event where 
    TournamentPlace :: Integer -> Integer -> Event 
    Tournament :: Integer -> Event 


