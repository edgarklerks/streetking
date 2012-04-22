{-# LANGUAGE OverloadedStrings, RankNTypes #-}
{-|

This is where all the routes and handlers are defined for your site. The
'site' function combines everything together and is exported by this module.

-}

module Site
  ( site
  ) where

import           Control.Applicative
import           Data.Monoid
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
import qualified Data.Aeson as AS 
import qualified Model.Account as A 
import qualified Model.AccountProfile as AP 
import qualified Model.MenuModel as MM 
import qualified Data.Tree as T
import qualified Data.MenuTree as MM 
import qualified Model.Garage as G 
import qualified Model.Manufacturer as M 
import qualified Model.Car as Car 
import qualified Model.CarInstance as CarInstance 
import qualified Model.CarInGarage as CIG 
import qualified Model.Car3dModel as C3D
import qualified Model.Part as Part 
import qualified Model.PartMarket as PM 
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
import           GHC.Exception (SomeException)

import qualified Control.Monad.CatchIO as CIO
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

salt = "blalalqa"

userRegister :: Application () 
userRegister = do 
           x <- getJson >>= scheck ["email", "password", "nickname"] 
           scfilter x [("email", email), ("password", minl 6), ("nickname", minl 3 `andcf` maxl 16)]
           let m = updateHashMap x (def :: A.Account)
           let c = m { A.password = H.b32TigerHash (H.tigerHash $ C.pack (A.password m) `mappend` salt) }
           let g = def :: G.Garage  

            -- save all  
           i <- runDb  $ do 
                uid <- save c 
                g <- save (g { G.account_id = uid })
                return uid
           writeResult i

userLogin :: Application ()
userLogin = do 
    x <- getJson >>= scheck ["email", "password"] 
    let m = updateHashMap x (def :: A.Account)
    u <- runDb (search ["email" |== toSql (A.email m)] [] 1 0) :: Application [A.Account]
    when (null u) $ internalError "Username or password is wrong, please try it again"
    let user = head u
    if ((H.b32TigerHash . H.tigerHash) (C.pack ( A.password m) `mappend` salt) == A.password user)
        then do 
            k <- getUniqueKey 
            addRole (convert $ A.id user) k 
            n <- runDb (load $ convert $ A.id user) :: Application (Maybe AP.AccountProfile)
            writeResult k
        else do 
            internalError "Username or password is wrong, please try it again"
            
     
userData :: Application ()
userData = do 
    x <- getOParam "user_id"
    n <- runDb (load $ convert x) :: Application (Maybe AP.AccountProfile)
    case n of 
        Nothing -> internalError "No such user"
        Just x -> writeMapable x

userMe :: Application ()
userMe = do 
    x <- getUserId 
    n <- runDb (load x) :: Application (Maybe AP.AccountProfile)
    case n of 
        Nothing -> internalError "You do not exist, kbye"
        Just x -> writeMapable x

loadMenu :: Application ()
loadMenu = do 
    mt <- getOParam "tree_type"
    n <- runDb (search ["menu_type" |== (toSql mt) ] [Order ("number", []) True] 100000 0) :: Application [MM.MenuModel] 
    writeResult  (AS.toJSON (MM.fromFlat (convert n :: MM.FlatTree)))

{-- 
 - {
 -  manufacturer_id: 2,
 -  car_model_id: 3
 -
 -
 --}
    
marketManufacturer :: Application ()
marketManufacturer = do 
       (l, o) <- getPages 
       xs <- runDb (search [] [] l o) :: Application [M.Manufacturer]
       writeMapables xs

marketModel :: Application ()
marketModel = do 
      ((l,o),xs) <-  getPagesWithDTD ("manufacturer_id" +== "manufacturer_id")
      ns <- runDb (search xs [] l o) :: Application [PM.PartMarket]
      writeMapables ns

marketBuy :: Application ()
marketBuy = ni 

marketSell :: Application ()
marketSell = ni

marketReturn :: Application ()
marketReturn = ni

marketParts :: Application ()
marketParts = do 
   uid <- getUserId
   ((l, o), xs) <- getPagesWithDTD ("manufacturer_id" +== "manufacturer_id" +&& "car_id" +== "car_id" +&& "level" +== "level" +&& "name" +== "part_type")
   ns <- runDb (search (("uid" |== toSql uid):xs) [] l o) :: Application [PM.PartMarket]
   writeMapables ns

garageCar :: Application ()
garageCar = do 
        (l,o) <- getPages  
        uid <- getUserId 
        ps <- runDb $ search ["id" |== (toSql uid)] [] l o :: Application [CIG.CarInGarage]
        writeMapables ps

loadModel :: Application ()
loadModel = do 
        idp <- getOParam "car_id"
        ns <- (runDb $ load $ convert idp) :: Application (Maybe C3D.Car3dModel)
        case ns of 
            Nothing -> internalError "No such car"
            Just x -> writeMapable x

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
site = CIO.catch (CIO.catch (route [ 
                ("/", index),
                ("/User/login", userLogin),
                ("/User/register", userRegister),
                ("/User/data", userData),
                ("/User/me", userMe),
                ("/Market/manufacturer", marketManufacturer),
                ("/Market/model", marketModel),
                ("/Market/buy", marketBuy),
                ("/Market/sell", marketSell),
                ("/Market/return", marketReturn),
                ("/Market/parts", marketParts),
                ("/Garage/car", garageCar),
                ("/Car/model", loadModel),
                ("/Game/template", loadTemplate),
                ("/Game/tree", loadMenu)
             ]
       <|> serveDirectory "resources/static") (\(UserErrorE s) -> writeError s)) (\(e :: SomeException) -> writeError (show e))
