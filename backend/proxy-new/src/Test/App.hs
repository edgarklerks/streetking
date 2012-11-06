{-# LANGUAGE MultiParamTypeClasses, FlexibleInstances, ViewPatterns #-}
module Test.App (
  TestServer(..),
  TestMonad,
  runTests,
  run,
  initRequest,
  setMethod,
  setResource,
  setAction,
  setArguments,
  setQuery,
  modifyQuery, 
  setSucceed,
  modifyArguments,
  setName,
  TestConf(..),
  Method(..),
  Response(..),
  ResponseHeaders(..),
  decode,
  mkReport 
) where 


import Network.HTTP.Enumerator
import Network.HTTP.Types 
import Control.Applicative
import Control.Monad 
import Control.Monad.Writer 
import Control.Monad.Reader 
import Control.Monad.State 
import Control.Monad.Error 
import Data.Monoid
import Data.Maybe 
import Data.Aeson 
import qualified Data.HashMap.Strict as S 
import Control.Monad.Trans 
import qualified Data.ByteString.Lazy.Char8 as L 
import qualified Data.ByteString.Char8 as B 
import System.Console.ANSI

data TestConf = TC {
        name :: Maybe String, 
        action :: Maybe String,
        resource :: Maybe String, 
        method_ :: Maybe Method,
        succeed :: Bool,
        arguments :: [(String, String)],
        query :: [(String, String)]
    } deriving Show 

emptyConf = TC Nothing Nothing Nothing Nothing False [] [] 

data TestServer = TS {
        host_ :: String,
        port_ :: Int
    }

newtype TestMonad a = TM {
            unTM :: (TestServer,TestConf) -> IO (Either String a,TestConf,[TestConf])
        }


first3 f (a,b,c) = (f a, b,c)
second3 f (a,b,c) = (a, f b,c)
third3 f (a,b,c) = (a,b,f c)

fst3 (a,b,c) = a 
snd3 (a,b,c) = b 
thd3 (a,b,c) = c 

instance Functor TestMonad where 
        fmap f m = TM $ \r -> fmap (first3 (fmap f)) $ (unTM m) r

instance Applicative TestMonad where 
        pure a = TM $ \(r,s) -> return (Right a,s,mempty)
        (<*>) f m = TM $ \(r,s) -> do 
                                (f',s',w1) <- (unTM f) (r,s)
                                case f' of 
                                    Left e -> return (Left e, s', w1)
                                    Right f' -> do 
                                        (a',s'',w2) <- (unTM m) (r, s')
                                        case a' of 
                                            Left e -> return (Left e, s'', w1 <> w2)
                                            Right a' -> return (Right $ f' a', s'', w1 <> w2)

instance Monad TestMonad where 
        return = pure 
        (>>=) m f = TM $ \(r,s) -> do 
                                (a, s', w1) <- (unTM m) (r,s)
                                case a of 
                                    Left e -> return (Left e, s', w1)
                                    Right a -> do 
                                        (a',s'',w2) <- (unTM (f a)) (r,s')
                                        return (a',s'',w2)

instance MonadState TestConf TestMonad where 
        get = TM $ \(r,s) -> return (Right s,s,mempty)
        put a = TM $ \(r,_) -> return (Right (),a,mempty)
        state f = TM $ \(_,s) -> let (a,s') = f s  
                                 in return (Right a,s',mempty)

instance MonadReader TestServer TestMonad where 
        ask = TM $ \(r,s) -> return (Right r,s,mempty) 
        local f m = TM $ \(r,s) -> (unTM m) (f r, s)
        reader f = TM $ \(r,s) ->  return (Right $ f r, s, mempty) 

instance MonadIO TestMonad where 
        liftIO m = TM $ \(r,s) -> m >>= \x -> return (Right x, s, mempty)

instance MonadError String TestMonad where 
        throwError e = TM $ \(r,s) -> return (Left e, s, mempty)
        catchError m f = TM $ \(r,s) -> do 
                            (a,s',w) <- unTM m (r,s)
                            case a of 
                                Left e -> unTM (f e) (r,s) 
                                Right a -> return (Right a,s',w)

instance MonadWriter [TestConf] TestMonad where 
        writer (a,w) = TM $ \(r,s) -> return $ (Right a,s,w)  
        tell w = TM $ \(r,s) -> return $ (Right (),s,w)
        listen w = TM $ \(r,s) -> do 
                                (a,s',w) <- unTM w (r,s)
                                case a of 
                                    Left e -> return (Left e, s, w)
                                    Right a -> return (Right (a,w),s',w)
        pass m = TM $ \(r,s) -> do 
                            (b,s,w) <- unTM m (r,s)
                            case b of 
                                Left a -> return (Left a,s,w)
                                Right (a,f) -> return (Right a, s, f w)

initRequest :: (Response -> TestMonad ()) -> TestMonad ()
initRequest f = ready *> do 
        a <- gets action 
        n <- gets name 
        liftIO (putStrLn $ fromJust n)
        s <- gets resource 
        args <- gets arguments 
        q <- gets query 
        m <- gets method_ 
        u <- asks host_ 
        p <- asks port_ 
        let rs = (fromJust s) ++ "/" ++ (fromJust a)
        let req = def {
             method = fromJust m, 
             host = B.pack u,
             port = p, 
             path = B.pack rs,
             requestBody = RequestBodyLBS $ encode $ S.fromList args,
             queryString = mkQueryItem q
           } 
        rsp <- liftIO $ withManager $ \m -> httpLbs req m
        f rsp 
        storeResult 
 

-- httpLBS 
run :: (Response -> Bool) -> TestMonad () 
run f = ready *> do 
        a <- gets action 
        n <- gets name 
        liftIO (putStrLn $ fromJust n)
        s <- gets resource 
        args <- gets arguments 
        q <- gets query 
        m <- gets method_ 
        u <- asks host_ 
        p <- asks port_ 
        let rs = (fromJust s) ++ "/" ++ (fromJust a)
        let req = def {
             method = fromJust m, 
             host = B.pack u,
             port = p,
             path = B.pack rs,
             requestBody = RequestBodyLBS $ encode $ S.fromList args,
             queryString = mkQueryItem q
           } 
        rsp <- liftIO $ withManager $ \m -> httpLbs req m
        setSucceed (f rsp)
        storeResult 

mkQueryItem :: [(String, String)] -> Query 
mkQueryItem [] = [] 
mkQueryItem ((k,v):xs) = (B.pack k, Just $ B.pack v) : mkQueryItem xs  





   
setSucceed :: Bool -> TestMonad () 
setSucceed b = TM $ \(r,s) -> return (Right (), s { succeed = b}, mempty) 

ready :: TestMonad ()
ready = do 
    a <- gets action 
    when (isNothing a) $ throwError "no action specified"
    n <- gets name 
    when (isNothing n) $ throwError "no name specified"
    s <- gets resource
    when (isNothing s) $ throwError "no resource set"
    m <- gets method_ 
    when (isNothing m) $ throwError "no method specified"

setMethod :: String -> TestMonad ()
setMethod (B.pack -> m) = TM $ \(r,s) -> return (Right (), s { method_ = Just m }, mempty)

setArguments :: [(String, String)] -> TestMonad ()
setArguments f = modifyArguments (const f)

setQuery :: [(String, String)] -> TestMonad ()
setQuery xs = TM $ \(r,s) -> return (Right (), s { query = xs }, mempty)

modifyQuery :: ([(String, String)] -> [(String, String)]) -> TestMonad ()
modifyQuery f = TM $ \(r,s) -> return (Right (), s { query = f (query s) }, mempty)

modifyArguments :: ([(String, String)] -> [(String, String)]) -> TestMonad ()
modifyArguments f = TM $ \(r,s) -> return (Right (), s {arguments = f (arguments s)}, mempty) 

storeResult  :: TestMonad ()
storeResult = TM $ \(r,s) -> return (Right (), s {action = Nothing, name = Nothing, arguments = []}, [s]) 

setName :: String -> TestMonad ()
setName x = TM $ \(r,s) -> return (Right (), s { name = Just x}, mempty)

setResource :: String -> TestMonad ()
setResource x = TM $ \(r,s) -> return (Right (), s { resource = Just x}, mempty) 


setAction :: String -> TestMonad ()
setAction x = do 
        s <- gets action          
        when (isJust s) $ throwError "action cannot be set twice"
        TM $ \(r,s) -> return (Right (), s { action = Just x}, mempty)


runTests :: TestMonad () -> TestServer -> IO [TestConf]  
runTests m r = do (a,s,w) <- unTM m (r, emptyConf) 
                  case a of 
                    Left e -> error e  
                    Right a -> return w 


mkReport :: [TestConf] -> IO ()  
mkReport xs = clearScreen *> foldM_ step () xs 
    where step z (TC name action resource method succeed arguments query) =  
                next *> keyValue "name" (fromJust name) 
                     *> keyValue "action" (fromJust action)
                     *> keyValue "resource" (fromJust resource)
                     *> keyValue "method" (B.unpack $ fromJust method)
                     *> succeeds succeed
                     *> keyValue "arguments" (show arguments)
                     *> keyValue "query" (show query)
            

succeeds True = okColor *> keyValue "succeed" "True" <* normalColor 
succeeds False = errorColor *> keyValue "succeed" "False" <* normalColor 

rpad k = rpad' k (replicate 15 ' ')
    where rpad' (x:xs) (y:ys) = x : rpad' xs ys 
          rpad' [] ys = ys 
          rpad' xs [] = xs 
          rpad' [] [] = [] 

keyValue k v = putStrLn (rpad (k ++ ":") ++  v) 

next = putStrLn "-----------------------------------------------------------------"

okStr s = okColor *> putStrLn s <* normalColor  

errorStr s = errorColor *> putStrLn s <* normalColor  

errorColor = setSGR [SetColor Foreground Vivid Red]

okColor = setSGR [SetColor Foreground Vivid Green] 

normalColor = setSGR [SetColor Foreground Vivid White]
