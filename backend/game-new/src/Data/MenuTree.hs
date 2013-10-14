{-# LANGUAGE TemplateHaskell, DeriveGeneric, StandaloneDeriving,
 ViewPatterns  #-}

module Data.MenuTree where 

import Control.Applicative
import Control.Monad
import Control.Monad.State 
import qualified Data.Foldable as F 
import qualified Data.Traversable as T

import qualified Data.Aeson as A 
import qualified Data.Aeson.TH as A

import Data.Tree 
import qualified Data.ByteString.Lazy.Char8 as C
import Debug.Trace 
import Data.List 

import Test.SmallCheck 
import Test.SmallCheck.Series
-- import GHC.Generics

-- Tree a = Node a [Tree a]
-- Classic rose tree. 

type Module = String 
type Label = String 
type Class = String 

data Menu = Root 
          | MenuItem Label Module Class
          | SubMenu Label Module Class 
          | Tab Label Module Class
        deriving (Show , Eq)

mkTabs p xs =  Node Root (foldr step [] xs)
                where step x z = Node (Tab x p "") [] : z

type MenuTree = Tree (Int, Menu)

{-- Tree in labeled flat form, suitable for database storage --}
type FlatTree = [((Int, Int), Menu)]

$(A.deriveJSON (\x -> case x of 
                        "subForest" -> "nodes" 
                        "rootLabel" -> "content") ''Tree)
$(A.deriveJSON id ''Menu)

anotateTree :: Tree Menu -> MenuTree 
anotateTree xs = fst $ runState (T.mapM step xs) 0 
    where 
        step m = do 
            p <- get 
            put (p + 1)
            return (p, m)

stripTree :: MenuTree -> Tree Menu 
stripTree = fmap snd 

toFlat :: Tree Menu -> FlatTree 
toFlat (anotateTree -> xs) = flatten $ evalState (rn xs) 0
                        where rn  (Node (n, m) xs) = do 
                                p <- get 
                                xs' <- mapM (\x -> put n *> rn x) xs
                                return (Node ((p, n), m) xs')



fromFlat :: FlatTree -> Tree Menu
fromFlat xs = fmap snd $ rn xs
        where rn (x:xs) = F.foldl' (flip step) (Node ((0,0), Root) []) xs
--              step (snd -> Root) z = z
              step t@(fst3 -> p) (Node s@(snd3 -> p') xs) =  
                                        if p == p' 
                                            then Node s (xs ++ [(Node t [])])
                                            else Node s (map (step t) xs)
              fst3 ((a, b),c) = a 
              snd3 ((a,b),c) = b
testTree = Node (Root) [
                    Node (MenuItem "T" "T" "") [], 
                    Node (MenuItem "L" "C" "") 
                        [(Node (MenuItem "B" "B" "") [Node (MenuItem "D" "D" "") []])],
                    Node (MenuItem "S" "S" "") [
                        Node (MenuItem "G" "G" "") [Node (MenuItem "H" "H" "") []],
                        Node (MenuItem "Q" "Q" "") []

                    ]
                ]

-- GENERATED START
{-
isoProp = smallCheck 4 (property prop) 
    where prop :: Tree Menu -> Bool 
          prop x = fromFlat (toFlat t) == t
            where t = Node Root [x]
 
instance Serial Menu where
        series = cons0 Root \/ cons3 MenuItem \/ cons3 SubMenu \/ cons3 Tab
        coseries rs d
          = [\ t ->
               case t of
                   Root -> t0
                   MenuItem x1 x2 x3 -> t1 x1 x2 x3
                   SubMenu x1 x2 x3 -> t2 x1 x2 x3
                   Tab x1 x2 x3 -> t3 x1 x2 x3
             | t0 <- alts0 rs d, t1 <- alts3 rs d, t2 <- alts3 rs d,
             t3 <- alts3 rs d]

instance (Serial a) => Serial (Tree a) where
        series = cons2 Node
        coseries rs d
          = [\ t ->
               case t of
                   Node x1 x2 -> t0 x1 x2
             | t0 <- alts2 rs d]
-}
-- GENERATED STOP
--
