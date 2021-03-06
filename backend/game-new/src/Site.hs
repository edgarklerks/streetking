{-# LANGUAGE OverloadedStrings, FlexibleContexts, RankNTypes, ScopedTypeVariables, ViewPatterns, ImplicitParams, MultiParamTypeClasses #-}
------------------------------------------------------------------------------
--
-- | This module is where all the routes and handlers are defined for your
-- site. The 'app' function is the initializer that combines everything
-- together and is exported by this module.
module Site
  ( Site.app
  ) where

{-- Change log 
- EDGAR: Added unset immutable flag to cancelTournamentJoin
- EDGAR: Added set and unset immutable flag to challenge
- EDGAR: Added immutable predicate to buy and sell functions 
- EDGAR: personnelLock is a top-level TVAR should be inside a snaplet
---}
------------------------------------------------------------------------------
------------------------------------------------------------------------------



import           Prelude hiding (take, drop)
import           Application
import           ConfigSnaplet 
import           Control.Applicative
import           Control.Arrow 
import           Control.Concurrent 
import           Control.Concurrent.STM 
import           Control.Monad hiding (join)
import           Control.Monad.Random 
import           Control.Monad.Trans
import           Data.Car
import           Data.Function
import           Data.CarDerivedParameters
import           Data.ComposeModel
import           Data.Constants
import           Data.Conversion hiding (project)
import           Data.Convertible
import           Data.DataPack
import           Data.Database hiding (select)
import           Data.DatabaseTemplate
import           Data.Decider 
import           Data.Driver
import           Data.Environment
import           Data.Event 
import           Data.Hstore
import           Data.Maybe
import           Data.Monoid
import           Data.RaceParticipant
import           Data.RaceReward
import           Data.RacingNew
import           Data.Reward 
import           Data.Section
import           Data.SqlTransaction
import           Data.String
import           Data.Tiger
import           Data.Time.Clock 
import           Data.Time.Clock.POSIX
import           Data.Tools hiding (join)
import           Data.Tournament 
import           Data.Track
import           Database.HDBC (toSql, fromSql)
import           Debug.Trace
import           GHC.Exception (SomeException)
import           Model.General (Mapable(..), Default(..), Database(..), aload, adeny, aget, agetlist)
import           Model.Transaction (transactionMoney)
import           NodeSnapletTest 
import           NotificationSnaplet (initNotificationSnaplet, getPostOffice)
import           RandomSnaplet (l32, initRandomSnaplet)
import           Snap.Core
import           Snap.Snaplet
import           Snap.Util.FileServe
import           Snap.Util.FileUploads
import           SqlTransactionSnaplet (initSqlTransactionSnaplet)
import           System.Directory
import           System.FilePath.Posix
import           System.IO.Unsafe 
import qualified Config.ConfigFileParser as Config
import qualified Control.Monad.CatchIO as CIO
import qualified Data.Aeson as AS 
import qualified Data.ByteString.Char8 as C
import qualified Data.ByteString.Lazy as LB
import qualified Data.ByteString.Lazy.Char8 as LBC
import qualified Data.CarReady as CR
import qualified Data.Foldable as F
import           Data.HeartBeat 
import qualified Data.HashMap.Strict as HM
import qualified Data.InRules as IR
import qualified Data.List as List
import qualified Data.MenuTree as MM 
import qualified Data.Set as Set 
import qualified Data.Task as Task
import qualified Data.Text as T 
import qualified Data.Text.Encoding as T
import qualified Data.Tree as T
import           Data.Relation
import qualified LockSnaplet as SL 
import           LogSnaplet (initLogSnaplet)
import qualified Model.Account as A 
import qualified Model.AccountProfile as AP 
import qualified Model.AccountProfileMin as APM
import qualified Model.Car as Car 
import qualified Model.Car3dModel as C3D
import qualified Model.CarInGarage as CIG 
import qualified Model.CarInstance as CarInstance 
import qualified Model.CarInstanceParts as CIP
import qualified Model.CarMarket as CM 
import qualified Model.CarMinimal as CMI 
import qualified Model.CarOptions as CO
import qualified Model.CarOptionsExtended as COE
import qualified Model.CarOwners as COW
import qualified Model.CarStockParts as CSP
import qualified Model.Challenge as Chg
import qualified Model.ChallengeAccept as ChgA
import qualified Model.ChallengeExtended as ChgE
import qualified Model.ChallengeType as ChgT
import qualified Model.City as City
import qualified Model.Config as CFG 
import qualified Model.Continent as Cont 
import qualified Model.Diamonds as DM 
import qualified Model.Escrow as Escrow
import qualified Model.EventStream as ES 
import qualified Model.Functions as DBF
import qualified Model.Garage as G 
import qualified Model.GarageParts as GPT 
import qualified Model.GarageReport as GRP
import qualified Model.GarageReportInsert as GRPI
import qualified Model.GeneralReport as GR 
import qualified Model.Manufacturer as M 
import qualified Model.ManufacturerMarket as MAM 
import qualified Model.MarketCarInstanceParts as MCIP
import qualified Model.MarketItem as MI 
import qualified Model.MarketPartType as MPT
import qualified Model.MarketPlace as MP
import qualified Model.MarketPlaceCar as MPC
import qualified Model.MenuModel as MM 
import qualified Model.Mission as Mission 
import qualified Model.MissionUser as MissionUser 
import qualified Model.Part as Part 
import qualified Model.PartDetails as PD 
import qualified Model.PartInstance as PI 
import qualified Model.PartMarket as PM 
import qualified Model.PartMarketPlaceType as PMPT
import qualified Model.PartMarketType as PMT
import qualified Model.PartType as PT 
import qualified Model.Personnel as PL
import qualified Model.PersonnelDetails as PLD
import qualified Model.PersonnelInstance as PLI
import qualified Model.PersonnelInstanceDetails as PLID
import qualified Model.PersonnelReport as PR 
import qualified Model.PersonnelTaskType as PTT 
import qualified Model.PreLetter as Not 
import qualified Model.Race as R
import qualified Model.RaceDetails as RAD
import qualified Model.RaceReward as RWD
import qualified Model.Report as RP 
import qualified Model.RewardLog as RL 
import qualified Model.RewardLogEvent as RLE 
import qualified Model.Rule as Rule 
import qualified Model.ShopReport as SR 
import qualified Model.Support as SUP 
import qualified Model.Tournament as TR 
import qualified Model.Tournament as TRM 
import qualified Model.TournamentExtended as TRMEx
import qualified Model.TournamentPlayers as TP 
import qualified Model.TournamentReport as TRP 
import qualified Model.TournamentResult as TMR 
import qualified Model.TrackCity as TCY
import qualified Model.TrackContinent as TCN
import qualified Model.TrackDetails as TD
import qualified Model.TrackMaster as TT
import qualified Model.TrackTime as TTM
import qualified Model.Transaction as Transaction
import qualified Model.TravelReport as TR 
import qualified Notifications as N 
import qualified Data.Role as Role 

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

        -- TODO: nice error messages. also unique email address from database, add a check here.

        scfilter x [("email", email), ("password", minl 6), ("nickname", minl 3 `andcf` maxl 16)]
        i <- runDb $ do 
            p <- aget ["id" |== SqlInteger 0] (rollback "Account prototype not found") :: SqlTransaction Connection A.Account
            let m = updateHashMap x p 
            let c = m { A.id = Nothing, A.password = tiger32 $ C.pack (A.password m) `mappend` salt }
            let g = def :: G.Garage  
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
            addRole (Role.User $ convert $ A.id user) k 
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
                    xs <- searchCarMinified ["account_id" |== toSql (APM.id m) .&& "active" |== toSql True] [] 1 0 :: SqlTransaction Connection [CMI.CarMinimal]
                    
                    case xs of 
                        [] -> return Nothing
                        [x] -> return (Just x)
    writeResult n 

userMe :: Application ()
userMe = do 
    x <- getUserId
    n <- runDb $ do 
            userActions x
            DBF.account_update_energy x 
            p <- (load x) :: SqlTransaction Connection (Maybe AP.AccountProfile)
            return p
    case n of 
        Nothing -> internalError "You do not exist, kbye"
        Just x -> writeMapable x

loadMenu :: Application ()
loadMenu = do 
    mt <- getOParam "tree_type"
    n <- runDb (search ["menu_type" |== (toSql mt) ] [Order ("number", []) True] 1000 0) :: Application [MM.MenuModel] 
    writeResult  (AS.toJSON (MM.fromFlat (convert n :: MM.FlatTree)))

marketPlace :: Application ()
marketPlace = do 
           uid <- getUserId
           puser <- fromJust <$> runDb (load uid) :: Application (A.Account )
           ((l, o), xs) <- getPagesWithDTD (
                    "level" +<= "level-max" +&& 
                    "level" +>= "level-min" +&& 
                    "name" +== "part_type" +&& 
                    "price" +<= "price-max" +&&
                    "price" +>= "price-min" +&&

                    "weight" +<= "weight-max" +&&
                    "weight" +>= "weight-min" +&&
                    "manufacturer_name" +== "manufacturer_name" +&&

                    ifdtd "unique" (=="1")
                        ("unique" +==| (toSql True))
                        ("unique" +== "unique") +&&

                    ifdtd "used" (=="1")
                        ("wear" +<= "wear-max" +&& "wear" +>= "wear-min" +&& "wear" +>| (SqlInteger 0))
                        ("wear" +<= "wear-max" +&& "wear" +>= "wear-min") +&&

                    ifdtd "improved" (=="1")
                        ("improvement" +<= "improvement-max" +&& "improvement" +>= "improvement-min" +&& "improvement" +>| (SqlInteger 0))
                        ("improvement" +<= "improvement-max" +&& "improvement" +>= "improvement-min") +&&

--                    "car_id" +== "car_id" +&&  
                    ifdtd "anycar" (=="1")
                        ("car_id" +== "car_id" +|| "car_id" +==| toSql (0 :: Integer))
                        ("car_id" +== "car_id") +&& 

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
      ((l,o),xs) <- getPagesWithDTD ("manufacturer_id" +== "manufacturer_id" +&& "id" +== "id")
      ns <- runDb (search (ctr:xs) [] l o) :: Application [CM.CarMarket]
      writeMapables ns

marketCarPrototype :: Application ()
marketCarPrototype = do 
      uid <- getUserId
      puser <- fromJust <$> runDb (load uid) :: Application (A.Account )
      let ctr = ("level" |<= (toSql $ A.level puser)) 
      ((l,o),xs) <- getPagesWithDTD (
                  "manufacturer_id" +== "manufacturer_id"
              +&& "id" +== "id"
              +&& "car_id" +== "car_id"
              +&& "prototype" +==| toSql True
              +&& "prototype_available" +==| toSql True
              +&& "prototype_claimable" +== "prototype_claimable"
          )
      ns <- runDb (searchCarInGarage (ctr:xs) [] l o)
      writeMapables ns

marketAllowedParts :: Application ()
marketAllowedParts = do 
    xs <- getJson 
    uid <- getUserId 
    let d = updateHashMap xs (def :: MPT.MarketPartType)
    p <- runDb $ do 
            x <- fromJust <$> load uid :: SqlTransaction Connection A.Account 
    	    n <- (search ["menu_type" |== (toSql ("market_tabs" :: String)) .&& "module" |== (toSql ("PARTS" :: String)) ] [Order ("number", []) True] 1000 0) :: SqlTransaction Connection [MM.MenuModel] 
    	    xs <- forM n $ \p -> do 
                   search ["car_id" |== (toSql $ MPT.car_id d) .&& "level" |<= (toSql $ A.level x) .&& "name" |== (toSql $ MM.label p)] [Order ("sort_part_type",[]) True] 1000 0 :: SqlTransaction Connection [MPT.MarketPartType]
	    return (concat xs)
    writeResult (AS.toJSON $ MM.mkTabs "PARTS" (fmap MPT.name p))

marketBuy :: Application ()
marketBuy = do 
    uid <- getUserId 
    xs <- getJson 
    tpsx <- runDb $ milliTime 
    
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

{--
evalLua x xs = do 
            p <- rl 
            case p of 
                Left e -> internalError e
                Right (a, p) -> return a
    where rl = liftIO $ runLua $ do 
                        forM_ xs (uncurry saveLuaValue)
                        eval x
                        peekGlobal "res"
            --}

-- Second hand shop 
marketSell :: Application ()
marketSell = do 
            uid <- getUserId 
            xs <- getJson >>= scheck ["price", "part_instance_id"]
            let d = updateHashMap xs (def :: MI.MarketItem)
            prg <- loadConfig "market_fee"
            let x = max 100 $ (fromIntegral (MI.price d) * 0.10)
{--            x <- evalLua prg [
                          ("price", LuaNum (fromIntegral $ MI.price d))
                          ]
                          --}
            -- -5.6 -> -5
            -- floor -5.6 -> -6
            -- ceil -5.6 -> -5
            --
            pts uid d (floor (x :: Double)) 
            writeResult True 
    where pts uid d fee = runDb $ dbWithLockNonBlock "marketparts-sell" uid $ do 
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
        let mid = extract "id" xs

        cid <- runDb $ do

            -- create car in user's garage
            cid <- instantiateCar mid uid

            -- get car model
            car <- getCarInGarage ["id" |== toSql mid, "prototype" |== toSql True, "prototype_available" |== toSql True] (rollback "Car prototype not found")
        
            -- create shopping report
            reportShopper uid (def {
                    SR.amount = abs(CIG.total_price car),
                    SR.car_instance_id =  Just cid,
                    SR.report_descriptor = "shop_car_buy"
                })

            -- make payment
            transactionMoney uid (def {
                    Transaction.amount = - abs(CIG.total_price car),
                    Transaction.type = "car_instance",
                    Transaction.type_id = CIG.car_id car
                })

            return cid

        writeResult ("You succesfully bought the car" :: String)

carReturn :: Application ()
carReturn = do 
        uid <- getUserId 
        xs <- getJson >>= scheck ["car_instance_id"]
        let d = updateHashMap xs (def :: MI.MarketItem)
        p uid d
        writeResult ("Your car is returned to your garage" :: String)
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

    let fee = min 100 $ (fromIntegral (MI.price d) * 0.10)
        {-- 
    fee <- evalLua prg [
            ("price", LuaNum (fromIntegral $ MI.price d))
            ]
 --}
    p uid d (fee :: Double)
    writeResult ("You car is in the market place" :: String)
 where p uid d (fromIntegral . floor -> fee) = runDb $ do
                cig <- load (fromJust $ MI.car_instance_id d) :: SqlTransaction Connection (Maybe CIG.CarInGarage)
                case cig of 
                    Nothing -> rollback "no such car"
                    Just car -> do 
                        b <- CarInstance.isMutable (fromJust $ MI.car_instance_id d)
                        when (not b) $ rollback "Car is used in a tournament or race; cannot sell car."
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
                        
                                         

finishImprovement :: Application ()
finishImprovement = do 
        uid <- getUserId 
        runDb $ do 
            am <- loaddbConfig "finish_improvement_cost"
            DM.transactionDiamonds uid (def {
                        DM.amount = am,
                        DM.type = "finish improvement",
                        DM.type_id = 0
                    })
        return ()




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
                        b  <- CarInstance.isMutable (fromJust $ CIG.id d)
                        when (not b) $ rollback "car is in a tournament or race; cannot be sold"
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
    gid <- getUserGarageId
    xs <- getJson >>= scheck ["id"]
    let cid = extract "id" xs :: Integer
    rs <- runDb $ do
            -- update actions
            let ?name = "garageCarReady"
            personnelUpdate uid
            -- check if user owns the car
            aget ["garage_id" |== toSql gid] (rollback "Car not found in garage") :: SqlTransaction Connection CarInstance.CarInstance
            -- get result
            CR.carReady cid
    writeResult rs 

            
garageActiveCarReady :: Application ()
garageActiveCarReady = do 
    uid <- getUserId 
    gid <- getUserGarageId
    rs <- runDb $ do
            -- update actions
            let ?name = "garageActiveCarReady"
            personnelUpdate uid
            -- get user active car 
            ac <- aget ["garage_id" |== toSql gid, "active" |== toSql True] (rollback "Active car not found") :: SqlTransaction Connection CarInstance.CarInstance
            -- get result
            CR.carReady $ fromJust $ CarInstance.id ac
    writeResult rs 

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
        tpsx <- runDb $ milliTime 
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
                "manufacturer_name" +== "manufacturer_name" +&& 
                     ifdtd "me" (=="1") 
                                ("account_id" +==| toSql uid) 
                                ("account_id" +<>| toSql uid +&& 
                                    "level" +<=| (toSql $ A.level puser)
                                    )
                    )
    -- TODO: single integrated detailed car instance type
    ns <- runDb $ do
            ns <- search xs [] l o :: SqlTransaction Connection [MPC.MarketPlaceCar]
            forM ns $ \n -> do
                    c <- loadCarInGarage (fromJust $ MPC.car_instance_id n) $ rollback "cannot load CIG"
                    return $ n {
                            MPC.acceleration = CIG.acceleration c,
                            MPC.top_speed = CIG.top_speed c,
                            MPC.stopping = CIG.stopping c,
                            MPC.cornering = CIG.cornering c,
                            MPC.nitrous = CIG.nitrous c
                        }
            
    writeMapables ns 
    

marketParts :: Application ()
marketParts = do 
   uid <- getUserId
   puser <- fromJust <$> runDb (load uid) :: Application (A.Account)
   ((l, o), xs) <- getPagesWithDTD (

                ifdtd "unique" (=="1")
                    ("unique" +==| (toSql True))
                    ("unique" +== "unique") +&&

                ifdtd "anycar" (=="1")
                    ("car_id" +== "car_id" +|| "car_id" +==| toSql (0 :: Integer))
                    ("car_id" +== "car_id") +&& 

--                "car_id" +== "car_id" +&& 
                "name" +== "part_type" +&&  
                "level" +<= "level-max" +&& 
                "level" +>= "level-min" +&&
                "price" +>= "price-min" +&&
                "price" +<= "price-max" +&&

                "weight" +<= "weight-max" +&&
                "weight" +>= "weight-min" +&&
                "manufacturer_name" +== "manufacturer_name" +&&

                "level" +<=| (toSql $ A.level puser)
            )
   ns <- runDb (search xs [] l o) :: Application [PM.PartMarket]
   writeMapables ns  

marketPartTypes :: Application ()
marketPartTypes = do 
   uid <- getUserId
   puser <- fromJust <$> runDb (load uid) :: Application (A.Account)
   ((l, o), xs) <- getPagesWithDTD (
            "max_level" +>= "level-min" +&&
            "max_price" +>= "price-min" +&&
            "min_level" +<= "level-max" +&& 
            "min_level" +<=| (toSql $ A.level puser) +&&
            "min_price" +<= "price-max" +&&
            "name" +== "name" 
        )
   ns <- runDb (search xs [] l o) :: Application [PMT.PartMarketType]
   writeMapables ns  

marketPlacePartTypes :: Application ()
marketPlacePartTypes = do 
   uid <- getUserId
   puser <- fromJust <$> runDb (load uid) :: Application (A.Account)
   ((l, o), xs) <- getPagesWithDTD (
            "name" +== "name" +&&  
            "min_level" +<= "level-max" +&& 
            "max_level" +>= "level-min" +&&
            "min_price" +<= "price-max" +&&
            "max_price" +>= "price-min" +&&
            "min_level" +<=| (toSql $ A.level puser)
        )
   ns <- runDb (search xs [] l o) :: Application [PMPT.PartMarketPlaceType]
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
                "manufacturer_name" +== "manufacturer_name" +&&

                ifdtd "unique" (=="1")
                    ("unique" +==| (toSql True))
                    ("unique" +== "unique") +&&

                ifdtd "used" (=="1")
                    ("wear" +<= "wear-max" +&& "wear" +>= "wear-min" +&& "wear" +>| (SqlInteger 0))
                    ("wear" +<= "wear-max" +&& "wear" +>= "wear-min") +&&

                ifdtd "improved" (=="1")
                    ("improvement" +<= "improvement-max" +&& "improvement" +>= "improvement-min" +&& "improvement" +>| (SqlInteger 0))
                    ("improvement" +<= "improvement-max" +&& "improvement" +>= "improvement-min") +&&

                "weight" +<= "weight-max" +&&
                "weight" +>= "weight-min" +&&

                -- get parts that fit any car, i.e. generic parts
                ifdtd "anycar" (=="1")
                    ("car_id" +== "car_id" +|| "car_id" +==| toSql (0 :: Integer))
                    ("car_id" +== "car_id") +&&

                    
                "account_id" +==| toSql uid
            )

        let p = runDb $ do
            let ?name = "garageParts"
            personnelUpdate uid 
            ns <- search xs od l o
            return ns 

        ns <- p :: Application [GPT.GaragePart]
        writeMapables ns 

