
{-# Language TypeSynonymInstances, FlexibleInstances, IncoherentInstances #-}
module Data.Security where


import Data.List
import qualified Data.Map as Map
import Data.Ratio 

import Data.Object
import Control.Monad

-- 
import qualified Data.ByteString as B

import qualified Data.ByteString.Lazy.Char8 as L
-- import Network.ByteString
--
 

import Data.Digest.TigerHash
import Data.Digest.TigerHash.ByteString


 
tiger ::  [Char] -> String
tiger str =  b32TigerHash. tigerHash $ (L.pack str)


