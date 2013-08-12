{-# LANGUAGE OverloadedStrings, GeneralizedNewtypeDeriving, RankNTypes #-}
import qualified Data.ByteString.Lazy.Char8 as L
import qualified Data.ByteString.Char8 as B
import Data.String 
import Control.Applicative
import Control.Monad
import Test.App
import Data.List
import Control.Monad.Trans

remoteServer d = d { 
        server = "graf2.graffity.me", 
        sport = "9021",
        devtoken = "demodemodemo"
    }
 

main :: IO ()
main = do 
    d <- defaultProgramState 
    runUserTestSession allTests (remoteServer d)
    return ()

allTests = simpleTests 

simpleTests :: TestSession ()
simpleTests = do 

    test "/User/me - get data"
    resource "User" "me"
    setMethod GET 
    runTest $ ifresult ok

    test "/Market/parts - get data"
    resource "Market" "parts"
    setMethod POST 
    runTest $ ifresult ok

    test "/Market/manufacturer - get data"
    resource "Market" "manufacturer"
    setMethod POST 
    runTest $ ifresult ok

    test "/Market/model - get data"
    resource "Market" "model"
    setMethod POST 
    runTest $ ifresult ok 

    test "/Market/cars - get data"
    resource "Market" "cars"
    setMethod POST 
    runTest $(liftIO . print) 

    return ()


