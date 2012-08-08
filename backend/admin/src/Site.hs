{-# LANGUAGE OverloadedStrings, ViewPatterns, NoMonomorphismRestriction,FlexibleContexts #-}

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
import           Data.Text (Text)
import           Snap.Core
import           Snap.Snaplet
import           Snap.Snaplet.Auth hiding (save)
import           Snap.Snaplet.Auth.Backends.JsonFile
import           Snap.Snaplet.Heist
import           Snap.Snaplet.Session.Backends.CookieSession
import qualified Model.Car as C 
import qualified Model.CarInstance as CI
import qualified Model.CarOptions as CO 
import qualified Model.Account as A
import qualified Model.PartModifier as PM 
import qualified Model.PartInstance as PI 
import           Snap.Util.FileServe
import           Text.Templating.Heist
import           SqlTransactionSnaplet hiding (runDb)
import qualified SqlTransactionSnaplet as S 
import qualified Model.Part as P 
import           Model.General 
import           Data.Monoid
import           Control.Monad.Trans 
import           Data.DatabaseTemplate
import           Data.SearchBuilder 
import           Database.HDBC.PostgreSQL (Connection) 


------------------------------------------------------------------------------
import           Application


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
         , ("/car_model/get", getModel (def :: C.Car)) 
         , ("/car_model/put", putModel (def :: C.Car))
         , ("/car_instance/get", getModel (def :: CI.CarInstance))
         , ("/car_instance/put", putModel (def :: CI.CarInstance))
         , ("/car_options/get", getModel (def :: CO.CarOptions))
         , ("/car_options/put", putModel (def :: CO.CarOptions))
         , ("/account/get", getModel (def :: A.Account)) 
         , ("/account/put", putModel (def :: A.Account))
         , ("/part_modifier/get", getModel (def :: PM.PartModifier))
         , ("/part_modifier/put", putModel (def :: PM.PartModifier))
         , ("/part_instance/get", getModel (def :: PI.PartInstance))
         , ("/part_instance/put", putModel (def :: PI.PartInstance))
         , ("",          serveDirectory "static")
         ]






------------------------------------------------------------------------------
-- | The application initializer.
app :: SnapletInit App App
app = makeSnaplet "app" "An snaplet example application." Nothing $ do
    h <- nestSnaplet "" heist $ heistInit "templates"
    s <- nestSnaplet "sess" sess $
           initCookieSessionManager "site_key.txt" "sess" (Just 3600)

    -- NOTE: We're using initJsonFileAuthManager here because it's easy and
    -- doesn't require any kind of database server to run.  In practice,
    -- you'll probably want to change this to a more robust auth backend.
    a <- nestSnaplet "auth" auth $
           initJsonFileAuthManager defAuthSettings sess "users.json"
    db <- nestSnaplet "sql" sql $ initSqlTransactionSnaplet "resources/server.ini"
    addRoutes routes
    addAuthSplices auth
    return $ App h s a db


getModel :: (Database Connection a) => a -> Application ()
putModel :: (Mapable a, Database Connection a) => a -> Application ()
getModel a = sgets 
        where sgets = do 
                  let (dtd, so) = build defaultBehaviours a  [] 
                  (((l,o),xs),od) <- getPagesWithDTDOrdered so dtd 
                  ns <- runDb $ search xs od l o :: Application [C.Car] 
                  writeMapables ns
putModel a = sputs 
    where sputs = do 
                xs <- getJson 
                let p = updateHashMap xs a
                x <- runDb $ save p
                writeResult x 







                    

                  
