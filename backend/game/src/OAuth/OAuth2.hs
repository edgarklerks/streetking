{-# LANGUAGE OverloadedStrings, DeriveDataTypeable #-}
module OAuth.OAuth2 where 

import Control.Category
import Control.Arrow
import Control.Statemachine 
import System.Miniserver
import Network.Socket 
import Control.Concurrent.MVar
import Control.Concurrent

import OAuth.Types
import OAuth.Providers 

import Data.URLEncoded
import Network.URI
import Data.List
import Network.Curl
import Network.Curl.Easy
import System.Process
import Data.Either 
import Control.Monad
import Data.Aeson
import Data.Aeson.Parser
import qualified Data.Aeson.Types as AT
import qualified Data.Attoparsec as R
import qualified Data.ByteString.Char8 as B
import qualified Data.Text as T 
import Prelude hiding (id, (.), catch)
import qualified Data.Map as M
import Control.Monad.CatchIO
import Data.Typeable
import Data.Word


myTest = defaultGooglePars "285964854318.apps.googleusercontent.com" "jur4-aXCwt9H8rx8Zkkq89WB" "http://localhost" "test"

myFacebookTest = (defaultFacebookPars "283494445022314" "365f41f257e02669b9bab69904c6befe" "http://graf2.graffity.me" )

{--
main :: IO () 
main = do 
    red <- newEmptyMVar 
    o <- newEmptyMVar 
    t <- authOAuth red o myFacebookTest 
    print "Facebook test"
    r <- takeMVar red
    print r
    s <- takeMVar o  
    print s
    print "Google test" 
    t <- authOAuth red o myTest 
    r <- takeMVar red
    print r
    s <- takeMVar o 
    print s

--}

authOAuth :: MVar String -> MVar (Either String Token) -> OAuthLoginPars -> IO (ThreadId)
authOAuth red o myTest = forkIO $ do 
        h <- newEmptyMVar 
        (thread, port) <- oauthRedirectUser h red myTest 
        -- get redirection url 
        p <- readMVar h
        t <- oauthToken (Code p) port myTest
        print ("facebook", t)
        putMVar o t

authOAuthBrowser  :: MVar (Either String Token) -> OAuthLoginPars -> IO (ThreadId)
authOAuthBrowser r m = forkIO $ do 
    h <- newEmptyMVar 
    (thread, port) <- oauthRedirectBrowser h m
    p <- readMVar h 
    t <- oauthToken (Code p) port m 
    putMVar r t 

    
{-- Redirection with Browser --}
redirectRequestBrowser p myTest = do 
        let (Right u) = (mkRedirectUrl myTest) (myTest { redirect_uri = redirect_uri myTest ++ ":" ++ (show p) })
        let b = browser myTest 
        let url = "'" ++ (show u) ++ "'"
        system(b ++ " " ++ url)

{-- Step 1 redirect user via an outside url --}


{-- Step 1 redirect the user via an channel --}
-- | First MVar String is input, the other is the output variable --}
oauthRedirectUser :: MVar String -> MVar String -> OAuthLoginPars -> IO (ThreadId, PortNumber)
oauthRedirectUser o i par = do 
        (s, p) <- mkMiniSocket 
        let (Right u) = (mkRedirectUrl par) (par { redirect_uri = redirect_uri par ++ ":" ++ (show p)})
        t <- mkMiniServer s (getCode par o)
        putMVar i (show u) 
        return (t, p)

{-- Step 1 redirect the user to the authorization server --}
oauthRedirectBrowser :: MVar String -> OAuthLoginPars -> IO (ThreadId, PortNumber)
oauthRedirectBrowser m u = do 
    (s, p) <- mkMiniSocket 
    forkIO $ void $ redirectRequestBrowser p u
    r <- mkMiniServer s (getCode u m)
    return (r, p)

{-- Step 2 get the permanent token from the authorization server --}
oauthToken :: OAuthObject ->  PortNumber -> OAuthLoginPars -> IO (Either String Token)
oauthToken (Code n) p m = do 
            withCurlDo $ do 
                if tokenMethod m == Post 
                then do 
                    c <- initialize
                    b <- do_curl_ c (tokenPath m) (method_POST ++ [CurlPostFields [show $ mkTokenRequest m m n p], CurlHttpHeaders ["Content-Type: application/x-www-form-urlencoded"]]) :: IO (CurlResponse_ [(String, String)] String)
                    b `seq` return $ getToken m (respBody b)

                else do 
                    let (Right u) = mkAuthUrl (tokenPath m) $ pairs $ mkTokenRequest m m n p
                    print u
                    b <- curlGetResponse_ (show u) [] :: IO (CurlResponse_ [(String, String)] String) 

                    b `seq` return $ getToken m (respBody b)


