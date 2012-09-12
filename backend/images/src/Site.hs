{-# LANGUAGE OverloadedStrings, NoMonomorphismRestriction, DeriveDataTypeable, ImplicitParams #-}

------------------------------------------------------------------------------
-- | This module is where all the routes and handlers are defined for your
-- site. The 'app' function is the initializer that combines everything
-- together and is exported by this module.
module Site
  ( app
  ) where

------------------------------------------------------------------------------
import           Control.Applicative
import           Control.Monad hiding (when, forM_)
import           Data.ByteString (ByteString)
import           Data.Database hiding (sql, Delete)
import           Data.Maybe
import           Data.List (isPrefixOf) 
import           Data.Foldable 
import qualified Data.Text as T
import           Snap.Core
import           Snap.Snaplet
import           Snap.Snaplet.Heist
import           Snap.Util.FileServe
import           Text.Templating.Heist
import           ConfigSnaplet
import qualified Data.ByteString.Char8 as B
import qualified SqlTransactionSnaplet as S (runDb)
import          SqlTransactionSnaplet hiding (runDb)
import qualified ImageSnapLet as I (uploadImage, serveImage)
import           ImageSnapLet hiding (uploadImage, serveImage)
import          Control.Arrow hiding (app)
import          Data.Monoid 
import          Control.Monad.Trans
import          System.FilePath.Posix
import          System.Directory
import          Data.Typeable
import          Data.String 
import qualified Control.Monad.CatchIO as CIO
import qualified Model.Application as A
import           Control.Conditional
------------------------------------------------------------------------------
import           Application
import           Data.And 
import Model.General
import qualified SqlTransactionSnaplet as S
import Database.HDBC.SqlValue
import Prelude hiding (not, (&&),(||), foldr)
import Debug.Trace

import Data.Algebra.Boolean 

type Application = AppHandler

data UserException = UE String 
        deriving Typeable

instance Show (UserException) where 
    show (UE s) = s

instance CIO.Exception UserException 

genTable :: IO ()
genTable = let ops = [("&&", (&&)), ("||", (||)), ("xor", xor), ("-->", (-->)), ("<-->", (<-->))]
               mods = [("!", not), ("", id)]
               val = [("false", False), ("true", True)]
               b = [ str_mod ++ vl_str ++ " " ++ str_op ++ " " ++ str_mod2  ++ vl_str2 ++ " = " ++ (show $ mod vl `op` mod2 vl2)     | (str_op, op) <- ops, (str_mod, mod) <- mods, (str_mod2, mod2) <- mods, (vl_str, vl) <- val, (vl_str2, vl2) <- val ]
               expand n (' ':xs) = replicate (10 - n) ' '  ++ expand 0 xs  
               expand n (x:xs) = x : expand (n + 1) xs 
               expand _ [] = [] 
           in forM_ b (putStrLn . (expand 0))

internalError = CIO.throw . UE 

------------------------------------------------------------------------------
-- | Render login form
cons = liftIO . print 

handleUpload pred subpath = do 
                b <- pred  
                when (isNil b) $ internalError "Not allowed by predicate"
                let past x z = (x:z) 
                let fp_new b = foldr past [] b 
                let fp_new' = case fp_new b of 
                                    [x] -> x 
                                    (x:xs) -> foldl' (\z x -> z ++ "_" ++ x) x xs 

                with img $ I.uploadImage (\x -> cons "wop" *> internalError x) (\sd fp mt -> liftIO $ do 
                                                    print fp 
                                                    step sd fp (fp_new') subpath mt)
    where step sd fp fp_new sp mt | "image/png" `isPrefixOf` mt = renameFile fp (joinPath [sd, sp, addExtension fp_new ".png"])
                        | "image/jpg" `isPrefixOf` mt || "image/jpeg" `isPrefixOf` mt = liftIO (print $ "blub: " ++  joinPath [sd, sp, addExtension fp_new ".jpeg"]) *> renameFile fp (joinPath [sd, sp, addExtension fp_new ".jpeg"])
                        | otherwise = internalError ("not allowed by mimetype: " ++ mt)



serveImage = with img $ I.serveImage internalError $ do 
                image <- fromJust <$> getParam "image"
                dir <- fromJust <$> getParam "dir"  

                let b = joinPath [takeBaseName (B.unpack dir), addExtension (takeBaseName (B.unpack image)) (takeExtension $ B.unpack image)]
                liftIO (print b)
                return b 




getParamAnd c = do 
        car_id <- getParam c
        case car_id of 
            Nothing -> return Nil 
            Just a -> return (One $ B.unpack a)

carModel = getParamAnd "car_id"
partModel = getParamAnd "part_id"
fileName = getParamAnd "filename" 
carInstance = getParamAnd "car_instance_id"
partInstance = getParamAnd "part_instance_id"
userExist = getParamAnd "userid"
trackId = getParamAnd "track_id"




enroute x = do 
--         modifyRequest (setHeader "Content-Type" "application/x-www-form-urlencoded")
        g <- rqMethod <$> getRequest 
        case g of 
            OPTIONS -> allowAll 
            otherwise -> allowAll *> CIO.catch x (\(UE e) -> writeBS $ B.pack $  "{\"error\":\"" <> e <> "\"}")



------------------------------------------------------------------------------
-- | The application's routes.
routes :: [(ByteString, Handler App App ())]
routes = fmap (second enroute) $ [ 
           ("/upload/parts", handleUpload partModel  "parts")
         , ("/upload/car", handleUpload carModel "car")
         , ("/upload/dump", handleUpload fileName "dump")
         , ("/upload/track", handleUpload trackId "track")
         , ("/user/car", handleUpload ((<>) <$> userExist <*> carInstance) "user_car")
         , ("/user/parts", handleUpload ((<>) <$> userExist <*> partInstance) "user_parts")
         , ("/user/image", handleUpload (userExist) "user_image")
         , ("/crossdomain.xml", crossDomain)
         , ("/image/:dir/:image", serveImage) 
--          , ("/", internalError "not allowed top")
         ]
crossDomain :: Application()
crossDomain = do
    modifyResponse (addHeader "Content-Type" "text/xml")
    writeBS $ B.pack $ ("<?xml version=\"1.0\"?><cross-domain-policy><allow-access-from domain=\"*\"/></cross-domain-policy>" :: String)




------------------------------------------------------------------------------
-- | The application initializer.
-- app :: SnapletInit App App
app = makeSnaplet "app" "An snaplet example application." Nothing $ do
    h <- nestSnaplet "" heist $ heistInit "templates"

    -- NOTE: We're using initJsonFileAuthManager here because it's easy and
    -- doesn't require any kind of database server to run.  In practice,
    -- you'll probably want to change this to a more robust auth backend.
    c <- nestSnaplet "conf" config $ initConfig "resources/server.ini"
    db <- nestSnaplet "sql" sql $ initSqlTransactionSnaplet "resources/server.ini"
    img <- nestSnaplet "img" img $ initImage "resources/server.ini"
    addRoutes routes
    return $ App h c db img 


getOpParam s = do 
        x <- getParam s
        case x of 
            Nothing -> internalError ("parameter " ++ B.unpack s ++ " not in querystring") 
            Just a -> return a
 


allowAll = allowCredentials *> allowOrigin *> allowMethods *> allowHeaders
        
-- -Access-Control-Allow-Origin: * 

allowOrigin :: Application ()
allowOrigin = do 
            g <- getRequest
            modifyResponse (addHeader "Content-Type" "text/plain")
            modifyResponse (\x -> 
               case getHeader "Origin" g of 
                    Nothing -> traceShow x $ addHeader "Access-Control-Allow-Origin" "http://192.168.1.99" x
                    Just n -> traceShow n $  addHeader "Access-Control-Allow-Origin" n x
                )
-- Access-Control-Allow-Credentials: true  

allowCredentials :: Application () 
allowCredentials = modifyResponse (addHeader "Access-Control-Allow-Credentials" "true")

allowMethods :: Application () 
allowMethods = modifyResponse (addHeader "Access-Control-Allow-Methods" "POST, GET, OPTIONS, PUT")

allowHeaders :: Application () 
allowHeaders = modifyResponse (addHeader "Access-Control-Allow-Headers" "origin, content-type, accept, cookie");



           
