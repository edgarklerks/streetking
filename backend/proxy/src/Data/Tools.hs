{-# LANGUAGE OverloadedStrings, BangPatterns, FlexibleInstances, MultiParamTypeClasses, GADTs, ViewPatterns, FlexibleContexts #-}

module Data.Tools where

import Data.Convertible 
import Control.Monad
import Control.Applicative
import Control.Comonad 

instance Convertible a a where 
    safeConvert = Right . id

encWith :: a -> [a] -> [a]
encWith x xs = x : xs ++ [x]
