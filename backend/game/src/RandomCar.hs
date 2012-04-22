{-# LANGUAGE TupleSections #-}
module Main where 

import           Control.Monad;
import           Control.Monad.Random
import           Control.Applicative;
import           Data.SqlTransaction;
import           Data.Database 
import qualified Data.ByteString.Lazy as BL 
import qualified Data.ByteString.Lazy.Char8 as BC
import qualified Model.Manufacturer as M
import qualified Model.Car as C 
import qualified Model.Part as P 
import qualified Model.PartType as PT 
import           Model.General
import           Data.Char
import           Data.Maybe 
import           Database.HDBC.Types
import           Database.HDBC.PostgreSQL


data Car = Car BL.ByteString BL.ByteString Integer (Maybe Integer)
    deriving Show 

-- readCars :: FilePath -> IO [Car]

putCars = do 
    xs <- readCars "cars.csv" 
    c <- dbconn 
    forM xs (dumpCars c)

readCars f = do 
        c <- BL.readFile f
        let xs = reverse $ tail $ reverse $ (BL.split (fromIntegral $ ord '\n') c)
        let xss = fmap (BL.split (fromIntegral $ ord ';')) xs
        return (fmap mkCar xss)

mkCar xs = case p of
                 [] -> Car (xs !! 0)  (xs !! 1) 101 (fst <$> listToMaybe y)
                 ((n,s):p) -> Car (xs !! 0) (xs !! 1) n (fst <$> listToMaybe y)
    where p = reads ((chr . fromIntegral) <$> BL.unpack (xs !! 5)) :: [(Integer, String)]
          y = reads ((chr . fromIntegral) <$> BL.unpack (xs !! 4)) :: [(Integer, String)]


dumpCars :: Connection  -> Car -> IO ()
dumpCars c (Car nm mdl lvl yr) = do 
               p1 <- getRandomR (1,100)
               p2 <- getRandomR (1,100)
               p3 <- getRandomR (1,100)
               p4 <- getRandomR (1,100)
               p5 <- getRandomR (1,100)
               let b = def {C.id = Nothing,C.top_speed = p1,C.braking = p3, C.handling = p4, C.nos = p5, C.acceleration = p2,  C.year = maybe 0 id  yr, C.name = (BC.unpack mdl), C.level = lvl} ::  C.Car 

               let saveManufacturer = do 
                   let m = def { M.name = (BC.unpack nm)} :: M.Manufacturer 
                   x <- search ["name" |== toSql nm] [] 1 0 
                   case x of 
                        []   -> do i <- save m
                                   save (b { C.manufacturer_id = i })
                        [n] -> save (b { C.manufacturer_id = (fromJust $ M.id n) })

               runSqlTransaction saveManufacturer error c 
                
               return ()

data Part = Part {
            part_type :: String, 
            manufacturer_id :: Integer,
            weight :: Integer,
            car_id :: Maybe Integer,
            parameter :: Integer
            level :: Integer 
        } deriving Show 

putParts :: Connection -> [Part] -> IO ()
putParts c xs = undefined 

getParts :: Int -> Connection -> IO ()
getParts n c = do 
        ms <- runSqlTransaction (fmap (fromJust . M.id) <$> search [] [] 10000 0) error c 
        cs <- runSqlTransaction (fmap (fromJust . C.id) <$> search [] [] 10000 0) error c 
        ps <- generateParts n  ms cs 
        ps <- generateParts 10000 ms cs 
        let bs = forM ps $ \(Part pt mid w cid d pr) -> do 
                    p <- search ["name" |== (toSql pt)] [] 1 0 
                    case p of 
                        [] -> do 
                            i <- save (def { PT.name = pt })
                            save ( def { P.manufacturer_id = mid, P.part_type_id = i, P.weight = w, P.car_id = cid, P.parameter = pr, P.level = d })
                        [n] -> save ( def { P.manufacturer_id = mid, P.part_type_id = fromJust $ PT.id n, P.weight = w, P.car_id = cid, P.parameter = pr , P.level = d})
        runSqlTransaction bs error c 
        return ()


generateParts :: Int -> [Integer] -> [Integer] -> IO [Part]
generateParts n ms cs = evalRandIO $ replicateM n $ do 
                    let xs = ["body","engine","chassis","brake", "wheel", "nos", "aerodynamic", "spoiler"] 
                    t <- fromList $ (,1/10) <$> xs
                    m <- fromList $ (,1/10) <$> ms 
                    w <- getRandomR (1,100)
                    c <- fromList $ (,1/10) <$> cs 
                    p <- getRandomR (1, 100)
                    d <- getRandomR $ (1, 100) 
                    case t of 
                        "aerodynamic" -> return (Part t m w (Just c) p d)
                        otherwise -> return (Part t m w Nothing p d)


breakChar ::  Char -> String -> [String]
breakChar p [] = []
breakChar p xs = let (c, d) = break (==p) xs
                 in c : breakChar p d

