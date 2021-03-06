{-# LANGUAGE OverloadedStrings, ViewPatterns, NoMonomorphismRestriction,FlexibleContexts #-}
{--
- Change log:
-   Edgar - added loadTemplate resource to server 
-
- -}
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
import           Snap.Snaplet.Heist as H
import           Snap.Snaplet.Session.Backends.CookieSession
import qualified Data.HashMap.Strict as S 
import qualified Control.Monad.CatchIO as CIO 
import qualified Model.Car as C 
import qualified Model.CarInstance as CI
import qualified Model.CarInGarage as CIG
import qualified Model.CarOptions as CO 
import qualified Model.Account as A
import qualified Model.PartModifier as PM 
import qualified Model.PartInstance as PI 
import qualified Model.PartInstance as PIn 
import qualified Model.CarInstanceParts as CIP
import qualified Model.Application as AP
import qualified Model.Challenge as CH
import qualified Model.ChallengeAccept as CHA 
import qualified Model.ChallengeType as CHT 
import qualified Model.Track as TR 
import qualified Model.TrackTime as TRM 
import qualified Model.Transaction as TS
import qualified Model.City as CIT 
import qualified Model.Country as CY 
import qualified Model.Continent as CON 
import qualified Model.Config as CO  
import qualified Model.Garage as G 
import qualified Model.GarageParts as GP
import qualified Model.Notification as NT 
import qualified Model.Personnel as P
import qualified Model.PersonnelInstance as PI
import qualified Model.ParameterTable as PT 
import qualified Model.Notification as NN 
import qualified Model.PartMarket as MP
import qualified Model.AccountGarage as AG 
import           Snap.Util.FileServe
import           SqlTransactionSnaplet hiding (runDb)
import qualified SqlTransactionSnaplet as S 
import qualified Model.Part as P 
import qualified Model.Part as PP 
import qualified Model.PartType as PT 
import qualified Model.RewardLog as RL 
import qualified Model.Rule as RULE
import qualified Model.Action as ACTION
import qualified Model.RuleReward as RW  
import qualified Model.Reward as REW 
import qualified Model.MenuModel as Menu

import           Model.General 
import           Data.Monoid
import           Control.Monad.Trans 
import           Data.DatabaseTemplate
import           Data.SearchBuilder  
import           Database.HDBC.PostgreSQL (Connection) 
import           Database.HDBC.SqlValue
import qualified Data.ModelToSVG as SB  
import           Data.ModelToSVG hiding (def, render, lines)
import           Data.InRules 
import qualified Model.Tournament as TRM 
import qualified Data.Tournament as TRM 
import qualified Model.TournamentType as TRMT
import           Data.Conversion 
import qualified Data.ByteString.Char8 as C 
import           System.Directory
import           System.FilePath.Posix


------------------------------------------------------------------------------
import           Application
import           Control.Arrow (second) 


------------------------------------------------------------------------------
-- | Render login form

------------------------------------------------------------------------------

visualPartModel = do 
            xs <- getJson 
            let c = updateHashMap xs (def :: P.Part) 
            case PP.id c of 
                Just a -> writeSVG =<< runDb (loadPartModel a)
                Nothing -> writeAeson $ S.fromList [("result" :: String, "" :: String)] 

visualCarInstance = do 
            xs <- getJson 
            let c = updateHashMap xs (def :: CI.CarInstance)
            case CI.id c of 
                Just a -> writeSVG =<< runDb (loadCarInstance a)
                Nothing -> writeAeson $ S.fromList [("result" :: String, "" :: String )] 


visualPartInstance = do 
            xs <- getJson 
            let c = updateHashMap xs (def :: PI.PartInstance)
            case PIn.id c of 
                Just a -> writeSVG =<< runDb (loadPartInstance a) 
                Nothing -> writeAeson $ S.fromList [("result" :: String, "" :: String)] 

writeSVG s = writeAeson $ S.fromList  [("result" :: String, unlines $ drop 4 $ lines $ SB.render s)]


------------------------------------------------------------------------------
-- | The application's routes.
routes :: [(ByteString, Handler App App ())]
routes = fmap (second enroute)  [ 
          ("/account_garage/get", getModel (def :: AG.AccountGarage))
         , ("/car_model/get", getModel (def :: C.Car)) 
         , ("/car_model/put", putModel (def :: C.Car))
         , ("/parameter/get", getModel (def :: PT.ParameterTable))
         , ("/parameter/put", putModel (def :: PT.ParameterTable))
         , ("/car_instance_parts/get", getModel (def :: CIP.CarInstanceParts))
         , ("/market_parts/get", getModel (def :: MP.PartMarket))
         , ("/car_in_garage/get", getModel (def :: CIG.CarInGarage))
         , ("/garage_part/get", getModel (def :: GP.GaragePart))
         , ("/car_instance/get", getModel (def :: CI.CarInstance))
         , ("/car_instance/put", putModel (def :: CI.CarInstance))
         , ("/car_instance/visual", visualCarInstance) 
         , ("/car_options/get", getModel (def :: CO.CarOptions))
         , ("/car_options/put", putModel (def :: CO.CarOptions))
         , ("/account/get", getModel (def :: A.Account)) 
         , ("/account/put", putModel (def :: A.Account))
         , ("/part_model/get", getModel (def :: P.Part))
         , ("/part_model/put", putModel (def :: P.Part))
         , ("/part_model/visual", visualPartModel)
         , ("/part_modifier/get", getModel (def :: PM.PartModifier))
         , ("/part_modifier/put", putModel (def :: PM.PartModifier))
         , ("/part_instance/get", getModel (def :: PI.PartInstance))
         , ("/part_instance/put", putModel (def :: PI.PartInstance))
--         , ("/part_instance/update", updateModel "id" (def :: PI.PartInstance))
         , ("/notification/put", putModel (def :: NN.Notification))
         , ("/notification/get", getModel (def :: NN.Notification))
         , ("/part_instance/visual", visualPartInstance) 
         , ("/country/get", getModel (def :: CY.Country))
         , ("/country/put", putModel (def :: CY.Country))

         , ("/city/get", getModel (def :: CIT.City))
         , ("/city/put", putModel (def :: CIT.City))
         , ("/continent/get", getModel (def :: CON.Continent))
         , ("/continent/put", putModel (def :: CON.Continent))
         , ("/garage/get", getModel (def :: G.Garage))
         , ("/garage/put", putModel (def :: G.Garage))
         , ("/config/get", getModel (def :: CO.Config))
         , ("/config/put", putModel (def :: CO.Config))
         , ("/transaction/get", getModel (def :: TS.Transaction))
--         , ("/transaction/put", putModel (def :: TS.Transaction))
         , ("/track/get", getModel (def :: TR.Track))
         , ("/track/put", putModel (def :: TR.Track))
         , ("/track_time/get", getModel (def :: TRM.TrackTime))
         , ("/track_time/put", putModel (def :: TRM.TrackTime))
         , ("/challenge/get", getModel (def :: CH.Challenge))
         , ("/challenge/put", putModel (def :: CH.Challenge))
         , ("/challenge_accept/get", getModel (def :: CHA.ChallengeAccept))
         , ("/challenge_accept/put", putModel (def :: CHA.ChallengeAccept))
         , ("/challenge_type/get", getModel (def :: CHT.ChallengeType))
         , ("/challenge_type/put", putModel (def :: CHT.ChallengeType))
         , ("/personnel/get", getModel (def :: P.Personnel))
         , ("/personnel/put", putModel (def :: P.Personnel))
         , ("/personnel_instance/get", getModel (def :: PI.PersonnelInstance))
         , ("/personnel_instance/put", putModel (def :: PI.PersonnelInstance))
         , ("/part_type/get", getModel (def :: PT.PartType))
         , ("/part_type/put", putModel (def :: PT.PartType))
         , ("/tournament_type/get", getModel (def ::  TRMT.TournamentType))
         , ("/tournament_type/put", putModel (def :: TRMT.TournamentType))

         , ("/tournament/get", getModel (def :: TRM.Tournament))
         , ("/tournament/put", putTournament)
         , ("/notification/get", getModel (def :: NT.Notification))
         , ("/notification/put", putModel (def :: NT.Notification))
         , ("/reward/get", getModel (def :: REW.Reward))
         , ("/reward/put", putModel (def :: REW.Reward))
         , ("/action/get", getModel (def :: ACTION.Action))
         , ("/action/put", putModel (def :: ACTION.Action))
         , ("/rule/get", getModel (def :: RULE.Rule))
         , ("/rule/put", putModel (def :: RULE.Rule))
         , ("/reward_log/get", getModel (def :: RL.RewardLog))
         , ("/Game/template", loadTemplate)
         , ("/game/menu/get", getModel (def :: Menu.MenuModel))
         , ("/game/menu/put", putModel(def :: Menu.MenuModel))
         , ("",          serveDirectory "static")
         ]


loadTemplate :: Application ()
loadTemplate = do 
        name <- getOParam "name"
        let pth =  "resources/static/" ++ C.unpack name ++ ".tpl"
        let dirs = splitDirectories pth
        if ".." `elem` dirs 
            then internalError "hi my friend, we are using snap 0.9 "
            else serveFileAs "text/plain" pth





------------------------------------------------------------------------------
-- | The application initializer.
app :: SnapletInit App App
app = makeSnaplet "app" "An snaplet example application." Nothing $ do
    s <- nestSnaplet "sess" sess $
           initCookieSessionManager "site_key.txt" "sess" (Just 3600)

    -- NOTE: We're using initJsonFileAuthManager here because it's easy and
    -- doesn't require any kind of database server to run.  In practice,
    -- you'll probably want to change this to a more robust auth backend.
    a <- nestSnaplet "auth" auth $
           initJsonFileAuthManager defAuthSettings sess "users.json"
    db <- nestSnaplet "sql" sql $ initSqlTransactionSnaplet "resources/server.ini"
    addRoutes routes
    return $ App s a db


putTournament :: Application () 
putTournament = do 
            xs <- getJson 
            let p = updateHashMap xs def 
            x <- runDb $ TRM.createTournament p  
            writeResult x
-- for part_instance 

getModel :: (Database Connection a, Mapable a) => a -> Application ()
putModel :: (Mapable a, Database Connection a) => a -> Application ()
-- updateModel :: (Mapable a, Database Connection a) => a -> Application () 
getModel a = sgets 
        where sgets = do 
                  let (dtd, so) = build defaultBehaviours a  defaultExceptions  
                  (((l,o),xs),od) <- getPagesWithDTDOrdered so dtd 
                  ns <- runDb $ search xs od l o 
                  writeMapables (ns `asTypeOf` ([a]))


putModel a = sputs 
    where sputs = do 
                xs <- getJson 
                let p = updateHashMap xs a
                x <- runDb $ save p
                writeResult x 


updateModel k a = sputs 
    where sputs = do 
            xs <- getJson 
            let v = (S.!) xs k 
            s <- runDb $ do 
                ps <- fromJust <$> load (fromSql v)  
                let ts = toHashMap (ps `asTypeOf` a)
                save (fromInRule (toInRule $ ts `S.union` xs ) `asTypeOf` a)
            writeResult s





enroute x = do 
        g <- rqMethod <$> getRequest 
        case g of 
            OPTIONS -> allowAll 
            otherwise -> allowAll *> CIO.catch x (\(UserErrorE e) -> writeBS $ "{\"error\":\"" <> e <> "\"}")




                    

allowAll = allowCredentials *> allowOrigin *> allowMethods *> allowHeaders
        
-- -Access-Control-Allow-Origin: * 

allowOrigin :: Application ()
allowOrigin = do 
            g <- getRequest
            modifyResponse (addHeader "Content-Type" "text/plain")
            modifyResponse (\x -> 
               case getHeader "Origin" g <|> getHeader "Referer" g of 
                    Nothing -> addHeader "Access-Control-Allow-Origin" "*" x
                    Just n -> addHeader "Access-Control-Allow-Origin" n x
                )
-- Access-Control-Allow-Credentials: true  

allowCredentials :: Application () 
allowCredentials = modifyResponse (addHeader "Access-Control-Allow-Credentials" "true")

allowMethods :: Application ()
allowMethods = modifyResponse (addHeader "Access-Control-Allow-Methods" "POST, GET, OPTIONS, PUT")

allowHeaders :: Application ()
allowHeaders = modifyResponse (addHeader "Access-Control-Allow-Headers" "origin, content-type, accept, cookie");


