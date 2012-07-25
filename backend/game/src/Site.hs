{-# LANGUAGE OverloadedStrings, RankNTypes, DisambiguateRecordFields, FlexibleContexts  #-}

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
import qualified Data.ByteString.Lazy as LB
import qualified Data.Text.Encoding as T
import qualified Data.Text as T 
import           Snap.Util.FileServe
import           Snap.Util.FileUploads
import           Snap.Types
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
import qualified Model.Manufacturer as M 
import qualified Model.Car as Car 
import qualified Model.CarInstance as CarInstance 
import qualified Model.CarInGarage as CIG 
import qualified Model.CarMinimal as CAM 
import qualified Model.Car3dModel as C3D
import qualified Model.Part as Part 
import qualified Model.PartMarket as PM 
import qualified Model.PartInstance as PI 
import qualified Model.PartDetails as PD 
import qualified Model.CarMarket as CM 
import qualified Model.ManufacturerMarket as MAM 
import qualified Model.MarketItem as MI 
import qualified Model.Transaction as Transaction
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
import qualified Model.Challenge as Chg
import qualified Model.ChallengeAccept as ChgA
import qualified Model.ChallengeType as ChgT
import qualified Model.ChallengeExtended as ChgE
import qualified Model.Race as R
import qualified Model.RaceDetails as RAD
import qualified Model.GeneralReport as GR 
import qualified Model.ShopReport as SR 
import qualified Model.GarageReport as GRP
import qualified Model.PersonnelReport as PR 
import qualified Model.TravelReport as TR 
import qualified Model.Functions as DBF
import qualified Data.HashMap.Strict as HM
import           Control.Monad.Trans
import           Application
import           Model.General (Mapable(..), Default(..), Database(..))
import           Data.Convertible
import           Data.Time.Clock 
import           Data.Time.Clock.POSIX
import qualified Data.Foldable as F
import           Data.Hstore

import qualified Data.Digest.TigerHash as H
import qualified Data.Digest.TigerHash.ByteString as H
import           Data.Conversion
import           Data.InRules
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
import           Data.ComposeModel

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
    x <- getJson >>= scheck ["id"]
    let m = updateHashMap x (def :: APM.AccountProfileMin)
    n <- runCompose $ do 
                action "user" ((load $ fromJust $ APM.id m) :: SqlTransaction Connection (Maybe APM.AccountProfileMin))
                action "car" $ do
                    xs <- search ["account_id" |== toSql (APM.id m) .&& "active" |== toSql True] [] 1 0 :: SqlTransaction Connection [CAM.CarMinimal]
                    case xs of 
                        [] -> return Nothing
                        [x] -> return (Just x)
    writeResult n 

userMe :: Application ()
userMe = do 
    x <- getUserId 
    n <- runDb $ do 
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
    tpsx <- liftIO (floor <$> getPOSIXTime :: IO Integer )
    
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
    let car = updateHashMap xs ( def :: CM.CarMarket)
    flup <- ps uid xs car 
    writeResult ("You succesfully bought the car" :: String)
         where ps uid xs car =  runDb $ do 
                g <- head <$> search ["account_id" |== toSql uid] [] 1 0 :: SqlTransaction Connection G.Garage 
                cm <- load (fromJust $ CM.id car) :: SqlTransaction Connection (Maybe CM.CarMarket)
                case cm of 
                        Nothing -> rollback "No such car found"
                        Just car -> do  
                
                            -- save car to garage 
                
                            cid <- save ((def :: CarInstance.CarInstance) {
                                         CarInstance.garage_id =  G.id g,
                                         CarInstance.car_id = fromJust $ CM.id car 
                                    }) :: SqlTransaction Connection Integer
                
                        -- sammeln stockr parts 
                        --

                            -- Part loader 
                            pts <- search ["car_id" |== (toSql $ CM.id car)] [] 1000 0 :: SqlTransaction Connection [CSP.CarStockPart]


                            let step z part = do 
                                    save (def {
                                       PI.part_id = fromJust $ CSP.id part,
                                       PI.car_instance_id = Just cid,
                                       PI.account_id = uid,
                                       PI.deleted = False 
                                    })
                                    return ()

                            foldM_ step () pts  

                            reportShopper uid (def {
                                    SR.amount = abs(CM.price car),
                                    SR.car_instance_id =  Just cid,
                                    SR.report_descriptor = "shop_car_buy"
                                })

                                    -- pay shit
                            transactionMoney uid (def {
                                    Transaction.amount = - abs(CM.price car),
                                    Transaction.type = "car_instance",
                                    Transaction.type_id = fromJust $ CM.id car
                                })
                            return True


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
        p uid d 
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
                        --
                        delete (undefined :: MI.MarketItem) ["part_instance_id" |== toSql (MP.id d)] 

                        -- reassign part_instance to new garage_id 

                        pi <- fromJust <$> load (fromJust $ MP.id d) :: SqlTransaction Connection PI.PartInstance
                        save (pi {PI.garage_id =  G.id a, PI.car_instance_id = Nothing, PI.account_id = uid})
            p 

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
        tpsx <- liftIO (floor <$> getPOSIXTime :: IO Integer )
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
                        
        (((l, o), xs),od) <- getPagesWithDTDOrdered ["level", "part_instance_id"] (
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
            r <- DBF.garage_actions_account uid
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
            r <- DBF.garage_actions_account uid
            (ns :: [CIG.CarInGarage]) <- search xs od l o
            return ns 
        ns <- p :: Application [CIG.CarInGarage]
        writeMapables (props <$> ns)
    where
        props :: CIG.CarInGarage -> CIG.CarInGarage
        props c = c {
                CIG.acceleration = todbi $ acceleration car defaultEnvironment,
                CIG.top_speed = todbi $ topspeed car defaultEnvironment,
                CIG.cornering = todbi $ cornering car defaultEnvironment,
                CIG.stopping = todbi $ stopping car defaultEnvironment,
                CIG.nitrous = todbi $ nitrous car defaultEnvironment
            }
                where
                    car = Car (fromInteger $ CIG.weight c) (fromdbi $ CIG.power c) (fromdbi $ CIG.traction c) (fromdbi $ CIG.handling c) (fromdbi $ CIG.braking c) (fromdbi $ CIG.aero c) (fromdbi $ CIG.nos c)


todbi :: Double -> Integer
todbi = floor . (10000 *)
fromdbi :: Integer -> Double
fromdbi = (/ 10000) . fromInteger


garageActiveCar :: Application ()
garageActiveCar = do 
        uid <- getUserId 
        (((l,o), xs),od) <- getPagesWithDTDOrdered [] ("id" +== "car_instance_id" +&& "account_id"  +==| (toSql uid) +&& "active" +==| SqlBool True) 
        let p = runDb $ do
            r <- DBF.garage_actions_account uid
            ns <- search xs od l o
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
            then internalError "do not hacked server"
            else serveFileAs "text/plain" pth

userAddSkill :: Application ()
userAddSkill = do 
        uid <- getUserId 
        xs <- getJson
        u' <- runDb $ do 
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
    let d = updateHashMap xs (def :: MI.MarketItem)
    p uid d
    writeResult ("You added the part" :: String)
 where p uid d = runDb $ do 
        pl <- load (fromJust $ MI.part_instance_id d) :: SqlTransaction Connection (Maybe PI.PartInstance)
        case pl of 
            Nothing -> rollback "No such part"
            Just x -> do 
                p <- search ["part_instance_id" |== toSql (MI.part_instance_id d)] [] 1 0 :: SqlTransaction Connection [GPT.GaragePart]
                case p of 
                    [] -> rollback "impossubru happended" 
                    [p] -> do 
                        xs <- search ["part_type_id" |== toSql (GPT.part_type_id p) .&& "car_instance_id" |== toSql (MI.car_instance_id d)] [] 1 0 :: SqlTransaction Connection [CIP.CarInstanceParts]
                        case xs of 
                            [] -> do  

                                g <- head <$> search ["account_id" |== toSql uid] [] 1 0 :: SqlTransaction Connection G.Garage
        
                                when (isJust (PI.car_instance_id x)) $ rollback "part already in car"

            
                                save (x {PI.garage_id = Nothing, PI.car_instance_id = MI.car_instance_id d }) 
                                return ()
                            [s] -> do 
                                pl <- fromJust <$> load (CIP.part_instance_id s) :: SqlTransaction Connection (PI.PartInstance)
                                g <- head <$> search ["account_id" |== toSql uid] [] 1 0 :: SqlTransaction Connection G.Garage
                                save (pl {PI.garage_id = G.id g, PI.car_instance_id = Nothing})
                                save (x {PI.garage_id = Nothing, PI.car_instance_id = MI.car_instance_id d }) 
                                return ()





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
            r <- DBF.garage_actions_account uid
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
                            r <- DBF.personnel_start_task (extract "personnel_instance_id" xs) (extract "task" xs) (extract "subject_id" xs)
                            return r


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
                            r <- DBF.personnel_cancel_task $ extract "personnel_instance_id" xs
                            return r


-- extract is extract
extract k xs = fromSql . fromJust $ HM.lookup k xs


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

{-- Money stuff --}
transactionMoney :: Integer -> Transaction.Transaction -> SqlTransaction Connection ()
transactionMoney uid tr' =   do 
                            tpsx <- liftIO (floor <$> getPOSIXTime :: IO Integer )
                            let tr = tr' {Transaction.time = tpsx }
                            a <- load uid :: SqlTransaction Connection (Maybe A.Account)
                            case a of 
               
                                Nothing -> rollback "tri tho serch yer paspoht suplieh bette, friennd"
                                Just a -> do 

                                    when (A.money a + Transaction.amount tr < 0) $ rollback "You don' tno thgave eninh monye, brotther"

                                    -- save transaction 

                                    save $ tr { Transaction.current = A.money a, Transaction.account_id = uid }
                                    -- save user 
                                    save $ a { A.money = A.money a + Transaction.amount tr }
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
                                                when ( (TCY.city_level city) > (A.level a)) $ rollback "You are not ready for this city"
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
            DBF.garage_actions_account uid
            search xs [Order ("time",[]) False] l o 
        writeMapables (ns :: [GRP.GarageReport])

   
travelReports :: Application ()
travelReports = do 
    uid <- getUserId 
    ((l,o),xs) <- getPagesWithDTD ("time" +>= "timemin" +&& "time" +<= "timemax" +&& "account_id" +==| (toSql uid))
    ns <- runDb (search xs [] l o) :: Application [TR.TravelReport]
    writeMapables ns 

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



racePractice :: Application ()
racePractice = do
        uid <- getUserId
        -- get track id
        xs <- getJson >>= scheck ["track_id"]
        let tid = extract "track_id" xs :: Integer
        -- get account
        r <- runDb $ do
            as <- search ["id" |== toSql uid] [] 1 0 :: SqlTransaction Connection [A.Account]
            case as of
                [] -> rollback "you dont exist, go away."
                a:_ -> do

                    -- TODO: disallow racing if busy -- use time_left instead of < t
--                   case A.busy_until > t of -- etc. rollback "you are busy"
--
--                   TODO: check track level against account level
                   
                    -- fetch profile
                    [ap] <- search ["id" |== toSql uid] [] 1 0 :: SqlTransaction Connection [APM.AccountProfileMin]
                    --  -> make Driver 
                    let d = accountDriver a
                    -- get active car
                    g <- head <$> search ["account_id" |== toSql uid] [] 1 0 :: SqlTransaction Connection G.Garage 
                    gcs <- search ["active" |== SqlBool True, "garage_id" |== (toSql $ G.id g)] [] 1 0 :: SqlTransaction Connection [CIG.CarInGarage]
                    case gcs of
                        [] -> rollback "you have no active car"
                        [gc] -> do
                            ry <- DBF.garage_active_car_ready (fromJust $ G.id g)
                            case length ry > 0 of
                                True -> rollback "your active car is not ready"
                                False -> do
                                    -- make Car
                                    let c = carInGarageCar gc
                                    -- get track sections
                                    --  -> make track
                                    tss <- search ["track_id" |== SqlInteger tid] [] 1000 0 :: SqlTransaction Connection [TD.TrackDetails]
                                    case tss of
                                        [] -> rollback "no data found for track"
                                        _ -> do
                                            -- make Track
                                            let ss = trackDetailsTrack tss
                                            -- get environment from track data
                                            let e = defaultEnvironment

                                            -- run race
                                            let rs = raceResult2FE $ runRace ss d c e
                                            
                                            -- store data
                                            t <- liftIO (floor <$> getPOSIXTime :: IO Integer)
                                            let te = (t + ) $ ceiling $ raceTime rs
                                            let race = def :: R.Race
                                            rid <- save (race { R.track_id = (trackId rs), R.start_time = t, R.end_time = te, R.type = 1, R.data = [RaceData ap gc rs] })

                                            -- set account busy
                                            save (a { A.busy_type = 2, A.busy_subject_id = rid, A.busy_until = te })

                                            -- return race id
                                            return rid
        -- write results
        writeResult r

testWrite :: Application ()
testWrite = do
        uid <- getUserId
        writeResult' $ AS.toJSON $ HM.fromList [("bla" :: LB.ByteString, AS.toJSON (1::Integer)), ("foo", AS.toJSON $ HM.fromList [("bar" :: LB.ByteString, 1 :: Integer)])]


{-
 - Asserted record fetching tools; move to some appropriate location later
 -}

-- get one record or run f if none found
aget :: Database Connection a => Constraints -> SqlTransaction Connection () -> SqlTransaction Connection a
aget cs f = do
    ss <- search cs [] 1 0
    unless (not $ null ss) f
    return $ head ss

-- get list of records or run f if none found
agetlist :: Database Connection a => Constraints -> Orders -> Integer -> Integer -> SqlTransaction Connection () -> SqlTransaction Connection [a]
agetlist cs os l o f = do
    ss <- search cs os l o 
    unless (not $ null ss) f
    return ss

-- run f if any records found. note: return is necessary in order to infer search type.
adeny :: Database Connection a => Constraints -> SqlTransaction Connection () -> SqlTransaction Connection [a]
adeny cs f = do
    ss <- search cs [] 1 0
    unless (null ss) f
    return ss

raceChallenge :: Application ()
raceChallenge = raceChallengeWith 2 

raceChallengeWith :: Integer -> Application ()
raceChallengeWith p = do
        uid <- getUserId
        xs <- getJson >>= scheck ["track_id", "type"]
        -- challenger busy during race?? what if challenger already busy? --> active challenge sets user busy?
        -- what if challenger leaves city? disallow travel if challenge active? or do not care?
        let tid = extract  "track_id" xs :: Integer
        let tp = extract "type" xs :: String
        i <- runDb $ do
            a <- aget ["id" |== toSql uid] (rollback "account not found") :: SqlTransaction Connection A.Account
--            ap <- aget ["id" |== toSql uid] (rollback "account profile not found") :: SqlTransaction Connection AP.AccountProfile
            apm <- aget ["id" |== toSql uid] (rollback "account min not found") :: SqlTransaction Connection APM.AccountProfileMin
            c <- aget ["account_id" |== toSql uid .&& "active" |== toSql True] (rollback "Active car not found") :: SqlTransaction Connection CIG.CarInGarage
            t <- aget ["track_id" |== toSql tid, "track_level" |<= (SqlInteger $ A.level a), "city_id" |== (SqlInteger $ A.city a)] (rollback "track not found") :: SqlTransaction Connection TT.TrackMaster
            _ <- adeny ["account_id" |== SqlInteger uid] (rollback "you're already challenging") :: SqlTransaction Connection [Chg.Challenge]
            n <- aget ["name" |== SqlString tp] (rollback "unknown challenge type") :: SqlTransaction Connection ChgT.ChallengeType
            save $ (def :: Chg.Challenge) {
                    Chg.track_id = tid,
                    Chg.account_id = uid,
                    Chg.participants = p,
                    Chg.type = (fromJust $ ChgT.id n),
                    Chg.account = a,
                    Chg.account_min = apm,
                    Chg.car = c
                }
        writeResult i

raceChallengeAccept :: Application ()
raceChallengeAccept = do

        uid <- getUserId :: Application Integer
        xs <- getJson >>= scheck ["challenge_id"]

        let cid = extract "challenge_id" xs :: Integer 

        res <- runDb $ do
        
            chg <- aget ["id" |== toSql cid, "account_id" |<> toSql uid ] (rollback "challenge not found") :: SqlTransaction Connection Chg.Challenge

            -- TODO: check user busy

            a <- aget ["id" |== toSql uid] (rollback "account not found") :: SqlTransaction Connection A.Account
            c <- aget ["account_id" |== toSql uid .&& "active" |== toSql True] (rollback "Active car not found") :: SqlTransaction Connection CIG.CarInGarage
            tr <- aget ["track_id" |== (SqlInteger $ Chg.track_id chg), "track_level" |<= (SqlInteger $ A.level a), "city_id" |== (SqlInteger $ A.city a)] (rollback "track not found") :: SqlTransaction Connection TT.TrackMaster
           
            -- get track section data
            ts <- agetlist ["track_id" |== (SqlInteger $ TT.track_id tr) ] [] 1000 0 (rollback "track data not found") :: SqlTransaction Connection [TD.TrackDetails]
            
            ma <- aget ["id" |== toSql uid] (rollback "account minimal not found") :: SqlTransaction Connection APM.AccountProfileMin
            oma <- aget ["id" |== (toSql $ Chg.account_id chg)] (rollback "opponent account minimal not found") :: SqlTransaction Connection APM.AccountProfileMin
            
            let env = defaultEnvironment
            let trk = trackDetailsTrack ts

            -- run race
            let yrs = raceResult2FE $ runRace trk (accountDriver a) (carInGarageCar c) env
            let ors = raceResult2FE $ runRace trk (accountDriver $ Chg.account chg) (carInGarageCar $ Chg.car chg) env
           
            let win = (raceTime yrs) < (raceTime ors) -- draw in favour of challenger

            -- store data
            t <- liftIO (floor <$> getPOSIXTime :: IO Integer)
            let te = (t + ) $ ceiling $ max (raceTime yrs) (raceTime ors)
            rid <- save $ (def :: R.Race) { R.track_id = (TT.track_id tr), R.start_time = t, R.end_time = te, R.type = 1, R.data = [RaceData ma c yrs, RaceData oma (Chg.car chg) ors] }

            -- set account busy
            -- TODO: also set / modify challenger account busy
            save (a { A.busy_type = 2, A.busy_subject_id = rid, A.busy_until = te })
            
--            return $ toInRule $ HM.fromList $ [("td" :: String, toInRule ts), ("a", toInRule a), ("rres", toInRule yrs), ("c", toInRule c), ("tr", toInRule tr), ("ma", toInRule ma), ("oma", toInRule oma)]

            -- return race id
            return rid

        writeResult res

-- get own race challenge
-- get race challenge by id
-- get race challenges by level, city_id, etc.

getRaceChallenge :: Application ()
getRaceChallenge = do
        -- min account data in challenge
        uid <- getUserId 
        cs <- runDb $ search [] [Order ("challenge_id",[]) False] 10000 0 :: Application [ChgE.ChallengeExtended] -- TODO: some account stuff in there
        writeMapables cs



getRace :: Application ()
getRace = do
        ((l,o),xs) <- getPagesWithDTD ("id" +== "race_id")
        rs <- runDb (search xs [] l o) :: Application [R.Race]
        writeMapables rs

userCurrentRace :: Application ()
userCurrentRace = do
        uid <- getUserId
        (dat, td, ts) <- runDb $ do
            as <- search ["id" |== toSql uid] [] 1 0 :: SqlTransaction Connection [A.Account]
            case length as > 0 of
                False -> rollback "you dont exist, go away."
                True -> do
                    rs <- search ["race_id" |== (toSql $ A.busy_subject_id (head as))] [] 1 0 :: SqlTransaction Connection [RAD.RaceDetails]
                    case length rs > 0 of
                        False -> rollback "error: race not found"
                        True -> do
                            let r = head rs
                            ts <- search ["track_id" |== (SqlInteger $ RAD.track_id r)] [] 1000 0 :: SqlTransaction Connection [TD.TrackDetails]
                            td <- head <$> (search ["track_id" |== (SqlInteger $ RAD.track_id r)] [] 1 0 :: SqlTransaction Connection [TT.TrackMaster])
                            return (r, td, ts) 
        writeResult' $ AS.toJSON $ HM.fromList [("race" :: LB.ByteString, AS.toJSON dat), ("track_sections", AS.toJSON ts), ("track_data", AS.toJSON td)]

-- | The main entry point handler.
site :: Application ()
site = CIO.catch (CIO.catch (route [ 
                ("/", index),
                ("/User/login", userLogin),
                ("/User/register", userRegister),
                ("/User/data", userData),
                ("/User/me", userMe),
                ("/User/currentRace", userCurrentRace),
                -- skill_acceleration: <number>
                ("/User/addSkill", userAddSkill),
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
                ("/Race/challengeGet", getRaceChallenge),
                ("/Race/practice", racePractice),
                ("/Race/get", getRace)
             ]
       <|> serveDirectory "resources/static") (\(UserErrorE s) -> writeError s)) (\(e :: SomeException) -> writeError (show e))



