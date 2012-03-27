{-# LANGUAGE OverloadedStrings #-}
{-|

This is where all the routes and handlers are defined for your site. The
'site' function combines everything together and is exported by this module.

-}

module Site
  ( site
  ) where

import           Control.Applicative
import           Data.Maybe
import qualified Data.ByteString.Char8 as C
import qualified Data.Text.Encoding as T
import           Snap.Extension.Heist
import           Snap.Extension.Timer
import           Snap.Util.FileServe
import           Snap.Types
import           Text.Templating.Heist
import qualified Model.Account as as A 

import           Application


------------------------------------------------------------------------------
-- | Renders the front page of the sample site.
--
-- The 'ifTop' is required to limit this to the top of a route.
-- Otherwise, the way the route table is currently set up, this action
-- would be given every request.
index :: Application ()
index = ifTop $ writeBS "go rape yourself" 
  where

ni = error "Not implemented"

userRegister :: Application () 
userRegister = do 
            


marketManufacturer :: Application ()
marketManufacturer = ni 

marketModel :: Application ()
marketModel = ni

marketBuy :: Application ()
marketBuy = ni 

marketSell :: Application ()
marketSell = ni

marketReturn :: Application ()
marketReturn = ni

garageCar :: Application ()
garageCar = ni 

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
