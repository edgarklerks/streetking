{-# LANGUAGE OverloadedStrings, FlexibleContexts, RankNTypes, ScopedTypeVariables, ViewPatterns #-}
------------------------------------------------------------------------------
--
-- | This module is where all the routes and handlers are defined for your
-- site. The 'app' function is the initializer that combines everything
-- together and is exported by this module.
module Site
  ( Site.app
  ) where

------------------------------------------------------------------------------
import           Control.Applicative
import           Data.Monoid
import           Control.Monad
import           Data.Maybe
import qualified Data.List as List
import           Data.SqlTransaction
import           Data.Database
import           Data.DatabaseTemplate
import           Database.HDBC (toSql, fromSql)
import qualified Data.ByteString.Char8 as C
import qualified Data.ByteString.Lazy as LB
import qualified Data.ByteString.Lazy.Char8 as LBC
import qualified Data.Text.Encoding as T
import qualified Data.Text as T 
import           Snap.Util.FileServe
import           Snap.Util.FileUploads
import           Snap.Core
import qualified Data.Aeson as AS 
import qualified Model.Account as A 
import qualified Model.AccountProfile as AP 
import qualified Model.AccountProfileMin as APM
import qualified Model.MenuModel as MM 
import qualified Data.Tree as T
import qualified Data.MenuTree as MM 
import qualified Model.Garage as G 
import qualified Model.Continent as Cont 
import qualified Model.City as City
import qualified Model.TrackDetails as TD
import qualified Model.TrackMaster as TT
import qualified Model.TrackCity as TCY
import qualified Model.TrackContinent as TCN
import qualified Model.TrackTime as TTM
import qualified Model.Manufacturer as M 
import qualified Model.Car as Car 
import qualified Model.CarInstance as CarInstance 
import qualified Model.CarInGarage as CIG 
import qualified Model.CarMinimal as CMI 
import qualified Model.Car3dModel as C3D
import qualified Model.Part as Part 
import qualified Model.PartMarket as PM 
import qualified Model.PartInstance as PI 
import qualified Model.PartDetails as PD 
import qualified Model.CarMarket as CM 
import qualified Model.ManufacturerMarket as MAM 
import qualified Model.MarketItem as MI 
import qualified Model.Transaction as Transaction
import           Model.Transaction (transactionMoney)
import qualified Model.Escrow as Escrow
import qualified Model.MarketPartType as MPT
import qualified Model.GarageParts as GPT 
import qualified Model.Config as CFG 
import qualified Model.MarketPlace as MP
import qualified Model.PartType as PT 
import qualified Model.CarInstanceParts as CIP
import qualified Model.CarOptions as CO
import qualified Model.CarOptionsExtended as COE
import qualified Model.CarOwners as COW
import qualified Model.MarketCarInstanceParts as MCIP
import qualified Model.CarStockParts as CSP
import qualified Model.MarketPlaceCar as MPC
import qualified Model.Personnel as PL
import qualified Model.PersonnelDetails as PLD
import qualified Model.PersonnelInstance as PLI
import qualified Model.PersonnelInstanceDetails as PLID
import qualified Model.PersonnelTaskType as PTT 
import qualified Model.Challenge as Chg
import qualified Model.ChallengeAccept as ChgA
import qualified Model.ChallengeType as ChgT
import qualified Model.ChallengeExtended as ChgE
import qualified Model.Report as RP 
import qualified Model.Race as R
import qualified Model.RaceDetails as RAD
import qualified Model.RaceReward as RWD
import qualified Model.TournamentPlayers as TP 
import qualified Model.Tournament as TR 
import qualified Model.Tournament as TRM 
import qualified Model.TournamentExtended as TRMEx
import qualified Model.TournamentResult as TMR 
import qualified Model.GeneralReport as GR 
import qualified Model.ShopReport as SR 
import qualified Model.GarageReport as GRP
import qualified Model.GarageReportInsert as GRPI
import qualified Model.PersonnelReport as PR 
import qualified Model.TravelReport as TR 
import qualified Model.Functions as DBF
import qualified Model.Support as SUP 
import qualified Model.TournamentReport as TRP 
import qualified Data.HashMap.Strict as HM
import           Control.Monad.Trans
import           Application
import           Model.General (Mapable(..), Default(..), Database(..), aload, adeny, aget, agetlist)
import           Data.Convertible
import           Data.Time.Clock 
import           Data.Time.Clock.POSIX
import qualified Data.Foldable as F
import           Data.Hstore

import           Data.Conversion
import qualified Data.InRules as IR
import           Data.Tools
import           System.FilePath.Posix
import           System.Directory
import           Data.String
import           GHC.Exception (SomeException)

import qualified Control.Monad.CatchIO as CIO
import           Lua.Instances
import           Lua.Monad
import           Lua.Prim
import           Debug.Trace
import           Control.Monad.Random 
import           Data.Constants
import           Data.Car
import           Data.Environment
import           Data.Racing
import           Data.Section
import           Data.Track
import           Data.Driver
import           Data.Car
import           Control.Concurrent 
import           Data.ComposeModel
import qualified Data.Task as Task
import           Data.DataPack
import qualified Model.PreLetter as Not 
import           SqlTransactionSnaplet (initSqlTransactionSnaplet)
import           NotificationSnaplet (initNotificationSnaplet, getPostOffice)
import           ConfigSnaplet 
import           RandomSnaplet (l32, initRandomSnaplet)
import           NodeSnaplet 
import           Data.Tiger
import           Control.Arrow 
import           Snap.Snaplet
import           Data.Tournament 

import qualified Notifications as N 

------------------------------------------------------------------------------
-- | Renders the front page of the sample site.
--
-- The 'ifTop' is required to limit this to the top of a route.
-- Otherwise, the way the route table is currently set up, this action
-- would be given every request.
--

type STQ a = SqlTransaction Connection a

loadConfig :: String -> Application String 
loadConfig x = do 
        p <- runDb (search ["key" |== toSql x] [] 1 0) :: Application [CFG.Config]
        case p of 
            [] -> internalError $ "No such config key: " ++ x
            [x] -> return (CFG.value x)

loaddbConfig :: Read a => String -> SqlTransaction Connection a
loaddbConfig x = do 
            s <- search ["key" |== toSql x] [] 1 0 :: SqlTransaction Connection [CFG.Config]
            case s of
                [] -> rollback "no such key"
                [x] -> return (read $ CFG.value x)

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
           let c = m { A.password = tiger32 $ C.pack (A.password m) `mappend` salt }
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
    if ((tiger32) (C.pack ( A.password m) `mappend` salt) == A.password user)
        then do 

            k <- getUniqueKey 
            addRole (convert $ A.id user) k 
            n <- runDb (load $ convert $ A.id user) :: Application (Maybe AP.AccountProfile)
            writeResult k
        else do 
            internalError "Username or password is wrong, please try it again"
            
     
userData :: Application ()
userData = do 
    x <- getJson >>= scheck ["id"]
    let m = updateHashMap x (def :: APM.AccountProfileMin)

    runDb $ do
                userActions $ fromJust $ APM.id m
                Task.run Task.User $ fromJust $ APM.id m
 
    n <- runCompose $ do 
                action "user" ((load $ fromJust $ APM.id m) :: SqlTransaction Connection (Maybe APM.AccountProfileMin))
                action "car" $ do
                    xs <- search ["account_id" |== toSql (APM.id m) .&& "active" |== toSql True] [] 1 0 :: SqlTransaction Connection [CMI.CarMinimal]
                    case xs of 
                        [] -> return Nothing
                        [x] -> return (Just x)
    writeResult n 

userMe :: Application ()
userMe = do 
    x <- getUserId
    n <- runDb $ do 
            userActions x
--            Task.run Task.User x
            DBF.account_update_energy x 
            p <- (load x) :: SqlTransaction Connection (Maybe AP.AccountProfile)
            return p
    case n of 
        Nothing -> internalError "You do not exist, kbye"
        Just x -> writeMapable x

loadMenu :: Application ()
loadMenu = do 
    mt <- getOParam "tree_type"
    n <- runDb (search ["menu_type" |== (toSql mt) ] [Order ("number", []) True] 100000 0) :: Application [MM.MenuModel] 
    writeResult  (AS.toJSON (MM.fromFlat (convert n :: MM.FlatTree)))

marketPlace :: Application ()
marketPlace = do 
           uid <- getUserId
           puser <- fromJust <$> runDb (load uid) :: Application (A.Account )
           ((l, o), xs) <- getPagesWithDTD (
                    "car_id" +== "car_id" +&&  
                    "name" +== "part_type" +&& 
                    "level" +>= "level-min" +&& 
                    "level" +<= "level-max" +&& 
                    "price" +>= "price-min" +&&
                    "price" +<= "price-max" +&&

                     ifdtd "me" (=="1") 
                                ("account_id" +==| toSql uid) 
                                ("account_id" +<>| toSql uid)
                    
                    )
           ns <- runDb (search ( ("level" |<= (toSql $ A.level puser + 2)) : xs) [] l o) :: Application [MP.MarketPlace]
           writeMapables ns



marketManufacturer :: Application ()
marketManufacturer = do 
       uid <- getUserId
       puser <- fromJust <$> runDb (load uid) :: Application (A.Account )
       ((l, o),xs) <- getPagesWithDTD ("id" +== "manufacturer_id") 
       let ctr = ("level" |<= (toSql $ A.level puser )) 
       ms <- runDb (search (ctr:xs) [] l o) :: Application [MAM.ManufacturerMarket]
       writeMapables ms 

marketModel :: Application ()
marketModel = do 
      uid <- getUserId
      puser <- fromJust <$> runDb (load uid) :: Application (A.Account )
      let ctr = ("level" |<= (toSql $ A.level puser )) 
      ((l,o),xs) <-  getPagesWithDTD ("manufacturer_id" +== "manufacturer_id" +&& "id" +== "id")
      ns <- runDb (search (ctr:xs) [] l o) :: Application [CM.CarMarket]
      writeMapables ns

marketAllowedParts :: Application ()
marketAllowedParts = do 
    xs <- getJson 
    uid <- getUserId 
    let d = updateHashMap xs (def :: MPT.MarketPartType)
    p <- runDb $ do 
            x <- fromJust <$> load uid :: SqlTransaction Connection A.Account 
            (search ["car_id" |== (toSql $ MPT.car_id d) .&& "level" |<= (toSql $ A.level x)] [Order ("sort_part_type",[]) True] 10000 0) :: SqlTransaction Connection [MPT.MarketPartType]
    writeResult (AS.toJSON $ MM.mkTabs "PARTS" (fmap MPT.name p))

marketBuy :: Application ()
marketBuy = do 
    uid <- getUserId 
    xs <- getJson 
    tpsx <- liftIO milliTime 
    
    runDb $ do 
        let item' = updateHashMap xs (def :: Part.Part)        
        item <- load (fromJust $ Part.id item')
        -- Some checks 
        case item of 
            Nothing -> rollback "No such item, puddy puddy puddy"
            Just item -> do 
                puser <- fromJust <$> load uid
                when (Part.level item > A.level puser) $ rollback "No correct level cowboy"

                -- We can buy now 
                grg <- search ["account_id" |== (toSql uid)]  [] 1 0 :: SqlTransaction Connection [G.Garage]

                -- Add to user garage 

                i <- save (def {
                            PI.garage_id = G.id (head grg), 
                            PI.part_id = fromJust $ Part.id item,
                            PI.account_id = uid 
                            } :: PI.PartInstance) 
                reportShopper uid (def { 
                        SR.amount = abs(Part.price item),
                        SR.report_descriptor = "shop_part_buy",
                        SR.part_instance_id = Just i
                    })
                -- write it away in transaction log 
                transactionMoney uid  (def { 
                            Transaction.amount = - abs (Part.price item), 
                            Transaction.type = "part_model",
                            Transaction.type_id = fromJust $ Part.id item
                                })
                return ()
                
    writeResult ("You bought part"  :: String)

evalLua x xs = do 
            p <- rl 
            case p of 
                Left e -> internalError e
                Right (a, p) -> return a
    where rl = liftIO $ runLua $ do 
                        forM_ xs (uncurry saveLuaValue)
                        eval x
                        peekGlobal "res"


--         
-- Second hand shop 
marketSell :: Application ()
marketSell = do 
            uid <- getUserId 
            xs <- getJson >>= scheck ["price", "part_instance_id"]
            let d = updateHashMap xs (def :: MI.MarketItem)
            prg <- loadConfig "market_fee"
            x <- evalLua prg [
                          ("price", LuaNum (fromIntegral $ MI.price d))
                          ]

            -- -5.6 -> -5
            -- floor -5.6 -> -6
            -- ceil -5.6 -> -5
            --
            pts uid d (floor (x :: Double)) 
            writeResult True 
    where pts uid d fee = runDb $ do 
           p <- search [("id" |== toSql ( MI.part_instance_id d)) .&& ("account_id" |== toSql uid)] [] 1 0 :: SqlTransaction Connection [PI.PartInstance]
           case p of 
                [] -> rollback $ "No such part: " ++ (show $ MI.part_instance_id d)
                [x] -> do 
                    when (MI.price d < 0) $ rollback "Price should be positive" 
                    -- save part to market  
                    save (d {MI.account_id = uid, MI.price = abs (MI.price d)})

                    -- save part_instance as loon item 
                    save (x {PI.garage_id = Nothing })
                    reportShopper uid (def {
                            SR.amount = abs (MI.price d),
                            SR.part_instance_id = MI.part_instance_id d,
                            SR.report_descriptor = "market_part_fee"
                        })
                    -- write it away in transaction log 
                    transactionMoney uid (def { 
                            Transaction.amount = -(abs fee), 
                            Transaction.type = "garage_part_on_market",
                            Transaction.type_id = fromJust $ MI.part_instance_id d
                        })

carBuy :: Application ()
carBuy = do 
        uid <- getUserId 
        xs <- getJson >>= scheck ["id"]
--    let car = updateHashMap xs ( def :: CM.CarMarket)
--    flup <- ps uid mid
        let mid = extract "id" xs

        cid <- runDb $ do

            -- create car in user's garage
            cid <- instantiateCar mid uid

            -- get car model
            car <- fromJust <$> load mid :: SqlTransaction Connection CM.CarMarket
        
            -- create shopping report
            reportShopper uid (def {
                    SR.amount = abs(CM.price car),
                    SR.car_instance_id =  Just cid,
                    SR.report_descriptor = "shop_car_buy"
                })

            -- make payment
            transactionMoney uid (def {
                    Transaction.amount = - abs(CM.price car),
                    Transaction.type = "car_instance",
                    Transaction.type_id = fromJust $ CM.id car
                })

            return cid

        writeResult ("You succesfully bought the car" :: String)


carReturn :: Application ()
carReturn = do 
        uid <- getUserId 
        xs <- getJson >>= scheck ["car_instance_id"]
        let d = updateHashMap xs (def :: MI.MarketItem)
        p uid d
        writeResult ("You're car is returned to your garage" :: String)
    where p uid d = runDb $ do 
                    car <- search ["account_id" |== toSql uid .&& "car_instance_id" |== toSql (MI.car_instance_id d)] [] 1 0 :: SqlTransaction Connection [MI.MarketItem] 
                    case car of 
                        [] -> rollback "No such market item"
                        [car] -> do 
                            c <- fromJust <$> load (fromJust $ MI.car_instance_id car ) :: SqlTransaction Connection (CarInstance.CarInstance)
                            g <- head <$> search ["account_id" |== toSql uid] [] 1 0 :: SqlTransaction Connection G.Garage 
                            -- Move to garage  
                            save (c {CarInstance.garage_id = G.id g})
                            -- Remove from market place 
                            delete car ["id" |== toSql (MI.id car)]



carMarketBuy :: Application ()
carMarketBuy = do 
        uid <- getUserId 
        xs <- getJson >>= scheck ["car_instance_id"]
        let d = updateHashMap xs (def :: MI.MarketItem)
        s <- p uid d 
        N.sendNotification (MI.account_id s) (N.carMarket {
                                        N.car_id = fromJust $ MI.car_instance_id d,
                                        N.money = MI.price s 
                    })

        writeResult ("Your bought a car on the market" :: String)
    where  p uid d = runDb $ do 
            {-- 
             - 1. Add money 
             - 2. Remove car from market 
             - 3. Add car to account 
             - --} 

             mi <- search  [ "car_instance_id" |== toSql (MI.car_instance_id d)] [] 1 0 :: SqlTransaction Connection [MI.MarketItem]
             case mi of 
                [] -> rollback "no such car"
                [car] -> do 

                    transactionMoney uid (def { 
                                Transaction.amount = - abs(MI.price car),
                                Transaction.type = "garage_car_buy",
                                Transaction.type_id = fromJust $ MI.car_instance_id car
                        })
                    transactionMoney (MI.account_id car) (def {
                            Transaction.amount = abs(MI.price car),
                            Transaction.type = "garage_car_sell",
                            Transaction.type_id = fromJust $ MI.car_instance_id car 
                        })
                    reportShopper uid (def {
                            SR.amount = abs(MI.price car),
                            SR.car_instance_id = MI.car_instance_id car,
                            SR.report_descriptor = "market_car_buy"
                        })
                    reportShopper (MI.account_id car) (def {
                        SR.amount = abs(MI.price car),
                        SR.car_instance_id = MI.car_instance_id car, 
                        SR.report_descriptor = "market_car_sell"
                        })
                    -- Remove car from market 
                    delete car ["id" |== toSql (MI.id car)] 

                    -- Move car to new garage 
                    c <- fromJust <$> load (fromJust $ MI.car_instance_id d) :: SqlTransaction Connection (CarInstance.CarInstance)
                    g <- head <$> search ["account_id" |== toSql uid] [] 1 0 :: SqlTransaction Connection G.Garage
                    save (c { CarInstance.garage_id = G.id g })
                    return car 



{--
       $price = ($personnel_starting_price+(($personnel_starting_price/10*$improvement)-$personnel_starting_price))+rand(0,$personnel_starting_price/10);
       $salary = $personnel_starting_price*7+($personnel_starting_price+(($personnel_starting_price/10*$improvement)-$personnel_starting_price))+rand(0,$personnel_starting_price/10)-
 --}



carSell :: Application ()
carSell = do 
    uid <- getUserId 
    xs <- getJson >>= scheck ["car_instance_id", "price"]
    let d = updateHashMap xs (def :: MI.MarketItem)
    prg <- loadConfig "market_fee"
    fee <- evalLua prg [
            ("price", LuaNum (fromIntegral $ MI.price d))
            ]
 
    p uid d (fee :: Double)
    writeResult ("You car is in the market place" :: String)
 where p uid d (fromIntegral . floor -> fee) = runDb $ do
                cig <- load (fromJust $ MI.car_instance_id d) :: SqlTransaction Connection (Maybe CIG.CarInGarage)
                case cig of 
                    Nothing -> rollback "no such car"
                    Just car -> do 
                    {-- 
                     - 1. Substract fee 
                     - 2. Add car to market 
                     - 3. Remove car from garage
                     --}
                        transactionMoney uid (def {
                                Transaction.amount = -abs(fee),
                                Transaction.type = "garage_car_on_market",
                                Transaction.type_id = fromJust $ CIG.id car
                            })

                        reportShopper uid (def {    
                                SR.amount = MI.price d,
                                SR.car_instance_id = CIG.id car,
                                SR.report_descriptor = "market_car_fee"
                            })
                     -- 1. Add car to market 
                        save (def {
                               MI.car_instance_id =  CIG.id car,
                               MI.price = MI.price d,
                               MI.account_id = uid 
                            } :: MI.MarketItem)

                     -- 2. Remove car from garage 
                        x <- fromJust <$> load (fromJust $ CIG.id car) :: SqlTransaction Connection CarInstance.CarInstance
                        save (x { CarInstance.garage_id = Nothing })
                        
                                         
                        
                         
        


carTrash :: Application ()
carTrash = do 
    uid <- getUserId 
    xs <- getJson >>= scheck ["id"]
    p uid xs 
    writeResult ("You sold your car succesfully to the scrap heap" :: String)
    
         where p uid xs = runDb $ do 
                let d = updateHashMap xs (def :: CIG.CarInGarage)
                cig <- load (fromJust $ CIG.id d) :: SqlTransaction Connection (Maybe CIG.CarInGarage)
                case cig of 
                    Nothing -> rollback "no such car"
                    Just car -> do 
                        reportShopper uid (def {
                                SR.part_instance_id = CIG.id car,
                                SR.amount = abs (CIG.total_price car),
                                SR.report_descriptor = "car_trashed"
                            })


                        transactionMoney uid (def {
                                Transaction.amount = abs (CIG.total_price  car),
                                Transaction.type = "car_in_garage_trash",
                                Transaction.type_id = fromJust $ CIG.id car
                            })


                        ci <- fromJust <$> load (fromJust $ CIG.id car) :: SqlTransaction Connection CarInstance.CarInstance 

                        xs <- search [ "car_instance_id" |== toSql (CarInstance.id ci) ] [] 1000 0 :: SqlTransaction Connection [PI.PartInstance] 

                        forM_ xs $ \i -> save (i { PI.deleted = True }) 
                        save (ci { CarInstance.deleted = True }) 



carActivate :: Application ()
carActivate = do 
    uid <- getUserId 
    xs <- getJson >>= scheck ["id"]
    s <-  prc uid xs 
    writeResult (s :: String)
        where prc uid xs = runDb $ do 
                g <- head <$> search ["account_id" |== toSql uid] [] 1 0 :: SqlTransaction Connection G.Garage 
                r <- DBF.garage_set_active_car (fromJust $ G.id g) $ extract "id" xs
                case r of
                    True -> return "You set your active car"
                    False -> return "Could not set active car" 


carDeactivate :: Application ()
carDeactivate = do 
    uid <- getUserId 
    xs <- getJson >>= scheck ["id"]
    s <-  prc uid xs
    writeResult (s :: String)
        where prc uid xs =  runDb $ do 
                g <- head <$> search ["account_id" |== toSql uid] [] 1 0 :: SqlTransaction Connection G.Garage 
                r <- DBF.garage_unset_active_car (fromJust $ G.id g) $ extract "id" xs
                case r of
                    True -> return "You deactivated the car"
                    False -> return "Could not deactivate the car" 


garageCarReady :: Application ()
garageCarReady = do 
    uid <- getUserId 
    xs <- getJson >>= scheck ["id"]
    s <-  prc uid xs 
    writeResult s
        where prc uid xs = runDb $ do 
                personnelUpdate uid 
                g <- head <$> search ["account_id" |== toSql uid] [] 1 0 :: SqlTransaction Connection G.Garage 
                r <- DBF.garage_car_ready (fromJust $ G.id g) $ extract "id" xs
                return r
            

garageActiveCarReady :: Application ()
garageActiveCarReady = do 
    uid <- getUserId 
    s <-  prc uid
    writeResult s
        where prc uid = runDb $ do 
                g <- head <$> search ["account_id" |== toSql uid] [] 1 0 :: SqlTransaction Connection G.Garage 
                r <- DBF.garage_active_car_ready (fromJust $ G.id g)
                return r


marketPlaceBuy :: Application ()
marketPlaceBuy = do 
            uid <- getUserId
            xs <- getJson >>= scheck ["id"] 
            let d = updateHashMap xs (def :: MP.MarketPlace)
            let p = runDb $ do 
                mm <- load (fromJust $ MP.id d) :: SqlTransaction Connection (Maybe MP.MarketPlace)
                case mm of
                    Nothing -> rollback "No such item"
                    Just p -> do
                        -- remove money 
                        --
                        transactionMoney uid (def {
                                Transaction.amount = - abs(MP.price p),
                                Transaction.type = "market_place_buy",
                                Transaction.type_id = fromJust $ MP.id p 
                            })
                        reportShopper uid (def {
                                SR.part_instance_id = MP.id p,
                                SR.amount = abs (MP.price p),
                                SR.report_descriptor = "market_part_buy"
                            })

                        reportShopper (MP.account_id p) (def {
                                SR.part_instance_id = MP.id p,
                                SR.amount = abs (MP.price p),
                                SR.report_descriptor = "market_part_sell"
                            })
                        transactionMoney (MP.account_id p) (def {
                                Transaction.amount = abs(MP.price p),
                                Transaction.type = "market_place_sell",
                                Transaction.type_id = fromJust $ MP.id p
                            })

                        a <- head <$> search ["account_id" |== toSql uid]  []  1 0 :: SqlTransaction Connection G.Garage

                        -- remove market_part where part_instance_id =  part_instance_id 

                        delete (undefined :: MI.MarketItem) ["part_instance_id" |== toSql (MP.id d)] 

                        -- reassign part_instance to new garage_id 

                        pi <- fromJust <$> load (fromJust $ MP.id d) :: SqlTransaction Connection PI.PartInstance
                        save (pi {PI.garage_id =  G.id a, PI.car_instance_id = Nothing, PI.account_id = uid})
                        return p
            mp <- p 
            
            N.sendNotification (MP.account_id mp) (N.partMarket {
                                                                                                N.part_id = fromJust $ MP.id mp 
                                                                                                , N.money = MP.price mp
                                            })

            writeResult ("You bought the part" :: String) 



marketReturn :: Application ()
marketReturn = do 
        uid <- getUserId
        xs <- getJson
        let d = updateHashMap xs (def :: MP.MarketPlace)
        p uid d 
        writeResult True 
        -- check also on  account_id 
    
    where p uid d = runDb $ do 
                mm <- search [ "id" |== toSql (MP.id d) .&& "account_id" |== toSql uid] [] 1 0 :: SqlTransaction Connection [MP.MarketPlace]

                when (null mm) $ rollback "no such return"
                a <- head <$> search ["account_id" |== toSql uid]  []  1 0 :: SqlTransaction Connection G.Garage

                pit <- fromJust <$> load (fromJust $ MP.id d) :: SqlTransaction Connection PI.PartInstance

                delete (undefined :: MI.MarketItem) ["part_instance_id" |== toSql (MP.id d)] 

                save (pit {PI.garage_id = G.id a, PI.car_instance_id = Nothing, PI.account_id = uid})

 

carParts :: Application ()
carParts = do 
    uid <- getUserId
    ((l,o),xs) <- getPagesWithDTD (
        "car_instance_id" +== "car_instance_id" +&& 
        "account_id" +==| (toSql uid) ) 
    ns <- runDb $ search xs [] l o :: Application [CIP.CarInstanceParts]
    writeMapables ns

carPart :: Application ()
carPart = do 
    uid <- getUserId
    ((l,o),xs) <- getPagesWithDTD (
        "car_instance_id" +== "car_instance_id" +&& 
        "part_instance_id" +== "part_instance_id" +&& "account_id" +==| (toSql uid) ) 
    ns <- runDb $ search xs [] l o :: Application [CIP.CarInstanceParts]
    writeMapables ns


marketCarParts :: Application ()
marketCarParts = do 
    uid <- getUserId
    ((l,o),xs) <- getPagesWithDTD (
        "car_instance_id" +== "car_instance_id" +&& 
        "part_instance_id" +== "part_instance_id") 
    ns <- runDb $ search xs [] l o :: Application [MCIP.MarketCarInstanceParts]
    writeMapables ns




marketTrash :: Application ()
marketTrash = do 
        uid <- getUserId
        xs <- getJson >>= scheck ["part_instance_id"]
        let d = updateHashMap xs (def :: GPT.GaragePart)
        tpsx <- liftIO milliTime 
        pts uid d tpsx 
        writeResult True 
    where pts uid d tpsx = runDb $ do 
            pls <- search ["part_instance_id" |== toSql (GPT.part_instance_id d)] [] 1 0  :: SqlTransaction Connection [GPT.GaragePart]
            case pls of 
                [] -> rollback "Cannot find garage part"
                [d] -> do 
                        reportShopper uid (def {
                                SR.part_instance_id = Just $ GPT.part_instance_id d,
                                SR.amount = abs (GPT.trash_price d),
                                SR.report_descriptor = "part_trashed"
                            })
                        transactionMoney uid (def { 
                                Transaction.amount = abs (GPT.trash_price d), 
                                Transaction.type = "garage_trash",
                                Transaction.type_id = fromJust $ GPT.id d
                            })
                        -- hide forever
                        pti <- fromJust <$> load (GPT.part_instance_id d) :: SqlTransaction Connection PI.PartInstance
                        save (pti { PI.deleted = True })
             
 

marketCars :: Application ()
marketCars = do 
    uid <- getUserId 
    puser <- fromJust <$> runDb (load uid) :: Application (A.Account )
    ((l,o), xs) <- getPagesWithDTD (
                "car_instance_id" +== "car_instance_id" +&&
                "level" +<= "level-max" +&&
                "level" +>= "level-min" +&&
                "price" +>= "price-min" +&&
                "price" +<= "price-max" +&&
                     ifdtd "me" (=="1") 
                                ("account_id" +==| toSql uid) 
                                ("account_id" +<>| toSql uid +&& 
                                    "level" +<=| (toSql $ A.level puser)
                                    )
                    )
    ns <- runDb $ search xs [] l o :: Application [MPC.MarketPlaceCar]
    writeMapables ns 
    

marketParts :: Application ()
marketParts = do 
   uid <- getUserId
   puser <- fromJust <$> runDb (load uid) :: Application (A.Account )
   ((l, o), xs) <- getPagesWithDTD (
            "car_id" +== "car_id" +&& 
            "name" +== "part_type" +&&  
            "level" +<= "level-max" +&& 
            "level" +>= "level-min" +&&
            "price" +>= "price-min" +&&
            "price" +<= "price-max" +&&
            "level" +<=| (toSql $ A.level puser)
            )
   ns <- runDb (search xs [] l o) :: Application [PM.PartMarket]
   writeMapables ns  

garageParts :: Application ()
garageParts = do 
        uid <- getUserId 
                        
        (((l, o), xs),od) <- getPagesWithDTDOrdered ["level", "part_instance_id", "unique", "improvement"] (
                "name" +== "part_type" +&& 
                "part_instance_id" +== "part_instance_id" +&& 
                "level" +<= "level-max" +&& 
                "level" +>= "level-min" +&&
                "price" +>= "price-min" +&&
                "price" +<= "price-max" +&& 

                ifdtd "anycar" (=="1")
                    ("car_id" +== "car_id" +|| "car_id" +==| toSql (0 :: Integer))
                    ("car_id" +== "car_id") +&& 

                    
                "account_id" +==| toSql uid
            )
        let p = runDb $ do
            personnelUpdate uid 
            ns <- search xs od l o
            return ns 
        ns <- p :: Application [GPT.GaragePart]
        writeMapables ns 

           
garageCar :: Application ()
garageCar = do 
        uid <- getUserId 
        (((l,o), xs),od) <- getPagesWithDTDOrdered ["active", "level"] ("id" +== "car_instance_id" +&& "account_id"  +==| (toSql uid)) 
--        ps <- runDb $ search xs [] l o :: Application [CIG.CarInGarage]
        let p = runDb $ do
            personnelUpdate uid 
            (ns :: [CIG.CarInGarage]) <- search xs od l o
            return ns 
        ns <- p :: Application [CIG.CarInGarage]
        writeMapables (garageCarProps <$> ns)



garageActiveCar :: Application ()
garageActiveCar = do 
        uid <- getUserId 
        (((l,o), xs),od) <- getPagesWithDTDOrdered [] ("id" +== "car_instance_id" +&& "account_id"  +==| (toSql uid) +&& "active" +==| SqlBool True) 
        let p = runDb $ do
            personnelUpdate uid 
            ns <- search xs od l o
            return ns 
        ns <- p :: Application [CIG.CarInGarage]
        writeMapables (garageCarProps <$> ns)


loadModel :: Application ()
loadModel = do 
        (((l,o),xs),od) <- getPagesWithDTDOrdered [] ("id" +== "car_instance_id" +&& "part_instance_id" +== "part_instance_id")
        ns <- runDb $ search xs od l o :: Application [C3D.Car3dModel]
        writeMapables ns

loadTemplate :: Application ()
loadTemplate = do 
        name <- getOParam "name"
        let pth =  ("resources/static/" ++ C.unpack name ++ ".tpl")
        let dirs = splitDirectories pth
        if ".." `elem` dirs 
            then internalError "do not hacked server"
            else serveFileAs "text/plain" pth

userAddSkill :: Application ()
userAddSkill = do 
        uid <- getUserId 
        xs <- getJson
        u' <- runDb $ do 
            userActions uid
            u <- fromJust <$> load uid 
            let d = updateHashMap xs (def :: A.Account)
            let p = A.skill_acceleration d + A.skill_braking d + A.skill_control d + A.skill_reactions d + A.skill_intelligence d  
            if p > A.skill_unused u 
                then rollback "Not enough skill points"
                else do 
                        let u' = u {
                            A.skill_control = A.skill_control u + A.skill_control d,
                            A.skill_braking = A.skill_braking u + A.skill_braking d,
                            A.skill_acceleration = A.skill_acceleration u + A.skill_acceleration d,
                            A.skill_intelligence = A.skill_intelligence u + A.skill_intelligence d,
                            A.skill_reactions = A.skill_reactions u + A.skill_reactions d,
                            A.skill_unused = A.skill_unused u - abs p
                        }
                        save u'
                        return u'
        writeMapable u'

removePart :: Application ()
removePart = do 
    uid <- getUserId
    xs <- getJson >>= scheck ["part_instance_id"]
    let d = updateHashMap xs (def :: MI.MarketItem)
    p uid d 
    writeResult ("You removed the part." :: String)
 where p uid d = runDb $ do 
        mt <- search ["part_instance_id" |== toSql ( MI.part_instance_id d)] [] 1 0 :: SqlTransaction Connection ([CIP.CarInstanceParts])
        case mt of 
            [] -> rollback "No such part"
            [t] -> do 
                case CIP.fixed t of
                    True -> rollback "This part cannot be removed"
                    False -> do

                        -- move part from car_instance_id to garage_id 
                        pl <- load (fromJust $ MI.part_instance_id d) :: SqlTransaction Connection (Maybe PI.PartInstance)
                        case pl of 
                            Nothing -> rollback "No such part (should not happen)"
                            Just x -> do
                                g <- head <$> search ["account_id" |== toSql uid] [] 1 0 :: SqlTransaction Connection G.Garage
                                save (x { PI.garage_id = G.id g, PI.car_instance_id = Nothing })

addPart :: Application ()
addPart = do 
        uid <- getUserId 
        xs <- getJson >>= scheck ["part_instance_id", "car_instance_id"]
        let pid = extract "part_instance_id" xs :: Integer
        let cid = extract "car_instance_id" xs :: Integer

        void $ runDb $ do
                -- get garage record
                g <- aget ["account_id" |== toSql uid] (rollback "Garage not found") :: SqlTransaction Connection G.Garage 
                -- get garage part instance record; any parts in cars are not found
                p <- aget ["part_instance_id" |== toSql pid] (rollback "No such part in garage") :: SqlTransaction Connection GPT.GaragePart
                -- add part to car
                update "part_instance" ["id" |== toSql pid] [] [("car_instance_id", toSql cid), ("garage_id", SqlNull)]
                -- remove all other parts of the same type from the car
                ss <- search ["part_instance_id" |<> toSql pid .&&  "part_type_id" |== toSql (GPT.part_type_id p) .&& "car_instance_id" |== toSql cid] [] 100 0 :: SqlTransaction Connection [CIP.CarInstanceParts]
                forM_ ss $ \s -> do
                        update "part_instance" ["id" |== toSql (CIP.part_instance_id s)] [] [("car_instance_id", SqlNull), ("garage_id", toSql $ G.id g)]
 
        writeResult ("The part was successfully installed" :: String)


marketPersonnel :: Application ()
marketPersonnel = do 
        uid <- getUserId 
        ((l,o), xs) <- getPagesWithDTD (
                    "skill_repair" +>= "repairmin" +&&
                    "skill_repair" +<= "repairmax" +&&
                    "skill_engineering" +>= "engineeringmin" +&&
                    "skill_engineering" +<= "engineeringmax" +&&
                    "salary" +>= "salarymin" +&&
                    "salary" +<= "salarymax" 
            )
        r <- liftIO $ randomRIO (1, 100 :: Integer)
        ns <- runDb $ search (("sort" |== (toSql r)) :xs) [Order ("sort",[]) True]  l o :: Application [PLD.PersonnelDetails]
        writeMapables ns 



garagePersonnel :: Application ()
garagePersonnel = do 
        uid <- getUserId 
        ((l,o), xs) <- getPagesWithDTD (
                    "personnel_instance_id" +== "id" +&&
                    "skill_repair" +>= "repairmin" +&&
                    "skill_repair" +<= "repairmax" +&&
                    "skill_engineering" +>= "engineeringmin" +&&
                    "skill_engineering" +<= "engineeringmax" +&&
                    "salary" +>= "salarymin" +&&
                    "salary" +<= "salarymax" 
            )
        let p = runDb $ do
            personnelUpdate uid 
            g <- head <$> search ["account_id" |== toSql uid] [] 1 0 :: SqlTransaction Connection G.Garage 
            ns <- search (xs ++ ["garage_id" |== (toSql $ G.id g) ]) [Order ("personnel_instance_id",[]) True]  l o
            return ns 
        ns <- p :: Application [PLID.PersonnelInstanceDetails]
        writeMapables ns 


partTasks :: Application ()
partTasks = do 
    uid <- getUserId 
    xs <- getJson >>= scheck ["id"]
    let ts = runDb $ do
                g <- head <$> search ["account_id" |== toSql uid] [] 1 0 :: SqlTransaction Connection G.Garage 
                ps <- search ["account_id" |== (toSql $ uid), "part_instance_id" |== extract "id" xs] [] 1 0 :: SqlTransaction Connection [GPT.GaragePart]
                case ps of 
                        [] -> rollback "Cannae glean yer partie"
                        [part] -> do  
                                ts <- search ["garage_id" |== (toSql $ G.id g), "task_subject_id" |== (toSql $ GPT.part_instance_id part)] [] 1 0 :: SqlTransaction Connection [PLID.PersonnelInstanceDetails]
                                return ts
    ns <- ts :: Application [PLID.PersonnelInstanceDetails]
    writeMapables ns


trainPersonnel :: Application ()
trainPersonnel = do 
    uid <- getUserId 
    xs <- getJson >>= scheck ["id", "type", "level"]
    let person = updateHashMap xs (def :: PLI.PersonnelInstance)
    r <-  prc uid xs person 
    writeResult ("You succesfully trained this person" :: String)
         where prc uid xs person =  runDb $ do 
                g <- head <$> search ["account_id" |== toSql uid] [] 1 0 :: SqlTransaction Connection G.Garage 
                cm <- load (fromJust $ PLI.id person) :: SqlTransaction Connection (Maybe PLI.PersonnelInstance)
                case cm of 
                        Nothing -> rollback "No such person found"
                        Just person -> do  
                        
                            -- pay training price
                            transactionMoney uid (def {
                                    Transaction.amount = - abs(cost xs person),
                                    Transaction.type = "personnel_train",
                                    Transaction.type_id = fromJust $ PLI.id person
                                })

                            -- train personnel
                            r <- DBF.personnel_train (fromJust $ PLI.id person) (extract "type" xs) (extract "level" xs)
                            pm <- fromJust <$> load (fromJust $ PLI.id person) :: SqlTransaction Connection (PLI.PersonnelInstance)

                            reportPersonnel uid (def { 
                                             PR.report_descriptor = "train_personnel",
                                             PR.personnel_instance_id = PLI.id person,
                                             PR.result = show $ frm xs pm person,
                                             PR.cost = Just $ abs(cost xs person),
                                             PR.data = extract "type" xs 
                                        })
                            return r
                                where

                                    frm xs p1 p2 = case extract "type" xs of 
                                                    ("repair" :: String) -> abs (PLI.skill_repair p1 - PLI.skill_repair p2)
                                                    "engineering" -> abs ( PLI.skill_engineering p1 - PLI.skill_engineering p2 )
                                                    otherwise -> error "no type defined"
                                    cost xs p = floor $ toRational (cbas xs p) * (cmul xs)
                                    cbas xs p = case extract "type" xs of 
                                                    ("repair" :: String) -> PLI.training_cost_repair p
                                                    "engineering" -> PLI.training_cost_engineering p
                                                    otherwise -> error "no type defined"
                                    cmul xs = case extract "level" xs of 
                                                    ("high" :: String) -> 2
                                                    "medium" -> 1.5
                                                    "low" -> 1
                                                    otherwise -> error "no level defined"


hirePersonnel :: Application ()
hirePersonnel = do 
    uid <- getUserId 
    xs <- getJson >>= scheck ["personnel_id"]
    let person = updateHashMap xs (def :: PLD.PersonnelDetails)
    r <-  prc uid xs person 
    writeResult ("You succesfully hired this person" :: String)
         where prc uid xs person =  runDb $ do 
                g <- head <$> search ["account_id" |== toSql uid] [] 1 0 :: SqlTransaction Connection G.Garage 
                s <- search ["garage_id" |== (toSql $ G.id g)] [] 1 0 :: SqlTransaction Connection [PLID.PersonnelInstanceDetails]
                case s of
                    [_] -> rollback "You already have a mechanic"
                    [] -> do
                        cm <- load (fromJust $ PLD.personnel_id person) :: SqlTransaction Connection (Maybe PLD.PersonnelDetails)
                        case cm of 
                                Nothing -> rollback "No such person found"
                                Just person -> do  
                        
                                    -- pay hiring price of staff member
                                    transactionMoney uid (def {
                                            Transaction.amount = - abs(PLD.salary person + PLD.price person),
                                            Transaction.type = "personnel_instance",
                                            Transaction.type_id = fromJust $ PLD.personnel_id person
                                        })
                            
                                    plid <- save ((def :: PLI.PersonnelInstance) {
                                             PLI.garage_id =  fromJust $ G.id g,
                                             PLI.task_id = 1,
                                             PLI.personnel_id = PLD.personnel_id person,
                                             PLI.skill_repair = PLD.skill_repair person,
                                             PLI.skill_engineering = PLD.skill_engineering person
                                        }) :: SqlTransaction Connection Integer

                                    reportPersonnel uid (def { 
                                            PR.report_descriptor = "hire_personnel",
                                            PR.personnel_instance_id = Just plid,
                                            PR.result = "success",
                                            PR.cost = Just $ abs(PLD.salary person + PLD.price person)
                                        }) 
                                    return True

firePersonnel :: Application ()
firePersonnel = do 
    uid <- getUserId 
    xs <- getJson >>= scheck ["id"]
    let person = updateHashMap xs (def :: PLI.PersonnelInstance)
    r <-  prc uid xs person 
    writeResult ("You succesfully fired this person" :: String)
         where prc uid xs person =  runDb $ do 
                g <- head <$> search ["account_id" |== toSql uid] [] 1 0 :: SqlTransaction Connection G.Garage 
--                cm <- load (fromJust $ PLI.id person) :: SqlTransaction Connection (Maybe PLI.PersonnelInstance)
                cm <- search ["garage_id" |== (toSql $ G.id g), "id" |== (toSql $ PLI.id person), "deleted" |== (toSql False)] [] 1 0 :: SqlTransaction Connection [PLI.PersonnelInstance]
                case cm of 
                        [] -> rollback "That is not your mechanic, friend"
                        [person] -> do

                            reportPersonnel uid (def { 
                                    PR.report_descriptor = "fire_personnel",
                                    PR.personnel_instance_id = PLI.id person,
                                    PR.result = "success"
                                })

                            plid <- save $ person {
                                    PLI.deleted = True
                                }

                            return True


taskPersonnel :: Application ()
taskPersonnel = do
    uid <- getUserId
    xs <- getJson >>= scheck ["personnel_instance_id", "task", "subject_id"]
    r <- prc uid xs
    writeResult ("You succesfully tasked this person" :: String)
        where prc uid xs = runDb $ do
               g <- head <$> search ["account_id" |== toSql uid] [] 1 0 :: SqlTransaction Connection G.Garage 
               cm <- search ["garage_id" |== (toSql $ G.id g), "id" |== (toSql $ HM.lookup "personnel_instance_id" xs), "deleted" |== (toSql False)] [] 1 0 :: SqlTransaction Connection [PLI.PersonnelInstance]
               case cm of 
                        [] -> rollback "That is not your mechanic, friend"
                        [_] -> do 
                            reportGarage uid (def {
                                    GRP.part_instance_id = fromSql $ fromJust $ HM.lookup "subject_id" xs,
                                    GRP.personnel_instance_id = fromSql $ fromJust $ HM.lookup "personnel_instance_id" xs,
                                    GRP.task = fromSql $ fromJust $ HM.lookup "task" xs,
                                    GRP.report_descriptor = "personnel_task"
                                    })
                            r <- personnelStartTask (extract "personnel_instance_id" xs) (extract "task" xs) (extract "subject_id" xs)
                            return r

personnelStartTask :: Integer -> String -> Integer -> SqlTransaction Connection Bool 
personnelStartTask pid tsk sid = do 
                        ptt' <- search ["name" |== (toSql tsk)] [] 1 0 :: SqlTransaction Connection [PTT.PersonnelTaskType] 
                        assert (not . null $ ptt') "no such task" 
                        let ptt = head ptt' 
                        pid' <- search ["personnel_instance_id" |== (toSql pid)] [] 1 0 :: SqlTransaction Connection [PLID.PersonnelInstanceDetails]
                        assert (not . null $ pid') "no such personnel"
                        let pid = head pid' 
                        assert ((=="idle") .  PLID.task_name $ pid) "your personnel is busy"
                        case tsk of 
                            "repair_part" -> do 
                                    pi <- search ["id" |== (toSql sid) .&& "garage_id" |== toSql (PLID.garage_id pid) .&& "deleted" |== (toSql False)] [] 1 0 :: SqlTransaction Connection [PI.PartInstance] 
                                    assert (not . null $ pi) "part doesn't exist"
                            "improve_part" -> do
                                    pi <- search ["garage_id" |== toSql (PLID.garage_id pid) .&& "id" |== toSql sid .&& "deleted" |== (toSql False)] [] 1 0 :: SqlTransaction Connection [PI.PartInstance] 
                                    assert (not . null $ pi) "part doesn't exist"
                            "repair_car" -> do 
                                    ci <- search ["garage_id" |== toSql (PLID.garage_id pid) .&& "id" |== toSql sid .&& "deleted" |== (toSql False)] [] 1 0 :: SqlTransaction Connection [CarInstance.CarInstance]
                                    assert (not . null $ ci) "car doesn't exist"
                            otherwise -> rollback "no interpretation of task possible"
                        td <- loaddbConfig "task_duration"
                        now <- liftIO $ milliTime 
                        p <- aload (fromJust $ PLID.personnel_instance_id pid) (rollback "cannot find personnel") :: SqlTransaction Connection PLI.PersonnelInstance 
                        save (p {
                             PLI.task_id = fromJust $ PTT.id ptt,
                             PLI.task_subject_id = sid,
                             PLI.task_started = now,
                             PLI.task_updated = now,
                             PLI.task_end = now + td
 
                         })
                        return True 







cancelTaskPersonnel :: Application ()
cancelTaskPersonnel = do
    uid <- getUserId
    xs <- getJson >>= scheck ["personnel_instance_id"]
    r <- prc uid xs
    writeResult ("You succesfully canceled this persons task" :: String)
        where prc uid xs = runDb $ do
               g <- head <$> search ["account_id" |== toSql uid] [] 1 0 :: SqlTransaction Connection G.Garage 
               cm <- search ["garage_id" |== (toSql $ G.id g), "id" |== (toSql $ HM.lookup "personnel_instance_id" xs), "deleted" |== (toSql False)] [] 1 0 :: SqlTransaction Connection [PLI.PersonnelInstance]
               case cm of 
                        [] -> rollback "That is not your mechanic, friend"
                        [_] -> do
                            personnelUpdate uid 
                            stopTask (extract "personnel_instance_id" xs) uid  
                            return ()

stopTask :: Integer -> Integer -> SqlTransaction Connection () 
stopTask pid uid = do 
        pi <- aload pid $ rollback "personnel instance not found" :: SqlTransaction Connection PLI.PersonnelInstance
        -- stop task 
        save (def {
                GRP.part_instance_id = PLI.task_subject_id pi,
                GRP.personnel_instance_id = fromJust $ PLI.id pi 
            })
        save (pi {
                PLI.task_id = 1,
                PLI.task_subject_id = 0,
                PLI.task_started = 0,
                PLI.task_updated = 0,
                PLI.task_end = 0
            })
        return ()



        

-- TODO: fromSql <$> HM.lookup k xs --> Maybe Value
extract k xs = fromSql . fromJust $ HM.lookup k xs

-- dextract :: (Ord k, Convertible SqlValue a) => a -> k -> HM.HashMap k SqlValue -> a
dextract d k xs = return $ maybe d fromSql $ HM.lookup k xs

rextract k xs = case HM.lookup k xs of
        Nothing -> error $ k ++ " is a required field"
        Just a -> return $ fromSql a

{-- Reporting functions --}
{-- 
 - @IN Integer
 - @IN ShopReport
 - @OUT SqlTransaction Connection ()
 - @SIDEEFFECTS Save parameter object to database. Overrides the account identification number  
 - OBJECT-id: 1992771092736l
 --}
reportShopper :: Integer -> -- account_id, should exist and is a bigint 
                 SR.ShopReport -> -- ShopReport is a named parameter object (Model/ShopReport) 
                 SqlTransaction -- Executable and Composable Database Context for Forming Transactions 
                    Connection -- Polymorphic Database Connection Descriptor.  
                    () -- Resultant type of computation 
reportShopper uid x = do -- syntactic sugar for heightening readability.  
                -- some space to enforce enterprise ready deployability. 
                save {-- Opening the save clause --} (x { -- Special parameter object to achieve object type safety. 
                        SR.account_id = uid -- Setting the record type explicitely. 
                    }) -- Ending the save clause 
                -- overide the return type of the function. 
                return () -- return unit type in order to satisfy the type system.

reportPersonnel :: Integer -> PR.PersonnelReport -> SqlTransaction Connection ()
reportPersonnel uid tr = do 
                save (tr {
                       PR.account_id = uid 
                    })
                return ()

reportGarage :: Integer -> GRP.GarageReport -> SqlTransaction Connection ()
reportGarage uid tr = do 
            save (tr {  
                GRP.account_id = uid
                })
            return ()


reportRace :: Integer -> Integer -> Data -> SqlTransaction Connection ()
reportRace uid t d = do
        save $ (def::RP.Report) {
                RP.account_id = uid,
                RP.time = t,
                RP.type = RP.Race,
                RP.data = d
        }
        return ()

cityTravel :: Application ()
cityTravel = do
        uid <- getUserId 
        xs <- getJson >>= scheck ["id"]
        let tr = runDb $ do
                a <- load uid :: SqlTransaction Connection (Maybe A.Account)
                case a of 
                        Nothing -> rollback "oh noes diz can no happen"
                        Just a -> do 
                                cs <- search ["city_id" |== (toSql $ (extract "id" xs :: Integer))] [] 1 0 :: SqlTransaction Connection [TCY.TrackCity]
                                case cs of
                                        [] -> rollback "Cannot find city, is it lost?"
                                        [city] -> do
                                                when ( (TCY.city_level city) > (A.level a)) $ rollback "Kid, you're not ready for this city"
                                                save $ a { A.city = TCY.city_id city }
                                                return True 
        t <- tr
        writeResult ("you travel to the city" :: String)

cityList :: Application ()
cityList = do 
        uid <- getUserId 
        ((l,o),xs) <- getPagesWithDTD ("continent_id" +== "continent" +&& "city_level" +>= "levelmin" +&& "city_level" +<= "levelmax")
        ns <- runDb $ search xs [Order ("continent_id",[]) True, Order ("city_level",[]) True] l o :: Application [TCY.TrackCity]
        writeMapables ns

continentList :: Application ()
continentList = do 
        uid <- getUserId 
        ((l,o),xs) <- getPagesWithDTD ("continent_level" +>= "levelmin" +&& "continent_level" +<= "levelmax")
        ns <- runDb $ search xs [Order ("continent_level",[]) True] l o :: Application [TCN.TrackContinent]
        writeMapables ns

trackList :: Application ()
trackList = do 
        uid <- getUserId 
        ((l,o),xs) <- getPagesWithDTD ("city_id" +== "city" +&& "continent_id" +== "continent" +&& "track_level" +>= "levelmin" +&& "track_level" +<= "levelmax")
        ns <- runDb $ search xs [Order ("continent_id",[]) True, Order ("city_id",[]) True, Order ("track_level",[]) True] l o :: Application [TT.TrackMaster]
        writeMapables ns

trackHere :: Application ()
trackHere = do 
        uid <- getUserId 
        ((l,o),xs) <- getPagesWithDTD ("track_level" +>= "levelmin" +&& "track_level" +<= "levelmax")
        let tr = runDb $ do
                a <- load uid :: SqlTransaction Connection (Maybe A.Account)
                case a of 
                        Nothing -> rollback "oh noes diz can no happen"
                        Just a -> do 
                                 Task.runAll Task.Track 
                                 ts <- search (["city_id" |== (toSql $ A.city a)] ++ xs) [Order ("track_level",[]) True] l o :: SqlTransaction Connection [TT.TrackMaster]
                                 ts <- search ["city_id" |== (toSql $ A.city a)] [] 1000 0 :: SqlTransaction Connection [TT.TrackMaster]
                                 return ts
        ts <- tr
        writeMapables ts

userReports :: Application ()
userReports = do
        uid <- getUserId 
        ((l,o),xs) <- getPagesWithDTD ("report_type" +== "report_type" +&& "time" +>= "timemin" +&& "time" +<= "timemax" +&& "account_id" +==| (toSql uid))
        ns <- runDb $ search xs [Order ("time",[]) False] l o :: Application [GR.GeneralReport]
        writeMapables ns

personnelReports :: Application ()
personnelReports = do 
        uid <- getUserId 
        ((l,o),xs) <- getPagesWithDTD ("time" +>= "timemin" +&& "time" +<= "timemax" +&& "account_id" +==| (toSql uid))
        ns <- runDb $ search xs [Order ("time",[]) False] l o :: Application [PR.PersonnelReport]
        writeMapables ns

shoppingReports :: Application ()
shoppingReports = do 
        uid <- getUserId 
        ((l,o),xs) <- getPagesWithDTD ("time" +>= "timemin" +&& "time" +<= "timemax" +&& "account_id" +==| (toSql uid))
        ns <- runDb $ search xs [Order ("time",[]) False] l o :: Application [SR.ShopReport]
        writeMapables ns

garageReports :: Application ()
garageReports = do  
        uid <- getUserId 
        ((l,o),xs) <- getPagesWithDTD ("time" +>= "timemin" +&& "time" +<= "timemax" +&& "account_id" +==| (toSql uid))
        ns <- runDb $ do
            userActions uid
            search xs [Order ("time",[]) False] l o 
        writeMapables (ns :: [GRP.GarageReport])

travelReports :: Application ()
travelReports = do 
    uid <- getUserId 
    ((l,o),xs) <- getPagesWithDTD ("time" +>= "timemin" +&& "time" +<= "timemax" +&& "account_id" +==| (toSql uid))
    ns <- runDb (search xs [] l o) :: Application [TR.TravelReport]
    writeMapables ns 
    
searchReports :: RP.Type -> Application ()
searchReports t = do
        uid <- getUserId
        ((l,o),xs) <- getPagesWithDTD ("time" +>= "timemin" +&& "time" +<= "timemax" +&& "account_id" +==| (toSql uid) +&& "type" +==| (toSql t))
        ns :: [RP.Report] <- runDb $ do
            userActions uid
            search xs [Order ("time",[]) False] l o 
--        writeMapables ns -- toInRule wraps Data in ByteString so it ends up as a JSON string
        writeResult' ns
 
downloadCarImage :: Application ()
downloadCarImage = do
    uid <- getUserId
    pl <- getOParam "car_instance_id"
    let p = read (C.unpack pl) :: Integer 
    serveFile ("resource/static/carimages/" ++ (show p) ++ ".jpg")

carGetOptions :: Application ()
carGetOptions = do 
        uid <- getUserId
        ((l,o), xs) <- getPagesWithDTD ("car_instance_id" +== "car_instance_id" +&& "key"  +== "key" +&& "account_id" +==| (toSql uid)) 
        xs <- runDb $ search xs [] l o :: Application [(COE.CarOptionsExtended)]
        writeMapables xs

carSetOptions :: Application ()
carSetOptions = do 
        uid <- getUserId 
        xs <- getJsons
        
        forM_ xs $ \xs -> do 
            scheck ["car_instance_id", "key", "value"] xs  
            runDb $ do 
                let co = updateHashMap xs def :: CO.CarOptions 
                x <- load (CO.car_instance_id co) :: SqlTransaction Connection (Maybe COW.CarOwners)
                case x of 
                    Nothing -> rollback "no such car"
                    Just x -> do 
                        when (COW.account_id x /= uid) $ rollback "You're not the car owner"
                        s <- search  ["car_instance_id" |== toSql (CO.car_instance_id co), "key" |== toSql (CO.key co)] [] 1 0 :: SqlTransaction Connection [CO.CarOptions] 
                        case s of 
                            [] -> do 
                                    save co 
                            [id] -> do
                                save (co {CO.id = CO.id id})
                                
        writeResult (1 :: Integer)


uploadCarImage :: Application ()
uploadCarImage = do 
    uid <- getUserId
    xs <- getJson >>= scheck ["car_instance_id"]
    let ns = updateHashMap xs (def :: PI.PartInstance)
    handleFileUploads "resources/static/carimages" (setMaximumFormInputSize (1024 * 200) $ defaultUploadPolicy) (const $ allowWithMaximumSize (1024 * 200)) $ \xs -> do 
        when (null xs)  $ internalError "no file uploaded"
        case snd $ head xs of 
            Left x -> internalError (T.unpack $ policyViolationExceptionReason x)
            Right e -> do 
                    liftIO $ renameFile e (show (PI.car_instance_id ns)  ++ ".jpg")
                    return ()
 {-
 - Actions: transactions to be taken before selecting data
 -}

-- time based actions for user account: update before any activity involving the account
-- TODO: all Other time based actions, such as energy regeneration
userActions :: Integer -> SqlTransaction Connection ()
userActions uid = do
        Task.run Task.User uid
--        DBF.garage_actions_account uid
        a <- aget ["id" |== toSql uid] (rollback "account not found") :: SqlTransaction Connection A.Account
        t <- liftIO milliTime 
        let u = A.busy_until a
        personnelUpdate uid
        when (u > 0 && u <= t) $ do
--            save $ a { A.busy_until = 0, A.busy_subject_id = 0, A.busy_type = 1 }
            -- do not overwrite record as it may have changed; use update instead
            update "account" ["id" |== (toSql $ uid)] [] [("busy_until", SqlInteger 0), ("busy_subject_id", SqlInteger 0), ("busy_type", SqlInteger 1)]
            return ()

-- TODO: personnel actions here (improve, repair) i?
--
--

personnelUpdate :: Integer -> SqlTransaction Connection ()
personnelUpdate uid = do 
            g <- aget ["account_id" |== (toSql uid)] (rollback "cannot find garage") :: SqlTransaction Connection G.Garage 
            p <- search ["garage_id" |== (toSql $ G.id g)] [] 1 0 :: SqlTransaction Connection [PLID.PersonnelInstanceDetails]
            case p of
                [] -> return () 
                xs -> forM_ xs $ \x -> case PLID.task_name x of 
                                                "idle" -> return ()
                                                "improve_part"  -> partImprove uid x 
                                                "repair_part" -> partRepair uid x 
                                                "repair_car"  -> carRepair uid x  

            

            

partImprove :: Integer -> PLID.PersonnelInstanceDetails -> SqlTransaction Connection ()
partImprove uid pi = do
                s <- liftIO $ milliTime
                let ut = (min (PLID.task_end pi) s) - (PLID.task_updated pi)
                let sk = PLID.skill_engineering pi 
                let sid = PLID.task_subject_id pi 
                atomical $ do 
                        (pr' :: Double) <- loaddbConfig "part_improve_rate" 
                        p' <- load sid :: SqlTransaction Connection (Maybe PI.PartInstance)
                        when (isNothing p') $ rollback "cannot find partinstance"
                        let p = fromJust p'             
                        let a = fromIntegral (sk * ut)
                        void $ save (p {
                                PI.improvement = min 100000 $ (PI.improvement p + round (a * pr'))
                            })

                        when (PLID.task_end pi < s) $ do 
                            stopTask (fromJust $ PLID.personnel_instance_id pi) uid
                            void $ N.sendCentralNotification uid (N.partImprove {
                                                                    N.part_id = convert $ PI.part_id p,
                                                                    N.improved = round (a * pr')

                                                                })
                                        



partRepair :: Integer -> PLID.PersonnelInstanceDetails -> SqlTransaction Connection ()
partRepair uid pi = do 
                s <- liftIO $ milliTime 

                let ut = (min (PLID.task_end pi) s) - (PLID.task_updated pi)
                let sk = PLID.skill_repair pi 
                let sid = PLID.task_subject_id pi 
                atomical $ do 
                        (pr' :: Double) <- loaddbConfig "part_repair_rate" 
                        p' <- load sid :: SqlTransaction Connection (Maybe PI.PartInstance)
                        when (isNothing p') $ rollback "part instance not found"
                        let p = fromJust p' 
                        let a = fromIntegral (sk * ut) 
                        void $ save (p {
                                            PI.wear = max 0 $ PI.wear p - round (a * pr')
                                        })
                        when (PLID.task_end pi < s) $  do 
                            stopTask (fromJust $ PLID.personnel_instance_id pi) uid
                            void $ N.sendCentralNotification uid (N.partRepair {
                                                                    N.part_id = convert $ PI.part_id p,
                                                                    N.repaired = round (a * pr') 
                                                                })
 
                                              





carRepair ::  Integer -> PLID.PersonnelInstanceDetails -> SqlTransaction Connection ()
carRepair uid pi = do  
            s <- liftIO $ milliTime 
            (pr' :: Double) <- loaddbConfig "car_repair_rate" 
            let ut = (min s $ PLID.task_end pi) - (PLID.task_updated pi)
            let sk = PLID.skill_repair pi 
            let sid = PLID.task_subject_id pi 
            atomical $ do 
                    c' <- load sid :: SqlTransaction Connection (Maybe CIP.CarInstanceParts)
                    when (isNothing c') $ rollback "cannot find car instance parts"
                    let c = fromJust c' 
                    g' <- load (CIP.part_instance_id c) :: SqlTransaction Connection (Maybe PI.PartInstance)
                    when (isNothing g') $ rollback "cannot find part instance"
                    let p = fromJust g'
                    let a = fromIntegral (sk * ut)
                    void $ save (p {
                                            PI.wear = max 0 $ PI.wear p - round (a * pr')
                                        })
                    when (PLID.task_end pi < s) $  do 
                            stopTask (fromJust $ PLID.personnel_instance_id pi) uid
                            void $ N.sendCentralNotification uid (N.partRepair {
                                                                    N.part_id = convert $ PI.part_id p,
                                                                    N.repaired = round (a * pr') 
                                                                })
                                                 





-- TODO: car actions (on select) ?

racePractice :: Application ()
racePractice = do

        uid <- getUserId
        xs <- getJson >>= scheck ["track_id"]
        let tid = extract "track_id" xs :: Integer

        rid <- runDb $ do

            userActions uid

            a <-  aload uid (rollback "you dont exist, go away") :: SqlTransaction Connection A.Account
            am <- aload uid (rollback "profile not found") :: SqlTransaction Connection APM.AccountProfileMin

            -- TODO: check track level
            -- TODO: check user busy

            -- get active car
            g <-  aget ["account_id" |== toSql uid] (rollback "garage not found") :: SqlTransaction Connection G.Garage 
            c <-  fmap garageCarProps $ aget ["active" |== SqlBool True, "garage_id" |== (toSql $ G.id g)] (rollback "active car not found") :: SqlTransaction Connection CIG.CarInGarage
            cm <- fmap minimalCarProps $ aload (fromJust $ CIG.id c) (rollback "Active car minimal not found") :: SqlTransaction Connection CMI.CarMinimal

--            ry <- DBF.garage_active_car_ready (fromJust $ G.id g)
--                            case length ry > 0 of
--                                True -> rollback "your active car is not ready"
--                                False -> return ()
            
            let y = RaceParticipant a am c cm Nothing
            
            t <- liftIO milliTime 
            (rid, _) <- processRace t [y] tid 
            
            return rid

        -- write results
        writeResult rid

testWrite :: Application ()
testWrite = do
        uid <- getUserId
        writeResult' $ AS.toJSON $ HM.fromList [("bla" :: LB.ByteString, AS.toJSON (1::Integer)), ("foo", AS.toJSON $ HM.fromList [("bar" :: LB.ByteString, 1 :: Integer)])]



raceChallenge :: Application ()
raceChallenge = raceChallengeWith 2 

raceChallengeWith :: Integer -> Application ()
raceChallengeWith p = do
        
        uid <- getUserId
        xs <- getJson -- >>= scheck ["track_id", "type"]
        -- challenger busy during race?? what if challenger already busy? --> active challenge sets user busy?
        -- what if challenger leaves city? disallow travel if challenge active? or do not care?
        tid :: Integer <- rextract "track_id" xs
        tp :: String <- rextract "type" xs
        amt :: Integer <- max 0 <$> case tp of
                "money" -> rextract "declare_money" xs
                _ -> return 0 

        i <- runDb $ do
            userActions uid
            Task.run Task.User uid
            a  <- aget ["id" |== toSql uid] (rollback "account not found") :: SqlTransaction Connection A.Account
            am <- aget ["id" |== toSql uid] (rollback "account min not found") :: SqlTransaction Connection APM.AccountProfileMin
            c  <- fmap garageCarProps $ aget ["account_id" |== toSql uid .&& "active" |== toSql True] (rollback "Active car not found") :: SqlTransaction Connection CIG.CarInGarage
            cm <- fmap minimalCarProps $ aload (fromJust $ CIG.id c) (rollback "Active car minimal not found") :: SqlTransaction Connection CMI.CarMinimal
            t  <- aget ["track_id" |== toSql tid, "track_level" |<= (SqlInteger $ A.level a), "city_id" |== (SqlInteger $ A.city a)] (rollback "track not found") :: SqlTransaction Connection TT.TrackMaster
            _  <- adeny ["account_id" |== SqlInteger uid, "deleted" |== SqlBool False] (rollback "you're already challenging") :: SqlTransaction Connection [Chg.Challenge]
            n  <- aget ["name" |== SqlString tp] (rollback "unknown challenge type") :: SqlTransaction Connection ChgT.ChallengeType

            me <- case amt > 0 of
                    True -> Just <$> Escrow.deposit uid amt
                    False -> return Nothing

            save $ (def :: Chg.Challenge) {
                    Chg.track_id = tid,
                    Chg.account_id = uid,
                    Chg.participants = p,
                    Chg.type = (fromJust $ ChgT.id n),
                    Chg.account_min = am,
                    Chg.car_min = cm,
                    Chg.amount = amt,
                    Chg.challenger = RaceParticipant a am c cm me,
                    Chg.deleted = False
                } 

            return True
        writeResult i


cons f = liftIO $ print f *> print "---"


raceChallengeAccept :: Application ()
raceChallengeAccept = do

        uid <- getUserId :: Application Integer
        xs <- getJson >>= scheck ["challenge_id"]
        

        let cid = extract "challenge_id" xs :: Integer 
        -- Change, had to break up to be able to send to the user. 
        -- This should be ok, it are only get actions 

        -- retrieve challenge
        chg <- runDb $ (aget ["id" |== toSql cid, "account_id" |<> toSql uid, "deleted" |== toSql False] (rollback "challenge not found") :: SqlTransaction Connection Chg.Challenge)
        chgt <- runDb $ do
                    c <- (aget ["id" |== (toSql $ Chg.type chg)] (rollback $ "challenge type not found for id " ++ (show $ Chg.type chg)) :: SqlTransaction Connection ChgT.ChallengeType)
                    return $ ChgT.name c



        rid <- runDb $ do
            -- TODO: get / search functions for track, user, car with task triggering
            
            userActions uid
            userActions $ rp_account_id $ Chg.challenger chg
            Task.run Task.User uid
            Task.run Task.User $ rp_account_id $ Chg.challenger chg

            -- pay race dues to escrow 
            me <- case (Chg.amount chg) > 0 of
                    True -> fmap Just $ Escrow.deposit uid $ Chg.amount chg
                    False -> return Nothing 

            cons "wunk"
            cons (me :: Maybe Integer)

            a  <- aget ["id" |== toSql uid] (rollback "account not found") :: SqlTransaction Connection A.Account
            am <- aget ["id" |== toSql uid] (rollback "account minimal not found") :: SqlTransaction Connection APM.AccountProfileMin
            c  <- fmap garageCarProps $ aget ["account_id" |== toSql uid .&& "active" |== toSql True] (rollback "Active car not found") :: SqlTransaction Connection CIG.CarInGarage
            cm <- fmap minimalCarProps $ aget ["id" |== (toSql $ CIG.id c)] (rollback "Active car minimal not found") :: SqlTransaction Connection CMI.CarMinimal

            cons a
            cons am
            cons c
            cons cm

            let y = RaceParticipant a am c cm me
          
            cons "wghr"
            cons y

            -- TODO: add user to accepts list
            -- when count(accepts) >= participants, start race
            -- fetch participants as array
            -- run race with array

            -- get participants
            let ps = [y, Chg.challenger chg]
            cons ps 
            -- delete challenge
            foo <- save $ chg { Chg.deleted = True }

            cons "kwun: " 
            cons foo
            
            -- process race
            t <- liftIO milliTime 
            (rid, rs) <- processRace t ps (Chg.track_id chg)

            cons "iwunk: " 
            cons rid

            let fin r = (t+) $ ceiling $ raceTime r 
            let t1 = (\(_,r) -> fin r) $ head rs
            let winner_id = rp_account_id $ fst $ head rs


            forM_ rs $ \(p,r) -> do
                cons "form" 

                let isWinner = (rp_account_id p) == winner_id
 
                -- task: transfer challenge objects
                case chgt of
                    "money" -> case rp_escrow_id p of
                            -- release money from escrow on winner finish
                            Just e -> do
                                case isWinner of
                                    True -> Task.escrowCancel t1 e
                                    False -> Task.escrowRelease t1 e winner_id 
                            Nothing -> return () 
                    "car" -> case isWinner of
                            -- transfer car ownership on winner finish
                            True -> return ()
                            False -> Task.transferCar t1 (rp_account_id p) winner_id (rp_car_id p)
                    otherwise -> rollback $ "challenge type not supported: " ++ chgt

            return rid

        let t = N.raceStart {
                    N.race_type = read $ chgt,
                    N.race_id = rid  

                }
        N.sendNotification uid t
        N.sendNotification (rp_account_id $ Chg.challenger chg) t 


        writeResult rid


processRace :: Integer -> [RaceParticipant] -> Integer -> SqlTransaction Connection (Integer, [(RaceParticipant, RaceResult)]) 
processRace t ps tid = do

        let env = defaultEnvironment
        trk <- trackDetailsTrack <$> (agetlist ["track_id" |== toSql tid] [] 1000 0 (rollback "track data not found") :: SqlTransaction Connection [TD.TrackDetails])
        tdt <- aget ["track_id" |== toSql tid] (rollback "track not found") :: SqlTransaction Connection TT.TrackMaster

        cons "pral"

         -- race participants
        let rs = List.sortBy (\(_,a) (_,b) -> compare (raceTime a) (raceTime b)) $ map (\p -> (p, runRaceWithParticipant p trk env)) ps
        cons "laap"

        cons rs

        -- current time, finishing times, race time (slowest finishing time) 
        let fin r = (t+) $ ceiling $ (1000 *) $ raceTime r  
        let te = (\(_,r) -> fin r) $ last rs

        -- save race data
        rid <- save $ (def :: R.Race) {
                    R.track_id = tid,
                    R.start_time = t,
                    R.end_time = te,
                    R.type = 1,
                    R.data = map (\(p,r) -> raceData p r) rs 
                }

        let winner_id = rp_account_id $ fst $ head rs

--        parN $ flip fmap rs $ \(p,r) -> do
        forM_ rs $ \(p,r) -> do
            
                let uid = rp_account_id p
                let ft = fin r
                let isWinner = uid == winner_id

                -- set account busy until user finish
                update "account" ["id" |== toSql uid] [] [("busy_until", toSql ft), ("busy_subject_id", toSql rid), ("busy_type", SqlInteger 2)]

                -- task: update race time on user finish
                Task.trackTime ft tid uid (raceTime r)

                -- generate race rewards
                rew <- getReward isWinner -- TODO: extend function; different rewards for practice etc.

                -- task: grant rewards on user finish
                taskRewards ft uid rew rid

                -- store rewards for retrieval after user finish
                save (def :: RWD.RaceReward) { RWD.account_id = uid, RWD.race_id = rid, RWD.time = ft, RWD.rewards = rew }

                -- store user race report -- TODO: determine relevant information
                RP.report RP.Race uid ft $ mkData $ do
                    set "track_id" tid
                    set "race_id" rid
                    set "start_time" t
                    set "finish_time" ft
                    set "race_time" $ raceTime r
                    set "track_data" tdt
                    set "participant" p
                    set "result" r
                    set "rewards" rew

        -- return race id
        return (rid, rs)
       
-- TODO: this function is not finished.
getReward :: Bool -> SqlTransaction Connection RaceRewards
getReward w = do
        pt <- aget [] (rollback "reward part details not found") :: SqlTransaction Connection PD.PartDetails
        let wr = RaceRewards 0 20 [pt] 
        let br = RaceRewards 0 5 []
        case w of
            True -> return $ br + wr
            False -> return br

taskRewards :: Integer -> Integer -> RaceRewards -> Integer -> SqlTransaction Connection () 
taskRewards t u r d = void $ do
        unless ((==0) $ respect r) $ Task.giveRespect t u $ respect r
        unless ((==0) $ money r) $ Task.giveMoney t u (money r) "race" d
        forM_ (parts r) $ \p -> Task.givePart t u $ fromJust $ PD.id p 

searchRaceChallenge :: Application ()
searchRaceChallenge = do
        ((l,o), xs) <- getPagesWithDTD (
                    "deleted" +==| (SqlBool False)
                +&& "challenge_id" +== "challenge_id"
                +&& "track_id" +== "track_id"
                +&& "city_id" +== "city_id"
                +&& "continent_id" +== "continent_id"
                +&& "track_level" +>= "min_level"
                +&& "track_level" +<= "max_level"
                +&& "account_id" +<> "not_account_id"
                +&& "account_id" +== "account_id"
                +&& "type" +== "type"
            )
        cs <- runDb $ search xs [] l o :: Application [ChgE.ChallengeExtended]
        writeMapables cs

raceSearch :: Application ()
raceSearch = do
        ((l,o),xs) <- getPagesWithDTD ("race_id" +== "race_id")
        rs <- runDb $ (search xs [] l o) :: Application [RAD.RaceDetails]
        writeMapables rs


raceDetails :: Integer -> SqlTransaction Connection (RAD.RaceDetails, [TD.TrackDetails], TT.TrackMaster)
raceDetails rid = do
        r <- aget ["race_id" |== toSql rid] (rollback "race not found") :: SqlTransaction Connection RAD.RaceDetails 
        Task.run Task.Track $ RAD.track_id r
        td <- search ["track_id" |== (SqlInteger $ RAD.track_id r)] [] 1000 0 :: SqlTransaction Connection [TD.TrackDetails]
        ts <- aget ["track_id" |== (SqlInteger $ RAD.track_id r)] (rollback "track data not found for race") :: SqlTransaction Connection TT.TrackMaster 
        return (r, td, ts) 
 
getRaceDetails :: Application ()
getRaceDetails = do
        xs <- getJson
        rid :: Integer <- rextract "race_id" xs
        (dat, ts, td) <- runDb $ raceDetails rid
        writeResult' $ AS.toJSON $ HM.fromList [("race" :: LB.ByteString, AS.toJSON dat), ("track_sections", AS.toJSON ts), ("track_data", AS.toJSON td)]

userCurrentRace :: Application ()
userCurrentRace = do
        uid <- getUserId
        (r, td, ts) <- runDb $ do
            a <- aget ["id" |== toSql uid] (rollback "you dont exist, go away") :: SqlTransaction Connection A.Account
            raceDetails $ A.busy_subject_id a
        writeResult' $ AS.toJSON $ HM.fromList [("race" :: LB.ByteString, AS.toJSON r), ("track_sections", AS.toJSON ts), ("track_data", AS.toJSON td)]


searchTournamentCar :: Application ()
searchTournamentCar = do 
        uid <- getUserId 
        xs <- getJson >>= scheck ["tournament_id"]  
        ts <- runDb $ do 
                let ts = updateHashMap xs (def :: TP.TournamentPlayer)
                trn <- load (fromJust $ TP.tournament_id ts)  :: SqlTransaction Connection (Maybe Tournament)
                when (isNothing trn) $ rollback "no such tournament"

                let car_id = TR.car_id $ fromJust trn 
                case car_id of 
                    Nothing -> fmap (map garageCarProps) $ search ["account_id" |== (toSql uid)] [] 100 0 ::  SqlTransaction Connection [CIG.CarInGarage]
                    Just x -> fmap (map garageCarProps) $ search ["account_id" |== (toSql uid) .&& "car_id" |== (toSql x)] [] 100 0 :: SqlTransaction Connection [CIG.CarInGarage]
        writeMapables ts 


searchRaceReward :: Application ()
searchRaceReward = do
        t <- liftIO milliTime
        uid <- getUserId
        ((l,o), xs) <- getPagesWithDTD (
                    "time" +<=| (SqlInteger t)
                +&& "account_id" +==| (SqlInteger uid)
                +&& "race_id" +== "race_id" 
            )
        rs <- runDb $ search xs [] l o :: Application [RWD.RaceReward]
        writeMapables rs

milliTime :: IO Integer
milliTime = floor <$> (*1000) <$> getPOSIXTime :: IO Integer

secondTime :: IO Integer
secondTime = floor <$> getPOSIXTime :: IO Integer


serverTime :: Application ()
serverTime = do
        t <- liftIO milliTime
        writeResult t

viewTournament :: Application ()
viewTournament = do
        uid <- getUserId 
        a <- runDb $ fromJust <$> (load uid :: SqlTransaction Connection (Maybe A.Account))

        (((l, o), xs),od) <- getPagesWithDTDOrdered ["minlevel","maxlevel", "track_id", "costs", "car_id", "name", "id","players"] (
            "id" +== "tournament_id" +&& 
            "minlevel" +<=| (toSql $ A.level a) +&& 
            "maxlevel" +>=| (toSql $ A.level a) +&& 
            "minlevel" +>= "minlevel" +&& 
            "maxlevel" +>= "maxlevel" +&& 
            "name" +%% "name" +&& 
            "track_id" +== "track_id" +&& 
            "players" +>= "minplayers" +&& 
            "players" +<= "maxplayers" +&&
            "city" +==| (toSql $ A.city a) 

            )

        ys <- runDb $ search xs od l o :: Application [TRMEx.TournamentExtended]

        writeMapables ys  

cancelTournamentJoin :: Application ()
cancelTournamentJoin = do 
                    uid <- getUserId 
                    xs <- getJson >>= scheck ["tournament_id"] 
                    runDb $ do 
                        xs <- search ["deleted" |== (toSql False) .&& "account_id" |== (toSql uid) .&& "tournament_id" |== (toSql $ HM.lookup "tournament_id" xs)] [] 1 0 :: SqlTransaction Connection [TP.TournamentPlayer]
                        case xs of 
                            [a] -> void $ save (a {TP.deleted = True})
                            [] -> return () 
                    writeResult (1 :: Int) 

tournamentJoined :: Application ()
tournamentJoined = do 
                    uid <- getUserId 
                    ps <- runDb $ do 
                        xs <- search ["account_id" |== toSql uid .&& "deleted" |== (toSql False)] [] 1000 0 :: SqlTransaction Connection [TP.TournamentPlayer] 
                        ss <- forM xs $ \(TP.tournament_id -> i) -> load (fromJust i) :: SqlTransaction Connection (Maybe TRM.Tournament) 
                        return (catMaybes ss)
                    writeMapables ps 

                                

tournamentResults :: Application ()
tournamentResults = do 
        uid <- getUserId 
        xs <- getJson >>= scheck ["tournament_id"] 
        let b = updateHashMap xs (def :: TP.TournamentPlayer) 
        liftIO $ print (TP.tournament_id b)
        ys <- runDb $ getResults (fromJust $ TP.tournament_id b)  
        writeMapables ys 

tournamentPlayers :: Application () 
tournamentPlayers = do 
        uid <- getUserId 
        xs <- getJson >>= scheck ["tournament_id"] 
        let b = updateHashMap xs (def :: TP.TournamentPlayer)
        ys <- runDb $ getPlayers (fromJust $ TP.tournament_id b )
        writeResult ys 

tournamentJoin :: Application ()
tournamentJoin = do 
    uid <- getUserId
    xs <- getJson >>= scheck ["car_instance_id", "tournament_id"] 
    let b = updateHashMap xs (def :: TP.TournamentPlayer) 
    runDb $ joinTournament (fromJust $ TP.car_instance_id b) (fromJust $ TP.tournament_id b) uid 
    writeResult (1 :: Int)

{-- till here --}
wrapErrors g x = when g (void $ runDb (forkSqlTransaction $ Task.run Task.Cron 0 >> return ())) >>  CIO.catch (CIO.catch x (\(UserErrorE s) -> writeError s)) (\(e :: SomeException) -> writeError (show e))


userNotification :: Application ()
userNotification = do 
                uid <- getUserId 
                xs <- checkMailBox uid 
                writeMapables xs 

testNotification :: Application ()
testNotification = do 
            uid <- getUserId 
            void $ sendLetter uid (def {
                        Not.ttl = Just 100000,
                        Not.message = "Hello user",
                        Not.title = "I am a faggot"
                                })


archiveNotification :: Application ()
archiveNotification = do 
            uid <- getUserId 
            xs <- getJson 
            let ps = updateHashMap xs (def :: Not.PreLetter)
            case Not.id ps of 
                Nothing -> internalError "no such notification"
                Just a -> setArchive  uid a *> writeResult True  

readNotification :: Application ()
readNotification = do 
            uid <- getUserId 
            xs <- getJson 
            let ps = updateHashMap xs (def :: Not.PreLetter)
            case Not.id ps of 
                Nothing -> internalError "no such notification"
                Just a -> setRead  uid a *> writeResult True  

tournamentReport :: Application ()
tournamentReport = do 
            uid <- getUserId 
            (((l,o),xs),od) <- getPagesWithDTDOrdered ["id", "created"] (
                        "tournament_id" +== "tournament_id" +&&
                        "id" +== "id" +&&
                        "created" +>= "created-min" +&&
                        "created" +<= "created-max" +&&
                        "account_id" +==| (toSql uid)
                    )
            rs <- runDb $ search xs od l o :: Application [TRP.TournamentReport] 
            writeMapables rs
readArchive :: Application ()
readArchive = do 
        uid <- getUserId 
        (((l,o), xs),od) <- getPagesWithDTDOrdered ["sendat", "title", "id", "read", "archive"] (
                    "message" +%% "message" +&&
                    "title" +%% "title" +&& 
                    "sendat" +>= "sendat-min" +&& 
                    "sendat" +<= "sendat-max" +&&
                    "id" +== "id" +&&
                    "from" +== "from" +&& 
                    "archive" +== "archive" +&& 
                    "read" +== "read" +&& 
                    "to" +==| (toSql uid)
                    )

        ys <- runDb $ search xs od l o :: Application [Not.PreLetter]
        writeMapables ys 


instantiateCar :: Integer -> Integer -> SqlTransaction Connection Integer
instantiateCar mid uid = do

        g <- aget ["account_id" |== toSql uid] (rollback "Garage not found") :: SqlTransaction Connection G.Garage 
        m <- aget ["id" |== toSql mid] (rollback "car model not found") :: SqlTransaction Connection CM.CarMarket 
                
        -- if user has no active car, the new car will be active 
        as <- search ["garage_id" |== toSql (G.id g), "active" |== toSql True] [] 1 0 :: SqlTransaction Connection [CarInstance.CarInstance]
        let act = case as of
                [] -> True
                otherwise -> False

        cid <- save ((def :: CarInstance.CarInstance) {
                CarInstance.garage_id =  G.id g,
                CarInstance.car_id = mid,
                CarInstance.active = act 
            }) :: SqlTransaction Connection Integer
                
        -- Part loader 
        pts <- search ["car_id" |== (toSql $ CM.id m)] [] 1000 0 :: SqlTransaction Connection [CSP.CarStockPart]

        let step z part = do 
            save (def {
                    PI.part_id = fromJust $ CSP.id part,
                    PI.car_instance_id = Just cid,
                    PI.account_id = uid,
                    PI.deleted = False 
                })
            return ()

        foldM_ step () pts

        return cid

userClaimFreeCar :: Application ()
userClaimFreeCar = do
        uid <- getUserId
        xs <- getJson >>= scheck ["car_model_id"]
        let mid = extract "car_model_id" xs :: Integer

        -- get records and set free_car to false
        m <- runDb $ do
            m <- aget ["id" |== toSql mid, "level" |== toSql (1 :: Integer)] (rollback "car cannot be claimed") :: SqlTransaction Connection CM.CarMarket 
            aget ["id" |== toSql uid, "free_car" |== toSql True] (rollback "you may not claim a free car") :: SqlTransaction Connection A.Account
            update "account" ["id" |== toSql uid] [] [("free_car", toSql False)]
            return m
        
        -- create new car in user's garage
        runDb $ instantiateCar mid uid

{-
        -- create car in user's garage; create stock parts in car
        runDb $ do

            cid <- save ((def :: CarInstance.CarInstance) {
                    CarInstance.garage_id =  G.id g,
                    CarInstance.car_id = mid
                }) :: SqlTransaction Connection Integer
                
            pts <- search ["car_id" |== toSql mid] [] 1000 0 :: SqlTransaction Connection [CSP.CarStockPart]

            let step z part = do 
                save (def {
                        PI.part_id = fromJust $ CSP.id part,
                        PI.car_instance_id = Just cid,
                        PI.account_id = uid,
                        PI.deleted = False 
                    })
                return ()

            foldM_ step () pts
    -}        
        writeResult ("You have received a free car" :: String)


reportIssue :: Application ()
reportIssue = do 
        xs <- getJson 
        uid <- getUserId 
        let b = updateHashMap xs (def :: SUP.Support)
        runDb $ save (b { SUP.account_id = uid })
        writeResult (1 :: Integer)

------------------------------------------------------------------------------
-- | The application's routes.
routes :: Bool ->  [(C.ByteString, Handler App App ())]
routes g = fmap (second (wrapErrors g)) $ [ 
                ("/", index),
                ("/User/login", userLogin),
                ("/User/register", userRegister),
                ("/User/data", userData),
                ("/User/me", userMe),
                ("/User/notification", userNotification),
                ("/User/readNotification", readNotification), 
                ("/User/archiveNotification", archiveNotification), 
                ("/User/searchNotification", readArchive),
                ("/User/testNotification", testNotification),
                ("/User/currentRace", userCurrentRace),
                ("/User/addSkill", userAddSkill),
                ("/User/claimFreeCar", userClaimFreeCar),
                ("/Market/manufacturer", marketManufacturer),
                ("/Market/model", marketModel),
                ("/Market/buy", marketBuy),
                ("/Market/sell", marketSell),
                ("/Market/return", marketReturn),
                ("/Market/parts", marketParts),
                ("/Market/buyCar", carMarketBuy),
                ("/Market/cars", marketCars),
                ("/Garage/car", garageCar),
                ("/Car/model", loadModel),
                ("/Car/trash", carTrash),
                ("/Game/template", loadTemplate),
                ("/Game/tree", loadMenu),
                ("/Garage/parts", garageParts),
                ("/Market/allowedParts", marketAllowedParts),
                ("/Market/place", marketPlace),
                ("/Market/trash", marketTrash),
                ("/Market/buySecond", marketPlaceBuy),
                ("/Market/reports", shoppingReports),
                ("/Car/buy", carBuy),
                ("/Car/parts", carParts),
                ("/Car/part", carPart),
                ("/Car/sell", carSell),
                ("/Car/activate", carActivate),
                ("/Car/deactivate", carDeactivate),
                ("/Car/uploadImage", uploadCarImage),
                ("/Car/image", downloadCarImage),
                ("/Car/getOptions", carGetOptions),
                ("/Car/setOptions", carSetOptions),
                ("/Market/returnCar", carReturn),
                ("/Market/carParts", marketCarParts),
                ("/Garage/addPart", addPart),
                ("/Garage/removePart", removePart),
                ("/Garage/personnel", garagePersonnel),
                ("/Garage/reports", garageReports),
                ("/Garage/activeCar", garageActiveCar),
                ("/Market/personnel", marketPersonnel),
                ("/Personnel/hire", hirePersonnel),
                ("/Personnel/fire", firePersonnel),
                ("/Part/tasks", partTasks),
                ("/Garage/carReady", garageCarReady),
                ("/Garage/activeCarReady", garageActiveCarReady),
                ("/Personnel/train", trainPersonnel),
                ("/Personnel/task", taskPersonnel),
                ("/Personnel/cancelTask", cancelTaskPersonnel),
                ("/Personnel/reports", personnelReports),
                ("/Continent/list", continentList),
                ("/City/list", cityList),
                ("/City/travel", cityTravel),
                ("/Travel/reports", travelReports),
                ("/Track/list", trackList),
                ("/Track/here", trackHere),
                ("/User/reports", userReports),
                ("/Test/write", testWrite),
                ("/Race/challenge", raceChallenge),
                ("/Race/challengeAccept", raceChallengeAccept),
                ("/Race/challengeGet", searchRaceChallenge),
                ("/Race/practice", racePractice),
                ("/Race/reward", searchRaceReward),
                ("/Race/reports", searchReports RP.Race),
                ("/Race/details", getRaceDetails),
                ("/Race/search", raceSearch),
                ("/Time/get", serverTime),
                ("/Tournament/get", viewTournament),
                ("/Tournament/join", tournamentJoin),
                ("/Tournament/car", searchTournamentCar),
                ("/Tournament/result", tournamentResults),
                ("/Tournament/joined", tournamentJoined),
                ("/Tournament/cancel", cancelTournamentJoin),
                ("/Tournament/idk", tournamentPlayers),
                ("/Tournament/report", tournamentReport),
                ("/Support/send", reportIssue) 
          ]

initAll po = Task.initTask *> initTournament po  

------------------------------------------------------------------------------
-- | The application initializer.
app :: Bool -> SnapletInit App App
app g = makeSnaplet "app" "An snaplet example application." Nothing $ do
    c <- nestSnaplet "conf" config $ initConfig "resources/server.ini"
    db <- nestSnaplet "sql" db $ initSqlTransactionSnaplet "resources/server.ini"
    rnd <- nestSnaplet "random" rnd $ initRandomSnaplet l32 
    addRoutes (routes g)
    dst <- nestSnaplet "nde" nde $ initDHTConfig "resources/server.ini"
    s <- liftIO $ newEmptyMVar 
    notfs <- nestSnaplet "notf" notf $ initNotificationSnaplet db (Just s) 
    p <- liftIO $ takeMVar s 
    liftIO $ initAll p 
    return $ App db c rnd dst notfs 

