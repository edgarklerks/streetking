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
import qualified Model.PartInstance as PI 
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
import qualified Model.MarketCarInstanceParts as MCIP
import qualified Model.CarStockParts as CSP
import qualified Model.MarketPlaceCar as MPC
import qualified Model.Personnel as PL
import qualified Model.PersonnelDetails as PLD
import qualified Model.PersonnelInstance as PLI
import qualified Model.PersonnelInstanceDetails as PLID
import qualified Model.GeneralReport as GR 
import qualified Model.ShopReport as SR 
import qualified Model.PersonnelReport as PR 
import qualified Model.Functions as DBF
import qualified Data.HashMap.Strict as HM
import           Control.Monad.Trans
import           Application
import           Model.General (Mapable(..), Default(..), Database(..))
import           Data.Convertible
import           Data.Time.Clock 
import           Data.Time.Clock.POSIX
import qualified Data.Foldable as F

import qualified Data.Digest.TigerHash as H
import qualified Data.Digest.TigerHash.ByteString as H
import           Data.Conversion
import           Data.InRules
import           Data.Tools
import           System.FilePath.Posix
import           Data.String
import           GHC.Exception (SomeException)

import qualified Control.Monad.CatchIO as CIO
import           Lua.Instances
import           Lua.Monad
import           Lua.Prim
import           Debug.Trace
import           Control.Monad.Random 
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
    x <- getOParam "user_id"
    n <- runDb (load $ convert x) :: Application (Maybe AP.AccountProfile)
    case n of 
        Nothing -> internalError "No such user"
        Just x -> writeMapable x

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

