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
import           Control.Monad
import           Data.ByteString (ByteString)
import           Data.Database hiding (sql, Delete)
import           Data.Maybe
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
import          Control.Monad.Trans
import          System.FilePath.Posix
import          System.Directory
import          Data.Typeable
import qualified Control.Monad.CatchIO as CIO
import qualified Model.Application as A
------------------------------------------------------------------------------
import           Application
import Model.General
import qualified SqlTransactionSnaplet as S
import Database.HDBC.SqlValue


data UserException = UE String 
        deriving Typeable

instance Show (UserException) where 
    show (UE s) = s

instance CIO.Exception UserException 

internalError = terminateConnection . UE 

------------------------------------------------------------------------------
-- | Render login form


handleUpload pred subpath = do 
                b <- pred undefined  
                when (not b) $ internalError "Not allowed"
                with img $ I.uploadImage internalError (\sd fp mt -> liftIO $ step sd (joinPath [fp,subpath]) mt)
    where step sd fp mt  =  case mt of 
            "image/png" -> renameFile fp (joinPath [sd, addExtension (takeBaseName fp) ".png"])
            "image/jpg" -> renameFile fp (joinPath [sd,addExtension (takeBaseName fp) ".jpg"])
            "image/jpeg" -> renameFile fp (joinPath [sd, addExtension (takeBaseName fp) ".jpeg"])
            otherwise -> internalError "not allowed"



serveImage = with img $ I.serveImage internalError $ do 
                image <- fromJust $ getParam "image"
                dir <- fromJust $ getParam "dir"  
                case x of 
                    Nothing -> internalError "no id specified"
                    Just a -> return (B.unpack a)


{-- routes  --}

constM :: Monad m => a -> b -> m a  
constM a _ = return a 
------------------------------------------------------------------------------
-- | The application's routes.
routes :: [(ByteString, Handler App App ())]
routes = let ?proxyTransform = id in [ 
           ("/upload/parts", handleUpload (constM True) "parts")
         , ("/upload/car", handleUpload (constM True) "car")
         , ("/upload/dump", handleUpload (constM True) "dump")
         , ("/user/car", handleUpload (constM True) "user_car")
         , ("/user/parts", handleUpload (constM True) "user_parts")
         , ("/user/image", handleUpload (constM True) "user_image")
         , ("/image/:dir/:image", serveImage) 
         , ("/", internalError "not allowed")
         ]


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
            
