{-# LANGUAGE OverloadedStrings #-}
{-
 - This module decodes the arguments passed to the application server. 
 - Arguments are (in order of importance):
 - Cookies
 - Path information
 - Query string 
 - Body
 -}
module Snap.Extension.Decoder where
import Snap.Extension
import qualified Data.ByteString.Char8 as C
import Data.ByteString.Char8 (ByteString(..))
import Snap.Types
import Control.Applicative
import Control.Monad
import Data.Maybe 
import qualified Data.Map as M

data Decoded = Decoded {
        identified :: Maybe DevCookie,
        roles :: Maybe RoleCookie,
        path :: [ByteString],
        query :: QueryMap  
    } deriving (Show, Read) 

{-- 
 - Sickened by the light. 
 -  Rejected by the  dark.
 --}

type RoleCookie = ByteString 
type DevCookie = ByteString 
type QueryMap = M.Map ByteString [ByteString]


decode :: Snap Decoded  
decode = Decoded <$>  (fmap cookieValue <$> getCookie "application_token") <*> (fmap cookieValue <$> getCookie "user_token") <*> decodePath <*> decodeQuery 
                   

decodePath :: Snap [ByteString]
decodePath = catMaybes . fmap urlDecode . C.splitWith (=='/') .  rqPathInfo <$> getRequest

decodeQuery :: Snap QueryMap 
decodeQuery = getParams 


