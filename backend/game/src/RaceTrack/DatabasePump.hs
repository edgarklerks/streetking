{-# LANGUAGE NoMonomorphismRestriction #-}
module Main where 


import Database.HDBC
import Database.HDBC.PostgreSQL hiding (begin)
import System.Environment 
import Vector 
import Data.Binary 
import qualified Data.ByteString.Lazy as B
import Control.Applicative
import Control.Monad
import Data.Maybe 
import Cell 


db = connectPostgreSQL "host=db.graffity.me user=deosx password=#*rl& dbname=streetking_dev";


main :: IO ()
main = do 
    xs <- getArgs 
    let dst = read (xs !! 0) :: Int
    let dbin = xs !! 1
    let sbin = xs !! 2
    let cbin = xs !! 3
    let cid  = xs !! 4 
    dsb <- decode <$> B.readFile dbin 
    print dsb
    seg <- decode <$> B.readFile sbin 
    cel <- decode <$> B.readFile cbin 
    dumpDatabase dst dsb seg cel cid 
    return ()

jsonArray :: [(Int,Int)] -> String 
jsonArray x = "[" ++ jsonPair x ++ "]"

jsonPair :: [(Int,Int)] -> String 
jsonPair [] = ""
jsonPair [(x,y)] = "[" ++ show x ++ "," ++ show y ++ "]"
jsonPair ((x,y):xs) = "[" ++ (show x) ++ "," ++ (show y) ++ "]," ++ jsonPair xs

dumpDatabase :: Int -> [(Int,Int)] -> [[Vector Double]] -> [Cell] -> String -> IO ()
dumpDatabase (fromIntegral -> dst) dsb seg cel cid = do 
                                  let xs = getData cel dsb 
                                  c <- db 
                                  std <- prepare c "delete from track_section where track_id = ?"
                                  execute std [toSql cid]
                                  stm <- prepare c "insert into track_section (track_id, radius,length,segment) values (?,?,?,?)" 
                                  forM_ (reverse xs) $ \(c, ps) -> do 
                                                let r = fromMaybe 0 (radius c)
                                                execute stm [toSql cid, toSql (r * dst), toSql (arclength c * dst), toSql (jsonArray ps)] 
                                  commit c
                                  disconnect c
                                  


getData :: [Cell] -> [(Int,Int)] -> [(Cell, [(Int,Int)])]
getData c xs = foldr step [] c  
    where 
        step x z = (x, reverse $ toXY <$> path x) : z 
            where toXY p = (round $ getX p, round $ getY p) 
