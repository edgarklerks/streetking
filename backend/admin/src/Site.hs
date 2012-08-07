{-# LANGUAGE OverloadedStrings, ViewPatterns, NoMonomorphismRestriction #-}

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
import           Snap.Util.FileServe
import           Text.Templating.Heist
import           SqlTransactionSnaplet hiding (runDb)
import qualified SqlTransactionSnaplet as S 
import qualified Model.Part as P 
import           Model.General 
import           Data.Monoid
import           Control.Monad.Trans 
import           Data.DatabaseTemplate


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
         , ("/car_model/get", getCarModel) 
         , ("/car_model/put", putCarModel)
         , ("/car_instance/get", getCarInstance)
         , ("/car_instance/put", putCarInstance)
         , ("/car_options/get", getCarOption)
         , ("/car_options/put", putCarOption)
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


getCarModel :: Application ()
getCarModel = do 
    (((l,o), xs),od) <- getPagesWithDTDOrdered [
                        "top_speed", "acceleration", "braking", 
                        "nos", "handling", "name", 
                        "id", "manufacturer_id", "braking",
                        "nos", "use_3d", "year",
                        "price" 
                        ] (
            "id" +== "id" +&& 
            "manufacturer_id" +== "manufacturer_id" +&& 
            "top_speed" +>= "top-speed-min" +&&
            "top_speed" +<= "top-speed-max" +&& 
            "acceleration" +>= "acceleration-min" +&&
            "acceleration" +<= "acceleration-max" +&& 
            "braking" +>= "braking-min" +&&
            "braking" +<= "braking-max" +&& 
            "nos" +>= "nos-min" +&&
            "nos" +<= "nos-max" +&& 
            "handling" +>= "handling-min" +&&
            "handling" +<= "handling-max" +&& 
            "name" +%% "name" +&& 
            "use_3d" +%% "name" +&& 
            "year" +>= "year-min" +&& 
            "year" +<= "year-max" +&& 
            "price" +>= "price-min" +&& 
            "price" +<= "price-max"
        )
    ns <- runDb $ search xs od l o :: Application [C.Car] 
    writeMapables ns


putCarModel :: Application ()
putCarModel = do 
    xs <- getJson 
    let p = updateHashMap xs (def :: C.Car)
    x <- runDb $ save p
    writeResult x 


getCarOption :: Application ()
getCarOption = do 
    (((l,o),xs),od) <- getPagesWithDTDOrdered ["id", "car_instance_id", "key", "value"] (
                    "id" +== "id" +&&
                    "car_instance_id" +== "car_instance_id" +&&
                    "key" +%% "key" +&& 
                    "value" +%% "value" 
            )
    ns <- runDb $ search xs od l o :: Application [CO.CarOptions]
    writeMapables ns 

putCarOption :: Application ()
putCarOption = do 
        xs <- getJson 
        let p = updateHashMap xs (def :: CO.CarOptions)
        x <- runDb $ save p
        writeResult x 

getCarInstance :: Application ()
getCarInstance = do 
        (((l,o),xs),od) <- getPagesWithDTDOrdered ["id", "car_instance_id", "key", "value"] (
            "id" +== "id" +&& 
            "car_id" +== "car_id" +&& 
            "garage" +== "garage" +&& 
            "deleted" +== "deleted" 
            )
        ns <- runDb $ search xs od l o :: Application [CI.CarInstance] 
        writeMapables ns 

putCarInstance :: Application ()
putCarInstance = do 
        xs <- getJson 
        let p = updateHashMap xs (def :: CI.CarInstance)
        x <- runDb $ save p 
        writeResult x 