garagePartsWithPreview :: Application ()
garagePartsWithPreview = do 
        uid <- getUserId 

        as <- getJson
        let pid = extract "preview_car_instance_id" as :: Integer

        (((l, o), xs),od) <- getPagesWithDTDOrderedAndParams as ["level", "part_instance_id", "unique", "improvement"] (
                "name" +== "part_type" +&& 
                "part_instance_id" +== "part_instance_id" +&& 
                "level" +<= "level-max" +&& 
                "level" +>= "level-min" +&&
                "price" +>= "price-min" +&&
                "price" +<= "price-max" +&& 

                ifdtd "unique" (=="1")
                    ("unique" +==| (toSql True))
                    ("unique" +== "unique") +&&

                ifdtd "used" (=="1")
                    ("wear" +<= "wear-max" +&& "wear" +>= "wear-min" +&& "wear" +>| (SqlInteger 0))
                    ("wear" +<= "wear-max" +&& "wear" +>= "wear-min") +&&

                ifdtd "improved" (=="1")
                    ("improvement" +<= "improvement-max" +&& "improvement" +>= "improvement-min" +&& "improvement" +>| (SqlInteger 0))
                    ("improvement" +<= "improvement-max" +&& "improvement" +>= "improvement-min") +&&

                "weight" +<= "weight-max" +&&
                "weight" +>= "weight-min" +&&


                ifdtd "anycar" (=="1")
                    ("car_id" +== "car_id" +|| "car_id" +==| toSql (0 :: Integer))
                    ("car_id" +== "car_id") +&& 

                "account_id" +==| toSql uid
            )

       
        ps <- runDb $ do
            let ?name = "garagePartsWithPreview"
            personnelUpdate  uid 
            ns <- search xs od l o :: SqlTransaction Connection [GPT.GaragePart]
            cig <- loadCarInGarage pid $ rollback $ "preview car not found for id " ++ (show pid)
            previewWithPartList cig ns
        
        writeMapables ps

           
