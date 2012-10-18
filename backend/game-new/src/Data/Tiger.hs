module Data.Tiger (
  tiger32                 
) where 


import  Codec.Binary.Base32
import qualified Data.ByteString as C
import qualified Data.ByteString.Lazy as B 
import Crypto.Hash.Tiger 

tiger32 :: C.ByteString -> String 
tiger32 = encode . C.unpack . hash 