{-- 
 - {
 -  manufacturer_id: 2,
 -  car_model_id: 3
 -
 -
 --}

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

                save (def {
                            PI.garage_id = G.id (head grg), 
                            PI.part_id = fromJust $ Part.id item,
                            PI.account_id = uid 
                            } :: PI.PartInstance) 

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
                                Transaction.amount = - abs(fee),
                                Transaction.type = "garage_car_on_market",
                                Transaction.type_id = fromJust $ CIG.id car
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
                        
                        transactionMoney uid (def {
                                Transaction.amount = abs (CIG.total_price  car),
                                Transaction.type = "car_in_garage_trash",
                                Transaction.type_id = fromJust $ CIG.id car
                            })


                        ci <- fromJust <$> load (fromJust $ CIG.id car) :: SqlTransaction Connection CarInstance.CarInstance 

                        xs <- search [ "car_instance_id" |== toSql (CarInstance.id ci) ] [] 1000 0 :: SqlTransaction Connection [PI.PartInstance] 

                        forM_ xs $ \i -> save (i { PI.deleted = True }) 
                        save (ci { CarInstance.deleted = True }) 

                                

        

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
                                Transaction.type_id = fromJust $ MP.id d 
                            })

                        transactionMoney (MP.account_id p) (def {
                                Transaction.amount = abs(MP.price p),
                                Transaction.type = "market_place_sell",
                                Transaction.type_id = fromJust $ MP.id d
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

 







---



                                

        



 




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

        ((l, o), xs) <- getPagesWithDTD (
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
        ns <- runDb (search xs [] l o) :: Application [GPT.GaragePart]
        writeMapables ns

           
garageCar :: Application ()
garageCar = do 
        uid <- getUserId 
        ((l,o), xs) <- getPagesWithDTD ("id" +== "car_instance_id" +&& "account_id"  +==| (toSql uid)) 
        ps <- runDb $ search xs [] l o :: Application [CIG.CarInGarage]
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
        -- move part from car_instance_id to garage_id 
        pl <- load (fromJust $ MI.part_instance_id d) :: SqlTransaction Connection (Maybe PI.PartInstance)
        case pl of 
            Nothing -> rollback "No such part"
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
        ns <- runDb $ search xs [Order ("sort",[]) True]  l o :: Application [PLD.PersonnelDetails]
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
            g <- head <$> search ["account_id" |== toSql uid] [] 1 0 :: SqlTransaction Connection G.Garage 
            ns <- search (xs ++ ["garage_id" |== (toSql $ G.id g) ]) [Order ("personnel_instance_id",[]) True]  l o
            return ns 
        ns <- p :: Application [PLID.PersonnelInstanceDetails]
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
                                    Transaction.amount = - abs(PLI.training_cost_repair person),
                                    Transaction.type = "personnel_train",
                                    Transaction.type_id = fromJust $ PLI.id person
                                })

                            -- train personnel
                            r <- DBF.personnel_train (fromJust $ PLI.id person) (fugly "type" xs) (fugly "level" xs)
                            return r
                                where fugly k xs = fromSql . fromJust $ HM.lookup k xs


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
                cm <- load (fromJust $ PLI.id person) :: SqlTransaction Connection (Maybe PLI.PersonnelInstance)
                case cm of 
                        Nothing -> rollback "No such person found"
                        Just person -> do
                           delete (undefined :: PLI.PersonnelInstance) ["id" |== toSql (PLI.id person), "garage_id" |== toSql (G.id g)] 
                           reportPersonnel uid (def { 
                                            PR.report_descriptor = "fire_personnel",
                                            PR.personnel_instance_id = PLI.id person,
                                            PR.result = "success"
                                        })
                           return True

{-- Reporting functions --}
{-- 
 - @IN Integer
 - @IN ShopReport
 - @OUT SqlTransaction Connection ()
 - @SIDEEFFECTS Save parameter object to database. Overrides the account identification number  
 --}
reportShopping :: Integer -> -- account_id, should exist and is a bigint 
                 SR.ShopReport -> -- ShopReport is a named parameter object (Model/ShopReport) 
                 SqlTransaction -- Executable and Composable Database Context for Forming Transactions 
                    Connection -- Polymorphic Database Connection Descriptor.  
                    () -- Resultant type of computation 
reportShopping uid x = do -- syntactic sugar for heightening readability.  
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


userReports :: Application ()
userReports = do 
        uid <- getUserId 
        ((l,o),xs) <- getPagesWithDTD ("report_type" +== "report_type" +&& "time" +>= "timemin" +&& "time" +<= "timemax" +&& "account_id" +==| (toSql uid))
        ns <- runDb $ search xs [] l o :: Application [GR.GeneralReport]
        writeMapables ns

personnelReports :: Application ()
personnelReports = do 
        uid <- getUserId 
        ((l,o),xs) <- getPagesWithDTD ("time" +>= "timemin" +&& "time" +<= "timemax" +&& "account_id" +==| (toSql uid))
        ns <- runDb $ search xs [] l o :: Application [PR.PersonnelReport]
        writeMapables ns

shoppingReports :: Application ()
shoppingReports = do 
        uid <- getUserId 
        ((l,o),xs) <- getPagesWithDTD ("time" +>= "timemin" +&& "time" +<= "timemax" +&& "account_id" +==| (toSql uid))
        ns <- runDb $ search xs [] l o :: Application [SR.ShopReport]
        writeMapables ns




-- | The main entry point handler.
site :: Application ()
site = CIO.catch (CIO.catch (route [ 
                ("/", index),
                ("/User/login", userLogin),
                ("/User/register", userRegister),
                ("/User/data", userData),
                ("/User/me", userMe),
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
                ("/Market/returnCar", carReturn),
                ("/Market/carParts", marketCarParts),
                ("/Garage/addPart", addPart),
                ("/Garage/removePart", removePart),
                ("/Garage/personnel", garagePersonnel),
                ("/Market/personnel", marketPersonnel),
                ("/Personnel/hire", hirePersonnel),
                ("/Personnel/fire", firePersonnel),
                ("/Personnel/train", trainPersonnel),
                ("/Personnel/reports", personnelReports),
                ("/User/reports", userReports)
             ]
       <|> serveDirectory "resources/static") (\(UserErrorE s) -> writeError s)) (\(e :: SomeException) -> writeError (show e))
