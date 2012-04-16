{-# LANGUAGE OverloadedStrings #-}
{-|

This is where all the routes and handlers are defined for your site. The
'site' function combines everything together and is exported by this module.

-}

module Site
  ( site
  ) where

import           Control.Applicative
import           Control.Monad
import           Data.Maybe
import           Data.SqlTransaction
import           Data.Database
import           Data.DatabaseTemplate
import           Database.HDBC (toSql, fromSql)
import qualified Data.ByteString.Char8 as C
import qualified Data.Text.Encoding as T
import           Snap.Util.FileServe
import           Snap.Types
import qualified Model.Account as A 
import qualified Model.Garage as G 
import qualified Model.Manufacturer as M 
import qualified Model.Car as Car 
import qualified Model.CarInstance as CarInstance 
import qualified Model.CarInGarage as CIG 
import           Application
import           Model.General (Mapable(..), Default(..), Database(..))
import           Data.Convertible

import qualified Data.Digest.TigerHash as H
import qualified Data.Digest.TigerHash.ByteString as H
import           Data.Conversion
import           Data.InRules
import           Data.Tools
import           System.FilePath.Posix
import           Data.String

------------------------------------------------------------------------------
-- | Renders the front page of the sample site.
--
-- The 'ifTop' is required to limit this to the top of a route.
-- Otherwise, the way the route table is currently set up, this action
-- would be given every request.
--

type STQ a = SqlTransaction Connection a

index :: Application ()
index = ifTop $ writeBS "go rape yourself" 
  where

ni :: forall t. t
ni = error "Not implemented"

userRegister :: Application () 
userRegister = do 
           x <- getJson  
           let m = updateHashMap x (def :: A.Account)
           let c = m { A.password = H.b32TigerHash (H.tigerHash $ C.pack (A.password m)) }
           let g = def :: G.Garage  

            -- save all  
           i <- runDb (save c <* save g)
           writeResult i

userLogin :: Application ()
userLogin = do 
    x <- getJson 
    let m = updateHashMap x (def :: A.Account)
    u <- runDb (search ["email" |== toSql (A.email m)] [] 1 0) :: Application [A.Account]
    when (null u) $ internalError "No such user"
    let user = head u
    if ((H.b32TigerHash . H.tigerHash) (C.pack $ A.password m) == A.password user)
        then do 
            k <- getUniqueKey 
            addRole (convert $ A.id user) k 
            writeResult (A.id user)
        else do 
            internalError "Go rape yourself. Tnxbye"
     

marketManufacturer :: Application ()
marketManufacturer = do 
       (l, o) <- getPages 
       xs <- runDb (search [] [] l o) :: Application [M.Manufacturer]
       writeMapables xs

marketModel :: Application ()
marketModel = do 
      ((l,o),xs) <-  getPagesWithDTD ("manufacturer_id" +== "manufacturer_id")
      ns <- runDb (search xs [] l o) :: Application [Car.Car]
      writeMapables ns

marketBuy :: Application ()
marketBuy = ni 

marketSell :: Application ()
marketSell = ni

marketReturn :: Application ()
marketReturn = ni

garageCar :: Application ()
garageCar = do 
        (l,o) <- getPages  
        uid <- getUserId 
        ps <- runDb $ search ["id" |== (toSql uid)] [] l o :: Application [CIG.CarInGarage]
        writeMapables ps
loadModel :: Application ()
loadModel = do 
        model_name <- getOParam "car_id"
        ns <- (runDb $ load  $ convert model_name) :: Application (Maybe Car.Car)
        case ns of 
            Nothing -> internalError "No such car"
            Just x -> do 
                return undefined 

loadTemplate :: Application ()
loadTemplate = do 
        name <- getOParam "name"
        let pth =  ("resources/static/" ++ C.unpack name ++ ".tpl")
        let dirs = splitDirectories pth
        if ".." `elem` dirs 
            then internalError "do not hacked server"
            else serveFileAs "text/plain" pth

-- | The main entry point handler.
site :: Application ()
site = route [ 
                ("/", index),
                ("/User/login", userLogin),
                ("/User/register", userRegister),
                ("/Market/manufacturer", marketManufacturer),
                ("/Market/model", marketModel),
                ("/Market/buy", marketBuy),
                ("/Market/sell", marketSell),
                ("/Market/return", marketReturn),
                ("/Garage/car", garageCar),
                ("/Car/model", loadModel),
                ("/Game/template", loadTemplate)
             ]
       <|> serveDirectory "resources/static"
