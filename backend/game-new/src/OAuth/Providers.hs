{-# LANGUAGE OverloadedStrings, BangPatterns #-}
module OAuth.Providers where 

import OAuth.Types
import Data.List 
import qualified Data.Aeson.Types as AT
import Control.Concurrent.MVar
import qualified Data.Attoparsec as R
import Data.Aeson
import qualified Data.ByteString.Char8 as B
import Data.URLEncoded
import qualified Data.Text as T
import Control.Monad
import Control.Monad.Trans



{-- Default Parameters OAuth2
 -  
 -  Hierachy 
 -   
 -                    defaultOAuthPars
 -                   /                \
 -  defaultGooglePars                  defaultFacebookPars
 -
 - --}



defaultOAuthPars x y z s = OAuth {
        browser = "/usr/local/bin/firefox3",
        response_type = "code",
        client_id = x,
        client_secret = y, 
        redirect_uri = z,
        tokenPath = "",
        tokenMethod = Post,
        authPath = "",
        scope = [],
        state = s,
        access_type = undefined,
        approval_prompt = undefined,
        mkRedirectUrl = error "No redirect url generator defined",
        getCode = getDefaultCode,  
        mkTokenRequest = error "No token request generator defined",
mkRefreshRequest = error "No refresh request generator defined",
        getToken = error "No token getter defined"


    }

fkhdr :: String 
fkhdr = "HTTP/1.1 200 OK\n" ++ 
        "Content-Type: text/html\n" ++ 
        "Connection: close\n\n"

getDefaultCode :: MVar String -> String -> IO (Maybe String)
getDefaultCode m x = do 
            let xs = takeWhile (\x -> x /= '&' && x /= ' ') . tail . dropWhile (/='=') . dropWhile (/='c') $ x
            case xs of 
                [] -> return (Just $ fkhdr 
                                ++ "<script type=\"text/javascript\">console.log(\"{\\\"error\\\":\\\"Not authenticated\\\"}\");</script>"
                                ++ "<script type=\"text/javascript\">function getResult() { return \"{\\\"error\\\":\\\"Not authenticated\\\"}\"; };</script>"
                            )
                xs -> putMVar m xs >> return (Just $ fkhdr 
                        ++ "<script type=\"text/javascript\">console.log(\"{\\\"result\\\":true}\");</script>"
                        ++ "<script type=\"text/javascript\">function getResult() { return \"{\\\"result\\\":true}\"; };</script>"
                    )

{-- 
 -
 - m chars as needle,
 - n chars as haystack,
 - In worst case:
 -
 - The user wants us to find a repeated sequence of a character ('ccccc'), the haystack has
 - many of these repetitions, but the last of such a sequence is wrong. The last sequence is at last correct. 
 -
 - Say, the haystack is p repetitions of the pattern ((m - 1) * c + s ) and at last m * c. 
 -      the needle is (m * c). n == m * (p + 1) 
 - One evaluation of one repetition costs us: 
 -  
 -      m * (m - 1) * (m - 2) * .. 1 = m! comparisons 
 -      ccccu 
 -      ccccu -> False  
 -       cccu -> False 
 -        ccu -> False 
 -         cu -> False 
 -          u -> False 
 -  p repetitions costs us: 
 -  p * m! comparisons 
 - Then the last case is:
 - m comparisons 
 - p * m! + m 
 - Now rewrite p:
 - m * p + m = n -> p + 1 = n / m 
 - p -> n / m - 1 
 -
 - Thus in worstcase this function behaves as:
 - O ((n / m - 1) * m! + m ) -> O ( (n / m - 1) * m!)
 - O (n / m * m!) -> 
 -
 - O (n * (m - 1)!)
 -
 - In the best case it runs only:
 - we only have to do m comparisons and m boolean evaluations. 
 - O (2 m) -> O (m )
 -
 --}
skipToString :: String -> String -> String 
skipToString (x:xs) (y:ys) | x == y && crest xs ys = (y:ys)
                           | otherwise = skipToString (x:xs) ys
        where crest (x:xs) (y:ys) = x == y && crest xs ys 
              crest [] ys = True 
              crest xs [] = False 
skipToString _ _ = "" 

getUrlEncodedPar :: String -> String -> Either String Token 
getUrlEncodedPar xs v = do 
                let c = skipToString xs v 
                guard (not . Data.List.null $ c)
                let b = takeWhile (/='&') $ tail $ dropWhile (/='=') $ c
                guard (not . Data.List.null $ b)
                return (OnlyToken b)

getJsonPar :: String -> String -> Either String Token  
getJsonPar xs v = case R.parseOnly json (B.pack v) of 
        (Right (Object v)) -> do 
                getToken v
        (Left t) -> Left $ "Problem parsing json object" ++ t
    where getToken v = let (AT.Success t) = AT.parse (v AT..:) (T.pack xs) 
                       in Right $ OnlyToken (t :: String) 

mkGenericRedirectUrl m = mkAuthUrl (authPath m) $ [
        ("client_id", client_id m),
        ("redirect_uri", redirect_uri m),
        ("scope", intercalate " " (scope m))
    ]

mkGenericTokenRequest m n p = importList $ [
            ("client_id", client_id m),
            ("redirect_uri", redirect_uri m ++ ":" ++ (show p) ++ "/"),
            ("client_secret", client_secret m),
            ("code", n)
        ]

{-- Facebook specific --}

defaultFacebookPars x y z s = (defaultOAuthPars x y z s) {
        tokenMethod = Get,
        authPath = "https://m.facebook.com/dialog/oauth",
        tokenPath = "https://graph.facebook.com/oauth/access_token",
        scope = ["email", "read_stream", "offline_access","user_about_me", "user_hometown", "user_location", "user_status", "publish_stream"],
        mkRedirectUrl = \s -> mkAuthUrl (authPath s) [
                ("redirect_uri", redirect_uri s),
                ("client_id", client_id s),
                ("scope", intercalate " " (scope s))
            ],
        mkTokenRequest = \m n p -> importList $ [ 
            ("client_id", client_id m),
            ("redirect_uri", redirect_uri m ++ ":" ++ (show p) ++ "/"),
            ("client_secret", client_secret m),
            ("code", n)]
            ,
        mkRefreshRequest = undefined,
        getToken = \(!v) -> do 
            getFacebookError v
            return (OnlyToken (tail $ dropWhile (/='=') v))
    }

getFacebookError :: String  -> Either String () 
getFacebookError x = case R.parseOnly json (B.pack x) of 
                            Left _ -> return ()
                            Right (Object v) -> case AT.parse (v AT..:?) "error" of 
                                AT.Success (Just (Object t)) -> case AT.parse (t AT..:?) "message"  of 
                                       AT.Success (Just t) -> Left t
                                       AT.Success (Nothing) -> Left "unknown error"
                                AT.Success (Nothing) -> Left "server returned malformed json"
                                _ -> Left "Server returned malformed response"
                            _ -> Left "server returned malformed json"

                                
{-- Google Specific --}

getGoogleError :: Object -> Either String ()
getGoogleError v = case AT.parse (v AT..:?) "error" of 
                        (AT.Success (Just t)) -> Left t
                        (AT.Success Nothing) -> Right () 
                        _ -> Left "Problem parsing json object"
getGoogleToken :: String -> Either String Token  
getGoogleToken v = case R.parseOnly json (B.pack v) of 
        (Right (Object v)) -> do 
                getGoogleError v 
                getToken v
        (Left t) -> Left $ "Problem parsing json object" ++ t
    where getToken v = let (AT.Success t) = AT.parse (v AT..:) "access_token"
                           (AT.Success r) = AT.parse (v AT..:) "refresh_token"
                       in Right $ TokenRefresh (t :: String) (r :: String)



defaultGooglePars :: String -> String -> String -> String -> OAuthLoginPars
defaultGooglePars x z y s = (defaultOAuthPars x z y s) {
                scope = ["https://www.googleapis.com/auth/userinfo.email", "https://www.googleapis.com/auth/userinfo.profile"],
                authPath = "https://accounts.google.com/o/oauth2/auth",
                tokenPath = "https://accounts.google.com/o/oauth2/token",
                access_type = Offline,
                approval_prompt = Auto,
                mkRedirectUrl = \s ->  mkAuthUrl (authPath s) [
                    ("access_type", show $ access_type s),  
                    ("response_type", response_type s),
                    ("client_id", client_id s),
                    ("redirect_uri", redirect_uri s),
                    ("scope", intercalate " " $ scope s),
                    ("state", state s),
                    ("approval_prompt", show $ approval_prompt s)
                ],
                mkTokenRequest = \m n p -> importList [("code", n), ("client_id", client_id m), ("client_secret", client_secret m), ("redirect_uri", redirect_uri m ++ ":" ++ (show p)), ("grant_type", "authorization_code")],
                mkRefreshRequest = undefined,
                getToken = getGoogleToken
            }