garageCar :: Application ()
garageCar = do 
        uid <- getUserId 
        (((l,o), xs),od) <- getPagesWithDTDOrdered ["active", "level"] ("id" +== "car_instance_id" +&& "account_id"  +==| (toSql uid)) 
        let p = runDb $ do
            let ?name = "garageCar"
            personnelUpdate uid 
            ns <- searchCarInGarage xs od l o
            return ns 
        ns <- p :: Application [CIG.CarInGarage]
        writeMapables ns



garageActiveCar :: Application ()
garageActiveCar = do 
        uid <- getUserId 
        (((l,o), xs),od) <- getPagesWithDTDOrdered [] ("id" +== "car_instance_id" +&& "account_id"  +==| (toSql uid) +&& "active" +==| SqlBool True) 
        let p = runDb $ do
            let ?name = "garageCarActive"
            personnelUpdate  uid 
            ns <- searchCarInGarage xs od l o
            return ns 
        ns <- p :: Application [CIG.CarInGarage]
        writeMapables ns


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
            then internalError "Hi my friend, I am a node based on snap 0.10, which is a haskell web framework to create webservers. I am compiled with GHC 7.4.2 You came by me through a load-balancing and security proxy. We have a this moment 3 backend nodes running. Our connection_pool holds at maximum 200 connections to the database. We are using prepared statements and don't allow to do direct queries by some typesystem trick. We use PostgreSQL 9.2.2 with a PGPool-II as load balancer and failover mechanism. Also .. cannot be used in this query and we basename it anyway. Disregards that, I suck cock. Bye."
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
                b <- CarInstance.isMutable (CIP.car_instance_id t)
                when (not b) $ rollback "This part cannot be removed. Car is in tournament or race"
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
                -- check wear
                when (GPT.wear p >= 10000) $ rollback "part cannot be installed; it is too worn"
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
            let ?name = "garagePersonnel"
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
                            case extract "task" xs of 

                                        ("repair_car" :: String) -> do -- car repair 
                                            c' <- search ["part_type_id" |== (SqlInteger 20) .&& "car_instance_id" |==   (extract "subject_id" xs)] [] 1 0  :: SqlTransaction Connection [CIP.CarInstanceParts]
                                            when (null c') $ rollback "car doesn't have part_instance"
                                            liftIO $ print $ CIP.part_instance_id (head c')
                                            reportGarage uid (def {
                                                GRP.part_instance_id = Just $ CIP.part_instance_id (head c'),
                                                GRP.personnel_instance_id = fromSql $ fromJust $ HM.lookup "personnel_instance_id" xs,
                                                GRP.task = fromSql $ fromJust $ HM.lookup "task" xs,
                                                GRP.report_descriptor = Just "personnel_task"
                                                })
                                            r <- personnelStartTask (extract "personnel_instance_id" xs) (extract "task" xs) (extract "subject_id" xs)
                                            return r

                                        otherwise -> do 

                                            reportGarage uid (def {
                                                GRP.part_instance_id = fromSql $ fromJust $ HM.lookup "subject_id" xs,
                                                GRP.personnel_instance_id = fromSql $ fromJust $ HM.lookup "personnel_instance_id" xs,
                                                GRP.task = fromSql $ fromJust $ HM.lookup "task" xs,
                                                GRP.report_descriptor = Just "personnel_task"
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
                        now <- milliTime 
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
    r <- prc  uid xs
    writeResult ("You succesfully canceled this persons task" :: String)
        where prc  uid xs = runDb $ do
               g <- head <$> search ["account_id" |== toSql uid] [] 1 0 :: SqlTransaction Connection G.Garage 
               cm <- search ["garage_id" |== (toSql $ G.id g), "id" |== (toSql $ HM.lookup "personnel_instance_id" xs), "deleted" |== (toSql False)] [] 1 0 :: SqlTransaction Connection [PLI.PersonnelInstance]
               case cm of 
                        [] -> rollback "That is not your mechanic, friend"
                        [_] -> do
                            let ?name = "cancelTaskPersonnel"
                            personnelUpdate uid 
                            stopTask (extract "personnel_instance_id" xs) uid  
                            return ()

stopTask :: Integer -> Integer -> SqlTransaction Connection () 
stopTask pid uid = void $ do  
        -- get personnel instance
        pi <- aload pid $ rollback "personnel instance not found" :: SqlTransaction Connection PLID.PersonnelInstanceDetails
        -- get "effective" task subject id
        sid <- case PLID.task_name pi of
                -- in case of repair_car, get the car part id that is attached to the car instance
                "repair_car" -> do
                        cs <- search ["part_type_id" |== (SqlInteger 20) .&& "car_instance_id" |== (toSql $ PLID.task_subject_id pi)] [] 1 0  :: SqlTransaction Connection [CIP.CarInstanceParts]
                        when (null cs) $ rollback "stopTask: cannot find car instance part for car"
                        return $ CIP.part_instance_id $ head cs
                -- in all other cases, get the task_subject_id
                _ -> return $ PLID.task_subject_id pi
        
        -- generate report
        save (def {
                GRP.part_instance_id = Just sid,
                GRP.personnel_instance_id =  PLID.personnel_instance_id pi
            })

        -- stop task
        update "personnel_instance" ["id" |== toSql (PLID.personnel_instance_id pi)] [] [
                    ("task_id", SqlInteger 1),
                    ("task_subject_id", SqlInteger 0),
                    ("task_started", SqlInteger 0),
                    ("task_updated", SqlInteger 0),
                    ("task_end", SqlInteger 0)
                ]
{-
            save (pi {
                PLI.task_id = 1,
                PLI.task_subject_id = 0,
                PLI.task_started = 0,
                PLI.task_updated = 0,
                PLI.task_end = 0
            })
-}

{-
stopTaskCar :: Integer -> Integer -> Integer -> SqlTransaction Connection () 
stopTaskCar pid cpid uid = do  
        pi <- aload pid $ rollback "personnel instance not found" :: SqlTransaction Connection PLI.PersonnelInstance
        -- stop task 
--        liftIO $ print $ ?name 
--        liftIO $ print $ cpid 
        save (def {
                GRP.part_instance_id = Just cpid,
                GRP.personnel_instance_id =  PLI.id pi 
            })
        save (pi {
                PLI.task_id = 1,
                PLI.task_subject_id = 0,
                PLI.task_started = 0,
                PLI.task_updated = 0,
                PLI.task_end = 0
            })
--        t <- DBF.unix_timestamp
--        traceShow (t, ?name, pid) $ commit 

-}
        

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
                    Connection -- Monomorphic Database Connection Descriptor.  
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
                GRP.account_id = Just uid
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
                                                save $ a { A.city = Just $ TCY.city_id city }
                                                return True 
        t <- tr
        writeResult ("you travel to the city" :: String)

cityList :: Application ()
cityList = do 
        uid <- getUserId 
        ((l,o),xs) <- getPagesWithDTD ("city_id" +== "id" +&& "continent_id" +== "continent" +&& "city_level" +>= "levelmin" +&& "city_level" +<= "levelmax")
        ns <- runDb $ search xs [Order ("continent_id",[]) True, Order ("city_level",[]) True] l o :: Application [TCY.TrackCity]
        writeMapables ns

continentList :: Application ()
continentList = do 
        uid <- getUserId 
        ((l,o),xs) <- getPagesWithDTD ("continent_id" +== "id" +&& "continent_level" +>= "levelmin" +&& "continent_level" +<= "levelmax")
        ns <- runDb $ search xs [Order ("continent_level",[]) True] l o :: Application [TCN.TrackContinent]
        writeMapables ns

trackList :: Application ()
trackList = do 
        uid <- getUserId 
        ((l,o),xs) <- getPagesWithDTD ("track_id" +== "id" +&& "city_id" +== "city" +&& "continent_id" +== "continent" +&& "track_level" +>= "levelmin" +&& "track_level" +<= "levelmax")
        ns <- runDb $ search xs [Order ("continent_id",[]) True, Order ("city_id",[]) True, Order ("track_level",[]) True] l o :: Application [TT.TrackMaster]
        writeMapables ns

trackHere :: Application ()
trackHere = do 
        uid <- getUserId 
        ((l,o),xs) <- getPagesWithDTD ("track_level" +>= "levelmin" +&& "track_level" +<= "levelmax")
        ts <- runDb $ do
                a <- load uid :: SqlTransaction Connection (Maybe A.Account)
                case a of 
                        Nothing -> rollback "oh noes diz can no happen"
                        Just a -> do 
                                 Task.runAll Task.Track 
                                 ts <- search (["city_id" |== (toSql $ A.city a)] ++ xs) [Order ("track_level",[]) True] l o :: SqlTransaction Connection [TT.TrackMaster]
                                 -- ts <- search ["city_id" |== (toSql $ A.city a)] [] 1000 0 :: SqlTransaction Connection [TT.TrackMaster]
                                 return ts
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
        tim <- runDb $ milliTime 
        ((l,o),xs) <- getPagesWithDTD ("time" +>= "timemin" +&& "time" +<= "timemax" +&& "account_id" +==| (toSql uid) +&& "type" +==| (toSql t) +&& "time" +<=| (SqlInteger tim)
        
            )
        ns :: [RP.Report] <- runDb $ do
            userActions uid
            search xs [Order ("time",[]) False] l o 
--      BUG:  writeMapables ns -- toInRule wraps Data in ByteString so it ends up as a JSON string
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
        t <- milliTime 
        let u = A.busy_until a
        let ?name = "userActions"
        personnelUpdate uid
        when (u > 0 && u <= t) $ do
--            save $ a { A.busy_until = 0, A.busy_subject_id = 0, A.busy_type = 1 }
            -- do not overwrite record as it may have changed; use update instead
            update "account" ["id" |== (toSql $ uid)] [] [("busy_until", SqlInteger 0), ("busy_subject_id", SqlInteger 0), ("busy_type", SqlInteger 1)]
            return ()


personnelUpdate uid = dbWithLockNonBlock "personnel" uid $ do 
                s <- milliTime
                g <- aget ["account_id" |== (toSql uid)] (rollback "cannot find garage") :: SqlTransaction Connection G.Garage 
                ps <- search ["garage_id" |== (toSql $ G.id g)] [] 1 0 :: SqlTransaction Connection [PLID.PersonnelInstanceDetails]
                case length ps > 0 of
                    False -> return () 
                    True -> forM_ ps $ \p -> do
                            let elapsed = max 0 $ (min (PLID.task_end p) s) - (PLID.task_updated p)
                            let timeleft = max 0 $ (PLID.task_end p) - s
                            case PLID.task_name p of 
                                    "idle" -> return ()
                                    "improve_part" -> partImprove uid p elapsed timeleft
                                    "repair_part" -> partRepair uid p elapsed timeleft
                                    "repair_car" -> carRepair uid p elapsed timeleft
                            -- set task updated
--                            save (p { PLID.task_updated = s })
                            update "personnel_instance" ["id" |== (toSql $ PLID.personnel_instance_id p)] [] [("task_updated", toSql s)]
                            -- if task finished, stop task and generate report
                            when (timeleft <= 0) $ do
                                    stopTask (fromJust $ PLID.personnel_instance_id p) uid
--                            stopTaskCar (fromJust $ PLID.personnel_instance_id pi) (CIP.part_instance_id c) uid 


{-
personnelUpdateBusy s id = do 
                    p <- aload id (rollback "cannot find personnel") :: SqlTransaction Connection PLI.PersonnelInstance
                    save (p {
                            PLI.task_updated = s
                        })
-}

-- partImprove :: Integer -> PLID.PersonnelInstanceDetails -> SqlTransaction Connection ()
partImprove uid pi elapsed timeleft = do
                let skill = PLID.skill_engineering pi 
                let sid = PLID.task_subject_id pi 
                atomical $ do 
                        (rate :: Double) <- loaddbConfig "part_improve_rate" 
                        p' <- load sid :: SqlTransaction Connection (Maybe PI.PartInstance)
                        when (isNothing p') $ rollback "cannot find partinstance"
                        let p = fromJust p'
                        let a = fromIntegral (skill * elapsed)
                        let effect = round (a * rate)
                        void $ save $ p { PI.improvement = min (10^4) (PI.improvement p + effect) }

                        -- needed to put data outside transaction 
                        commit

                        when (timeleft <= 0) $ dbWithLockNonBlock "notification_personnel" uid $ do 
                                void $ N.sendCentralNotification uid (N.partImprove {
                                                                N.part_id = convert $ PI.part_id p,
                                                                N.improved = min (10^4) effect
                                                            })
                                commit 
                                        


-- partRepair :: Integer -> PLID.PersonnelInstanceDetails -> SqlTransaction Connection ()
partRepair uid pi elapsed timeleft = do 
                let skill = PLID.skill_repair pi 
                let sid = PLID.task_subject_id pi 
                atomical $ do 
                        (rate :: Double) <- loaddbConfig "part_repair_rate" 
                        p' <- load sid :: SqlTransaction Connection (Maybe PI.PartInstance)
                        when (isNothing p') $ rollback "part instance not found"
                        let p = fromJust p' 
                        let a = fromIntegral (skill * elapsed)
                        let effect = round (a * rate)
                        void $ save $ p { PI.wear = max 0 $ PI.wear p - effect }

                        -- Commit needed to put data outside transaction
                        commit 

                        when (timeleft <= 0) $  do 
                                    void $ N.sendCentralNotification uid (N.partRepair {
                                                                    N.part_id = convert $ PI.part_id p,
                                                                    N.repaired = max 0 effect
                                                                })
                                    commit
 
-- carRepair ::  Integer -> PLID.PersonnelInstanceDetails -> SqlTransaction Connection ()
carRepair uid pi elapsed timeleft = do 
            let skill = PLID.skill_repair pi 
            let sid = PLID.task_subject_id pi 
            atomical $ do 
                    (rate :: Double) <- loaddbConfig "car_repair_rate" 
                    c' <- search ["part_type_id" |== (SqlInteger 20) .&& "car_instance_id" |==  toSql sid] [] 1 0  :: SqlTransaction Connection [CIP.CarInstanceParts]
                    when (null c') $ rollback "cannot find car instance parts"
                    let c = head c' 
                    g' <- load (CIP.part_instance_id c) :: SqlTransaction Connection (Maybe PI.PartInstance)
                    when (isNothing g') $ rollback "cannot find part instance"
                    let p = fromJust g'
                    let a = fromIntegral (skill * elapsed)
                    let effect = round (a * rate)
                    void $ save $ p { PI.wear = max 0 $ PI.wear p - effect }

                    commit 
                    when (timeleft <= 0) $  do 
                            void $ N.sendCentralNotification uid (N.partRepair {
                                                                    N.part_id = convert $ PI.part_id p,
                                                                    N.repaired = max 0 effect
                                                                })
                            commit 
                                                 





-- TODO: car actions (on select) ?

racePractice :: Application ()
racePractice = do

        uid <- getUserId
        xs <- getJson >>= scheck ["track_id"]
        let tid = extract "track_id" xs :: Integer
        rid <- runDb $ do

            userActions uid

            a <- aload uid (rollback "you dont exist, go away") :: SqlTransaction Connection A.Account

            -- check busy
            when ((A.busy_type a) /= 1) $ rollback "You are currently busy with something else"

            -- check track level
            t <- aget ["track_id" |== (SqlInteger $ tid)] $ rollback "track not found" :: SqlTransaction Connection TT.TrackMaster
            when (A.level a < TT.track_level t) $ rollback "Your are not ready for this track"

            -- check user energy
            let ecost = TT.energy_cost t * 10000
            when (A.energy a < ecost) $ rollback "You don't have enough energy, bro"

            -- get active car
            g <- aget ["account_id" |== toSql uid] (rollback "garage not found") :: SqlTransaction Connection G.Garage 
            c <- getCarInGarage ["active" |== SqlBool True, "garage_id" |== (toSql $ G.id g)] (rollback "active car not found")

            -- check active car
            r <- CR.carReady $ fromJust $ CIG.id c
            unless (CR.ready r) $ rollback "Your car is not ready, brony"

            -- apply energy cost
            update "account" ["id" |== toSql uid] [] [("energy", toSql $ (A.energy a) - ecost)]

            t <- milliTime 
            (rid, rs) <- let y = RaceParticipant a (APM.toAPM a) c (CMI.toCM c) Nothing
                         in processRace 1 t [y] tid 
             
            Task.emitEvent uid (PracticeRace tid rid) $  t + (maximum $ ceiling  . (*1000) . raceTime <$> (fmap snd rs))
 
            forM_ rs $ \r -> do 
                    healthLost (rp_account_id $ fst r) (snd r) 
                    partsWear (rp_car_id $ fst r) (snd r)  
            
            return rid

        -- write results
        writeResult rid

testWrite :: Application ()
testWrite = do
        uid <- getUserId
        xs <- runCompose $ do 
            label "bla" (1 :: Integer)
            label "foo" (HM.fromList [("string" :: String, toInRule (1 :: Integer))])
            label "bar" (2 :: Integer)
        writeResult xs 




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
            userActions  uid
--            Task.run Task.User uid
            a  <- aget ["id" |== toSql uid] (rollback "account not found") :: SqlTransaction Connection A.Account

            -- check busy
            when ((A.busy_type a) /= 1) $ rollback "You are currently busy with something else"
            t <- aget ["track_id" |== (SqlInteger $ tid)] $ rollback "track not found" :: SqlTransaction Connection TT.TrackMaster
            when (A.level a < TT.track_level t) $ rollback "Your are not ready for this track"

            -- check user energy
            let ecost = TT.energy_cost t * 10000
            when (A.energy a < ecost) $ rollback "You don't have enough energy, bro"

            c  <- getCarInGarage ["account_id" |== toSql uid .&& "active" |== toSql True] (rollback "Active car not found")

            adeny ["account_id" |== SqlInteger uid, "deleted" |== SqlBool False] (rollback "you're already challenging") :: SqlTransaction Connection [Chg.Challenge]
            n  <- aget ["name" |== SqlString tp] (rollback "unknown challenge type") :: SqlTransaction Connection ChgT.ChallengeType

            -- check active car
            r <- CR.carReady $ fromJust $ CIG.id c
            unless (CR.ready r) $ rollback "Your car is not ready, brony"

            -- apply energy cost
            update "account" ["id" |== toSql uid] [] [("energy", toSql $ (A.energy a) - ecost)]

            me <- case amt > 0 of
                    True -> Just <$> Escrow.deposit uid amt
                    False -> return Nothing

            let am = APM.toAPM a
            let cm = CMI.toCM c 

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
            CarInstance.setImmutable (fromJust $ CMI.id cm)

            return True
        writeResult i


raceChallengeWithdraw :: Application ()
raceChallengeWithdraw = do
        uid <- getUserId :: Application Integer
        xs <- getJson >>= scheck ["challenge_id"]
        let cid = extract "challenge_id" xs :: Integer

        -- search constraints

        let p = ["id" |== toSql cid, "account_id" |== toSql uid, "deleted" |== toSql False]

        -- check challenge exists and owned

        chg <- runDb $ aget p (rollback "challenge not found") :: Application Chg.Challenge

        -- delete

        runDb $ update "challenge" p [] [("deleted", toSql True)] *> CarInstance.setMutable (fromJust $ CMI.id $ Chg.car_min $ chg)

        writeResult ("challenge withdrawn" :: String)
 

 

raceChallengeAccept :: Application ()
raceChallengeAccept = do

        uid <- getUserId :: Application Integer
        xs <- getJson >>= scheck ["challenge_id"]
        

        let cid = extract "challenge_id" xs :: Integer 
        -- Change, had to break up to be able to send to the user. 
        -- This should be ok, it are only get actions 


        -- retrieve challenge
        chg  <- runDb $ aget ["id" |== toSql cid, "account_id" |<> toSql uid, "deleted" |== toSql False] (rollback "challenge not found") :: Application Chg.Challenge
        chgt <- runDb $ ChgT.name <$> 
                                (aget ["id" |== (toSql $ Chg.type chg)] (rollback $ "challenge type not found for id " ++ (show $ Chg.type chg)) :: SqlTransaction Connection ChgT.ChallengeType)


        rid <- runDb $ do

            -- TODO: get / search functions for track, user, car with task triggering
            
            userActions  uid
            userActions . rp_account_id $ Chg.challenger chg

--            Task.run Task.User uid
--            Task.run Task.User . rp_account_id $ Chg.challenger chg

            -- pay race dues to escrow 
            me <- case Chg.amount chg > 0 of
                    True -> fmap Just . Escrow.deposit uid $ Chg.amount chg
                    False -> return Nothing 


            a  <- aget ["id" |== toSql uid] $ rollback "account not found" :: SqlTransaction Connection A.Account
            let am = APM.toAPM a

            let tid = Chg.track_id chg

            -- check busy
            when (A.busy_type a /= 1) $ rollback "You are currently busy with something else"

            -- check user location
            track_master <- aget ["track_id" |== SqlInteger tid] $ rollback "track not found" :: SqlTransaction Connection TT.TrackMaster
            unless (fromJust (A.city a) == TT.city_id track_master) $ rollback "You are not in that city"

            -- check track level
            when (A.level a < TT.track_level track_master) $ rollback "Your are not ready for this track"

            -- check user energy
            let ecost = TT.energy_cost track_master * 10000
            when (A.energy a < ecost) $ rollback "You don't have enough energy, bro"


            c <- getCarInGarage ["account_id" |== toSql uid .&& "active" |== toSql True] $ rollback "Active car minimal not found" 

            -- check active car
            r <- CR.carReady $ fromJust $ CIG.id c
            unless (CR.ready r) $ rollback "Your car is not ready, brony"

            -- apply energy cost
            update "account" ["id" |== toSql uid] [] [("energy", toSql $ A.energy a - ecost)]


            let y = RaceParticipant a am c (CMI.toCM c) me
          
            -- TODO: add user to accepts list
            -- when count(accepts) >= participants, start race
            -- fetch participants as array
            -- run race with array

            -- delete challenge
            foo <- save $ chg { Chg.deleted = True }

            -- process race
            current_time <- milliTime 

            CarInstance.setMutable (fromJust $ CMI.id $ Chg.car_min chg)
            (rid, rs) <- processRace 2 current_time [y, Chg.challenger chg] (Chg.track_id chg)


            let fin  = (current_time+) . (1000 *) . ceiling . raceTime  
            let t1 = (\(_,r) -> fin r) $ head rs
            let winner_id = rp_account_id . fst . head $ rs
            let other_id = rp_account_id . Chg.challenger $ chg

            {-
            if winner_id == uid 
                    then do             
                        Task.emitEvent uid (ChallengeRace 1 tid rid) t1 
                        Task.emitEvent other_id (ChallengeRace 2 tid rid) t1 
                    else do 
                        Task.emitEvent other_id (ChallengeRace 1 tid rid) t1 
                        Task.emitEvent uid (ChallengeRace 2 tid rid) t1 
            -}

            foldM_ (\k (p,r) -> do

                    -- apply wear
                    partsWear (rp_car_id p)  r

                    -- apply energy loss
                    healthLost (rp_account_id p) r

                    -- task: emit race event
                    Task.emitEvent (rp_account_id p) (ChallengeRace k tid rid) $ fin r
 
                    -- task: transfer challenge objects
                    let isWinner = rp_account_id p == winner_id
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
                                False -> Task.transferCar t1 (rp_account_id p) winner_id $ rp_car_id p
                        otherwise -> rollback $ "challenge type not supported: " ++ chgt

                    return $ k + 1
                ) 1 rs

            return rid

        let raceStart = N.raceStart {
                    N.race_type = read $ chgt,
                    N.race_id = rid  
                }

        N.sendNotification uid raceStart 
        N.sendNotification (rp_account_id . Chg.challenger $ chg) raceStart 

        writeResult rid


processRace :: Integer -> Integer -> [RaceParticipant] -> Integer -> SqlTransaction Connection (Integer, [(RaceParticipant, RaceResult)]) 
processRace typid t ps tid = do

        trk <- trackDetailsTrack <$> (agetlist ["track_id" |== toSql tid] [] 1000 0 (rollback "track data not found") :: SqlTransaction Connection [TD.TrackDetails])
        tdt <- aget ["track_id" |== toSql tid] (rollback "track not found") :: SqlTransaction Connection TT.TrackMaster

        -- race participants
        rs' <- forM ps $ \p -> do
                g <- liftIO $ newStdGen
                case raceWithParticipant p trk g of
                        Left e -> rollback e
                        Right r -> return (p, r)

        let rs = List.sortBy (\(_, a) (_, b) -> compare (raceTime a) (raceTime b)) rs'

        -- current time, finishing times, race time (slowest finishing time) 
        let fin r = (t+) $ ceiling $ (1000 *) $ raceTime r  
        let te = fin $ snd $ last rs

--        when (te > 9223372036854775808) $ rollback "finish time out of bounds"

        -- save race data
        rid <- save $ (def :: R.Race) {
                    R.track_id = tid,
                    R.start_time = t,
                    R.end_time = te, 
                    R.type = typid,
                    R.data = uncurry raceData <$> rs 
                }

        forM_ rs $ \(p,r) -> do
                let uid = rp_account_id p  
                let ft = fin r 
                -- set account busy until user finish; subtract energy
                update "account" ["id" |== toSql uid] [] [("busy_until", toSql ft), ("busy_subject_id", toSql rid), ("busy_type", SqlInteger 2)]

                -- apply wear to user's parts in race

                -- task: update race time on user finish
                Task.trackTime ft tid uid (raceTime r)

                -- store user race report -- TODO: determine relevant information
                -- TODO race reports should have there own table. Ies
                -- broken now. 
                --
                -- TODO: should not be hardcoded
                --
                let tpid 1 = "practice" :: String
                    tpid 2 = "race" :: String 
                    tpid n = "what?" :: String 
                RP.report RP.Race uid ft $ mkData $ do
                    set "track_id" tid
                    set "race_id" rid
                    set "start_time" t
                    set "finish_time" ft
                    set "race_time" $ raceTime r
                    set "track_data" tdt
                    set "participant" (rp_account_min p)
                    set "result" r
                    set "type" typid
                    set "type_name" (tpid typid)

        -- return race id
        return (rid, rs)
       

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
                    Nothing -> searchCarInGarage ["account_id" |== (toSql uid)] [] 100 0
                    Just x -> searchCarInGarage ["account_id" |== (toSql uid) .&& "car_id" |== (toSql x)] [] 100 0
        writeMapables ts 


searchRaceReward :: Application ()
searchRaceReward = do
        t <- runDb $  milliTime
        uid <- getUserId
        ((l,o), xs) <- getPagesWithDTD (
                    "time" +<=| (SqlInteger t)
                +&& "account_id" +==| (SqlInteger uid)
                +&& "race_id" +== "race_id" 
            )
        rs <- runDb $ search xs [] l o :: Application [RWD.RaceReward]
        writeMapables rs

milliTime :: SqlTransaction Connection Integer
milliTime = DBF.unix_millitime -- (*1000) <$> DBF.unix_timestamp 


serverTime :: Application ()
serverTime = do
        t <- runDb $ milliTime
        writeResult t

viewTournament :: Application ()
viewTournament = do
        uid <- getUserId 
        a <- runDb $ fromJust <$> (load uid :: SqlTransaction Connection (Maybe A.Account))

        (((l, o), xs),od) <- getPagesWithDTDOrdered ["minlevel","maxlevel", "track_id", "costs", "car_id", "name", "id","players", "done", "running"] (
            "id" +== "tournament_id" +&& 
            "minlevel" +<=| (toSql $ A.level a) +&& 
            "maxlevel" +>=| (toSql $ A.level a) +&& 
            "minlevel" +>= "minlevel" +&& 
            "maxlevel" +>= "maxlevel" +&& 
            "name" +%% "name" +&&
            "tournament_type" +== "tournament_type" +&&
            "tournament_type_id" +== "tournament_type_id" +&&
            "track_id" +== "track_id" +&& 
            "players" +>= "minplayers" +&& 
            "players" +<= "maxplayers" +&&
            "city" +==| (toSql $ A.city a)  +&&
            "done" +== "done" +&&
            "running" +== "running"

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
                            [a] -> CarInstance.setMutable (fromJust $ TP.car_instance_id a)  *> void ( save (a {TP.deleted = True}) )
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
        ys <- runDb $ getResults (fromJust $ TP.tournament_id b)  
        writeMapables ys 

tournamentPlayers :: Application () 
tournamentPlayers = do 
        uid <- getUserId 
        xs <- getJson >>= scheck ["tournament_id"] 
        let b = updateHashMap xs (def :: TP.TournamentPlayer)
        ys <- runDb $ getPlayers (fromJust $ TP.tournament_id b )
        writeResult ys 


tournamentAllPlayers :: Application ()
tournamentAllPlayers = do 
        uid <- getUserId 
        xs <- getJson >>= scheck ["tournament_id"]
        let b = updateHashMap xs (def :: TP.TournamentPlayer)
        ys <- runDb $ do 
                        xs <- search ["deleted" |== (toSql False) .&& "tournament_id" |== (toSql $ TP.tournament_id b)] [] 100000 0 :: SqlTransaction Connection [TP.TournamentPlayer]
                        forM xs $ \t -> do 
                            y <- aget ["id" |== (toSql $ TP.account_id t)] (rollback "goodbye cruel world") :: SqlTransaction Connection APM.AccountProfileMin 
                            z <- aget ["id" |== (toSql $ TP.car_instance_id t)] (rollback "ahahaha player doesn't have sucky car") :: SqlTransaction Connection CMI.CarMinimal
                            return $ HM.fromList $ [("user" :: String, toInRule y), ("car",toInRule z)]


        writeResult ys 

tournamentJoin :: Application ()
tournamentJoin = do 
    uid <- getUserId
    xs <- getJson >>= scheck ["car_instance_id", "tournament_id"] 
    let b = updateHashMap xs (def :: TP.TournamentPlayer) 
    runDb $ do

            -- check active car
            r <- CR.carReady $ fromJust $ TP.car_instance_id b
            unless (CR.ready r) $ rollback "Your car is not ready, brony"

            joinTournament (fromJust $ TP.car_instance_id b) (fromJust $ TP.tournament_id b) uid 
    writeResult (1 :: Int)

{-- till here --}
wrapErrors g x = when g (void $ runDb (forkSqlTransaction $ Task.run Task.Cron 0 >> return ())) 
              >>  CIO.catch (CIO.catch x (\(UserErrorE s) -> writeError s)) (\(e :: SomeException) -> writeError (show e))


userNotification :: Application ()
userNotification = do 
                uid <- getUserId
                ys <- getJson
                let lim = maybe 100 fromSql $ HM.lookup "limit" ys
                let ofs = maybe 0 fromSql $ HM.lookup "offset" ys
                xs <- runDb $ search [
                                 "to" |== toSql uid 
                             .&& "read" |== toSql False 
                             .&& "archive" |== toSql False
                             ] [] lim ofs :: Application [Not.PreLetter] 
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

        -- get garage
        g <- aget ["account_id" |== toSql uid] (rollback "Garage not found") :: SqlTransaction Connection G.Garage 

        -- get car prototype
        c <- aget ["id" |== toSql mid, "prototype" |== toSql True] (rollback "Car prototype not found") :: SqlTransaction Connection CarInstance.CarInstance

        -- get car prototype parts 
        ps <- search ["car_instance_id" |== toSql mid] [] 1000 0 :: SqlTransaction Connection [PI.PartInstance]
        
        -- if user has no active car, the new car will be active 
        act <- ( not . (> 0) . length) <$> (search ["garage_id" |== toSql (G.id g), "active" |== toSql True] [] 1 0 :: SqlTransaction Connection [CarInstance.CarInstance])
        
        -- instantiate new car
        cid <- save (def :: CarInstance.CarInstance) {
                CarInstance.garage_id =  G.id g,
                CarInstance.car_id = CarInstance.car_id c,
                CarInstance.active = act 
            } :: SqlTransaction Connection Integer

        -- instantiate new parts
        forM_ ps $ \p -> save (def :: PI.PartInstance) {
                PI.part_id = PI.part_id p,
                PI.car_instance_id = Just cid,
                PI.improvement = PI.improvement p,
                PI.wear = PI.wear p,
                PI.account_id = uid,
                PI.deleted = False
            }
                

        return cid

userClaimFreeCar :: Application ()
userClaimFreeCar = do
        uid <- getUserId
        xs <- getJson >>= scheck ["id"]
        let mid = extract "id" xs :: Integer

        -- get records and set free_car to false
        m <- runDb $ do
            aget ["id" |== toSql uid, "free_car" |== toSql True] (rollback "you may not claim a free car") :: SqlTransaction Connection A.Account
            m <- getCarInGarage ["id" |== toSql mid, "prototype" |== toSql True, "prototype_claimable" |== toSql True] (rollback "car cannot be claimed")
            update "account" ["id" |== toSql uid] [] [("free_car", toSql False)]
            return m
        
        -- create new car in user's garage
        runDb $ instantiateCar mid uid

        writeResult ("You have received a free car" :: String)


reportIssue :: Application ()
reportIssue = do 
        xs <- getJson 
        uid <- getUserId 
        let b = updateHashMap xs (def :: SUP.Support)
        runDb $ save (b { SUP.account_id = uid })
        writeResult (1 :: Integer)

 

  

getUserGarageId :: Application Integer
getUserGarageId = do 
        uid <- getUserId 
        g <- runDb (aget ["account_id" |== toSql uid] (rollback "Garage not found") :: SqlTransaction Connection G.Garage)
        return $ fromJust $ G.id g


----
-- runDb :: SqlTransaction ->  Application 
--
-- Application
findRewards :: Application ()
findRewards = do 
        uid <- getUserId
        js  <- getJson >>= scheck ["type", "id"]
        let ttype = HM.lookupDefault "tournament" "type" js :: SqlValue 
        case ttype of 
            "tournament" -> tournamentRewards (convert $ HM.lookup ("id" :: String) js)
            otherwise -> internalError "No such type"


tournamentRewards :: Integer -> Application ()
tournamentRewards tid = do 
                xs <- runDb $ do 
                        t <- loadTournament tid 
                        let pos = [1 .. TR.players t]
                        ys <- forM pos $ \p -> do  
                                ys <- (getTournamentRewards t p)
                                return $ ys 
                        return $ HM.fromList ( (show <$> pos) `zip` ys)
                writeResult $ xs 
        where getTournamentRewards t p = do
                    xs <- rewardAction (Tournament p (fromJust $ TRM.id t) (TRM.tournament_type_id t))
                    return $ xs

availableMissions :: Application ()
availableMissions = do 
            uid <- getUserId 
            (((l,o),xs),od) <- getPagesWithDTDOrdered ["id", "description","time_limit"] $ 
                    "id" +== "id" +&& 
                    "time_limit" +>= "time_limit_min" +&& 
                    "time_limit" +<= "time_limit_max" +&& 
                    "time_limit" +== "time_limit"
            ys <- runDb $ avDb xs od l o 
            writeResult ys 

avDb xs od l o =  do 
                             ms <- search xs od l o
                             liftIO $ print ms 
                             forM ms $ \p -> do 
                                                liftIO $ print p 
                                                r <- load (Mission.rule_id p) :: SqlTransaction Connection  (Maybe Rule.Rule)
                                                liftIO $ print r 
                                                return $ InObject $ HM.fromList $ [("rule", toInRule (ruleToExpression <$> (Rule.rule <$>  r))), ("mission", toInRule p)]

userMission :: Application ()
userMission = do 
        uid <- getUserId 
        (((l,o),xs),od) <- getPagesWithDTDOrdered ["id","time_start", "time_left"] $ 
                "id" +== "id" +&& 
                "account_id" +==| (toSql uid)
        ys <- runDb $ search xs od l o :: Application [MissionUser.MissionUser] 
        writeMapables ys 

acceptMission :: Application ()
acceptMission = undefined 

{-
-- hiscore: take a worker that produces a list of mapables given an argument map, get user arguments, apply the worker and write the results
-- e.g. hiscoreRespect = hiscore hsRespect
-- TODO: include offset and limit in workers
hiscore :: Mapable a => (SqlMap -> SqlTransaction Connection [a]) -> Application ()
hiscore w = do
        m <- getJson
        let lim = case HM.lookup "limit" m of
                Nothing -> 10
                Just x -> max (fromSql x) 100
        let ofs = case HM.lookup "offset" m of
                Nothing -> 0
                Just x -> fromSql x
        rs <- runDb $ (\x -> List.take lim $ List.drop ofs x) <$> w m
        writeMapables rs


-- TODO: breaks if the server has over 9000 users.
hsRespect :: SqlMap -> SqlTransaction Connection [AP.AccountProfile]
hsRespect m =
        let
                -- convenient foldM takes step function as last argument
                foldM' a xs f = foldM f a xs
                
                -- filters: each filter takes the whole input map and produces either Nothing or a list of account profiles
                -- the intersection of all generated lists shall be the result
                filters :: [SqlMap -> SqlTransaction Connection (Maybe [AP.AccountProfile])]
                filters = [

                        (\m -> case HM.lookup "has_car_model" m of
                                Nothing -> return Nothing
                                Just cmid -> do

                                        -- get unique garage ids for car instances for given model
                                        gs <- (\xs -> List.nub $ map (fromJust . CarInstance.garage_id) xs) <$> search ["car_id" |== cmid, "deleted" |== toSql False, "garage_id" |> SqlInteger 0] [] 100000 0
                                        -- get unique account ids for garages
                                        as <- (\xs -> List.nub $ map G.account_id xs) <$> (forM gs $ \g -> aget ["id" |== toSql g] $ rollback $ "garage not found for " ++ (show g))

                                        -- return account profiles
                                        rs <- forM as $ \a -> aget ["id" |== toSql a] $ rollback $ "account profile not found for " ++ (show a)

                                        return $ Just rs
                            ),

                        (\m -> case HM.lookup "in_city" m of
                                Nothing -> return Nothing
                                Just cid -> do

                                        -- get account ids in city
                                        as <- (map (fromJust . A.id)) <$> search ["city" |== toSql cid] [] 100000 0

                                        -- get profiles for accounts
                                        rs <- forM as $ \a -> aget ["id" |== toSql a] $ rollback $ "account profile not found for " ++ (show a)

                                        return $ Just rs
                                        
                                
                            ),

                        (\m -> case HM.lookup "on_continent" m of
                                Nothing -> return Nothing
                                Just cid -> do

                                        -- get city ids for continent
                                        cs <- (map (fromJust . City.id)) <$> search ["continent_id" |== toSql cid] [] 100000 0
                                        
                                        -- get account ids from each city
                                        ass <- forM cs $ \c -> (map (fromJust . A.id)) <$> search ["city" |== toSql c] [] 100000 0
                                        let as = List.nub $ concat ass
                                        
                                        -- get profiles for accounts
                                        rs <- forM as $ \a -> aget ["id" |== toSql a] $ rollback $ "account profile not found for " ++ (show a)

                                        return $ Just rs
                             )

                    ]
        in do

            -- TODO: server side views. locally juggling potentially humongous lists is probably horribly inefficient.

            -- get all accounts ordered by respect (!)
            as <- search [] [order "respect" desc] 100000 0
            -- get filter produced accounts
            fs <- forM filters $ \f -> f m
            -- filter accounts, left order seems to be preserved?
            rs <- foldM' as fs $ \xs mf -> return $ maybe xs (List.intersectBy (on (==) AP.id) xs) mf
            -- inversely order by respect
            return $ List.sortBy (\a b -> on compare AP.respect b a) rs
                        
-}
                   
hiscore :: (Mapable a) => (SqlMap -> Integer -> Integer -> SqlTransaction Connection [a]) -> Application ()
hiscore w = do
        m <- getJson
        lim <- min 100 <$> dextract 10 "limit" m
        ofs <- max 0 <$> dextract 0 "offset" m
        rs <- runDb $ w m lim ofs
        writeMapables rs
         
-- use Relations to allow serving over 9000 users.
hsRespect :: SqlMap -> Integer -> Integer -> SqlTransaction Connection [AP.AccountProfile]
hsRespect m lim ofs = 
        let
                -- filters: each filter takes the whole input map and produces either Nothing or a list of account profiles <-- no longer; RelationM are produced and they can be chained
                -- the intersection of all generated lists shall be the result
                --
                -- 1. we need relations for tables and views used. these can be generated.
                -- 2. we need some way to typeify relations. 
                filters :: [[RelationM]]
                filters = [

                        (case HM.lookup "has_car_model" m of
                                Nothing -> []
                                Just cmid -> [AP.relation >> do
                                            -- add garage id
                                            join ("id" |==| "account_id") $ G.relation >> projectAs [("id", "garage_id"), ("account_id", "account_id")]
                                            -- add car id for cars in garage 
                                            join ("garage_id" |==| "car_garage_id") $ CarInstance.relation >> do
                                                    projectAs [("car_id", "car_model_id"), ("garage_id", "car_garage_id")]
                                                    select $ "car_model_id" |==* cmid
                                            -- foo <- schema -- TODO? schema :: State Relation Schema --> type RelationM = State Relation
                                            -- TODO: there should be no duplicate records
                                            -- 1. aggregation?
                                            -- 2. implicit record distinction?
                                            -- project to Account relation schema
                                            project AP.schema
                                    ]
                            ),

                        (case HM.lookup "in_city" m of
                                Nothing -> []
                                Just cid -> [AP.relation >> select ("city_id" |==* cid)]
                            ),

                        (case HM.lookup "on_continent" m of
                                Nothing -> [] 
                                Just cid -> [AP.relation >> do
                                            join ("city_city_id" |==| "city_id") $ City.relation >> projectAs [("id", "city_city_id"), ("continent_id", "city_continent_id")]
                                            select ("city_continent_id" |==* cid)
                                            project AP.schema
                                    ]
                             )
                    ]

        in do
                -- result is intersection of all result sets
                xs <- getAssoc $ foldr (\n r -> r >> intersect n) AP.relation (concat filters) >> sort [("respect", Desc)] >> drop ofs >> take lim
                return $ map (fromJust . fromHashMap) xs



------------------------------------------------------------------------------
-- | The application's routes.
routes :: Bool ->  [(C.ByteString, Handler App App ())]
routes g = fmap (second (wrapErrors g)) $ [ 
                ("/", index),
                ("/Car/activate", carActivate),
                ("/Car/buy", carBuy),
                ("/Car/deactivate", carDeactivate),
                ("/Car/getOptions", carGetOptions),
                ("/Car/image", downloadCarImage),
                ("/Car/model", loadModel),
                ("/Car/part", carPart),
                ("/Car/parts", carParts),
                ("/Car/sell", carSell),
                ("/Car/setOptions", carSetOptions),
                ("/Car/trash", carTrash),
                ("/Car/uploadImage", uploadCarImage),
                ("/City/list", cityList),
                ("/City/travel", cityTravel),
                ("/Continent/list", continentList),
                ("/Game/template", loadTemplate),
                ("/Game/tree", loadMenu),
                ("/Garage/activeCar", garageActiveCar),
                ("/Garage/activeCarReady", garageActiveCarReady),
                ("/Garage/addPart", addPart),
                ("/Garage/car", garageCar),
                ("/Garage/carReady", garageCarReady),
                ("/Garage/parts", garageParts),
                ("/Garage/partsPreviewed", garagePartsWithPreview),
                ("/Garage/personnel", garagePersonnel),
                ("/Garage/removePart", removePart),
                ("/Garage/reports", garageReports),
                ("/Hiscore/respect", hiscore hsRespect),
                ("/Market/allowedParts", marketAllowedParts),
                ("/Market/buy", marketBuy),
                ("/Market/buyCar", carMarketBuy),
                ("/Market/buySecond", marketPlaceBuy),
                ("/Market/carParts", marketCarParts),
                ("/Market/cars", marketCars),
                ("/Market/manufacturer", marketManufacturer),
                ("/Market/model", marketModel),
                ("/Market/partTypes", marketPartTypes),
                ("/Market/parts", marketParts),
                ("/Market/personnel", marketPersonnel),
                ("/Market/place", marketPlace),
                ("/Market/prototype", marketCarPrototype),
                ("/Market/reports", shoppingReports),
                ("/Market/return", marketReturn),
                ("/Market/returnCar", carReturn),
                ("/Market/sell", marketSell),
                ("/Market/trash", marketTrash),
                ("/Market/usedPartTypes", marketPlacePartTypes),
                ("/Part/tasks", partTasks),
                ("/Personnel/cancelTask", cancelTaskPersonnel),
                ("/Personnel/fire", firePersonnel),
                ("/Personnel/hire", hirePersonnel),
                ("/Personnel/reports", personnelReports),
                ("/Personnel/task", taskPersonnel),
                ("/Personnel/train", trainPersonnel),
                ("/Race/challenge", raceChallenge),
                ("/Race/challengeAccept", raceChallengeAccept),
                ("/Race/challengeGet", searchRaceChallenge),
                ("/Race/challengeWithdraw", raceChallengeWithdraw),
                ("/Race/details", getRaceDetails),
                ("/Race/practice", racePractice),
                ("/Race/reports", searchReports RP.Race),
                ("/Race/reward", searchRaceReward),
                ("/Race/search", raceSearch),
                ("/Reward/event", getRewards),
                ("/Reward/find", findRewards),
                ("/Reward/get", rewardLog),
                ("/Support/send", reportIssue), 
                ("/Test/write", testWrite),
                ("/Time/get", serverTime),
                ("/Tournament/cancel", cancelTournamentJoin),
                ("/Tournament/car", searchTournamentCar),
                ("/Tournament/get", viewTournament),
                ("/Tournament/idk", tournamentPlayers),
                ("/Tournament/players", tournamentAllPlayers),
                ("/Tournament/join", tournamentJoin),
                ("/Tournament/joined", tournamentJoined),
                ("/Tournament/report", tournamentReport),
                ("/Tournament/result", tournamentResults),
                ("/Track/here", trackHere),
                ("/Track/list", trackList),
                ("/Travel/reports", travelReports),
                ("/User/addSkill", userAddSkill),
                ("/User/archiveNotification", archiveNotification), 
                ("/User/claimFreeCar", userClaimFreeCar),
                ("/User/currentRace", userCurrentRace),
                ("/User/data", userData),
                ("/User/login", userLogin),
                ("/User/me", userMe),
                ("/User/notification", userNotification),
                ("/User/readNotification", readNotification), 
                ("/User/register", userRegister),
                ("/User/reports", userReports),
                ("/User/searchNotification", readArchive),
                ("/User/testNotification", testNotification),
                ("/Mission/get", availableMissions),
                ("/Mission/my", userMission),
                ("/Mission/accept", acceptMission)

          ]

getRewards :: Application ()
getRewards = do 
        uid <- getUserId 
        runDb $ activateRewards uid 
        (((l,o), xs),od) <- getPagesWithDTDOrdered ["id"] (
           "account_id" +==| (toSql uid) +&& 
           "id" +== "id" +&& 
           "type_id" +== "type_id" +&&
           "type" +== "type"
            ) 
        xs <- runDb $ do 
                rs <- search xs od l o :: SqlTransaction Connection [RLE.RewardLogEvent]
                forM rs $ \r -> do 
                       fromJust <$> load (fromJust $ RLE.id r) :: SqlTransaction Connection (RL.RewardLog)
        writeResult (transformRewards xs) 

rewardLog :: Application ()
rewardLog = do 
        uid <- getUserId 
        runDb $ activateRewards uid 
        (((l,o), xs),od) <- getPagesWithDTDOrdered ["id","name","viewed","experience","money", "tournament_id", "practice_id", "race_id"] (
           "account_id" +==| (toSql uid) +&&
           "id" +== "id" +&& 

           ifdtd "viewed" (const True)
               ("viewed" +== "viewed")
               ("viewed" +==| (toSql False))
            
            ) 
        xs <- runDb $ do 
                xs <- search xs od l o :: SqlTransaction Connection [RL.RewardLog]
                -- TODO: This is my fault, this code will be runned
                -- a ziljion times if there are ziljion records. 
                --
                -- it should be replaced by an update based on DTD  
                --
                forkSqlTransaction $ forM_ xs (checkRewardLog . fromJust . RL.id)
                return xs 

        writeResult (transformRewards xs) 

initHeartbeat = do 
            cp <- liftIO $ Config.readConfig "resources/server.ini"
            let (Just (StringC announce)) = Config.lookupConfig "Heartbeat" cp >>= Config.lookupVar "announce-address"
            let (Just (StringC own)) = Config.lookupConfig "Heartbeat" cp >>= Config.lookupVar "own-address"
            liftIO $ forkIO $ checkin own announce $ \x -> case x of 
                                                                            Right () -> return $ Nothing 
                                                                            Left e -> error e 





initAll po = Task.init *> initTournament po  

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
    q <- nestSnaplet "slock" slock $ SL.initLock 
    ls <- nestSnaplet "" logcycle $ initLogSnaplet "resources/server.ini"
    initHeartbeat

    liftIO $ initAll p 
    return $ App db c rnd dst notfs q ls  

