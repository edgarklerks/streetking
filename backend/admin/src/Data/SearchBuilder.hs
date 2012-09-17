{-# LANGUAGE GADTs #-}
module Data.SearchBuilder where 

import Model.General 
import Data.DatabaseTemplate
import Data.SortOrder 
import Data.Database (ConOp(..))
import Control.Applicative
import Data.Maybe
import Data.List 

type Sortable = Bool 
type Exceptions = [(String -> Type -> Maybe DTD)] 
type Behaviours = [(Type, Behaviour)] 
type Type = String 

data Behaviour where 
    Max :: Behaviour 
    Min :: Behaviour
    MinMax :: Behaviour 
    Equal :: Behaviour 
    Like :: Behaviour 
    Ignore :: Behaviour 
 deriving Eq

defaultBehaviours :: Behaviours
defaultBehaviours = [
            ("Integer", MinMax),
            ("Int", MinMax),
            ("Double", MinMax),
            ("String", Like),
            ("Bool", Equal),
            ("Id", Equal),
            ("Id", MinMax),
            ("Char", Equal)
        ]

defaultExceptions :: Exceptions 
defaultExceptions = [
        \x t -> case "_id" `isSuffixOf` x && (t == "Id" || t == "Integer") of 
                                                                True -> return (x +== x)
                                                                False -> fail ""] 

findException :: String -> Type -> Exceptions -> Maybe DTD 
findException s t [] = Nothing 
findException s t (x:xs) = x s t <|> findException s t xs 

                               

build :: Database c a => Behaviours -> a -> Exceptions -> (DTD, [String])
build bs a ex =  (foldr (\(t,f) z -> fromJust (action t f) +&& z) ("1" +== "1") fds, fmap fst fds) 
    where fds = fields a
          action t f = custom f t <|> pure (standard f t)
          custom t f = findException f t ex 
          standard (lkb -> ts) f = foldr step ("1" +== "1") ts 
                where step t z = case t of 
                                    Equal -> f +== f +&& z
                                    Max -> f +<= (f ++ "-max") +&& z 
                                    Min -> f +>= (f ++ "-min") +&& z 
                                    MinMax -> f +>= (f ++ "-min") +&& f +<= (f ++ "-max") +&& z 
                                    Like -> f +%% f +&& z 
                                    Ignore -> "1" +== "1" +&& z 
          lkb t = case lookupMany t bs of
                        [] -> [Equal]
                        xs -> xs 


lookupMany :: Eq a => a -> [(a,b)] -> [b] 
lookupMany a [] = [] 
lookupMany a ((s,x):xs) | s == a = x : lookupMany a xs 
                        | otherwise = lookupMany a xs 

