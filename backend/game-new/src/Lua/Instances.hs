{-# LANGUAGE FlexibleInstances, OverlappingInstances, MultiParamTypeClasses, UndecidableInstances, TypeSynonymInstances, FlexibleContexts, ScopedTypeVariables #-}
module Lua.Instances where

import Data.Convertible
import Control.Applicative
import Control.Monad.Trans
import Control.Monad.Error
import Control.Monad.Reader
import Control.Monad
import Data.List
import qualified Data.Map as M
import qualified Scripting.Lua as Lua
import Data.String
import Data.Typeable
import Data.Data
import Lua.Prim



instance Num LuaValue where
    fromInteger = LuaNum . fromInteger 

instance IsString LuaValue where
    fromString = LuaString 

instance Convertible String LuaValue where
    safeConvert  = Right . LuaString  

instance Convertible LuaValue String where
    safeConvert (LuaString x) = Right x
    safeConvert a  = convError "Cannot convert incompatible types" a 

instance Convertible LuaValue Double where
    safeConvert (LuaNum x) = Right  x
    safeConvert a = convError "Cannot convert incompatible types"  a

instance Convertible Double LuaValue where
    safeConvert  = Right . LuaNum 
-- Relative slow but really general 

instance (Typeable a, Convertible a LuaValue) => Convertible [(String, a)] LuaValue where
    safeConvert  = Right . LuaObj . fmap cv 
        where cv (a, b) = (LuaString a, convert b :: LuaValue )

instance (Typeable a, Convertible LuaValue a) => Convertible LuaValue [(String, a)] where
    safeConvert (LuaObj xs) = Right $ fmap cv xs
        where cv (LuaString a, b) = (a, convert b)
              cv (LuaNum a, b) = (show a, convert b :: (Convertible LuaValue a) => a)
    safeConvert x = convError "Cannot convert incompatible types" x

instance Convertible Integer LuaValue where
    safeConvert  = Right . LuaNum . fromInteger 

instance Convertible LuaValue Integer where
    safeConvert (LuaNum x) = Right . floor $ x

instance Convertible Rational LuaValue where
    safeConvert = Right . LuaNum . fromRational 

instance Convertible LuaValue Rational where
    safeConvert (LuaNum x) = Right . toRational $ x
    safeConvert a = convError "Cannot convert incompatible types" a

instance Convertible LuaValue LuaValue where
    safeConvert = Right . id

