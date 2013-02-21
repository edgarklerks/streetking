{-# LANGUAGE OverloadedStrings, GADTs, GeneralizedNewtypeDeriving,ScopedTypeVariables  #-}
module Data.HashQuery where 

import Control.Applicative
import Control.Monad
import Data.Serialize 
import qualified Data.ByteString as B
import Data.Word

data HashQuery a where 
        Search :: B.ByteString -> HashQuery a 
        Add :: Serialize a => B.ByteString -> a -> HashQuery a
        Remove :: B.ByteString -> HashQuery a
        Witness :: a -> HashQuery a



instance Serialize a => Serialize (HashQuery a) where 
        put (Search b) = put (0 :: Word8) *> put b
        put (Add a b) = put (1 :: Word8) *> put a *> put b
        put (Remove a) = put (2 :: Word8) *> put a
        put (Witness a) = put (3 :: Word8) *> put a
        get = do 
            (x :: Word8) <- get 
            case x of 
                0 -> Search <$> get
                1 -> Add <$> get <*> get
                2 -> Remove <$> get 
                3 -> Witness <$> get


