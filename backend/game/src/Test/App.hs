{-# LANGUAGE OverloadedStrings, GeneralizedNewtypeDeriving, RankNTypes #-}
module Test.App (
module Network.HTTP,
module Network.URI,
RequestState,
defaultProgramState,
TestSession, 
runTestSession,
runUserTestSession, 
expect,
body, 
ok,
runTest,
setMethod,
setUri,
writeJson,
resource,
params,
userTests,
test,
writeBody,
getUnixTime,
readJson,
ProgramState(..),
ifresult
) where 

import qualified Data.ByteString.Lazy.Char8 as L
import qualified Data.ByteString.Char8 as B
import Data.String 
import Control.Applicative
import Control.Monad
import Control.Monad.Reader
import Control.Monad.State
import Control.Monad.Trans 
import Network.HTTP
import Network.URI
import Control.Monad.Error
import Control.Concurrent.STM
import Data.Aeson 
import Data.Aeson.Parser
import Data.Attoparsec as AT
import Data.Maybe
import qualified Data.Map as M
import Data.List
import Data.Time.Clock
import Data.Time.Clock.POSIX

data ProgramState = PS {
        server :: String,
        sport :: String,
        apptoken :: TMVar String,
        usertoken :: TMVar String,
        devtoken :: String 
    }

data RequestState = RS {
        rsUri :: Maybe String, 
        rsMethod :: Maybe RequestMethod, 
        rsHeaders :: [Header],
        rsBody :: B.ByteString,
        testName :: Maybe String,
        rsParams :: [(String, String)]
    } deriving Show

newtype TestSession a = TS {
            runTS :: StateT RequestState (ReaderT ProgramState (ErrorT String IO)) a 
    } deriving (Functor, Applicative, Monad, MonadReader ProgramState, MonadIO, MonadError String, MonadPlus, Alternative, MonadState RequestState)

{-- Test combinators --}
ifresult f r = case t r of 
                Error s -> error s 
                Success x -> case M.lookup ("result" :: String) x of 
                                      Nothing -> error "no result" 
                                      Just (x :: Value) -> f r 
    where t = fromJSON . readJson . rspBody

expect :: Show a => (Int,Int,Int) -> (Response a -> TestSession ()) -> Response a -> TestSession () 
expect t@(x,y,z) f r = case rspCode r == (x,y,z) of 
                    True -> f r
                    False -> throwError $ "Got response code: " ++ (show $ rspCode r) ++ " expected " ++ (show t) ++ ", body:\n " ++ (show $ rspBody r)

body :: (a -> Bool) -> Response a -> TestSession ()
body f r = guard (f (rspBody r))

ok :: Response a -> TestSession () 
ok x = return ()

defaultProgramState :: IO ProgramState 
defaultProgramState = do 
            ut <- newEmptyTMVarIO
            at <- newEmptyTMVarIO
            return $ PS {
                server = "95.170.67.60",
                sport = "9124",
                apptoken = at,
                usertoken = ut,
                devtoken = ""
             }

userTests :: TestSession a -> TestSession a 
userTests m = getUserToken >> m


defaultRequestState :: RequestState 
defaultRequestState = RS Nothing Nothing [] B.empty Nothing []

requestPossible :: TestSession Bool 
requestPossible = get >>= \s -> case s of 
                            RS (Just _) (Just _) _ _ (Just _) _ -> return True 
                            _ -> return False 

runUserTestSession :: TestSession a -> ProgramState -> IO (Either String a) 
runUserTestSession s ps = runTestSession (userTests s) ps 

runTestSession :: TestSession a -> ProgramState -> IO (Either String a)
runTestSession s ps = fmap fst <$> runErrorT (runReaderT (runStateT (runTS (initApp >> s)) defaultRequestState) ps)

runTest :: (Response B.ByteString -> TestSession ()) -> TestSession ()
runTest pd = do 
        e <- requestPossible 
        when (not e) $ throwError "Not ready for request yet"  
        sv <- asks server
        pt <- asks sport
        tn <- fromJust <$> gets testName 
        uri <- getUri 
        met <- fromJust <$> gets rsMethod 
        hdr <- gets rsHeaders 
        bdy <- gets rsBody 
        ut <- asks usertoken 
        at <- asks apptoken 
        cks <- (fmap) (mkHeader HdrCookie) $ liftIO . atomically $ do 
                    x <- readTMVar' ut 
                    y <- readTMVar' at 
                    return $ foldr catCookie "" ( x ++ y) 
        liftIO $ print $ "Running test: " ++ tn
        
        let req = Request { 
                rqMethod = met,
                rqBody = bdy,
                rqURI = uri,
                rqHeaders = (mkHeader HdrContentLength (show $ B.length bdy)) : (cks : hdr)
            }

        r <- liftIO $ simpleHTTP req 


        case r of 
            Left e -> throwError $ "Connection error" ++ (show e)
            Right xs -> xs `seq` pd xs

        liftIO $ print "Test ok"

        -- Resetting state  
        modify (const defaultRequestState)
    where catCookie :: String -> String -> String 
          catCookie xs z = z ++ (parseCookie xs)  ++ "; "

parseCookie :: String -> String  
parseCookie = fst . break (==';') 
getUri :: TestSession URI 
getUri = do 
    at <- asks apptoken 
    ut <- asks usertoken 
    x <- liftIO $ atomically $ do 
                p <- readTMVar' ut 
                f <- readTMVar' at 
                return (head $ p ++ [""], head $ f ++ [""])


            
    xs' <- gets rsParams
    let xs = [("user_token", fst x), ("application_token", snd x)] ++ xs'
    ts <- fromJust <$> gets rsUri 
    case (parseURI $ ts ++ "?" ++ foldr step "" xs) of 
        Just x ->  return x
        Nothing -> throwError "Uri not correct" 
 where step (x,y) z = x ++ "=" ++ y ++ "&" ++ z

writeJson :: [(String, String)] -> TestSession ()
writeJson xs = modify (\s ->  s { rsBody =  B.pack $ L.unpack $ encode (M.fromList xs) } )

writeBody :: B.ByteString -> TestSession ()
writeBody xs = modify (\s -> s { rsBody = xs })

test :: String -> TestSession () 
test x = modify (\s -> s { testName = Just x} )

readTMVar' :: TMVar a -> STM [a] 
readTMVar' x = do 
    b <- isEmptyTMVar x
    if b then return [] 
         else do 
            y <- readTMVar x
            return [y]

getUserToken :: TestSession () 
getUserToken = do 
    test "getUserToken" 
    resource "User" "login"
    setMethod POST 
    writeJson $ [
            ("email", "edgar.klerks@gmail.com"),
            ("password","wetwetwet")
        ]
    runTest $ \r -> do 
        let x' = fromJSON $ readJson (rspBody r) 
        case x' of 
            Error s -> error s 
            Success x' -> do 
                a <- asks usertoken 
                case M.lookup ("result" :: String) x' of 
                   Nothing -> error "NO user token"
                   Just x -> liftIO $ atomically $ void $ writeTMVar' a x

writeTMVar' :: TMVar a -> a -> STM ()
writeTMVar' x a = do 
            b <- isEmptyTMVar x
            if b then putTMVar x a
                 else void $ swapTMVar x a

getDevToken :: TestSession () 
getDevToken = do 
    test "getDevToken"
    resource "Application" "identify"
    setMethod POST
    d <- asks devtoken 
--    params [("token", "5IKRKNPBVQH2F3LHWHYZC4CCTOINU3GP5NEUPLQ=")]
--    params [("token", "JLQQT3OQAT2WBZNF6QAORQJRBMHUKN4MO5IHFFI=")]
--    params [("token", "LGJIVBTKDI7OPASCSHEVM5CGLQGNYFTTZJKIJLY=")]
    params [("token", d)]
    runTest $ \r -> do 
        
        let x' = fromJSON $ readJson (rspBody r)
        case x' of 
            Error s -> error s
            Success x' -> do 
            a <- asks apptoken
            case M.lookup ("result" :: String) x' of 
                    Nothing -> error "NO dev token"
                    Just x -> do 
                        liftIO $ print x
                        liftIO $ atomically $ void $ writeTMVar' a x


getCookie :: Show a => Response a -> TestSession String 
getCookie p = do 
            let (x,y,z) = rspCode p
            case x == 2 && y == 0 of  
                    True -> case findHeader HdrSetCookie p of 
                                Just x -> return x 
                                Nothing -> throwError "Couldn't find cookie"
                    False -> throwError $ "Problem with cookie retrieval\n"  ++ (show p) ++ (show $ rspBody p)


resource :: String -> String -> TestSession () 
resource x y = ask >>= \r -> setUri ("http://" ++ (server r) ++ ":" ++ (sport r) ++ "/" ++ x ++ "/" ++ y)

params :: [(String, String)] -> TestSession ()
params xs = let y = fmap (\(x,y) -> (escapeURIString esu x, escapeURIString esu y)) xs
            in modify (\s -> s { rsParams = y })
    where esu '=' = False 
          esu '?' = False 
          esu '/' = False 
          esu '.' = False 
          esu _  = True 
initApp :: TestSession ()
initApp = getDevToken  

setUri :: String -> TestSession () 
setUri s = modify $ \r -> r { rsUri = Just s }

setMethod :: RequestMethod -> TestSession  () 
setMethod r = modify (\s -> s { rsMethod = Just r}) 

getUnixTime :: MonadIO m =>  m Integer 
getUnixTime = liftIO $ do 
        x <- getPOSIXTime  
        return $ floor $ realToFrac x
readJson :: B.ByteString -> Value 
readJson x = case parse (value :: Parser Value) x of 
                AT.Done _ v -> v
                _ -> error "Not JSON"
withResult :: (Value -> TestSession ()) -> (Response B.ByteString -> TestSession ())
withResult f = f . readJson . rspBody
