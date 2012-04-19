module Main where 

import           Control.Monad;
import           Control.Applicative;
import           Data.SqlTransaction;
import qualified Data.ByteString.Lazy as BL 
import qualified Model.Manufacturer as M
import qualified Model.Car as C 
import qualified Model.Part as P 
import qualified Model.PartType as PT 
import           Model.General
import           Data.Char
import           Data.Maybe 


data Car = Car BL.ByteString BL.ByteString Integer (Maybe Integer)
    deriving Show 

-- readCars :: FilePath -> IO [Car]
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


dumpCars :: Car -> IO ()
dumpCars (Car nm mdl lvl yr) = do 
               let b = def ::  C.Car 
               return ()
        

breakChar ::  Char -> String -> [String]
breakChar p [] = []
breakChar p xs = let (c, d) = break (==p) xs
                 in c : breakChar p d

