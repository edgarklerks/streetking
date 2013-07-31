{-# LANGUAGE OverloadedStrings, TupleSections #-}
module Main where 

import Control.Monad
import Control.Monad.Random 
import Control.Applicative
import Data.SqlTransaction
import Data.Database
import qualified Database.HDBC as H

import qualified Data.ByteString.Lazy as BL 
import qualified Data.ByteString.Lazy.Char8 as BC
import Model.General
import qualified Model.Country as C 
import qualified Model.PersonnelType as PT 
import qualified Model.Personnel as P 

import Data.Maybe
import qualified Data.Set as S
import Data.List
import Data.Ord
import Data.Default
import Control.Arrow

clashNames = do
        x <- loadFirstNames 
        y <- loadLastNames
        return $ (\x y -> [x] ++ [y]) <$> x <*> (reverse y)


skipn :: Int -> [x] -> [x] 
skipn n xs = skipn' n n xs 
    where skipn' n p (x:xs) | p == 0 = x : skipn' n n xs 
                            | otherwise = skipn' n (p - 1) xs
          skipn' n p [] = []

saveNames :: [[BC.ByteString]] -> IO ()
saveNames xs = do 
        let bc = fmap (BC.intercalate " ") xs 
        let  n = BC.intercalate "\n" bc 
        BC.writeFile "out.csv" n

transformNames :: [Integer] -> [[BC.ByteString]] -> IO [P.Personnel]
transformNames cs [] = return []
transformNames cs (x:xs) = do 
         s <- getRandomR (5,15) 
         smull <- getRandomR (1, 100)
         smulk <- getRandomR (1, 100)
         ps <- getRandomR (1,100)
         cid <- fromList $ (,1) <$> cs 
         rest <- transformNames cs xs
         g <- getRandom 
         let z = def {
            P.name = BC.unpack $ BC.intercalate " " x, 
            P.gender = g, 
            P.skill = s,
            P.salary = s * 100 + 7000 + smull,
            P.country_id = cid,
            P.price = s * 100 + 1000 + smulk,
            P.sort = ps
            }
         return (z : rest)

getCountries :: IO [Integer]
getCountries = do 
    c <- dbconn
    xs <- runSqlTransaction (search [] [] 1000 0) error c :: IO [C.Country]
    return (fromJust . C.id <$> xs)

loadCountries :: IO [C.Country]
loadCountries = do 
   xs <- readFile "countries.csv"
   let cp (s,n) = def { C.name = n, C.shortname = s }
   let f = fmap (cp . second tail . break (=='|')) . lines 
   return (f xs)

saveCountries :: [C.Country] -> IO [C.Country]
saveCountries xs = dbconn >>= \c -> runSqlTransaction  (forM xs $ \i -> do 
                n <- save i
                return (i {C.id = Just n })) error c <* H.commit c  

main :: IO ()
main = getCountries >>= \cs -> dbconn >>= \c -> (transformNames cs . skipn 7128 =<< clashNames) >>= step c
    where step c xs = sequence_ . fmap (\x -> runSqlTransaction (save x) error c) $ xs

loadLastNames :: IO [BC.ByteString]
loadLastNames = fmap (filter (not . BC.null)) $ BC.lines <$> BC.readFile "lastname.csv" 


loadFirstNames :: IO [BC.ByteString]
loadFirstNames = fmap (fmap BC.init) $ BC.lines <$> BC.readFile "firstnames.txt"


generatePersonnel :: Int -> IO [P.Personnel]
generatePersonnel x = return [] 
                            
