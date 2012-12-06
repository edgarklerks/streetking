{-# LANGUAGE GADTs, ScopedTypeVariables, ViewPatterns, RankNTypes, ImpredicativeTypes, NoMonomorphismRestriction #-}
module Notifications (
      NotificationParam(..),
      carMarket,
      carRepair,
      levelUp,
      partImprove,
      partMarket,
      partRepair,
      raceStart,
      returnCar, 
      returnPart,
      sendBulk,
      sendCentralNotification,
      sendNotification,
      tournamentStart
    ) where 

import           Application 
import           Data.Aeson 
import           Data.Conversion 
import           Data.Convertible 
import           Data.Database hiding (Value)
import           Data.SqlTransaction 
import           Database.HDBC.PostgreSQL
import           Database.HDBC.SqlValue
import           GHC.Read 
import           Model.General 
import           Model.Notification as N
import           Model.PreLetter as L 
import           Unsafe.Coerce 
import qualified Data.ByteString.Lazy as L 
import qualified Data.HashMap.Strict as HM 
import qualified Data.Notifications as N 
import qualified Text.Read.Lex as L 


data RaceType = Money | Car | Custom String 

instance Show RaceType where 
    show Money = "money"
    show Car = "car"
    show (Custom s) = s 

instance Read RaceType where 
    readPrec = parens $ do
                L.Ident s <- lexP 
                case s of 
                    "money" -> return Money
                    "car" -> return Car  
                    otherwise -> return (Custom s)


data NotificationParam where 

        LevelUp :: {level :: Integer 
                , skill :: Integer
                , health :: Integer
                , money :: Integer
                , diamonds :: Integer} 
                -> NotificationParam 

        PartRepair  :: {part_id :: Integer
                    , repaired :: Integer} 
                    -> NotificationParam

        CarRepair :: {car_id :: Integer
                   ,  repaired :: Integer } 
                  ->  NotificationParam 

        PartImprove :: {part_id :: Integer
                    ,   improved :: Integer}
                    -> NotificationParam

        RaceStart :: {race_type :: RaceType
                  ,   race_id :: Integer}
                  ->  NotificationParam 

        TournamentStart :: {tournament_id :: Integer}
                        -> NotificationParam 

        CarMarket :: {car_id :: Integer, money :: Integer} -> NotificationParam 
        PartMarket :: {part_id :: Integer, money :: Integer} -> NotificationParam 
        ReturnCar :: {car_id :: Integer}
                  -> NotificationParam 
        ReturnPart :: {part_id :: Integer}
                   -> NotificationParam 

instance Show NotificationParam where 
        show (LevelUp _ _ _ _ _) = "LevelUp"
        show (PartRepair _ _) = "PartRepair"
        show (CarRepair _ _) = "CarRepair"
        show (PartImprove _ _) = "PartImprove"
        show (RaceStart _ _) = "RaceStart"
        show (TournamentStart _) = "TournamentStart"
        show (CarMarket _ _) = "CarMarket"
        show (PartMarket _ _) = "PartMarket"
        show (ReturnCar _) = "ReturnCar"
        show (ReturnPart _) = "ReturnPart"

sendBulk xs d = mapM_ (flip sendNotification d) xs 

sendNotification uid d@(show -> xs) =  do 
                 x <- runDb $ (aget ["language" |== (SqlInteger 1) .&& "name" |== (SqlString xs)] (rollback $ "notification " ++ xs ++ " not found") :: SqlTransaction Connection Notification) 

                 sendLetter uid (
                            (notificationToLetter x) {
                                        L.data = Just $ toData d 
                            })


                    

-- sendCentralNotification :: Integer -> NotificationParam -> SqlTransaction Connection () 
sendCentralNotification uid d@(show -> xs) = do 
                    x <- aget ["language" |== (SqlInteger 1) .&& "name" |== (SqlString xs)] (rollback $ "notification " ++ xs ++ " not found") :: SqlTransaction Connection Notification                  
                    
                    N.sendCentral uid (
                            (notificationToLetter x) {
                                        L.data = Just $ toData d 
                            })





toData :: NotificationParam -> L.ByteString 
toData p = encode $ (fromInRule :: InRule -> Value) $ toInRule p 

notificationToLetter :: Notification -> PreLetter 
notificationToLetter x = def {
                        message = N.body x,
                        L.title = N.title x, 
                        L.type = N.type x 
                             }

levelUp :: NotificationParam 
levelUp = LevelUp {
                level = 0,
                skill = 0,
                health = 0,
                money = 0,
                diamonds = 0
            }
partRepair :: NotificationParam 
partRepair = PartRepair {
                part_id = 0,
                repaired = 0
            }

carMarket :: NotificationParam 
carMarket = CarMarket {
                car_id = 0,
                money = 0
            }
partMarket :: NotificationParam 
partMarket = PartMarket {
                part_id = 0,
                money = 0
            }
carRepair :: NotificationParam 
carRepair = CarRepair {
                car_id = 0,
                repaired = 0
            }
returnPart :: NotificationParam 
returnPart = ReturnPart {
                part_id = 0
            }

returnCar :: NotificationParam 
returnCar = ReturnCar {
                car_id = 0
            }

raceStart :: NotificationParam 
raceStart = RaceStart {
                race_type = Money,
                race_id = 0
            }
tournamentStart :: NotificationParam 
tournamentStart = TournamentStart {
                    tournament_id = 0
                }

partImprove :: NotificationParam 
partImprove = PartImprove {
            part_id = 0,
            improved = 0
        }

isLevelUp :: NotificationParam -> Bool 
isLevelUp (LevelUp _ _ _ _ _) = True 
isLevelUp _ = False 

isPartRepair :: NotificationParam -> Bool 
isPartRepair (PartRepair _ _) = True 
isPartRepair _ = False 

isCarRepair :: NotificationParam -> Bool 
isCarRepair (CarRepair _ _) = True 
isCarRepair _ = False 

isRaceStart :: NotificationParam -> Bool 
isRaceStart (RaceStart _ _) = True 
isRaceStart _ = False 

isTournamentStart :: NotificationParam -> Bool 
isTournamentStart (TournamentStart _) = True 
isTournamentStart _ = False 

isCarMarket :: NotificationParam -> Bool 
isCarMarket (CarMarket _ _) = True 
isCarMarket _ = False 

isPartMarket :: NotificationParam -> Bool 
isPartMarket (PartMarket _ _) = True 
isPartMarket _ = False 

isPartImprove :: NotificationParam -> Bool 
isPartImprove (PartImprove _ _) = True 
isPartImprove _ = False 

isReturnPart :: NotificationParam -> Bool 
isReturnPart (ReturnPart _) = True 
isReturnPart _ = False 

isReturnCar :: NotificationParam -> Bool 
isReturnCar (ReturnCar _) = True 
isReturnCar _ = False 

instance ToInRule RaceType where 
        toInRule Money = InString "Money"
        toInRule Car = InString "Car"
        toInRule (Custom s) = InString s 

instance ToInRule NotificationParam where 
        toInRule d                     | isPartRepair d = InObject $ asInRule [
                                                            ("part_instance_id", l part_id d),
                                                                ("repaired", l repaired d)
                                                            ]
                                       | isCarRepair d = InObject $ asInRule [
                                                                ("car_instance_id", l car_id d),
                                                                ("repaired", l repaired d)
                                                            ]
                                       | isRaceStart d = InObject $ asInRule [
                                                                ("race_type", l race_type d),
                                                                ("race_id", l race_id d)
                                                            ]
                                       | isPartImprove d = InObject $ asInRule [
                                                                ("part_instance_id", l part_id d),
                                                                ("improved" , l improved d)
                                                            ]
                                       | isTournamentStart d = InObject $ asInRule [
                                                                ("tournament_id", l tournament_id d)
                                                            ]
                                       | isLevelUp d = InObject $ asInRule [
                                                         ("level", l level d )
                                                       , ("skill", l skill d )
                                                       , ("health",l health d) 
                                                       , ("money", l money d)
                                                       , ("diamonds",l diamonds d)
                                                    ]
                                       | isPartMarket d = InObject $ asInRule [
                                                                ("part_instance_id", l part_id d),
                                                                ("money", l money d)
                                                            ]
                                       | isCarMarket d = InObject $ asInRule [
                                                                ("car_instance_id", l car_id d),
                                                                ("money", l money d)
                                                            ]
                                       | isReturnPart d = InObject $ asInRule [
                                                                ("part_instance_id", l part_id d)
                                                            ]
                                       | isReturnCar d = InObject $ asInRule [
                                                                ("car_instance_id", l car_id d)
                                                            ]

l :: ToInRule a => (s -> a) -> s -> Box 
l f g = Box $ f g  

data Box = forall a. ToInRule a => Box a 



asInRule :: ([(String,Box)]) -> HM.HashMap String InRule  
asInRule xs = HM.fromList $ worker [] xs 
    where worker z ((x,Box y):xs) = worker ((x,toInRule y):z) xs 
          worker z [] = z 

