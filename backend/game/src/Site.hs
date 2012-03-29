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
           let g = def :: G.Garage  
            -- save all  
           i <- runDb (save m <* save g)
           writeResult i
            


marketManufacturer :: Application ()
marketManufacturer = do 
       (l, o) <- getPages 
       xs <- runDb (search [] [] l o) :: Application [M.Manufacturer]
       writeMapables xs

marketModel :: Application ()
marketModel = ni 

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
         

-- | The main entry point handler.
site :: Application ()
site = route [ 
                ("/", index),
                ("/User/register", userRegister),
                ("/Market/manufacturer", marketManufacturer),
                ("/Market/model", marketModel),
                ("/Market/buy", marketBuy),
                ("/Market/sell", marketSell),
                ("/Market/return", marketReturn),
                ("/Garage/car", garageCar)
             ]
       <|> serveDirectory "resources/static"
