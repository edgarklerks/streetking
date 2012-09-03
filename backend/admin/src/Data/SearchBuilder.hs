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
    MinMax :: Behaviour 
    Equal :: Behaviour 
    Like :: Behaviour 
    Ignore :: Behaviour 

defaultBehaviours = [
            ("Integer", MinMax),
            ("Int", MinMax),
            ("Double", MinMax),
            ("String", Like),
            ("Bool", Equal),
            ("Id", Equal),
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
          standard (lkb -> t) f =  case t of 
                                    Equal -> f +== f
                                    Max -> f +<= (f ++ "-max") 
                                    MinMax -> f +>= (f ++ "-min") +&& f +<= (f ++ "-max")
                                    Like -> f +%% f 
                                    Ignore -> "1" +== "1"
          lkb t = case lookup t bs of
                        Nothing -> Equal 
                        Just a -> a 

