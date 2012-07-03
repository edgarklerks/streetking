{-# LANGUAGE OverloadedStrings, NoMonomorphismRestriction, DeriveDataTypeable #-}

------------------------------------------------------------------------------
-- | This module is where all the routes and handlers are defined for your
-- site. The 'app' function is the initializer that combines everything
-- together and is exported by this module.
module Site
  ( app
  ) where

------------------------------------------------------------------------------
import           Control.Applicative
import           Data.ByteString (ByteString)
import           Data.Maybe
import qualified Data.Text as T
import           Snap.Core
import           Snap.Snaplet
import           Snap.Snaplet.Auth
import           Snap.Snaplet.Auth.Backends.JsonFile
import           Snap.Snaplet.Heist
import           Snap.Snaplet.Session.Backends.CookieSession
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
------------------------------------------------------------------------------
import           Application


data UserException = UE String 
        deriving Typeable

instance Show (UserException) where 
    show (UE s) = s

instance CIO.Exception UserException 

internalError = terminateConnection . UE 

------------------------------------------------------------------------------
-- | Render login form
handleLogin :: Maybe T.Text -> Handler App (AuthManager App) ()
handleLogin authError = heistLocal (bindSplices errs) $ render "login"
  where
    errs = [("loginError", textSplice c) | c <- maybeToList authError]


------------------------------------------------------------------------------
-- | Handle login submit
handleLoginSubmit :: Handler App (AuthManager App) ()
handleLoginSubmit =
    loginUser "login" "password" Nothing
              (\_ -> handleLogin err) (redirect "/")
  where
    err = Just "Unknown user or password"


------------------------------------------------------------------------------
-- | Logs out and redirects the user to the site index.
handleLogout :: Handler App (AuthManager App) ()
handleLogout = logout >> redirect "/"

handleUpload = do 
            x <- with img $ I.uploadImage internalError (\sd fp mt -> liftIO $ step sd fp mt)
            return x
    where step sd fp mt  =  case mt of 
            "image/png" -> renameFile fp (joinPath [sd, addExtension (takeBaseName fp) ".png"])
            "image/jpg" -> renameFile fp (joinPath [sd,addExtension (takeBaseName fp) ".jpg"])
            "image/jpeg" -> renameFile fp (joinPath [sd, addExtension (takeBaseName fp) ".jpeg"])


serveImage = with img $ I.serveImage internalError $ do 
                x <- getParam "id"
                case x of 
                    Nothing -> internalError "no id specified"
                    Just a -> return (B.unpack a)

showConfig :: Handler App App ()
showConfig = do x <- with config $ lookupVal "test" "test" 
                runDb (return ())
                writeText (T.pack $ show x)

------------------------------------------------------------------------------
-- | Handle new user form submit
handleNewUser :: Handler App (AuthManager App) ()
handleNewUser = method GET handleForm <|> method POST handleFormSubmit
  where
    handleForm = render "new_user"
    handleFormSubmit = registerUser "login" "password" >> redirect "/"


------------------------------------------------------------------------------
-- | The application's routes.
routes :: [(ByteString, Handler App App ())]
routes = [ ("/login",    with auth handleLoginSubmit)
         , ("/logout",   with auth handleLogout)
         , ("/new_user", with auth handleNewUser)
         , ("/test", showConfig)
         , ("",          serveDirectory "static")
         , ("/upload", handleUpload)
         , ("/show", serveImage) 
         ]


------------------------------------------------------------------------------
-- | The application initializer.
-- app :: SnapletInit App App
app = makeSnaplet "app" "An snaplet example application." Nothing $ do
    h <- nestSnaplet "" heist $ heistInit "templates"
    s <- nestSnaplet "sess" sess $
           initCookieSessionManager "site_key.txt" "sess" (Just 3600)

    -- NOTE: We're using initJsonFileAuthManager here because it's easy and
    -- doesn't require any kind of database server to run.  In practice,
    -- you'll probably want to change this to a more robust auth backend.
    a <- nestSnaplet "auth" auth $
           initJsonFileAuthManager defAuthSettings sess "users.json"
    c <- nestSnaplet "conf" config $ do 
            initConfig "resources/server.ini"
    db <- nestSnaplet "sql" sql $ initSqlTransactionSnaplet "resources/server.ini"
    img <- nestSnaplet "img" img $ initImage "resources/server.ini"
    addRoutes routes
    addAuthSplices auth
    return $ App h s a c db img 


    
runDb x = with' sqlLens $ S.runDb internalError  x
