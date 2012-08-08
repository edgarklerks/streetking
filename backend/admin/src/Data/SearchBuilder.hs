{-# LANGUAGE GADTs #-}
module Data.SearchBuilder where 

import Model.General 
import Data.DatabaseTemplate
import Data.SortOrder 
import Data.Database (ConOp(..))
import Control.Applicative
import Data.Maybe

type Sortable = Bool 
type Exceptions = [(String,DTD)] 
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

build :: Database c a => Behaviours -> a -> Exceptions -> (DTD, [String])
build bs a ex =  (foldr (\(t,f) z -> fromJust (action t f) +&& z) ("1" +== "1") fds, fmap fst fds) 
    where fds = fields a
          action t f = custom f <|> pure (standard f t)
          custom f = lookup f ex 
          standard f (lkb -> t) =  case t of 
                                    Equal -> f +== f
                                    Max -> f +<= (f ++ "-max") 
                                    MinMax -> f +>= (f ++ "-min") +&& f +<= (f ++ "-max")
                                    Like -> f +%% f 
                                    Ignore -> "1" +== "1"
          lkb t = case lookup t bs of
                        Nothing -> Equal 
                        Just a -> a 

