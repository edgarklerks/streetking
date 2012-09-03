{-# LANGUAGE DeriveDataTypeable, DisambiguateRecordFields #-}
module OAuth.Types where 

import Network.Socket
import Network.URI
import Data.Typeable
import Control.Monad.CatchIO
import Data.Aeson
import Control.Concurrent.MVar
import Data.URLEncoded
import Data.Word

data UserError = UserError String 
    deriving (Show, Typeable)

data Token = OnlyToken String 
           | TokenRefresh String String 
           | TokenRefreshExpire String String Integer
        deriving (Show)

justToken :: Token -> String 
justToken (OnlyToken r) = r
justToken (TokenRefresh r s) = r
justToken (TokenRefreshExpire r s t) = r

data Method = Post | Get 
    deriving (Eq, Ord)


instance Show Method where 
    show (Post) = "POST"
    show (Get) = "GET"

instance Exception UserError 

data SignatureMethod = HMAC_SHA1
    deriving (Show, Eq, Ord)

data OAuth1aLoginPars = OAuth1a {
        test_browser :: String, 
        consumer_key :: String,
        callback_uri :: String,
        request_token_uri :: String,
        signature_method :: SignatureMethod,
        version :: String,
        requestTokenMethod :: Method 
    }

defaultOAuth1aPars = OAuth1a {
        test_browser = "/usr/local/bin/firefox3",
        consumer_key = error "Provide consumer key",
        callback_uri = error "Provide redirect_uri",
        request_token_uri = error "Provide an requestToken uri",
        signature_method = HMAC_SHA1,
        version = "1.0",
        requestTokenMethod = Post
    }

defaultTwitterOAuthPars x y = defaultOAuth1aPars {
        consumer_key = x,
        callback_uri = y,
        request_token_uri = "http://api.twitter.com/oauth/request_token"
    }

data OAuthLoginPars = OAuth {
                browser :: String,
                response_type :: String,
                client_id :: String,
                client_secret :: String, 
                redirect_uri :: String, 
                tokenMethod :: Method,
                authPath :: String, 
                tokenPath :: String, 
                scope :: [String],
                state :: String,
                access_type :: AccessType,
                approval_prompt :: ApprovalPrompt, 
                mkRedirectUrl :: OAuthLoginPars -> Either String URI,
                mkTokenRequest :: OAuthLoginPars -> String -> PortNumber -> URLEncoded ,
                mkRefreshRequest :: OAuthLoginPars -> String -> String,
                getToken :: String -> Either String Token, 
                getCode :: MVar String -> String -> IO (Maybe String)
            }

data OAuthState = OAuthStart 
                | OAuthRedirectUrl String String
                | OAuthCode String  
                | OAuthToken String Integer String 
                | OAuthRefresh String
                | OAuthError String 
                | OAuthWait 

data OAuthObject = Code String 
                  | Token String Integer String  
                  | Redirect
                  | Refresh 


data AccessType = Offline | Online 
data ApprovalPrompt = Force | Auto 

instance Show AccessType where 
        show Offline = "offline"
        show Online = "online"

instance Show ApprovalPrompt where 
    show Force = "force"
    show Auto = "auto"


throwUser :: (MonadCatchIO m) =>  String -> m a
throwUser t = throw (UserError t) >> return undefined

mkAuthUrl :: String -> [(String, String)] -> Either String URI
mkAuthUrl x xs = case parseURI x of 
                        Just x -> return $ addToURI (importList xs) x
                        Nothing -> Left "Not a correct URI" 



