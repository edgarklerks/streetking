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
import           Control.Monad.Trans
import           Application
import           Model.General (Mapable(..), Default(..), Database(..))
import           Data.Convertible
import           Data.Time.Clock 
import           Data.Time.Clock.POSIX

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

marketPlace :: Application ()
marketPlace = do 
           uid <- getUserId
           puser <- fromJust <$> runDb (load uid) :: Application (A.Account )
           ((l, o), xs) <- getPagesWithDTD ("car_id" +== "car_id" +&& "name" +== "part_type" +&& "level" +>= "minlevel" +&& "level" +<= "maxlevel")
           ns <- runDb (search ( ("level" |<= (toSql $ A.level puser )) : xs) [] l o) :: Application [MP.MarketPlace]
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
      ((l,o),xs) <-  getPagesWithDTD ("manufacturer_id" +== "manufacturer_id")
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
        (puser :: A.Account) <- fromJust <$> load uid
        let item' = updateHashMap xs (def :: Part.Part)        
        item <- load (fromJust $ Part.id item')
        -- Some checks 
        case item of 
            Nothing -> rollback "No such item, puddy puddy puddy"
            Just item -> do 
                when (Part.level item > A.level puser) $ rollback "No correct level cowboy"
                let mny = A.money puser - abs (Part.price item)
                if mny < 0 
                    then rollback "You don' tno thgave eninh monye, brotther"
                    else do 

                        -- We can buy now 
                        grg <- search ["account_id" |== (toSql uid)]  [] 1 0 :: SqlTransaction Connection [G.Garage]
                       
                        -- Add to user garage 
                        
                        save (def {
                            PI.garage_id = G.id (head grg), 
                            PI.part_id = fromJust $ Part.id item,
                            PI.account_id = uid 
                        } :: PI.PartInstance) 
                       
                       -- write it away in transaction log 
                        save (def { 
                            Transaction.amount = - abs (Part.price item), 
                            Transaction.current = A.money puser,
                            Transaction.type = "part_model",
                            Transaction.type_id = fromJust $ Part.id item,
                            Transaction.time = tpsx  
                                })
                        -- restore money to new amount 
                        save (puser { A.money = mny } )

                        return ()
                
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
            tpsx <- liftIO (floor <$> getPOSIXTime :: IO Integer )
            pts uid d (floor (x :: Double)) tpsx
            writeResult True 
    where pts uid d fee tpsx = runDb $ do 
           p <- search [("id" |== toSql ( MI.part_instance_id d)) .&& ("account_id" |== toSql uid)] [] 1 0 :: SqlTransaction Connection [PI.PartInstance]
           case p of 
            [] -> rollback $ "No such part: " ++ (show $ MI.part_instance_id d)
            [x] -> do 
                    a <- fromJust <$> load uid  :: SqlTransaction Connection (A.Account)
                    
                    let mny = A.money a - abs fee
                    when (mny < 0) $ rollback "Not enough money, fuckface"
                    when (Mi.price d < 0) $ rollback "Price should be positive" 
                    -- save part to market  

                    save (d {MI.account_id = uid, price = abs (Mi.price d)  })
                    

                    -- save part_instance as loon item 
                    save (x {PI.garage_id = Nothing })

                    -- write it away in transaction log 
                    save (def { 
                            Transaction.amount = -(abs fee), 
                            Transaction.current = A.money a,
                            Transaction.type = "garage_sell",
                            Transaction.type_id = fromJust $ MI.part_instance_id d,
                            Transaction.time = tpsx  
                        })
                    -- restore money to new amount 
                    save (a { A.money = mny } )

marketPlaceBuy :: Application ()
marketPlaceBuy = do 
            uid <- getUserId
            return undefined


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
                        a <-  fromJust <$> load uid :: SqlTransaction Connection A.Account
                        save (a {A.money = A.money a + abs (GPT.price d)})
                        save (def { 
                                Transaction.amount = abs (GPT.price d), 
                                Transaction.current = A.money a,
                                Transaction.type = "garage_trash",
                                Transaction.type_id = fromJust $ GPT.id d,
                                Transaction.time = tpsx  
                            })
                            
                        -- hide forever
                        pti <- fromJust <$> load (GPT.part_instance_id d) :: SqlTransaction Connection PI.PartInstance
                        save (pti { PI.deleted = True })
             




marketParts :: Application ()
marketParts = do 
   uid <- getUserId
   puser <- fromJust <$> runDb (load uid) :: Application (A.Account )
   ((l, o), xs) <- getPagesWithDTD ("car_id" +== "car_id" +&& "name" +== "part_type")
   ns <- runDb (search ( ("level" |<= (toSql $ A.level puser )) : xs) [] l o) :: Application [PM.PartMarket]
   writeMapables ns

garageParts :: Application ()
garageParts = do 
        uid <- getUserId 
        ((l, o), xs) <- getPagesWithDTD ("car_id" +== "car_id" +&& "name" +== "part_type" +&& "part_instance_id" +== "part_instance_id" +&& "level" +<= "level-max" +&& "level" +>= "level-min")
        ns <- runDb (search ( ("account_id" |== (toSql uid)) : xs) [] l o) :: Application [GPT.GaragePart]
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
                ("/Market/return", ni),
                ("/Market/parts", marketParts),
                ("/Garage/car", garageCar),
                ("/Car/model", loadModel),
                ("/Game/template", loadTemplate),
                ("/Game/tree", loadMenu),
                ("/Garage/parts", garageParts),
                ("/Market/allowedParts", marketAllowedParts),
                ("/Market/place", marketPlace),
                ("/Market/trash", marketTrash)
             ]
       <|> serveDirectory "resources/static") (\(UserErrorE s) -> writeError s)) (\(e :: SomeException) -> writeError (show e))
